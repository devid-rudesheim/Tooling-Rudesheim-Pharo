"
Tests AssignmentFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'AssignmentFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
AssignmentFormatterToolingRudesheimTest >> testSimpleAssignmentStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		FormatterToolingRudesheim
			format:	'run | total | total := 1 + 2'.

	expected :=
		'run' , String cr , String tab , '|' , String cr , String tab , String tab , 'total' , String cr , String tab , '|' , String cr , String cr ,
		String tab , 'total := 1 + 2.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
AssignmentFormatterToolingRudesheimTest >> testAssignmentPrefixJoinsMultipleVariablesWithColonEquals [
	self
		assert:
		(
			AssignmentFormatterToolingRudesheim
				assignmentPrefixForVariables:
				{
					OCParser parseExpression: 'a'.
					OCParser parseExpression: 'b'.
				}
		)
		equals:	'a := b :='.
]
