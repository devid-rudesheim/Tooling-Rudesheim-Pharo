"
EFFormatter compatible entry point that applies tmp/format.md rules first for known patterns, then falls back to EFFormatter.
"
Class {
	#name : 'FormatterToolingRudesheim',
	#superclass : 'OCAbstractFormatter',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> assignmentPrefixForVariables: aVariableCollection [
	|
		stream
	|

	stream :=
		String
			streamContents:
			[ :out |
				aVariableCollection
					doWithIndex:
					[ :var :idx |
						idx > 1
							ifTrue:
							[
								out
									nextPutAll:	' := '.
							].

						out
							nextPutAll:	var name.
					].

				out
					nextPutAll:	' :='.
			].

	^ stream.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> candidateIdentifiersIn: aString [
	|
		size
		index
		candidates
	|

	size := aString size.
	candidates := Set new.
	index := 1.
	[
		index <= size.
	]
		whileTrue:
		[
			[
				|
					break
				|

				break := thisContext.

				( aString at: index ) isAlphaNumeric
					ifTrue:
					[
						|
							start
							ident
							nextIndex
							nextChar
							nextChar2
						|

						start := index.
						[
							[
								|
									conditionBreak
								|

								conditionBreak := thisContext.

								index <= size
									ifTrue:
									[
										conditionBreak
											return:
											(
												aString
													at:	index
											) isAlphaNumeric.
									].

								false.
							] value
						]
							whileTrue:
							[
								index := index + 1.
							].

						ident :=
							aString
								copyFrom:	start
								to:	index - 1.

						nextIndex := index.
						nextChar := [ | valueBreak | valueBreak := thisContext. nextIndex <= size ifTrue: [ valueBreak return: ( aString at: nextIndex ) ]. nil ] value.
						nextChar2 := [ | valueBreak | valueBreak := thisContext. nextIndex + 1 <= size ifTrue: [ valueBreak return: ( aString at: nextIndex + 1 ) ]. nil ] value.

						nextChar = $:
							ifTrue:
							[
								nextChar2 = $=
									ifTrue:
									[
										candidates
											add:	ident.
									].
							].

						nextChar isNil
							ifTrue:
							[
								candidates
									add:	ident.
							].

						nextChar notNil
							ifTrue:
							[
								nextChar isSeparator
									ifTrue:
									[
										candidates
											add:	ident.
									].

								nextChar = $.
									ifTrue:
									[
										candidates
											add:	ident.
									].

								nextChar = $]
									ifTrue:
									[
										candidates
											add:	ident.
									].

								nextChar = $)
									ifTrue:
									[
										candidates
											add:	ident.
									].

								nextChar = $;
									ifTrue:
									[
										candidates
											add:	ident.
									].

								nextChar = $:
									ifTrue:
									[
										candidates
											add:	ident.
									].
							].

						break
							return:	self.
					].

				index := index + 1.
			] value
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> commentsInSource: aString
from: aStartInteger
to: aStopInteger [
	|
		comments
		index
		limit
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
					break
				|

				break := thisContext.

				( aString at: index ) = $"
					ifTrue:
					[
						|
							stream
							closed
							commentIndex
							quoteAction
							characterAction
							offset
						|

						stream :=
							WriteStream
								on:	String new.

						closed := false.
						commentIndex := index + 1.
						[
							[
								|
									conditionBreak
								|

								conditionBreak := thisContext.

								commentIndex <= limit
									ifTrue:
									[
										conditionBreak
											return:	closed not.
									].

								false.
							] value
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

								( aString at: commentIndex ) = $"
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
												( aString at: commentIndex + 1 ) = $"
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
								commentIndex := commentIndex + 1 + offset.
							].

						comments
							add:	stream contents.

						index := commentIndex.

						break
							return:	self.
					].

				index := index + 1.
			] value
		].

	^ comments.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> disableAsFormatter [
	OCProgramNode resetFormatter.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> enableAsFormatter [
	OCProgramNode
		formatterClass:	self.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> format: aParseTree [
	|
		source
	|

	source :=
		self
			sourceStringFrom:	aParseTree.

	^ self
		formatString:	source.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> format: aParseTree
withIndents: anInteger [
	|
		formatted
		indent
	|

	formatted :=
		self
			format:	aParseTree.

	anInteger <= 0
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
		[ :out |
			formatted
				linesDo:
				[ :line |
					|
						lineAction
					|

					lineAction :=
					[
						out
							nextPutAll:	indent;
							nextPutAll:	line.
					].

					line isEmpty
						ifTrue:
						[
							lineAction :=
							[
								out
									nextPutAll:	line.
							].
						].

					lineAction value.
					out cr.
				].
		].
]

{ #category : 'as yet unclassified' }
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
		ifTrue:
		[
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
				[ :each :idx |
					|
						elementLines
					|

					lines
						addAll:
						(
							self
								formatCommentLinesInSource:	anArrayNode source
								from:	previousEnd + 1
								to:
									each sourceInterval first - 1
								indent:	anIndentLevelInteger + 1
						).

					elementLines :=
						self
							formatSubexpressionLines:	each
							indent:	anIndentLevelInteger + 1.

					idx < statements size
						ifTrue:
						[
							elementLines
								at:	elementLines size
								put:
									elementLines last , '.'.
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
		].

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
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatAsYouReadPolicy [
	^ self
		propertyAt:	#formatAsYouReadPolicy
		ifAbsent:
		[
			false.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatAsYouReadPolicy: aBoolean [
	self
		propertyAt:	#formatAsYouReadPolicy
		put:	aBoolean.

	^ aBoolean.
]

{ #category : 'as yet unclassified' }
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
		ifTrue:
		[
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
		].

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
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatCascadePartLines: aMessageNode
indent: anIndentLevelInteger [
	|
		lines
		parts
		args
	|

	(
		self
			isKeywordMessage:	aMessageNode
	)
		ifTrue:
		[
			lines := OrderedCollection new.
			parts := aMessageNode selectorParts.
			args := aMessageNode arguments.

			1
				to:	parts size
				do:
				[ :idx |
					lines
						addAll:
						(
							self
								formatKeywordPart:
								(
									parts
										at:	idx
								)
								argument:
								(
									args
										at:	idx
								)
								indent:	anIndentLevelInteger
						).
				].

			^ lines.
		].

	aMessageNode isBinary
		ifTrue:
		[
			^
			{
				(
					self
						indentStringFor:	anIndentLevelInteger
				)
					, aMessageNode selector asString
					, ' '
					, (self formatInline: aMessageNode arguments first)
			}.
		].

	^
	{
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, aMessageNode selector asString
	}.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatClass: aClass
selector: aSymbol [
	|
		methodSource
	|

	methodSource :=
		aClass
			sourceCodeAt:	aSymbol
			ifAbsent:
			[
				self
					error:	'Method not found.'.
			].

	^ self
		formatString:	methodSource.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatCommentLinesInSource: aString
from: aStartInteger
to: aStopInteger
indent: anIndentLevelInteger [
	|
		lines
		comments
		indentString
	|

	comments :=
		self
			commentsInSource:	aString
			from:	aStartInteger
			to:	aStopInteger.

	indentString :=
		self
			indentStringFor:	anIndentLevelInteger.

	lines := OrderedCollection new.
	comments
		do:
		[ :each |
			lines
				add:	indentString , '"' , each , '"'.
		].

	^ lines.
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatInlineNodeLines: aParseNode
indent: anIndentLevelInteger [
	^
	{
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, (self formatInline: aParseNode)
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
			|
				character
				characterAction
			|

			character :=
				aString
					at:	index.

			characterAction :=
			[
				stream
					nextPut:	character.

				index := index + 1.
			].

			character = $"
				ifTrue:
				[
					|
						closed
						quote
					|

					closed := false.
					quote := character.

					stream
						nextPut:	character.

					index := index + 1.
					[
						[
							|
								conditionBreak
							|

							conditionBreak := thisContext.

							index <= aString size
								ifTrue:
								[
									conditionBreak
										return:	closed not.
								].

							false.
						] value
					]
						whileTrue:
						[
							|
								quoteAction
							|

							character :=
								aString
									at:	index.

							stream
								nextPut:	character.

							index := index + 1.

							character = quote
								ifTrue:
								[
									quoteAction :=
									[
										closed := true.
									].

									index <= aString size
										ifTrue:
										[
											( aString at: index ) = quote
												ifTrue:
												[
													quoteAction :=
													[
														stream
															nextPut:
															(
																aString
																	at:	index
															).

														index := index + 1.
													].
												].
										].

									quoteAction value.
								].
						].

					characterAction :=
					[
					].
				].

			character = $'
				ifTrue:
				[
					|
						closed
						quote
					|

					closed := false.
					quote := character.

					stream
						nextPut:	character.

					index := index + 1.
					[
						[
							|
								conditionBreak
							|

							conditionBreak := thisContext.

							index <= aString size
								ifTrue:
								[
									conditionBreak
										return:	closed not.
								].

							false.
						] value
					]
						whileTrue:
						[
							|
								quoteAction
							|

							character :=
								aString
									at:	index.

							stream
								nextPut:	character.

							index := index + 1.

							character = quote
								ifTrue:
								[
									quoteAction :=
									[
										closed := true.
									].

									index <= aString size
										ifTrue:
										[
											( aString at: index ) = quote
												ifTrue:
												[
													quoteAction :=
													[
														stream
															nextPut:
															(
																aString
																	at:	index
															).

														index := index + 1.
													].
												].
										].

									quoteAction value.
								].
						].

					characterAction :=
					[
					].
				].

			character = $$
				ifTrue:
				[
					characterAction :=
					[
						|
							literalAction
						|

						stream
							nextPut:	character.

						literalAction :=
						[
							index := index + 1.
						].

						index < aString size
							ifTrue:
							[
								stream
									nextPut:
									(
										aString
											at:	index + 1
									).

								index := index + 2.

								literalAction :=
								[
								].
							].

						literalAction value.
					].
				].

			character = $(
				ifTrue:
				[
					characterAction :=
					[
						stream
							nextPut:	character.

						index < aString size
							ifTrue:
							[
								( aString at: index + 1 ) ~= Character space
									ifTrue:
									[
										( aString at: index + 1 ) ~= $)
											ifTrue:
											[
												stream space.
											].
									].
							].

						index := index + 1.
					].
				].

			character = $)
				ifTrue:
				[
					characterAction :=
					[
						stream position > 0
							ifTrue:
							[
								stream contents last ~= Character space
									ifTrue:
									[
										stream contents last ~= $(
											ifTrue:
											[
												stream space.
											].
									].
							].

						stream
							nextPut:	character.

						index := index + 1.
					].
				].

			characterAction value.
		].

	^ stream contents.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatKeywordMessageLines: aMessageNode
indent: anIndentLevelInteger [
	|
		lines
		receiver
		keywordIndent
		parts
		args
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
	parts := aMessageNode selectorParts.
	args := aMessageNode arguments.

	1
		to:	parts size
		do:
		[ :idx |
			lines
				addAll:
				(
					self
						formatKeywordPart:
						(
							parts
								at:	idx
						)
						argument:
						(
							args
								at:	idx
						)
						indent:	keywordIndent
				).
		].

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
		ifTrue:
		[
			lines := OrderedCollection new.

			argumentLines :=
				self
					formatSubexpressionLines:	aNode
					indent:	anIndentLevelInteger.

			firstArgumentLine := argumentLines first trimBoth.

			argumentLineAction :=
			[
				lines
					add:
						indentString , aKeywordPart , String tab.

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
		].

	^
	{
		indentString , aKeywordPart , String tab ,
		(
			self
				formatInline:	aNode
		)
	}.
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

{ #category : 'as yet unclassified' }
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
					to:
						text size - 1.

			^ '#( ' , body trimBoth , ' )'.
		].

	^ text.
]

{ #category : 'as yet unclassified' }
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
				messageAction
			|

			receiverLines :=
				self
					formatBlockLines:	aMessageNode receiver
					indent:	anIndentLevelInteger.

			messageAction :=
			[
				receiverLines
					at:	receiverLines size
					put:
						receiverLines last , ' ' ,
						aMessageNode selector asString.
			].

			aMessageNode isBinary
				ifTrue:
				[
					messageAction :=
					[
						receiverLines
							at:	receiverLines size
							put:
								receiverLines last , ' ' ,
								aMessageNode selector asString , ' ' ,
								(
									self
										formatInline:
											aMessageNode arguments first
								).
					].
				].

			messageAction value.
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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatParenthesizedLines: aNode
indent: anIndentLevelInteger [
	|
		lines
		inner
	|

	lines := OrderedCollection new.

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, '('.

	inner :=
		aNode
			acceptFormatterRudesheim:	self
			indent:	anIndentLevelInteger + 1.

	lines
		addAll:	inner.

	lines
		add:
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, ')'.

	^ lines.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatReturnLines: aReturnNode
indent: anIndentLevelInteger [
	|
		indentString
		exprLines
		firstLineBody
		startsWithBracket
		lines
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
					copyFrom:
						indentString size + 1
					to:
						exprLines first size.
		].

	startsWithBracket := false.

	firstLineBody notEmpty
		ifTrue:
		[
			startsWithBracket :=
				self
					isOpeningBracketCharacter:	firstLineBody first.
		].

	startsWithBracket
		ifTrue:
		[
			exprLines size > 1
				ifTrue:
				[
					lines := OrderedCollection new.

					lines
						add:	indentString , '^'.

					lines
						addAll:	exprLines.

					^ lines.
				].
		].

	lines := OrderedCollection new.

	lines
		add:
			indentString , '^ ' , firstLineBody.

	lines
		addAll:	exprLines allButFirst.

	^ lines.
]

{ #category : 'as yet unclassified' }
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
			^ #(  ).
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
								return:
									aSequenceNode parent left.
						].

					aSequenceNode sourceInterval first - 1.
				] value
			].

	1
		to:	statements size
		do:
		[ :idx |
			|
				stmt
				stmtLines
				nextLines
				appendPeriodAction
			|

			stmt :=
				statements
					at:	idx.

			lines
				addAll:
				(
					self
						formatCommentLinesInSource:	aSequenceNode source
						from:	previousEnd + 1
						to:
							stmt sourceInterval first - 1
						indent:	anIndentLevelInteger
				).

			stmtLines :=
				self
					formatStatementLines:	stmt
					indent:	anIndentLevelInteger.

			appendPeriodAction :=
			[
				self
					appendPeriodToLastLine:	stmtLines.
			].

			idx = statements size
				ifTrue:
				[
					stmt isMessage
						ifTrue:
						[
							(
								self
									isBlockStatement:	stmt
							)
								ifTrue:
								[
									stmt isKeyword not
										ifTrue:
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
				addAll:	stmtLines.

			previousEnd := stmt sourceInterval last.

			idx < statements size
				ifTrue:
				[
					nextLines :=
						self
							formatStatementLines:
							(
								statements
									at:	idx + 1
							)
							indent:	anIndentLevelInteger.

					(
						self
							needsBlankLineAfter:	stmt
							next:
							(
								statements
									at:	idx + 1
							)
							currentLines:	stmtLines
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatSignatureLinesFor: aMethodNode [
	|
		selector
		parts
		args
		lines
	|

	selector := aMethodNode selector asString.

	(
		selector
			includes:	$:
	)
		ifTrue:
		[
			parts := aMethodNode selectorParts.
			args := aMethodNode argumentNames.
			lines := OrderedCollection new.

			1
				to:	parts size
				do:
				[ :idx |
					lines
						add:
						(
							parts
								at:	idx
						) , ' ' ,
						(
							args
								at:	idx
						).
				].

			^ lines.
		].

	aMethodNode numArgs = 0
		ifTrue:
		[
			^ {selector}.
		].

	^
	{
		selector , ' ' ,
		aMethodNode argumentNames first
	}.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatStatementLines: aStatementNode
indent: anIndentLevelInteger [
	^ aStatementNode
		acceptFormatterRudesheimAsStatement:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatSubexpressionLines: aNode
indent: anIndentLevelInteger [
	^ aNode
		acceptFormatterRudesheimAsSubexpression:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatTempsLinesFor: aTempsNode
indent: anIndentLevelInteger [
	|
		lines
		indent
		inner
	|

	indent :=
		self
			indentStringFor:	anIndentLevelInteger.

	inner :=
		self
			indentStringFor:	anIndentLevelInteger + 1.

	lines := OrderedCollection new.

	lines
		add:	indent , '|'.

	aTempsNode
		do:
		[ :each |
			lines
				add:	inner , each.
		].

	lines
		add:	indent , '|'.

	^ lines.
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
						stepText := step selector asString , ' ' , ( self formatInline: step arguments first ).
					].

				lines
					at:	lines size
					put:
						lines last , ' ' , stepText.
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
									put:
										lines last , ' ' ,
										step selector asString.

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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> indentStringFor: anInteger [
	|
		count
	|

	anInteger isNumber
		ifTrue:
		[
			count :=
				anInteger
					max:	0.

			count = 0
				ifTrue:
				[
					^ ''.
				].

			^ String
				new:	count
				withAll:	Character tab.
		].

	^ ''.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> isBlockStatement: aStatementNode [
	^ aStatementNode isBlockStatementForFormatterRudesheim.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> isKeywordMessage: aMessage [
	^ aMessage
		selector
		asString
		includes:	$:.
]

{ #category : 'testing' }
FormatterToolingRudesheim class >> isOpeningBracketCharacter: aCharacter [
	aCharacter = $(
		ifTrue:
		[
			^ true.
		].

	aCharacter = $[
		ifTrue:
		[
			^ true.
		].

	aCharacter asciiValue = 123
		ifTrue:
		[
			^ true.
		].

	^ false.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> joinLines: aLineCollection [
	|
		stream
	|

	stream :=
		String
			streamContents:
			[ :out |
				aLineCollection
					doWithIndex:
					[ :line :idx |
						out
							nextPutAll:	line.

						idx < aLineCollection size
							ifTrue:
							[
								out cr.
							].
					].
			].

	^ stream.
]

{ #category : 'as yet unclassified' }
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

	aCurrentLineCollection size > 1
		ifTrue:
		[
			^ true.
		].

	aNextLineCollection size > 1
		ifTrue:
		[
			^ true.
		].

	^ false.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> needsMultilineFor: aNode [
	^ aNode
		needsMultilineForFormatterRudesheim:	self.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> priority [
	^ 100.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> repairMethodString: aString [
	|
		size
		index
		stream
		keywords
		candidates
	|

	keywords := self systemKeywordParts.

	candidates :=
		self
			candidateIdentifiersIn:	aString.

	size := aString size.

	stream :=
		String
			streamContents:
			[ :out |
				index := 1.
				[
					index <= size.
				]
					whileTrue:
					[
						|
							ch
						|

						ch :=
							aString
								at:	index.
						[
							|
								break
							|

							break := thisContext.

							ch isAlphaNumeric
								ifTrue:
								[
									|
										start
										ident
										nextChar
										nextIsKeywordColon
										repaired
									|

									start := index.
									[
										[
											|
												conditionBreak
											|

											conditionBreak := thisContext.

											index <= size
												ifTrue:
												[
													conditionBreak
														return:
														(
															aString
																at:	index
														) isAlphaNumeric.
												].

											false.
										] value
									]
										whileTrue:
										[
											index := index + 1.
										].

									ident :=
										aString
											copyFrom:	start
											to:	index - 1.

									nextChar := [ | valueBreak | valueBreak := thisContext. index <= size ifTrue: [ valueBreak return: ( aString at: index ) ]. nil ] value.
									nextIsKeywordColon := false.

									nextChar = $:
										ifTrue:
										[
											nextIsKeywordColon := [ | valueBreak | valueBreak := thisContext. index + 1 <= size ifTrue: [ valueBreak return: ( aString at: index + 1 ) ~= $= ]. true ] value.
										].

									repaired :=
										self
											splitIdentifier:	ident
											usingUnarySelectors:	#(  )
											usingKeywordParts:	keywords
											usingCandidates:	candidates
											followedByColon:	nextIsKeywordColon.

									out
										nextPutAll:	repaired.

									break
										return:	self.
								].

							out
								nextPut:	ch.

							index := index + 1.
						] value
					].
			].

	^ stream.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> sourceStringFrom: anObject [
	anObject isString
		ifTrue:
		[
			^ anObject.
		].

	(
		anObject
			respondsTo:	#source
	)
		ifTrue:
		[
			^ anObject source.
		].

	(
		anObject
			respondsTo:	#sourceCode
	)
		ifTrue:
		[
			^ anObject sourceCode.
		].

	^ anObject asString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> splitIdentifier: anIdentifierString
usingUnarySelectors: aUnarySelectorCollection
usingKeywordParts: aKeywordPartCollection
usingCandidates: aCandidateCollection
followedByColon: anIsKeywordBoolean [
	|
		bestMatch
		bestSize
		prefix
	|

	anIsKeywordBoolean
		ifTrue:
		[
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
						eachSize
					|

					eachSize := each size.

					eachSize > 0
						ifTrue:
						[
							(
								anIdentifierString
									endsWith:	each
							)
								ifTrue:
								[
									eachSize < anIdentifierString size
										ifTrue:
										[
											eachSize > bestSize
												ifTrue:
												[
													bestSize := eachSize.
													bestMatch := each.
												].
										].
								].
						].
				].

			bestMatch
				ifNil:
				[
					^ anIdentifierString.
				].

			prefix :=
				anIdentifierString
					copyFrom:	1
					to:
						anIdentifierString size - bestMatch size.

			prefix isEmpty
				ifTrue:
				[
					^ anIdentifierString.
				].

			( aCandidateCollection includes: prefix ) not
				ifTrue:
				[
					^ anIdentifierString.
				].

			^ prefix , ' ' , bestMatch.
		].

	^ anIdentifierString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> systemKeywordParts [
	|
		parts
	|

	parts := Set new.

	Smalltalk allClasses
		do:
		[ :cls |
			|
				selectors
			|

			selectors := cls selectors.

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

			selectors := cls class selectors.

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

{ #category : 'as yet unclassified' }
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
