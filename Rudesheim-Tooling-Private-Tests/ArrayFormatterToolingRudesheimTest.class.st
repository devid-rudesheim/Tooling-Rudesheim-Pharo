"
Tests ArrayFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'ArrayFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
ArrayFormatterToolingRudesheimTest >> testDynamicArrayAlwaysUsesMultilineElements [
	|
		formatted
		expected
	|

	formatted :=
		FormatterToolingRudesheim
			format:	'ranges ^ { self rows. self columns }'.

	expected :=
		'ranges' , String cr , String tab , '^' , String cr , String tab , '{' , String cr ,
		String tab , String tab , 'self rows.' , String cr , String tab , String tab , 'self columns' , String cr ,
		String tab , '}.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
ArrayFormatterToolingRudesheimTest >> testEmptyDynamicArrayStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		FormatterToolingRudesheim
			format:	'empty ^ { }'.

	expected := 'empty' , String cr , String tab , '^ {}.'.

	self
		assert:	formatted
		equals:	expected.
]
