Extension { #name : 'OCAssignmentNode' }

{ #category : '*Rudesheim-Tooling' }
OCAssignmentNode >> acceptFormatterRudesheimAsStatement: aFormatter
indent: anIndentToolingRudesheim [
	^ aFormatter Assignment
		formatAssignmentLines:	self
		indent:	anIndentToolingRudesheim.
]
