Extension { #name : 'ClassDescription' }

{ #category : '*Rudesheim-Tooling' }
ClassDescription >> createGetMethodWithDefault:	aVariableNameString [
	|
		selectorForDefault
		classified
	|
	
	aVariableNameString
		ifEmpty:
		[
			Rudesheim Utility SyntaxErrorNotification
				inClass:		self
				withCode:		''
				doitFlag:		false
				errorMessage:	'Message pattern expected'
				location: 		1.
		].
	
	classified := 'accessing'.
	selectorForDefault := 'default', aVariableNameString first uppercase asString, aVariableNameString copyWithoutFirst.
	
	self
		compile:
		(
'{1}

	^ 0.
'
				format:
				{
					selectorForDefault
				}
		)
		classified: 	classified.

	self
		compile:
		(
'{1}

	^ {1}
		ifNil:
		[
			{1} := self {2}.
		].
'
				format:
				{
					aVariableNameString.
					selectorForDefault
				}
		)
		classified: 	classified.
]
