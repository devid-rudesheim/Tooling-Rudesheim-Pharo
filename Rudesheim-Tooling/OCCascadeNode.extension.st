Extension { #name : 'OCCascadeNode' }

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentLevelInteger [
	^ aFormatter
		formatCascadeLines:	self
		indent:	anIndentLevelInteger.
]

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> acceptFormatterRudesheimAsSubexpression: aFormatter
indent: anIndentLevelInteger [
	^ aFormatter
		formatParenthesizedLines:	self
		indent:	anIndentLevelInteger.
]

{ #category : '*Rudesheim-Tooling' }
OCCascadeNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ true.
]
