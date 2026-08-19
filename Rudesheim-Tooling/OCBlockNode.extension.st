Extension { #name : 'OCBlockNode' }

{ #category : '*Rudesheim-Tooling' }
OCBlockNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentLevelInteger [
	^ aFormatter
		formatBlockLines:	self
		indent:	anIndentLevelInteger.
]

{ #category : '*Rudesheim-Tooling' }
OCBlockNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ true.
]
