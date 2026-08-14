Class {
	#name : 'ExtentionOfClassDescriptionRudesheimTest',
	#superclass : 'TestCase',
	#instVars : [
		'forTest'
	],
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Tests'
}

{ #category : 'accessing' }
ExtentionOfClassDescriptionRudesheimTest >> defaultForTest [

	^ 0.

]

{ #category : 'accessing' }
ExtentionOfClassDescriptionRudesheimTest >> forTest [

	^ forTest
		ifNil:
		[
			forTest := self defaultForTest.
		].

]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> runCreateGetMethodWithDefault0 [

	self class
		createGetMethodWithDefault:	'forTest'.
	
	self
		assert: 0
		equals:	self defaultForTest.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> runCreateGetMethodWithDefault1 [

	self class
		createGetMethodWithDefault:	'forTest'.
	
	forTest := nil.
	
	self
		assert: 0
		equals:	self forTest.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> runCreateGetMethodWithDefault2 [

	self class
		createGetMethodWithDefault:	'forTest'.
	
	forTest := 1.
	
	self
		assert: 1
		equals:	self forTest.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> runCreateGetMethodWithDefault3 [
	|
		statement
		classForException
	|
	
	classForException := Rudesheim Utility SyntaxErrorNotification.
	
	statement :=
	[
		self class
			createGetMethodWithDefault:	''.
	].

	self
		should:	statement
		raise:	classForException.
	
	statement
		on:	classForException
		do:
		[ :exception |
			
			self
				assert:	'Message pattern expected'
				equals: exception messageText;

				assert:	''
				equals: exception errorCode;

				assert:	self class
				equals: exception errorClass;

				assert:	exception messageText
				equals: exception errorMessage;

				assert:	1
				equals: exception location;

				deny: exception doitFlag.
		]
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> testCreateGetMethodWithDefault [

	self
		testCreateGetMethodWithDefault0_0;
		tearDown;
		setUp;
		testCreateGetMethodWithDefault1_0;
		tearDown;
		setUp;
		testCreateGetMethodWithDefault2_0;
		tearDown;
		setUp;
		testCreateGetMethodWithDefault3_0.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> testCreateGetMethodWithDefault0_0 [

	self runCreateGetMethodWithDefault0.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> testCreateGetMethodWithDefault1_0 [

	self runCreateGetMethodWithDefault1.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> testCreateGetMethodWithDefault2_0 [

	self runCreateGetMethodWithDefault2.
]

{ #category : 'tests' }
ExtentionOfClassDescriptionRudesheimTest >> testCreateGetMethodWithDefault3_0 [

	self runCreateGetMethodWithDefault3.
]
