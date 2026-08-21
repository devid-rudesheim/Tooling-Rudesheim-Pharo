"
Tests BlockFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'BlockFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
BlockFormatterToolingRudesheimTest >> testBlockAssignmentBreaksOntoItsOwnLines [
	|
		formatted
		expected
	|

	formatted :=
		FormatterToolingRudesheim
			format:	'run | block | block := [ 1 ]'.

	expected :=
		'run' , String cr , String tab , '|' , String cr , String tab , String tab , 'block' , String cr , String tab , '|' , String cr , String cr ,
		String tab , 'block :=' , String cr , String tab , '[' , String cr , String tab , String tab , '1.' , String cr , String tab , '].'.

	self
		assert:	formatted
		equals:	expected.
]
