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

	lines := OrderedCollection new.
	receiver := aMessageNode receiver.

	lines
		addAll:
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
						indent:	keywordIndent
				]
		) flattened.

	^ lines.
]

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatKeywordPart: aKeywordPart
argument: aNode
indent: anIndentToolingRudesheim [
	|
		indentString
		lines
		argumentLines
		firstArgumentLine
		argumentLineAction
	|

	indentString := anIndentToolingRudesheim asString.

	aNode isBlock
		ifTrue:
		[
			^ OrderedCollection new
				add:	indentString , aKeywordPart;
				addAll:
				(
					BlockFormatterToolingRudesheim
						formatBlockLines:	aNode
						indent:	anIndentToolingRudesheim
				);
				yourself.
		].

	(
		FormatterToolingRudesheim
			needsMultilineFor:	aNode
	)
		ifFalse:
		[
			^
			{
				indentString , aKeywordPart , String tab ,
				(
					FormatterToolingRudesheim
						formatInline:	aNode
				)
			}.
		].

	lines := OrderedCollection new.

	argumentLines :=
		FormatterToolingRudesheim
			formatSubexpressionLines:	aNode
			indent:	anIndentToolingRudesheim.

	firstArgumentLine := argumentLines first trimBoth.

	argumentLineAction :=
	[
		lines
			add:	indentString , aKeywordPart , String tab.

		argumentLines :=
			FormatterToolingRudesheim
				formatSubexpressionLines:	aNode
				indent:	anIndentToolingRudesheim oneLevelDeeper.
	].

	firstArgumentLine notEmpty
		ifTrue:
		[
			(
				FormatterToolingRudesheim
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

{ #category : 'formatting' }
KeywordMessageKindFormatterToolingRudesheim class >> formatKeywordReceiverLines: aParseNode
indent: anIndentToolingRudesheim [
	^ FormatterToolingRudesheim
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
