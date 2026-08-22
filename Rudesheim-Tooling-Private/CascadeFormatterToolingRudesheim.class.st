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
		formatter
		lines
		receiver
		keywordIndent
		messages
		previousEnd
	|

	formatter := Rudesheim Tooling Formatter.
	receiver := aCascadeNode receiver.

	lines :=
		OrderedCollection
			newFrom:
			(
				formatter
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
					formatter
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
					with:	aMessageNode arguments
					collect:
					[ :part :argument |
						Rudesheim Tooling Formatter MessageKind Keyword
							formatKeywordPart:	part
							argument:	argument
							indent:	anIndentToolingRudesheim.
					]
			) flattened.
		].

	line := anIndentToolingRudesheim asString , aMessageNode selector asString.

	aMessageNode isBinary
		ifTrue:
		[
			line :=
				line , ' ' ,
				(
					Rudesheim Tooling Formatter
						formatInline:	aMessageNode arguments first
				).
		].

	^
	{
		line
	}.
]
