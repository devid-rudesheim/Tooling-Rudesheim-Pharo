Extension { #name : 'OCLiteralArrayNode' }

{ #category : '*Rudesheim-Tooling' }
OCLiteralArrayNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter LiteralArray
		formatLiteralArrayLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCLiteralArrayNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	"AssignmentFormatterToolingRudesheim class>>formatAssignmentLines:indent: uses this (not
	acceptFormatterRudesheim:indent:) to decide whether `x := value` puts the value on the
	assignment's own line at all -- when it answers false, the value is rendered with
	formatInline: unconditionally, which for a literal array means
	FormatterToolingRudesheim class>>formatLiteralArrayInline: (always single-line),
	bypassing needsMultilineForFormatterRudesheim: and this class's own multiline support
	entirely. A dynamic array ({ ... }, OCArrayNode) always answers true here since it always
	goes multiline anyway; a literal array must not (a short one like `x := #( 1 2 3 )` has to
	stay on one line, per testLiteralArrayKeepsInsideSpaces), so this defers to the very same
	check that decides whether the array needs its own multiple lines at all."

	^ aFormatter
		needsMultilineFor:	self.
]

{ #category : '*Rudesheim-Tooling' }
OCLiteralArrayNode >> needsMultilineForFormatterRudesheim: aFormatter [
	"Unlike a dynamic array ({ ... }), a literal array only needs its own multiple lines when
	the author already wrote it that way (handled generically by
	FormatterToolingRudesheim class>>needsMultilineFor:'s hasHandWrittenLineBreakFor: check)
	or when a literal array nested inside it needs multiple lines -- checking needsMultilineFor:
	on every element, not just the ones that are themselves literal arrays, both keeps this
	recursive for arbitrarily nested arrays and costs nothing extra: a plain literal value
	never needs multiline on its own."

	^ self contents
		anySatisfy:
		[ :each |
			aFormatter
				needsMultilineFor:	each.
		].
]
