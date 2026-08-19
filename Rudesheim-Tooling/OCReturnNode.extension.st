Extension { #name : 'OCReturnNode' }

{ #category : '*Rudesheim-Tooling' }
OCReturnNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentLevelInteger [
	^ aFormatter
		formatReturnLines:	self
		indent:	anIndentLevelInteger.
]
