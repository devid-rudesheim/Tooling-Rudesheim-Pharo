"
EFFormatter compatible entry point that applies tmp/format.md rules first for known patterns, then falls back to EFFormatter.
"
Class {
	#name : 'FormatterToolingRudesheim',
	#superclass : 'OCAbstractFormatter',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'namespace' }
FormatterToolingRudesheim class >> Array [
	^ ArrayFormatterToolingRudesheim.
]

{ #category : 'namespace' }
FormatterToolingRudesheim class >> Assignment [
	^ AssignmentFormatterToolingRudesheim.
]

{ #category : 'namespace' }
FormatterToolingRudesheim class >> Block [
	^ BlockFormatterToolingRudesheim.
]

{ #category : 'namespace' }
FormatterToolingRudesheim class >> Cascade [
	^ CascadeFormatterToolingRudesheim.
]

{ #category : 'namespace' }
FormatterToolingRudesheim class >> MessageKind [
	^ MessageKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
FormatterToolingRudesheim class >> Return [
	^ ReturnFormatterToolingRudesheim.
]

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

{ #category : 'accessing' }
FormatterToolingRudesheim class >> bracketStatesStartingWith: aCharacter [
	^ self characterKinds
		select:
		[ :each |
			each
				isOpeningBracketCharacter:	aCharacter.
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
					match:	aCharacter.
			]
			thenCollect:
			[ :each |
				each
					candidateIdentifierTerminatesWith:	aCharacter.
			]
	)
		anySatisfy:
		[ :each |
			each.
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
					self
						candidateIdentifierTerminatesWith:	nextChar.
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
		characterKind CharacterLiteral
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
						at:	index
				) ~= Rudesheim Tooling CharacterKind DoubleQuote quoteCharacter
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
								at:	commentIndex
						) = Rudesheim Tooling CharacterKind DoubleQuote quoteCharacter
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
												at:	nextCommentIndex
										) = Rudesheim Tooling CharacterKind DoubleQuote quoteCharacter
											ifTrue:
											[
												quoteAction :=
												[
													stream
														nextPut:	Rudesheim Tooling CharacterKind DoubleQuote quoteCharacter.
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
	(
		IndentToolingRudesheim
			level:	anInteger
	) asString.

	^ String
		streamContents:
		[ :writer |
			formatted
				linesDo:
				[ :line |
					line
						ifNotEmpty:
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
indent: anIndentToolingRudesheim [
	|
		indentString
	|

	indentString := anIndentToolingRudesheim asString.

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
indent: anIndentToolingRudesheim [
	^ aParseNode
		acceptFormatterRudesheim:	self
		indent:	anIndentToolingRudesheim.
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

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatInlineNodeLines: aParseNode
indent: anIndentToolingRudesheim [
	^
	{
		anIndentToolingRudesheim asString ,
		(
			self
				formatInline:	aParseNode
		)
	}.
]

{ #category : 'formatting-inline' }
FormatterToolingRudesheim class >> formatInlineParenthesesFor: aParseNode
text: aString [
	|
		text
		parenthesesCharacterKind
	|

	parenthesesCharacterKind := Rudesheim Tooling CharacterKind Parentheses.

	(
		aParseNode
			respondsTo:	#parentheses
	)
		ifTrue:
		[
			aParseNode parentheses
				ifEmpty:
				[
					^ aString.
				].

			aString size < 2
				ifTrue:
				[
					^ aString.
				].

			aString first ~= parenthesesCharacterKind openingCharacter
				ifTrue:
				[
					^ aString.
				].

			aString last ~= parenthesesCharacterKind closingCharacter
				ifTrue:
				[
					^ aString.
				].

			text :=
				aString
					copyFrom:	2
					to:	aString size - 1.

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
							).
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
									on:	stream.
							]
					) first.
				].
		].

	^ stream contents.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatLiteralArrayInline: aParseNode [
	|
		text
		body
		parenthesesCharacterKind
	|

	text :=
		OCSimpleFormatter
			format:	aParseNode.

	parenthesesCharacterKind := Rudesheim Tooling CharacterKind Parentheses.

	(
		text
			beginsWith:	'#' , parenthesesCharacterKind openingCharacter asString
	)
		ifTrue:
		[
			body :=
				text
					copyFrom:	3
					to:	text size - 1.

			^ '#' , parenthesesCharacterKind openingCharacter asString , ' ' , body trimBoth , ' ' , parenthesesCharacterKind closingCharacter asString.
		].

	^ text.
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
				add:	String tab , '"' , comment , '"'.
		].

	temps := aMethodNode temporaryNames.

	temps
		ifNotEmpty:
		[
			lines
				addAll:
				(
					self
						formatTempsLinesFor:	temps
						indent:
						(
							IndentToolingRudesheim
								level:	1
						)
				).

			lines
				add:	''.
		].

	lines
		addAll:
		(
			self
				formatSequenceLines:	aMethodNode body
				indent:
				(
					IndentToolingRudesheim
						level:	1
				)
		).

	^ self
		joinLines:	lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatParenthesizedLines: aNode
indent: anIndentToolingRudesheim [
	|
		lines
	|

	lines := OrderedCollection new.

	lines
		add:	anIndentToolingRudesheim asString , '('.

	lines
		addAll:
		(
			aNode
				acceptFormatterRudesheim:	self
				indent:	anIndentToolingRudesheim oneLevelDeeper
		).

	lines
		add:	anIndentToolingRudesheim asString , ')'.

	^ lines.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatSequenceLines: aSequenceNode
indent: anIndentToolingRudesheim [
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
						indent:	anIndentToolingRudesheim
				).

			statementLines :=
				self
					formatStatementLines:	statement
					indent:	anIndentToolingRudesheim.

			appendPeriodAction :=
			[
				self
					appendPeriodToLastLine:	statementLines.
			].
			[
				|
					continue
				|

				continue := thisContext.

				index = statements size
					ifFalse:
					[
						continue return.
					].

				statement isMessage
					ifFalse:
					[
						continue return.
					].

				statement isBlockStatementForFormatterRudesheim
					ifFalse:
					[
						continue return.
					].

				statement isKeyword
					ifTrue:
					[
						continue return.
					].

				appendPeriodAction :=
				[
				].
			] value.

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
							indent:	anIndentToolingRudesheim.

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
					part , ' ' , argument.
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
indent: anIndentToolingRudesheim [
	^ aStatementNode
		acceptFormatterRudesheimAsStatement:	self
		indent:	anIndentToolingRudesheim.
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
indent: anIndentToolingRudesheim [
	^ aNode
		acceptFormatterRudesheimAsSubexpression:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : 'formatting' }
FormatterToolingRudesheim class >> formatTempsLinesFor: aTempsNode
indent: anIndentToolingRudesheim [
	|
		indent
		inner
	|

	indent := anIndentToolingRudesheim asString.
	inner := anIndentToolingRudesheim oneLevelDeeper asString.

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

{ #category : 'functions' }
FormatterToolingRudesheim class >> hasHandWrittenLineBreakFor: aNode [
	|
		interval
		text
	|

	interval := aNode sourceInterval.

	interval isEmpty
		ifTrue:
		[
			^ false.
		].

	text :=
		aNode source
			copyFrom:	interval first
			to:	interval last.

	^ text
		anySatisfy:
		[ :each |
			{
				Character cr.
				Character lf
			}
				includes:	each.
		].
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
						at:	index
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
						to:	size
				)
					detect:
					[ :each |
						(
							aString
								at:	each
						) isAlphaNumeric not.
					]
					ifNone:
					[
						1 + size.
					].

				aBlock
					value:	start
					value:	index.
			] value
		].
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
					followedBy:	anotherCharacter.
			]
	) notEmpty.
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
					match:	aCharacter.
			]
			thenCollect:
			[ :each |
				each
					isKeywordColonCharacter:	aCharacter
					followedBy:	anotherCharacter.
			]
	)
		anySatisfy:	#yourself.
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
	nextIsBlock := aNextLineString isBlockStatementForFormatterRudesheim.

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
	(
		aNode
			needsMultilineForFormatterRudesheim:	self
	)
		ifTrue:
		[
			^ true.
		].

	^ self
		hasHandWrittenLineBreakFor:	aNode.
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
			candidateIdentifiersIn:	aString.

	size := aString size.

	^ String
		streamContents:
		[ :writer |
			lastIndex := 1.

			self
				identifierRangesIn:	aString
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
									copyFrom:	lastIndex
									to:	start - 1
							).

						identifier :=
							aString
								copyFrom:	start
								to:	nextIndex - 1.

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
										at:	nextIndex
								)
								followedBy:
								(
									aString
										at:	1 + nextIndex
								)
						)
							ifFalse:
							[
								continue return.
							].

						identifier :=
							self
								splitIdentifier:	identifier
								usingUnarySelectors:	#(  )
								usingKeywordParts:	keywords
								usingCandidates:	candidates.
					] value.

					writer
						nextPutAll:	identifier.

					lastIndex := nextIndex.
				].

			lastIndex <= size
				ifTrue:
				[
					writer
						nextPutAll:
						(
							aString
								copyFrom:	lastIndex
								to:	size
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

	#( #source #sourceCode )
		detect:
		[ :each |
			anObject
				respondsTo:	each.
		]
		ifFound:
		[ :selector |
			^ selector
				value:	anObject.
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
						0 < eachSize.
					].
					[
						anIdentifierString
							endsWith:	each.
					].
					[
						eachSize < anIdentifierString size.
					].
					[
						eachSize > bestSize.
					]
				}
					allSatisfy:
					[ :condition |
						condition value.
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
			to:	anIdentifierString size - bestMatch size.

	prefix isEmpty
		ifTrue:
		[
			^ anIdentifierString.
		].

	(
		aCandidateCollection
			includes:	prefix
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
						selectorString
						tokens
					|

					selectorString := selector asString.

					(
						selectorString
							includes:	$:
					)
						ifTrue:
						[
							tokens :=
								selectorString
									findTokens:	':'.

							tokens
								do:
								[ :each |
									each
										ifNotEmpty:
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
				[ :selector |
					|
						selectorString
						tokens
					|

					selectorString := selector asString.

					(
						selectorString
							includes:	$:
					)
						ifTrue:
						[
							tokens :=
								selectorString
									findTokens:	':'.

							tokens
								do:
								[ :each |
									each
										ifNotEmpty:
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
