Extension { #name : 'OCLiteralArrayNode' }

{ #category : '*Rudesheim-Tooling' }
OCLiteralArrayNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter LiteralArray
		formatLiteralArrayLines:	self
		indent:	anIndentToolingRudesheim.
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
