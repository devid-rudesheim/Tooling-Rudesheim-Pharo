Extension { #name : 'OCBlockNode' }

{ #category : '*Rudesheim-Tooling' }
OCBlockNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ BlockFormatterToolingRudesheim
		formatBlockLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCBlockNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ true.
]
