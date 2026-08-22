"
Formats keyword OCMessageNode sends.
"
Class {
	#name : 'KeywordMessageKindFormatterToolingRudesheim',
	#superclass : 'MessageKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
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

	(
		formatter
			needsMultilineFor:	aNode
	)
		ifFalse:
		[
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

	argumentLines :=
		formatter
			formatSubexpressionLines:	aNode
			indent:	anIndentToolingRudesheim.

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
