"
Tests ReturnFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'ReturnFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
ReturnFormatterToolingRudesheimTest >> testReturnSimpleValueStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		Rudesheim Tooling Formatter
			format:	'flag ^ true'.

	expected := 'flag' , String cr , String tab , '^ true.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
ReturnFormatterToolingRudesheimTest >> testReturnBracketedMultilineKeepsNewlineAfterCaret [
	|
		formatted
		expected
	|

	formatted :=
		Rudesheim Tooling Formatter
			format:	'makeBlock ^ [ 1 + 1 ]'.

	expected :=
		'makeBlock' , String cr , String tab , '^' , String cr , String tab , '[' , String cr ,
		String tab , String tab , '1 + 1.' , String cr , String tab , '].'.

	self
		assert:	formatted
		equals:	expected.
]
