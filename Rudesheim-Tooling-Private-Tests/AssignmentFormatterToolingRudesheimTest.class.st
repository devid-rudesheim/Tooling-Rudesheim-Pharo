"
Tests AssignmentFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'AssignmentFormatterToolingRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-Tooling-Private-Tests-Formatters',
	#package : 'Rudesheim-Tooling-Private-Tests',
	#tag : 'Formatters'
}

{ #category : 'accessing' }
AssignmentFormatterToolingRudesheimTest class >> targetClass [
	^ AssignmentFormatterToolingRudesheim.
]

{ #category : 'tests' }
AssignmentFormatterToolingRudesheimTest >> testAssignmentPrefixJoinsMultipleVariablesWithColonEquals [
	self
		assert:
		(
			self targetClass
				assignmentPrefixForVariables:
				{
					OCParser
						parseExpression:	'a'.
					OCParser
						parseExpression:	'b'
				}
		)
		equals:	'a := b :='.
]

{ #category : 'tests' }
AssignmentFormatterToolingRudesheimTest >> testSimpleAssignmentStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		Rudesheim Tooling Formatter
			format:	'run | total | total := 1 + 2'.

	expected := 'run' , String cr , String tab , '|' , String cr , String tab , String tab , 'total' , String cr , String tab , '|' , String cr , String cr , String tab , 'total := 1 + 2.'.

	self
		assert:	formatted
		equals:	expected.
]
