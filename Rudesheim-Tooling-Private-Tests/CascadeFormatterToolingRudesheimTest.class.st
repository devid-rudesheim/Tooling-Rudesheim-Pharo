"
Tests CascadeFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'CascadeFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
CascadeFormatterToolingRudesheimTest >> testCascadeSeparatesMessagesWithSemicolon [
	|
		formatted
		expected
	|

	formatted :=
		Rudesheim Tooling Formatter
			format:	'sample | builder | builder := Object new. builder name: #Foo; yourself'.

	expected :=
		'sample' , String cr , String tab , '|' , String cr , String tab , String tab , 'builder' , String cr , String tab , '|' , String cr , String cr ,
		String tab , 'builder := Object new.' , String cr , String cr ,
		String tab , 'builder' , String cr , String tab , String tab , 'name:' , String tab , '#Foo;' , String cr , String tab , String tab , 'yourself.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
CascadeFormatterToolingRudesheimTest >> testCascadeMessageStartAndEndCoverSelectorAndArguments [
	|
		parseTree
		cascadeMessage
	|

	parseTree :=
		OCParser
			parseMethod:	'sample builder name: #Foo; yourself'.

	cascadeMessage := parseTree body statements first messages first.

	self
		assert:
		(
			Rudesheim Tooling Formatter Cascade
				cascadeMessageStartFor:	cascadeMessage
		)
		equals:	cascadeMessage selectorInterval first.

	self
		assert:
		(
			Rudesheim Tooling Formatter Cascade
				cascadeMessageEndFor:	cascadeMessage
		)
		equals:	cascadeMessage arguments first sourceInterval last.
]
