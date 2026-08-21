Extension { #name : 'OCReturnNode' }

{ #category : '*Rudesheim-Tooling' }
OCReturnNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentToolingRudesheim [
	^ ReturnFormatterToolingRudesheim
		formatReturnLines:	self
		indent:	anIndentToolingRudesheim.
]
