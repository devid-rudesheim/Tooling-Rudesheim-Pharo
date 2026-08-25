Extension { #name : 'OCProgramNode' }

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter
		formatInlineNodeLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentToolingRudesheim [
	^ self
		acceptFormatterRudesheim:	aFormatter
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> acceptFormatterRudesheimAsSubexpression: aFormatter
indent: anIndentToolingRudesheim [
	^ self
		acceptFormatterRudesheim:	aFormatter
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> isBlockStatementForFormatterRudesheim [
	^ self isBlock.
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ self isBlock.
]

{ #category : '*Rudesheim-Tooling' }
OCProgramNode >> needsMultilineForFormatterRudesheim: aFormatter [
	^ false.
]
