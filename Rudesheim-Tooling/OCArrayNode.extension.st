Extension { #name : 'OCArrayNode' }

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger [
	^ aFormatter formatArrayLines: self indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCArrayNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ self statements anySatisfy: [ :each | each needsMultilineForFormatterRudesheim: aFormatter ]
]
