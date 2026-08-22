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
		formatter
		lines
		statements
		previousEnd
	|

	formatter := Rudesheim Tooling Formatter.
	statements := anArrayNode statements.

	statements
		ifEmpty:
		[
			^
			{
				anIndentToolingRudesheim asString , '{}'
			}.
		].

	(
		formatter
			needsMultilineFor:	anArrayNode
	)
		ifFalse:
		[
			^
			{
				anIndentToolingRudesheim asString ,
				(
					formatter
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
					formatter
						formatCommentLinesInSource:	anArrayNode source
						from:	previousEnd + 1
						to:	each sourceInterval first - 1
						indent:	anIndentToolingRudesheim oneLevelDeeper
				).

			elementLines :=
				formatter
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
