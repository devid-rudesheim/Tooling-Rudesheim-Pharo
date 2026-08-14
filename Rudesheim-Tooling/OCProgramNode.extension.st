Extension { #name : 'OCProgramNode' }

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger [
	^ aFormatter formatInlineNodeLines: self indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheimAsStatement: aFormatter indent: anIndentLevelInteger [
	^ self acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheimAsSubexpression: aFormatter indent: anIndentLevelInteger [
	^ self acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> isBlockStatementForFormatterRudesheim [
	^ self isBlock
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ self isBlock
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ false
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> unaryBinaryChainLengthForFormatterRudesheim: aFormatter [
	^ 0
]
