"
EFFormatter compatible entry point that applies tmp/format.md rules first for known patterns, then falls back to EFFormatter.
"
Class {
	#name : 'FormatterToolingRudesheim',
	#superclass : 'OCAbstractFormatter',
	#category : 'Rudesheim-Tooling',
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

	(
		last isEmpty
			or:
			[
				last
					endsWith:	'.'.
			]
	)
		ifFalse:
		[
			aLineCollection
				at:	aLineCollection size
				put:	last , '.'.
		].
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
			(
				aString
					at:	index
			)
				isAlphaNumeric
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
						index <= size
							and:
							[
								(
									aString
										at:	index
								)
									isAlphaNumeric.
							].
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

					nextChar :=
						nextIndex <= size
							ifTrue:
							[
								aString
									at:	nextIndex.
							]
							ifFalse:
							[
								nil.
							].

					nextChar2 :=
						nextIndex
							+ 1
							<= size
							ifTrue:
							[
								aString
									at:	nextIndex + 1.
							]
							ifFalse:
							[
								nil.
							].

					(
						nextChar = $:
							and:
							[
								nextChar2 = $=.
							]
					)
						ifTrue:
						[
							candidates
								add:	ident.
						].

					(
						nextChar isNil
							or:
							[
								nextChar isSeparator
									or:
									[
										nextChar = $.
											or:
											[
												nextChar = $]
													or:
													[
														nextChar = $)
															or:
															[
																nextChar = $;
																	or:
																	[
																		nextChar = $:.
																	].
															].
													].
											].
									].
							]
					)
						ifTrue:
						[
							candidates
								add:	ident.
						].
				]
				ifFalse:
				[
					index := index + 1.
				].
		].

	^ candidates.
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
					line isEmpty
						ifTrue:
						[
							out
								nextPutAll:	line.
						]
						ifFalse:
						[
							out
								nextPutAll:	indent;
								nextPutAll:	line.
						].

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
				)
					, '{}'
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
				)
					, (self formatInline: anArrayNode)
			}.
		].

	lines := OrderedCollection new.

	lines
		add:	
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, '{'.

	statements
		doWithIndex:
		[ :each :idx |
			|
				elementLines
			|

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
						elementLines
							last
							, '.'.
				].

			lines
				addAll:	elementLines.
		].

	lines
		add:	
		(
			self
				indentStringFor:	anIndentLevelInteger
		)
			, '}'.

	^ lines.
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
				)
					, prefix.

			lines
				addAll:	
				(
					self
						formatExpressionLines:	value
						indent:	anIndentLevelInteger + 1
				).

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
		)
			, prefix
			, ' '
			, inline
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
	header := (self indentStringFor: anIndentLevelInteger) , '['.

	args isEmpty
		ifFalse:
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

	temps isEmpty
		ifFalse:
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
		)
			, ']'.

	^ lines.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatCascadeLines: aCascadeNode
indent: anIndentLevelInteger [
	|
		lines
		receiver
		keywordIndent
		messages
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

	1
		to:	messages size
		do:
		[ :idx |
			|
				partLines
			|

			partLines :=
				self
					formatCascadePartLines:	
					(
						messages
							at:	idx
					)
					indent:	keywordIndent.

			idx < messages size
				ifTrue:
				[
					partLines
						at:	partLines size
						put:	
						partLines
							last
							, ';'.
				].

			lines
				addAll:	partLines.
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
FormatterToolingRudesheim class >> formatExpressionLines: aParseNode
indent: anIndentLevelInteger [
	^ aParseNode
		acceptFormatterRudesheim:	self
		indent:	anIndentLevelInteger.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatInline: aParseNode [
	|
		text
	|

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

	^ text trimBoth.
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
				formatSubexpressionLines:	receiver
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatKeywordPart: aKeywordPart
argument: aNode
indent: anIndentLevelInteger [
	|
		indentString
		lines
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

			lines
				add:	indentString , aKeywordPart.

			lines
				addAll:
				(
					self
						formatSubexpressionLines:	aNode
						indent:	anIndentLevelInteger
				).

			^ lines.
		].

	^
	{
		indentString
			, aKeywordPart
			, String tab
			, (self formatInline: aNode)
	}.
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

	aMessageNode
		receiver
		isBlock
		ifTrue:
		[
			|
				receiverLines
			|

			receiverLines :=
				self
					formatBlockLines:	aMessageNode receiver
					indent:	anIndentLevelInteger.

			aMessageNode isBinary
				ifTrue:
				[
					receiverLines
						at:	receiverLines size
						put:	
						receiverLines
							last
							, ' '
							, aMessageNode selector asString
							, ' '
							, (self formatInline: aMessageNode arguments first).
				]
				ifFalse:
				[
					receiverLines
						at:	receiverLines size
						put:	
						receiverLines
							last
							, ' '
							, aMessageNode selector asString.
				].

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
		)
			, (self formatInline: aMessageNode)
	}.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatMethodNode: aMethodNode [
	|
		lines
		temps
	|

	lines := OrderedCollection new.

	lines
		addAll:	
		(
			self
				formatSignatureLinesFor:	aMethodNode
		).

	temps := aMethodNode temporaryNames.

	temps isEmpty
		ifFalse:
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

	firstLineBody :=
		(
			exprLines first
				beginsWith:	indentString
		)
			ifTrue:
			[
				exprLines first
					copyFrom:	
					indentString
						size
						+ 1
					to:	
					exprLines
						first
						size.
			]
			ifFalse:
			[
				exprLines first.
			].

	startsWithBracket :=
		firstLineBody notEmpty
			and:
			[
				#($( $[ ${)
					includes:	firstLineBody first.
			].

	(
		startsWithBracket
			and:
			[
				exprLines
					size
					> 1.
			]
	)
		ifTrue:
		[
			lines := OrderedCollection new.

			lines
				add:	indentString , '^'.

			lines
				addAll:	exprLines.

			^ lines.
		].

	lines := OrderedCollection new.

	lines
		add:	
		indentString
			, '^ '
			, firstLineBody.

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
	|

	aSequenceNode isNil
		ifTrue:
		[
			self error: 'aSequenceNode must not be nil'.
		].

	statements := aSequenceNode statements.
	lines := OrderedCollection new.

	1
		to:	statements size
		do:
		[ :idx |
			|
				stmt
				stmtLines
				nextLines
				shouldAppend
				skipPeriod
			|

			stmt :=
				statements
					at:	idx.

			stmtLines :=
				self
					formatStatementLines:	stmt
					indent:	anIndentLevelInteger.

			shouldAppend := true.

			idx = statements size
				ifTrue:
				[
					skipPeriod :=
						stmt isMessage
							and:
							[
								(
									self
										isBlockStatement:	stmt
								)
									and:
									[
										stmt
											isKeyword
											not.
									].
							].

					skipPeriod
						ifTrue:
						[
							shouldAppend := false.
						].
				].

			shouldAppend
				ifTrue:
				[
					self
						appendPeriodToLastLine:	stmtLines.
				].

			lines
				addAll:	stmtLines.

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
		ifFalse:
		[
			aMethodNode
				numArgs
				= 0
				ifTrue:
				[
					^ {selector}.
				].

			^
			{
				selector
					, ' '
					, aMethodNode argumentNames first
			}.
		].

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
				)
					, ' '
					, (args at: idx).
		].

	^ lines.
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheim class >> formatUnaryOrBinaryChainLines: aMessageNode
indent: anIndentLevelInteger [
	|
		steps
		node
		lines
		receiverLines
		receiverNeedsParens
		keepWalking
		suffix
	|

	steps := OrderedCollection new.
	node := aMessageNode.
	receiverNeedsParens := false.
	keepWalking := true.
	[
		keepWalking
			and:
			[
				(
					node
						isKindOf:	OCMessageNode
				)
					and:
					[
						(
							self
								isKeywordMessage:	node
						)
							not.
					].
			].
	]
		whileTrue:
		[
			steps
				addFirst:	node.

			(
				node
					isBinary
					not
					and:
					[
						(
							node receiver
								isKindOf:	OCMessageNode
						)
							and:
							[
								node
									receiver
									isBinary.
							].
					]
			)
				ifTrue:
				[
					receiverNeedsParens := true.
					keepWalking := false.
				].

			node := node receiver.
		].

	receiverLines :=
		receiverNeedsParens
			ifTrue:
			[
				self
					formatParenthesizedLines:	node
					indent:	anIndentLevelInteger.
			]
			ifFalse:
			[
				self
					formatSubexpressionLines:	node
					indent:	anIndentLevelInteger.
			].

	suffix :=
		String
			streamContents:
			[ :out |
				steps
					do:
					[ :step |
						out space.

						step isBinary
							ifTrue:
							[
								out
									nextPutAll:
									step
										selector
										asString
										, ' '
										, (self formatInline: step arguments first).
							]
							ifFalse:
							[
								out
									nextPutAll:	step selector asString.
							].
					].
			].

	lines := OrderedCollection new.

	lines
		addAll:	receiverLines.

	lines
		at:	lines size
		put:	lines last , suffix.

	^ lines.
]

{ #category : 'as yet unclassified' }
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

	count = 0
		ifTrue:
		[
			^ ''.
		].

	^ String
		new:	count
		withAll:	Character tab.
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

	(
		currentIsAssign
			and:
			[
				nextIsBlock.
			]
	)
		ifTrue:
		[
			^ false.
		].

	(
		aCurrentLineCollection
			size
			> 1
			or:
			[
				aNextLineCollection
					size
					> 1.
			]
	)
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
									index <= size
										and:
										[
											(
												aString
													at:	index
											)
												isAlphaNumeric.
										].
								]
									whileTrue:
									[
										index := index + 1.
									].

								ident :=
									aString
										copyFrom:	start
										to:	index - 1.

								nextChar :=
									index <= size
										ifTrue:
										[
											aString
												at:	index.
										]
										ifFalse:
										[
											nil.
										].

								nextIsKeywordColon :=
									nextChar = $:
										and:
										[
											index
												+ 1
												<= size
												ifTrue:
												[
													(
														aString
															at:	index + 1
													)
														~= $=.
												]
												ifFalse:
												[
													true.
												].
										].

								repaired :=
									self
										splitIdentifier:	ident
										usingUnarySelectors:	#()
										usingKeywordParts:	keywords
										usingCandidates:	candidates
										followedByColon:	nextIsKeywordColon.

								out
									nextPutAll:	repaired.
							]
							ifFalse:
							[
								out
									nextPut:	ch.

								index := index + 1.
							].
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
		ifFalse:
		[
			^ anIdentifierString.
		].

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

			(
				eachSize > 0
					and:
					[
						anIdentifierString
							endsWith:	each.
					]
			)
				ifTrue:
				[
					(
						eachSize < anIdentifierString size
							and:
							[
								eachSize > bestSize.
							]
					)
						ifTrue:
						[
							bestSize := eachSize.
							bestMatch := each.
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
			anIdentifierString
				size
				- bestMatch size.

	(
		prefix isEmpty
			or:
			[
				(
					aCandidateCollection
						includes:	prefix
				)
					not.
			]
	)
		ifTrue:
		[
			^ anIdentifierString.
		].

	^ prefix
		, ' '
		, bestMatch.
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
									each isEmpty
										ifFalse:
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
									each isEmpty
										ifFalse:
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
