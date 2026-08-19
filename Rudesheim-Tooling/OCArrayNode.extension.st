Extension { #name : 'OCArrayNode' }

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger [
	^ aFormatter formatArrayLines: self indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ true
]

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ self statements notEmpty
]
