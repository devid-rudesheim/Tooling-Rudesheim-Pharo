Extension { #name : 'OCCascadeNode' }

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter Cascade
		formatCascadeLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> acceptFormatterRudesheimAsSubexpression: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter
		formatParenthesizedLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ true.
]
