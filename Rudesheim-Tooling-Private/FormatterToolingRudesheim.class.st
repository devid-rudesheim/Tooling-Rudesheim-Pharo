"
EFFormatter compatible entry point that applies tmp/format.md rules first for known patterns, then falls back to EFFormatter.
"
Class {
	#name : 'FormatterToolingRudesheim',
	#superclass : 'OCAbstractFormatter',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'functions' }
FormatterToolingRudesheim class >> appendPeriodToLastLine: aLineCollection [
	|
		last
	|

	aLineCollection isEmpty
		ifTrue:
		[
			^ self.
		].

	last := aLineCollection last.

	last isEmpty
		ifTrue:
		[
			^ self.
		].

	(
		last
			endsWith:	'.'
	)
		ifTrue:
		[
			^ self.
		].

	aLineCollection
		at:	aLineCollection size
		put:	last , '.'.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> assignmentPrefixForVariables: aVariableCollection [

	^ String
		streamContents:
		[ :writer |
			aVariableCollection
				doWithIndex:
				[ :value :index |
					1 < index
						ifTrue:
						[
							writer
								nextPutAll:	' := '.
						].

					writer
						nextPutAll:	value name.
				].

			writer
				nextPutAll:	' :='.
		].
]

{ #category : 'accessing' }
FormatterToolingRudesheim class >> bracketStatesStartingWith: aCharacter [
	^ self characterKinds
		select:
		[ :each |
			each
				isOpeningBracketCharacter:	aCharacter
		].
]

{ #category : 'testing' }
FormatterToolingRudesheim class >> candidateIdentifierTerminatesWith: aCharacter [
	^
	(
		self characterKinds
			select:
			[ :each |
				each
					match:	aCharacter
			]
			thenCollect:
			[ :each |
				each
					candidateIdentifierTerminatesWith:	aCharacter
			]
	)
		anySatisfy:
		[ :each |
			each
		].
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> candidateIdentifiersIn: aString [
	|
		size
		candidates
	|

	size := aString size.
	candidates := Set new.

	self
		identifierRangesIn:	aString
		do:
		[ :start :nextIndex |
			|
				continue
				nextChar
			|

			continue := thisContext.

			nextIndex <= size
				ifFalse:
				[
					continue return.
				].

			nextChar :=
				aString
					at:	nextIndex.

			(
				{
					(
						self
							candidateIdentifierTerminatesWith:	nextChar
					).
					(
						1 + nextIndex <= size
							and:
							[
								self
									isAssignmentStartCharacter:	nextChar
									followedBy:
									(
										aString
											at:	1 + nextIndex
									).
							]
					)
				}
					anySatisfy:	#yourself
			)
				ifFalse:
				[
					continue return.
				].

			candidates
				add:
				(
					aString
						copyFrom:	start
						to:	nextIndex - 1
				).
		].

	^ candidates.
]

{ #category : 'formatting-cascade' }
FormatterToolingRudesheim class >> cascadeMessageEndFor: aMessageNode [
	|
		end
	|

	end := aMessageNode selectorInterval last.

	aMessageNode arguments
		do:
		[ :each |
			end :=
				end
					max:	each sourceInterval last.
		].

	^ end.
]

{ #category : 'formatting-cascade' }
FormatterToolingRudesheim class >> cascadeMessageStartFor: aMessageNode [
	^ aMessageNode selectorInterval first.
]

{ #category : 'accessing' }
FormatterToolingRudesheim class >> characterKinds [
	|
		characterKind
	|

	characterKind := Rudesheim Tooling CharacterKind.

	^
	{
		characterKind Separator.
		characterKind Period.
		characterKind Semicolon.
		characterKind Colon.
		characterKind Assignment.
		characterKind Parentheses.
		characterKind SquareBrackets.
		characterKind CurlyBraces.
		characterKind DoubleQuote.
		characterKind SingleQuote.
		characterKind CharacterLiteral.
	}.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> commentsInSource: aString
from: aStartInteger
to: aStopInteger [
	|
		comments
		index
		limit
		stream
		closed
		commentIndex
		quoteAction
		characterAction
		offset
	|

	comments := OrderedCollection new.

	index :=
		aStartInteger
			max:	1.

	limit :=
		aStopInteger
			min:	aString size.
	[
		index <= limit.
	]
		whileTrue:
		[
			[
				|
					continue
					nextIndex
					nextCommentIndex
				|

				continue := thisContext.
				nextIndex := 1 + index.

				(
					aString
						at: index
				) ~= $"
					ifTrue:
					[
						index := nextIndex.

						continue
							return:	self.
					].

				stream :=
					WriteStream
						on:	String new.

				closed := false.
				commentIndex := nextIndex.
				[
					commentIndex <= limit
						and:
						[
							closed not.
						].
				]
					whileTrue:
					[
						offset := 0.

						characterAction :=
						[
							stream
								nextPut:
								(
									aString
										at:	commentIndex
								).
						].

						nextCommentIndex := 1 + commentIndex.

						(
							aString
								at: commentIndex
						) = $"
							ifTrue:
							[
								characterAction :=
								[
								].

								quoteAction :=
								[
									closed := true.
								].

								commentIndex < limit
									ifTrue:
									[
										(
											aString
												at: nextCommentIndex
										) = $"
											ifTrue:
											[
												quoteAction :=
												[
													stream
														nextPut:	$".
												].

												offset := 1.
											].
									].

								quoteAction value.
							].

						characterAction value.
						commentIndex := nextCommentIndex + offset.
					].

				comments
					add:	stream contents.

				index := commentIndex.
			] value
		].

	^ comments.
]

{ #category : 'control' }
FormatterToolingRudesheim class >> disableAsFormatter [
	OCProgramNode resetFormatter.
]

{ #category : 'control' }
FormatterToolingRudesheim class >> enableAsFormatter [
	OCProgramNode
		formatterClass:	self.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> format: aParseTree [

	^ self
		formatString:
		(
			self
				sourceStringFrom:	aParseTree
		).
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> format: aParseTree
withIndents: anInteger [
	|
		formatted
		indent
	|

	formatted :=
		self
			format:	aParseTree.

	0 >= anInteger 
		ifTrue:
		[
			^ formatted.
		].

	indent :=
		String
			new:	anInteger
			withAll:	Character tab.

	^ String
		streamContents:
		[ :writer |
			formatted
				linesDo:
				[ :line |
					line isEmpty
						ifFalse:
						[
							writer
								nextPutAll:	indent.
						].

					writer
						nextPutAll:	line.

					writer cr.
				].
		].
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatArrayLines: anArrayNode
indent: anIndentLevelInteger [
	|
		lines
		statements
		previousEnd
	|

	statements := anArrayNode statements.

	statements isEmpty
		ifTrue:
		[
			^
			{
				(
					self
						indentStringFor:	anIndentLevelInteger
				) , '{}'
			}.
		].

	(
		self
			needsMultilineFor:	anArrayNode
	)
		ifFalse:
		[
			^
			{
				(
					self
						indentStringFor:	anIndentLevelInteger
				) ,
				(
					self
						formatInline:	anArrayNode
				)
			}.
		].

	lines := OrderedCollection new.

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , '{'.

	previousEnd := anArrayNode left.

	statements
		doWithIndex:
		[ :each :index |
			|
				elementLines
			|

			lines
				addAll:
				(
					self
						formatCommentLinesInSource:	anArrayNode source
						from:	previousEnd + 1
						to:	each sourceInterval first - 1
						indent:	anIndentLevelInteger + 1
				).

			elementLines :=
				self
					formatSubexpressionLines:	each
					indent:	anIndentLevelInteger + 1.

			index < statements size
				ifTrue:
				[
					elementLines
						at:	elementLines size
						put:	elementLines last , '.'.
				].

			lines
				addAll:	elementLines.

			previousEnd := each sourceInterval last.
		].

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , '}'.

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatAsYouReadPolicy [
	^ self
		propertyAt:	#formatAsYouReadPolicy
		ifAbsent:
		[
			false.
		].
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatAsYouReadPolicy: aBoolean [
	self
		propertyAt:	#formatAsYouReadPolicy
		put:	aBoolean.

	^ aBoolean.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatAssignmentLines: anAssignmentNode
indent: anIndentLevelInteger [
	|
		vars
		value
		prefix
		inline
		lines
		valueLines
		firstValueLine
	|

	vars := OrderedCollection new.
	value := anAssignmentNode.
	[
		value isAssignment.
	]
		whileTrue:
		[
			vars
				add:	value variable.

			value := value value.
		].

	prefix :=
		self
			assignmentPrefixForVariables:	vars.

	(
		value
			needsExpressionLinesAsAssignmentValueForFormatterRudesheim:	self
	)
		ifFalse:
		[
			inline :=
				self
					formatInline:	value.

			^
			{
				(
					self
						indentStringFor:	anIndentLevelInteger
				) , prefix , ' ' , inline
			}.
		].

	lines := OrderedCollection new.

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , prefix.

	valueLines :=
		self
			formatExpressionLines:	value
			indent:	anIndentLevelInteger + 1.

	firstValueLine := valueLines first trimBoth.

	firstValueLine notEmpty
		ifTrue:
		[
			(
				self
					isOpeningBracketCharacter:	firstValueLine first
			)
				ifTrue:
				[
					valueLines :=
						self
							formatExpressionLines:	value
							indent:	anIndentLevelInteger.
				].
		].

	lines
		addAll:	valueLines.

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatBlockLines: aBlockNode
indent: anIndentLevelInteger [
	|
		lines
		header
		args
		argString
		temps
	|

	lines := OrderedCollection new.
	args := aBlockNode argumentNames.
	header := ( self indentStringFor: anIndentLevelInteger ) , '['.

	args notEmpty
		ifTrue:
		[
			argString :=
				String
					streamContents:
					[ :out |
						args
							doWithIndex:
							[ :arg :idx |
								idx > 1
									ifTrue:
									[
										out space.
									].

								out
									nextPut:	$:.

								out
									nextPutAll:	arg.
							].
					].

			header := header , ' ' , argString , ' |'.
		].

	lines
		add:	header.

	temps := aBlockNode temporaryNames.

	temps notEmpty
		ifTrue:
		[
			lines
				addAll:
				(
					self
						formatTempsLinesFor:	temps
						indent:	anIndentLevelInteger + 1
				).

			lines
				add:	''.
		].

	lines
		addAll:
		(
			self
				formatSequenceLines:	aBlockNode body
				indent:	anIndentLevelInteger + 1
		).

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , ']'.

	^ lines.
]

{ #category : 'formatting-cascade' }
FormatterToolingRudesheim class >> formatCascadeLines: aCascadeNode
indent: anIndentLevelInteger [
	|
		lines
		receiver
		keywordIndent
		messages
		previousEnd
	|

	lines := OrderedCollection new.
	receiver := aCascadeNode receiver.

	lines
		addAll:
		(
			self
				formatSubexpressionLines:	receiver
				indent:	anIndentLevelInteger
		).

	keywordIndent := anIndentLevelInteger + 1.
	messages := aCascadeNode messages.
	previousEnd := receiver sourceInterval last.

	1
		to:	messages size
		do:
		[ :idx |
			|
				partLines
				message
			|

			message :=
				messages
					at:	idx.

			lines
				addAll:
				(
					self
						formatCommentLinesInSource:	aCascadeNode source
						from:	previousEnd + 1
						to:
						(
							self
								cascadeMessageStartFor:	message
						) - 1
						indent:	keywordIndent
				).

			partLines :=
				self
					formatCascadePartLines:	message
					indent:	keywordIndent.

			idx < messages size
				ifTrue:
				[
					partLines
						at:	partLines size
						put:	partLines last , ';'.
				].

			lines
				addAll:	partLines.

			previousEnd :=
				self
					cascadeMessageEndFor:	message.
		].

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatCascadePartLines: aMessageNode
indent: anIndentLevelInteger [
	|
		line
	|

	(
		self
			isKeywordMessage:	aMessageNode
	)
		ifTrue:
		[
			^
			(
				aMessageNode selectorParts
					with: aMessageNode arguments
					collect:
					[ :part :argument |
						self
							formatKeywordPart:	part
							argument:	argument
							indent:	anIndentLevelInteger					
					]
			) flattened
		].
	
	line :=
	(
		self
			indentStringFor:	anIndentLevelInteger
	) , aMessageNode selector asString.

	aMessageNode isBinary
		ifTrue:
		[
			line := line , ' ' , ( self formatInline: aMessageNode arguments first )
		].

	^
	{
		line.
	}
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatClass: aClass
selector: aSymbol [
	^ self
		formatString:
		(
			aClass
				sourceCodeAt:	aSymbol
				ifAbsent:
				[
					self
						error:	'Method not found.'.
				]
		).
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatCommentLinesInSource: aString
from: aStartInteger
to: aStopInteger
indent: anIndentLevelInteger [
	|
		indentString
	|

	indentString :=
		self
			indentStringFor:	anIndentLevelInteger.

	^
	(
		self
			commentsInSource:	aString
			from:	aStartInteger
			to:	aStopInteger
	)
		collect:
		[ :each |
			indentString , '"' , each , '"'.
		]
		as:	OrderedCollection.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatExpressionLines: aParseNode
indent: anIndentLevelInteger [
	^ aParseNode
		acceptFormatterRudesheim:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatInline: aParseNode [
	|
		text
	|

	aParseNode isLiteralNode
		ifTrue:
		[
			(
				aParseNode
					respondsTo:	#isLiteralArray
			)
				ifTrue:
				[
					aParseNode isLiteralArray
						ifTrue:
						[
							^ self
								formatLiteralArrayInline:	aParseNode.
						].
				].
		].

	aParseNode isLiteralNode
		ifTrue:
		[
			^ OCSimpleFormatter
				format:	aParseNode.
		].

	text :=
		OCSimpleFormatter
			format:	aParseNode.

	text :=
		text
			copyReplaceAll:	String cr
			with:	' '.

	text :=
		text
			copyReplaceAll:	String lf
			with:	' '.

	^ self
		formatInlineParenthesesFor:	aParseNode
		text:
		(
			self
				formatInlineParenthesesIn:	text trimBoth
		).
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatInlineNodeLines: aParseNode
indent: anIndentLevelInteger [
	^
	{
		(
			self
				indentStringFor:	anIndentLevelInteger
		),
		(
			self
				formatInline: aParseNode
		)
	}.
]

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatInlineParenthesesFor: aParseNode
text: aString [
	|
		text
	|

	(
		aParseNode
			respondsTo:	#parentheses
	)
		ifTrue:
		[
			aParseNode parentheses isEmpty
				ifTrue:
				[
					^ aString.
				].

			aString size < 2
				ifTrue:
				[
					^ aString.
				].

			aString first ~= $(
				ifTrue:
				[
					^ aString.
				].

			aString last ~= $)
				ifTrue:
				[
					^ aString.
				].

			text :=
				aString
					copyFrom:	2
					to:
						aString size - 1.

			^ '( ' , text trimBoth , ' )'.
		].

	^ aString.
]

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatInlineParenthesesIn: aString [
	|
		stream
		index
		matchedKinds
	|

	stream :=
		WriteStream
			on:	String new.

	index := 1.
	[
		index <= aString size.
	]
		whileTrue:
	[
			matchedKinds :=
				self characterKinds
					select:
					[ :each |
						each
							match:
							(
								aString
									at:	index
							)
					].

			matchedKinds isEmpty
				ifTrue:
				[
					index :=
						Rudesheim Tooling CharacterKind
							formatInlineParenthesesIn:	aString
							at:	index
							on:	stream.
				].

			matchedKinds isEmpty
				ifFalse:
				[
					index :=
					(
						matchedKinds
							collect:
							[ :each |
								each
									formatInlineParenthesesIn:	aString
									at:	index
									on:	stream
							]
					) first.
				].
		].

	^ stream contents.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatKeywordMessageLines: aMessageNode
indent: anIndentLevelInteger [
	|
		lines
		receiver
		keywordIndent
	|

	lines := OrderedCollection new.
	receiver := aMessageNode receiver.

	lines
		addAll:
		(
			self
				formatKeywordReceiverLines:	receiver
				indent:	anIndentLevelInteger
		).

	keywordIndent := anIndentLevelInteger + 1.

	lines
		addAll:
		(
			aMessageNode selectorParts
				with:	aMessageNode arguments
				collect:
				[ :part :argument |
					self
						formatKeywordPart:	part
						argument:	argument
						indent:	keywordIndent
				]
		) flattened.

	^ lines.
]

{ #category : 'formatting-keyword' }
FormatterToolingRudesheim class >> formatKeywordPart: aKeywordPart
argument: aNode
indent: anIndentLevelInteger [
	|
		indentString
		lines
		argumentLines
		firstArgumentLine
		argumentLineAction
	|

	indentString :=
		self
			indentStringFor:	anIndentLevelInteger.

	aNode isBlock
		ifTrue:
		[
			^ OrderedCollection new
				add:	indentString , aKeywordPart;
				addAll:
				(
					self
						formatBlockLines:	aNode
						indent:	anIndentLevelInteger
				);
				yourself.
		].

	(
		self
			needsMultilineFor:	aNode
	)
		ifFalse:
		[
			^
			{
				indentString , aKeywordPart , String tab ,
				(
					self
						formatInline:	aNode
				)
			}.
		].

	lines := OrderedCollection new.

	argumentLines :=
		self
			formatSubexpressionLines:	aNode
			indent:	anIndentLevelInteger.

	firstArgumentLine := argumentLines first trimBoth.

	argumentLineAction :=
	[
		lines
			add:	indentString , aKeywordPart , String tab.

		argumentLines :=
			self
				formatSubexpressionLines:	aNode
				indent:	anIndentLevelInteger + 1.
	].

	firstArgumentLine notEmpty
		ifTrue:
		[
			(
				self
					isOpeningBracketCharacter:	firstArgumentLine first
			)
				ifTrue:
				[
					argumentLineAction :=
					[
						lines
							add:	indentString , aKeywordPart.
					].
				].
		].

	argumentLineAction value.

	lines
		addAll:	argumentLines.

	^ lines.
]

{ #category : 'formatting-keyword' }
FormatterToolingRudesheim class >> formatKeywordReceiverLines: aParseNode
indent: anIndentLevelInteger [
	(
		aParseNode
			isKindOf:	OCMessageNode
	)
		ifTrue:
		[
			(
				self
					isKeywordMessage:	aParseNode
			)
				ifTrue:
				[
					^ self
						formatSubexpressionLines:	aParseNode
						indent:	anIndentLevelInteger.
				].

			^ self
				formatInlineNodeLines:	aParseNode
				indent:	anIndentLevelInteger.
		].

	^ self
		formatSubexpressionLines:	aParseNode
		indent:	anIndentLevelInteger.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatLiteralArrayInline: aParseNode [
	|
		text
		body
	|

	text :=
		OCSimpleFormatter
			format:	aParseNode.

	(
		text
			beginsWith:	'#('
	)
		ifTrue:
		[
			body :=
				text
					copyFrom:	3
					to:	text size - 1.

			^ '#( ' , body trimBoth , ' )'.
		].

	^ text.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatMessageLines: aMessageNode
indent: anIndentLevelInteger [
	(
		self
			isKeywordMessage:	aMessageNode
	)
		ifTrue:
		[
			^ self
				formatKeywordMessageLines:	aMessageNode
				indent:	anIndentLevelInteger.
		].

	aMessageNode receiver isBlock
		ifTrue:
		[
			|
				receiverLines
				argumentString
			|

			receiverLines :=
				self
					formatBlockLines:	aMessageNode receiver
					indent:	anIndentLevelInteger.

			argumentString := ''.
			aMessageNode isBinary
				ifTrue:
				[
					argumentString := ' ' ,
					(
						self
							formatInline:	aMessageNode arguments first
					).
				].

			receiverLines
				at:	receiverLines size
				put: receiverLines last , ' ' , aMessageNode selector asString , argumentString.
			
			^ receiverLines.
		].

	(
		self
			needsMultilineFor:	aMessageNode
	)
		ifTrue:
		[
			^ self
				formatUnaryOrBinaryChainLines:	aMessageNode
				indent:	anIndentLevelInteger.
		].

	^
	{
		(
			self
				indentStringFor:	anIndentLevelInteger
		) ,
		(
			self
				formatInline:	aMessageNode
		)
	}.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatMethodNode: aMethodNode [
	|
		lines
		temps
		comment
	|

	lines := OrderedCollection new.

	lines
		addAll:
		(
			self
				formatSignatureLinesFor:	aMethodNode
		).

	comment := aMethodNode firstPrecodeComment.

	comment notNil
		ifTrue:
		[
			lines
				add:
					String tab , '"' , comment , '"'.
		].

	temps := aMethodNode temporaryNames.

	temps notEmpty
		ifTrue:
		[
			lines
				addAll:
				(
					self
						formatTempsLinesFor:	temps
						indent:	1
				).

			lines
				add:	''.
		].

	lines
		addAll:
		(
			self
				formatSequenceLines:	aMethodNode body
				indent:	1
		).

	^ self
		joinLines:	lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatParenthesizedLines: aNode
indent: anIndentLevelInteger [
	|
		lines
	|

	lines := OrderedCollection new.

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , '('.

	lines
		addAll:
		(
			aNode
				acceptFormatterRudesheim:	self
				indent:	1 + anIndentLevelInteger
		).

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		) , ')'.

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatReturnLines: aReturnNode
indent: anIndentLevelInteger [
	|
		indentString
		exprLines
		firstLineBody
	|

	indentString :=
		self
			indentStringFor:	anIndentLevelInteger.

	exprLines :=
		self
			formatExpressionLines:	aReturnNode value
			indent:	anIndentLevelInteger.

	firstLineBody := exprLines first.

	(
		firstLineBody
			beginsWith:	indentString
	)
		ifTrue:
		[
			firstLineBody :=
				firstLineBody
					copyFrom:	1 + indentString size
					to:	exprLines first size.
		].

	firstLineBody notEmpty
		ifTrue:
		[
			(
				self
					isOpeningBracketCharacter:	firstLineBody first
			)
				ifTrue:
				[
					1 < exprLines size
						ifTrue:
						[
							^ OrderedCollection new
								add:	indentString , '^';
								addAll:	exprLines;
								yourself.
						].
				].
		].

	^ OrderedCollection new
		add:	indentString , '^ ' , firstLineBody;
		addAll:	exprLines allButFirst;
		yourself.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatSequenceLines: aSequenceNode
indent: anIndentLevelInteger [
	|
		statements
		lines
		previousEnd
	|

	aSequenceNode isNil
		ifTrue:
		[
			self
				error:	'aSequenceNode must not be nil'.
		].

	statements := aSequenceNode statements.
	lines := OrderedCollection new.

	previousEnd :=
		aSequenceNode rightBar
			ifNil:
			[
				[
					|
						break
					|

					break := thisContext.

					(
						aSequenceNode parent
							respondsTo:	#left
					)
						ifTrue:
						[
							break
								return:	aSequenceNode parent left.
						].

					aSequenceNode sourceInterval first - 1.
				] value
			].

	1
		to:	statements size
		do:
		[ :index |
			|
				statement
				statementLines
				nextLines
				appendPeriodAction
			|

			statement :=
				statements
					at:	index.

			lines
				addAll:
				(
					self
						formatCommentLinesInSource:	aSequenceNode source
						from:	previousEnd + 1
						to:	statement sourceInterval first - 1
						indent:	anIndentLevelInteger
				).

			statementLines :=
				self
					formatStatementLines:	statement
					indent:	anIndentLevelInteger.

			appendPeriodAction :=
			[
				self
					appendPeriodToLastLine:	statementLines.
			].

			index = statements size
				ifTrue:
				[
					statement isMessage
						ifTrue:
						[
							(
								self
									isBlockStatement:	statement
							)
								ifTrue:
								[
									statement isKeyword
										ifFalse:
										[
											appendPeriodAction :=
											[
											].
										].
								].
						].
				].

			appendPeriodAction value.

			lines
				addAll:	statementLines.

			previousEnd := statement sourceInterval last.

			index < statements size
				ifTrue:
				[
					nextLines :=
						self
							formatStatementLines:
							(
								statements
									at:	1 + index
							)
							indent:	anIndentLevelInteger.

					(
						self
							needsBlankLineAfter:	statement
							next:
							(
								statements
									at:	1 + index
							)
							currentLines:	statementLines
							nextLines:	nextLines
					)
						ifTrue:
						[
							lines
								add:	String new.
						].
				].
		].

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatSignatureLinesFor: aMethodNode [
	|
		selector
	|

	selector := aMethodNode selector asString.

	(
		selector
			includes:	$:
	)
		ifTrue:
		[
			^ aMethodNode selectorParts
				with:	aMethodNode argumentNames
				collect:
				[ :part :argument |
					part, ' ', argument
				].
		].

	0 = aMethodNode numArgs
		ifTrue:
		[
			^
			{
				selector
			}.
		].

	^
	{
		( selector , ' ' , aMethodNode argumentNames first )
	}.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatStatementLines: aStatementNode
indent: anIndentLevelInteger [
	^ aStatementNode
		acceptFormatterRudesheimAsStatement:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatString: aString [
	|
		parseTree
		repaired
	|

	[
		parseTree :=
			OCParser
				parseMethod:	aString.

		^ self
			formatMethodNode:	parseTree.
	]
		on:	Error
		do:
		[ :ex |
			repaired :=
				self
					repairMethodString:	aString.
			[
				parseTree :=
					OCParser
						parseMethod:	repaired.

				^ self
					formatMethodNode:	parseTree.
			]
				on:	Error
				do:
				[ :ex2 |
					^ aString.
				].
		].
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatSubexpressionLines: aNode
indent: anIndentLevelInteger [
	^ aNode
		acceptFormatterRudesheimAsSubexpression:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatTempsLinesFor: aTempsNode
indent: anIndentLevelInteger [
	|
		indent
		inner
	|

	indent :=
		self
			indentStringFor:	anIndentLevelInteger.

	inner :=
		self
			indentStringFor:	1 + anIndentLevelInteger.

	^ OrderedCollection new
		add:	indent , '|';
		addAll:
		(
			aTempsNode
				collect:
				[ :each |
					inner , each.
				]
		);
		add:	indent , '|';
		yourself.
]

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatUnaryOrBinaryChainLines: aMessageNode
indent: anIndentLevelInteger [
	|
		steps
		node
		lines
		receiverLines
		receiverLinesAction
		keepWalking
	|

	steps := OrderedCollection new.
	node := aMessageNode.

	receiverLinesAction :=
	[
		self
			formatSubexpressionLines:	node
			indent:	anIndentLevelInteger.
	].

	keepWalking := true.
	[
		[
			|
				break
			|

			break := thisContext.

			keepWalking
				ifTrue:
				[
					(
						node
							isKindOf:	OCMessageNode
					)
						ifTrue:
						[
							break
								return:
								(
									self
										isKeywordMessage:	node
								) not.
						].
				].

			false.
		] value
	]
		whileTrue:
		[
			steps
				addFirst:	node.

			node isBinary not
				ifTrue:
				[
					(
						node receiver
							isKindOf:	OCMessageNode
					)
						ifTrue:
						[
							node receiver isBinary
								ifTrue:
								[
									receiverLinesAction :=
									[
										self
											formatParenthesizedLines:	node
											indent:	anIndentLevelInteger.
									].

									keepWalking := false.
								].
						].
				].

			node := node receiver.
		].

	receiverLines := receiverLinesAction value.
	lines := OrderedCollection new.

	lines
		addAll:	receiverLines.

	steps
		do:
		[ :step |
			|
				stepText
				argument
				stepAction
			|

			stepAction :=
			[
				stepText := step selector asString.

				step isBinary
					ifTrue:
					[
						stepText :=
							step selector asString , ' ' ,
							(
								self
									formatInline:	step arguments first
							).
					].

				lines
					at:	lines size
					put:	lines last , ' ' , stepText.
			].

			step isBinary
				ifTrue:
				[
					argument := step arguments first.

					(
						self
							needsMultilineFor:	argument
					)
						ifTrue:
						[
							stepAction :=
							[
								lines
									at:	lines size
									put:	lines last , ' ' , step selector asString.

								lines
									addAll:
									(
										self
											formatSubexpressionLines:	argument
											indent:	anIndentLevelInteger
									).
							].
						].
				].

			stepAction value.
		].

	^ lines.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> identifierRangesIn: aString
do: aBlock [
	|
		size
		index
	|

	size := aString size.
	index := 1.
	[
		index <= size.
	]
		whileTrue:
		[
			[
				|
					continue
					start
				|

				continue := thisContext.

				(
					aString
						at: index
				) isAlphaNumeric
					ifFalse:
					[
						index := 1 + index.
						
						continue return.
					].

				start := index.

				index :=
				(
					index
						to: size
				)
					detect:
					[ :each |
						(
							aString
								at: each
						) isAlphaNumeric not.
					]
					ifNone:
					[
						1 + size.
					].

				aBlock
					value: start
					value: index.
			] value.
		].

]

{ #category : 'functions' }
FormatterToolingRudesheim class >> indentStringFor: anInteger [
	|
		count
	|

	anInteger isNumber
		ifFalse:
		[
			self error: 'anInteger must be a number'.
		].

	count :=
		anInteger
			max:	0.

	0 = count
		ifTrue:
		[
			^ ''.
		].

	^ String
		new:	count
		withAll:	Character tab.
]

{ #category : 'testing' }
FormatterToolingRudesheim class >> isAssignmentStartCharacter: aCharacter
followedBy: anotherCharacter [
	^
	(
		self characterKinds
			select:
			[ :each |
				each
					isAssignmentStartCharacter:	aCharacter
					followedBy:	anotherCharacter
			]
	) notEmpty.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> isBlockStatement: aStatementNode [
	^ aStatementNode isBlockStatementForFormatterRudesheim.
]

{ #category : 'testing' }
FormatterToolingRudesheim class >> isKeywordColonCharacter: aCharacter
followedBy: anotherCharacter [
	^
	(
		self characterKinds
			select:
			[ :each |
				each
					match:	aCharacter
			]
			thenCollect:
			[ :each |
				each
					isKeywordColonCharacter:	aCharacter
					followedBy:	anotherCharacter
			]
	)
		anySatisfy: #yourself.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> isKeywordMessage: aMessage [
	^ aMessage selector asString
		includes:	$:.
]

{ #category : 'testing' }
FormatterToolingRudesheim class >> isOpeningBracketCharacter: aCharacter [
	^
	(
		self
			bracketStatesStartingWith:	aCharacter
	) notEmpty.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> joinLines: aLineCollection [
	^ String
		streamContents:
		[ :writer |
			aLineCollection
				doWithIndex:
				[ :line :index |
					writer
						nextPutAll:	line.

					index < aLineCollection size
						ifTrue:
						[
							writer cr.
						].
				].
		].

]

{ #category : 'functions' }
FormatterToolingRudesheim class >> needsBlankLineAfter: aCurrentLineString
next: aNextLineString
currentLines: aCurrentLineCollection
nextLines: aNextLineCollection [
	|
		currentIsAssign
		nextIsBlock
	|

	currentIsAssign := aCurrentLineString isAssignment.

	nextIsBlock :=
		self
			isBlockStatement:	aNextLineString.

	currentIsAssign
		ifTrue:
		[
			nextIsBlock
				ifTrue:
				[
					^ false.
				].
		].

	1 < aCurrentLineCollection size
		ifTrue:
		[
			^ true.
		].

	1 < aNextLineCollection size
		ifTrue:
		[
			^ true.
		].

	^ false.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> needsMultilineFor: aNode [
	^ aNode
		needsMultilineForFormatterRudesheim:	self.
]

{ #category : 'accessing' }
FormatterToolingRudesheim class >> priority [
	^ 100.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> repairMethodString: aString [
	|
		size
		keywords
		candidates
		lastIndex
	|

	keywords := self systemKeywordParts.

	candidates :=
		self
			candidateIdentifiersIn: aString.

	size := aString size.

	^ String
		streamContents:
		[ :writer |
			lastIndex := 1.

			self
				identifierRangesIn: aString
				do:
				[ :start :nextIndex |
					|
						continue
						identifier
					|

					[
						continue := thisContext.

						writer
							nextPutAll:
							(
								aString
									copyFrom: lastIndex
									to: start - 1
							).

						identifier :=
							aString
								copyFrom: start
								to: nextIndex - 1.

						1 + nextIndex <= size
							ifFalse:
							[
								continue return.
							].

						(
							self
								isKeywordColonCharacter:
								(
									aString
										at: nextIndex
								)
								followedBy:
								(
									aString
										at: 1 + nextIndex
								)
						)
							ifFalse:
							[
								continue return.
							].

					identifier :=
						self
							splitIdentifier: identifier
							usingUnarySelectors: #(  )
							usingKeywordParts: keywords
							usingCandidates: candidates.
					] value.

					writer
						nextPutAll: identifier.

					lastIndex := nextIndex.
				].

			lastIndex <= size
				ifTrue:
				[
					writer
						nextPutAll:
						(
							aString
								copyFrom: lastIndex
								to: size
						).
				].
		].
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> sourceStringFrom: anObject [
	anObject isString
		ifTrue:
		[
			^ anObject.
		].

	#(
		#source
		#sourceCode
	)
		detect:
		[ :each |
			anObject
				respondsTo:	each
		]
		ifFound:
		[ :selector |
			^ selector
				value: anObject.
		].

	^ anObject asString.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> splitIdentifier: anIdentifierString
usingUnarySelectors: aUnarySelectorCollection
usingKeywordParts: aKeywordPartCollection
usingCandidates: aCandidateCollection [
	|
		bestMatch
		bestSize
		prefix
	|

	(
		aKeywordPartCollection
			includes:	anIdentifierString
	)
		ifTrue:
		[
			^ anIdentifierString.
		].

	bestMatch := nil.
	bestSize := 0.

	aKeywordPartCollection
		do:
		[ :each |
			|
				continue
				eachSize
			|

			continue := thisContext.

			eachSize := each size.
			(
				{
					[
						0 < eachSize
					].
					[
						anIdentifierString
							endsWith:	each
					].
					[
						eachSize < anIdentifierString size
					].
					[
						eachSize > bestSize
					].
				}
					allSatisfy:
					[ :condition |
						condition value
					]
			)
				ifFalse:
				[
					continue return.
				].					

			bestSize := eachSize.
			bestMatch := each.
		].

	bestMatch
		ifNil:
		[
			^ anIdentifierString.
		].

	prefix :=
		anIdentifierString
			copyFrom:	1
			to:			anIdentifierString size - bestMatch size.

	prefix isEmpty
		ifTrue:
		[
			^ anIdentifierString.
		].

	(
		aCandidateCollection
			includes: prefix
	)
		ifFalse:
		[
			^ anIdentifierString.
		].

	^ prefix , ' ' , bestMatch.
]

{ #category : 'accessing' }
FormatterToolingRudesheim class >> systemKeywordParts [
	|
		parts
	|

	parts := Set new.

	Smalltalk allClasses
		do:
		[ :class |
			|
				selectors
			|

			selectors := class selectors.

			selectors
				do:
				[ :selector |
					|
						selString
						tokens
					|

					selString := selector asString.

					(
						selString
							includes:	$:
					)
						ifTrue:
						[
							tokens :=
								selString
									findTokens:	':'.

							tokens
								do:
								[ :each |
									each notEmpty
										ifTrue:
										[
											parts
												add:	each.
										].
								].
						].
				].

			selectors := class class selectors.

			selectors
				do:
				[ :sel |
					|
						selString
						tokens
					|

					selString := sel asString.

					(
						selString
							includes:	$:
					)
						ifTrue:
						[
							tokens :=
								selString
									findTokens:	':'.

							tokens
								do:
								[ :each |
									each notEmpty
										ifTrue:
										[
											parts
												add:	each.
										].
								].
						].
				].
		].

	^ parts.
]

{ #category : 'functions' }
FormatterToolingRudesheim class >> unaryBinaryChainLength: aNode [
	^ aNode
		unaryBinaryChainLengthForFormatterRudesheim:	self.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim >> format: aParseTree [
	^ self class
		format:	aParseTree.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim >> format: aParseTree
withIndents: anInteger [
	^ self class
		format:	aParseTree
		withIndents:	anInteger.
]
