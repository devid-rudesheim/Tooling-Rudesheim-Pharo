"
Sweeps every method actually defined by Tooling-Rudesheim-Pharo's own production packages
(Rudesheim-Tooling-Private, Rudesheim-Tooling) through FormatterToolingRudesheim class>>format:
and asserts formatting is idempotent (format: (format: aMethod) = format: aMethod).

This exists because per-method unit tests in FormatterToolingRudesheimTest did not catch bugs
that only surfaced when the formatter ran over real, whole classes/methods (see
note/formatter-tooling-rudesheim-bugs.md) -- syntax corruption and lost formatting among them.
Idempotence does not require a hand-authored expected string per method: if formatting a
method's own already-formatted output changes it again, either the formatter is unstable or it
produced something broken the first time.
"
Class {
	#name : 'FormatterToolingRudesheimIdempotenceTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'targetMethod'
	],
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'sweep' }
FormatterToolingRudesheimIdempotenceTest class >> targetPackageNames [
	^ #( 'Rudesheim-Tooling-Private' 'Rudesheim-Tooling' ).
]

{ #category : 'sweep' }
FormatterToolingRudesheimIdempotenceTest class >> methodsToSweep [
	|
		organizer
		methods
	|

	organizer := PackageOrganizer default.
	methods := OrderedCollection new.

	self targetPackageNames
		do:
		[ :packageName |
			|
				package
			|

			package :=
				organizer
					packageNamed:	packageName
					ifAbsent:	[ nil ].

			package isNil
				ifTrue:
				[
					self
						error:	'Package not found: ' , packageName.
				].

			package definedClasses
				do:
				[ :aClass |
					{ aClass. aClass class }
						do:
						[ :aBehavior |
							methods
								addAll:
								(
									package
										definedMethodsForClass:	aBehavior
								).
						].
				].

			package extendedClasses
				do:
				[ :aClass |
					methods
						addAll:
						(
							package
								extensionMethodsForClass:	aClass
						).
				].
		].

	^ methods
		asSortedCollection:
		[ :a :b |
			a printString < b printString
		].
]

{ #category : 'tests-data' }
FormatterToolingRudesheimIdempotenceTest class >> testParameters [
	|
		matrix
	|

	matrix := ParametrizedTestMatrix new.

	self methodsToSweep
		do:
		[ :each |
			matrix
				addCase:	{ #targetMethod -> each }.
		].

	^ matrix.
]

{ #category : 'accessing' }
FormatterToolingRudesheimIdempotenceTest >> targetMethod [
	^ targetMethod.
]

{ #category : 'accessing' }
FormatterToolingRudesheimIdempotenceTest >> targetMethod: aCompiledMethod [
	targetMethod := aCompiledMethod.
]

{ #category : 'tests' }
FormatterToolingRudesheimIdempotenceTest >> testFormattingIsIdempotent [
	|
		firstPass
		secondPass
	|

	firstPass :=
		FormatterToolingRudesheim
			format:	self targetMethod.

	secondPass :=
		FormatterToolingRudesheim
			format:	firstPass.

	self
		assert:	secondPass
		equals:	firstPass.
]
