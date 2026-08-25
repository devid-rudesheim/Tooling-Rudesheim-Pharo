"
Formats keyword OCMessageNode sends.
"
Class {
	#name : 'KeywordMessageKindFormatterToolingRudesheim',
	#superclass : 'MessageKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private-MessageKind',
	#package : 'Rudesheim-Tooling-Private',
	#tag : 'MessageKind'
}

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatKeywordMessageLines: aMessageNode
indent: anIndentToolingRudesheim [
	|
		lines
		receiver
		keywordIndent
	|

	receiver := aMessageNode receiver.

	lines :=
		OrderedCollection
			newFrom:
			(
				self
					formatKeywordReceiverLines:	receiver
					indent:	anIndentToolingRudesheim
			).

	keywordIndent := anIndentToolingRudesheim oneLevelDeeper.

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
						indent:	keywordIndent.
				]
		) flattened.

	^ lines.
]

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatKeywordPart: aKeywordPart
argument: aNode
indent: anIndentToolingRudesheim [
	|
		formatter
		indentString
		lines
		argumentLines
		firstArgumentLine
		argumentLineAction
	|

	formatter := Rudesheim Tooling Formatter.
	indentString := anIndentToolingRudesheim asString.

	aNode isBlock
		ifTrue:
		[
			^ OrderedCollection new
				add:	indentString , aKeywordPart;
				addAll:
				(
					formatter Block
						formatBlockLines:	aNode
						indent:	anIndentToolingRudesheim
				);
				yourself.
		].

	argumentLines :=
		formatter
			formatSubexpressionLines:	aNode
			indent:	anIndentToolingRudesheim.

	1 = argumentLines size
		ifTrue:
		[
			"aNode's own rendering already fits on one line, so it can share the keyword's
			line regardless of needsMultilineFor: aNode -- which also answers true for a node
			that was merely hand-typed across several lines (e.g. a plain unary chain like
			`root Column ForDateAndTime`) even though that chain's own formatting always
			collapses it onto one line anyway (see MessageKindFormatterToolingRudesheim
			class>>formatLines:indent:), regardless of how many lines it was hand-typed
			across. Deciding from aNode's *actual rendered* line count instead of that
			pre-formatting guess keeps this in sync with how the very same argument renders
			in every other position (a bare statement, a message receiver) -- otherwise the
			keyword gets pushed onto its own line above an argument that then renders as a
			single line anyway, and reformatting the result collapses the two lines the first
			pass insisted on keeping apart."
			^
			{
				indentString , aKeywordPart , String tab ,
				(
					formatter
						formatInline:	aNode
				)
			}.
		].

	lines := OrderedCollection new.
	firstArgumentLine := argumentLines first trimBoth.

	argumentLineAction :=
	[
		lines
			add:	indentString , aKeywordPart.

		argumentLines :=
			formatter
				formatSubexpressionLines:	aNode
				indent:	anIndentToolingRudesheim oneLevelDeeper.
	].
	[
		|
			continue
		|

		continue := thisContext.

		firstArgumentLine
			ifEmpty:
			[
				continue return.
			].

		(
			formatter
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

		(
			firstArgumentLine
				beginsWith:	'#('
		)
			ifTrue:
			[
				"A literal array's own opening bracket is the two characters #( , so it never
				matches the single-character isOpeningBracketCharacter: check above -- without
				this, a multiline literal array argument would get re-indented one level
				deeper instead of hanging at the keyword's own indent like { and [ already do."
				argumentLineAction :=
				[
					lines
						add:	indentString , aKeywordPart.
				].
			].
	] value.

	argumentLineAction value.

	lines
		addAll:	argumentLines.

	^ lines.
]

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatKeywordReceiverLines: aParseNode
indent: anIndentToolingRudesheim [
	^ Rudesheim Tooling Formatter
		formatSubexpressionLines:	aParseNode
		indent:	anIndentToolingRudesheim.
]

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatLines: aMessageNode
indent: anIndentToolingRudesheim [
	^ self
		formatKeywordMessageLines:	aMessageNode
		indent:	anIndentToolingRudesheim.
]
