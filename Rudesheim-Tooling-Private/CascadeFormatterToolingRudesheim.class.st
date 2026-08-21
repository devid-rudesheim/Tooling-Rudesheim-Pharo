"
Formats OCCascadeNode lines for FormatterToolingRudesheim.
"
Class {
	#name : 'CascadeFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
CascadeFormatterToolingRudesheim class >> cascadeMessageEndFor: aMessageNode [
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

{ #category : 'formatting' }
CascadeFormatterToolingRudesheim class >> cascadeMessageStartFor: aMessageNode [
	^ aMessageNode selectorInterval first.
]

{ #category : 'formatting' }
CascadeFormatterToolingRudesheim class >> formatCascadeLines: aCascadeNode
indent: anIndentToolingRudesheim [
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
			FormatterToolingRudesheim
				formatSubexpressionLines:	receiver
				indent:	anIndentToolingRudesheim
		).

	keywordIndent := anIndentToolingRudesheim oneLevelDeeper.
	messages := aCascadeNode messages.
	previousEnd := receiver sourceInterval last.

	1
		to:	messages size
		do:
		[ :index |
			|
				partLines
				message
			|

			message :=
				messages
					at:	index.

			lines
				addAll:
				(
					FormatterToolingRudesheim
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

			index < messages size
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
CascadeFormatterToolingRudesheim class >> formatCascadePartLines: aMessageNode
indent: anIndentToolingRudesheim [
	|
		line
	|

	aMessageNode isKeyword
		ifTrue:
		[
			^
			(
				aMessageNode selectorParts
					with: aMessageNode arguments
					collect:
					[ :part :argument |
						KeywordMessageKindFormatterToolingRudesheim
							formatKeywordPart:	part
							argument:	argument
							indent:	anIndentToolingRudesheim
					]
			) flattened
		].

	line :=
		anIndentToolingRudesheim asString , aMessageNode selector asString.

	aMessageNode isBinary
		ifTrue:
		[
			line :=
				line , ' ' ,
				(
					FormatterToolingRudesheim
						formatInline:	aMessageNode arguments first
				).
		].

	^
	{
		line.
	}
]
