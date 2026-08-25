Extension { #name : 'OCArrayNode' }

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter Array
		formatArrayLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ true.
]

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ self statements notEmpty.
]
