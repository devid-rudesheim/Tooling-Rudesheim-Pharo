"
Tests IndentToolingRudesheim.
"
Class {
	#name : 'IndentToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
IndentToolingRudesheimTest >> testLevelRejectsNonNumber [
	self
		should:
		[
			IndentToolingRudesheim
				level:	'not a number'.
		]
		raise:	Error.
]

{ #category : 'tests' }
IndentToolingRudesheimTest >> testLevelClampsNegativeToZero [
	self
		assert:
		(
			IndentToolingRudesheim
				level:	-3
		) indent
		equals:	0.
]

{ #category : 'tests' }
IndentToolingRudesheimTest >> testAsStringForLevelZeroAndLevelTwo [
	self
		assert:
		(
			IndentToolingRudesheim
				level:	0
		) asString
		equals:	''.

	self
		assert:
		(
			IndentToolingRudesheim
				level:	2
		) asString
		equals:	( String new: 2 withAll: Character tab ).
]

{ #category : 'tests' }
IndentToolingRudesheimTest >> testOneLevelDeeperReturnsNewInstanceWithoutMutatingOriginal [
	|
		original
		deeper
	|

	original :=
		IndentToolingRudesheim
			level:	1.

	deeper := original oneLevelDeeper.

	self
		assert:	original indent
		equals:	1.

	self
		assert:	deeper indent
		equals:	2.

	self
		deny:	deeper == original.
]
