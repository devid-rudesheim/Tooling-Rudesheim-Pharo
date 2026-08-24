"
Formats OCLiteralArrayNode lines for FormatterToolingRudesheim. Unlike
ArrayFormatterToolingRudesheim's dynamic array ({ ... }), which always goes multiline once
non-empty, a literal array (#( ... )) stays inline unless it (or a literal array nested
inside it) needs multiple lines -- see OCLiteralArrayNode>>needsMultilineForFormatterRudesheim:
in OCLiteralArrayNode.extension.st.
"
Class {
	#name : 'LiteralArrayFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
LiteralArrayFormatterToolingRudesheim class >> formatLiteralArrayElementLines: aNode
indent: anIndentToolingRudesheim [
	|
		formatter
	|

	formatter := Rudesheim Tooling Formatter.

	(
		aNode
			isKindOf:	OCLiteralArrayNode
	)
		ifTrue:
		[
			^ self
				formatLiteralArrayLines:	aNode
				indent:	anIndentToolingRudesheim.
		].

	^
	{
		anIndentToolingRudesheim asString ,
		(
			formatter
				formatInline:	aNode
		)
	}.
]

{ #category : 'formatting' }
LiteralArrayFormatterToolingRudesheim class >> formatLiteralArrayLines: aLiteralArrayNode
indent: anIndentToolingRudesheim [
	|
		formatter
		contents
		lines
		elementIndent
		previousEnd
	|

	formatter := Rudesheim Tooling Formatter.
	contents := aLiteralArrayNode contents.

	(
		formatter
			needsMultilineFor:	aLiteralArrayNode
	)
		ifFalse:
		[
			^
			{
				anIndentToolingRudesheim asString ,
				(
					formatter
						formatInline:	aLiteralArrayNode
				)
			}.
		].

	elementIndent := anIndentToolingRudesheim oneLevelDeeper.
	lines := OrderedCollection new.

	lines
		add:	anIndentToolingRudesheim asString , '#('.

	previousEnd :=
		aLiteralArrayNode sourceInterval first +
		aLiteralArrayNode openerSize -
		1.

	contents
		do:
		[ :each |
			lines
				addAll:
				(
					formatter
						formatCommentLinesInSource:	aLiteralArrayNode source
						from:	previousEnd + 1
						to:	each sourceInterval first - 1
						indent:	elementIndent
				).

			lines
				addAll:
				(
					self
						formatLiteralArrayElementLines:	each
						indent:	elementIndent
				).

			previousEnd := each sourceInterval last.
		].

	lines
		addAll:
		(
			formatter
				formatCommentLinesInSource:	aLiteralArrayNode source
				from:	previousEnd + 1
				to:	aLiteralArrayNode sourceInterval last - 1
				indent:	elementIndent
		).

	lines
		add:	anIndentToolingRudesheim asString , ')'.

	^ lines.
]
