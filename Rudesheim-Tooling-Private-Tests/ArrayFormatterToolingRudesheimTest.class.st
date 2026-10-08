"
Tests ArrayFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'ArrayFormatterToolingRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-Tooling-Private-Tests-Formatters',
	#package : 'Rudesheim-Tooling-Private-Tests',
	#tag : 'Formatters'
}

{ #category : 'accessing' }
ArrayFormatterToolingRudesheimTest class >> targetClass [
	^ Rudesheim Tooling Formatter.
]

{ #category : 'tests' }
ArrayFormatterToolingRudesheimTest >> testDynamicArrayAlwaysUsesMultilineElements [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'ranges ^ { self rows. self columns }'.

	expected := 'ranges' , String cr , String tab , '^' , String cr , String tab , '{' , String cr , String tab , String tab , 'self rows.' , String cr , String tab , String tab , 'self columns' , String cr , String tab , '}.'.

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
		self targetClass
			format:	'empty ^ { }'.

	expected := 'empty' , String cr , String tab , '^ {}.'.

	self
		assert:	formatted
		equals:	expected.
]
