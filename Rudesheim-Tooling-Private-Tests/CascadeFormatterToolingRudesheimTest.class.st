"
Tests CascadeFormatterToolingRudesheim via FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'CascadeFormatterToolingRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-Tooling-Private-Tests-Formatters',
	#package : 'Rudesheim-Tooling-Private-Tests',
	#tag : 'Formatters'
}

{ #category : 'accessing' }
CascadeFormatterToolingRudesheimTest class >> targetClass [
	^ Rudesheim Tooling Formatter Cascade.
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
			self targetClass
				cascadeMessageStartFor:	cascadeMessage
		)
		equals:	cascadeMessage selectorInterval first.

	self
		assert:
		(
			self targetClass
				cascadeMessageEndFor:	cascadeMessage
		)
		equals:	cascadeMessage arguments first sourceInterval last.
]

{ #category : 'tests' }
CascadeFormatterToolingRudesheimTest >> testCascadeSeparatesMessagesWithSemicolon [
	|
		formatted
		expected
	|

	formatted :=
		Rudesheim Tooling Formatter
			format:	'sample | builder | builder := Object new. builder name: #Foo; yourself'.

	expected := 'sample' , String cr , String tab , '|' , String cr , String tab , String tab , 'builder' , String cr , String tab , '|' , String cr , String cr , String tab , 'builder := Object new.' , String cr , String cr , String tab , 'builder' , String cr , String tab , String tab , 'name:' , String tab , '#Foo;' , String cr , String tab , String tab , 'yourself.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
CascadeFormatterToolingRudesheimTest >> testCascadeKeepsParenthesesOfBinaryReceiver [
	|
		source
		formatted
	|

	source := 'sample: directory
	(directory / ''PharoFiles'' / ''startup.st'')
		ensureCreateFile;
		writeStreamDo: [ :aStream | aStream nextPutAll: ''x'' ]'.

	formatted :=
		Rudesheim Tooling Formatter
			format:	source.

	self
		assert:
		(
			(
				OCParser
					parseMethod:	formatted
			) body statements first receiver
		) isMessage.

	self
		assert:
		(
			(
				OCParser
					parseMethod:	formatted
			) body statements first receiver selector
		)
		equals:	#/.
]

{ #category : 'tests' }
CascadeFormatterToolingRudesheimTest >> testCascadeAssignmentValueIsFormattedOnItsOwnLines [
	|
		source
		formatted
		expected
	|

	source := 'sample: aViewSpPresenter titled: aTitleString
	| worldWindow |
	worldWindow := aViewSpPresenter asWorldWindow title: aTitleString; open.
	^ worldWindow'.

	formatted :=
		Rudesheim Tooling Formatter
			format:	source.

	expected :=
		'worldWindow :=' , String cr , String tab , String tab ,
		'aViewSpPresenter asWorldWindow' , String cr , String tab , String tab , String tab ,
		'title:' , String tab , 'aTitleString;' , String cr , String tab , String tab , String tab ,
		'open.'.

	self
		assert:	( formatted includesSubstring: expected )
		description:	formatted.
]
