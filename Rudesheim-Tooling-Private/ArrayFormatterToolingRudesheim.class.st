"
Formats OCArrayNode lines for FormatterToolingRudesheim.
"
Class {
	#name : 'ArrayFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
ArrayFormatterToolingRudesheim class >> formatArrayLines: anArrayNode
indent: anIndentToolingRudesheim [
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
				anIndentToolingRudesheim asString , '{}'
			}.
		].

	(
		FormatterToolingRudesheim
			needsMultilineFor:	anArrayNode
	)
		ifFalse:
		[
			^
			{
				anIndentToolingRudesheim asString ,
				(
					FormatterToolingRudesheim
						formatInline:	anArrayNode
				)
			}.
		].

	lines := OrderedCollection new.

	lines
		add:
		anIndentToolingRudesheim asString , '{'.

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
					FormatterToolingRudesheim
						formatCommentLinesInSource:	anArrayNode source
						from:	previousEnd + 1
						to:	each sourceInterval first - 1
						indent:	anIndentToolingRudesheim oneLevelDeeper
				).

			elementLines :=
				FormatterToolingRudesheim
					formatExpressionLines:	each
					indent:	anIndentToolingRudesheim oneLevelDeeper.

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
		anIndentToolingRudesheim asString , '}'.

	^ lines.
]
