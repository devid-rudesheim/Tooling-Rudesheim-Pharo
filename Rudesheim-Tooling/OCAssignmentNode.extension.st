Extension { #name : 'OCAssignmentNode' }

{ #category : '*Rudesheim-Tooling' }
OCAssignmentNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentToolingRudesheim [
	^ AssignmentFormatterToolingRudesheim
		formatAssignmentLines:	self
		indent:	anIndentToolingRudesheim.
]
