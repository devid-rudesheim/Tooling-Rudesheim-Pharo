Extension { #name : 'OCAssignmentNode' }

{ #category : '*Rudesheim-Tooling' }
OCAssignmentNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentLevelInteger [
	^ aFormatter
		formatAssignmentLines:	self
		indent:	anIndentLevelInteger.
]
