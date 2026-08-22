Extension { #name : 'OCReturnNode' }

{ #category : '*Rudesheim-Tooling' }
OCReturnNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter Return
		formatReturnLines:	self
		indent:	anIndentToolingRudesheim.
]
