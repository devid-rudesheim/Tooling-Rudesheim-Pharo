"
Tests formatter character kind dispatch.
"
Class {
	#name : 'CharacterKindFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testBracketKindMatchesOpeningAndClosingCharacters [
	|
		kind
	|

	kind := ParenthesesCharacterKindFormatterToolingRudesheim new.

	self
		assert:
		(
			kind
				match:	$(
		).

	self
		assert:
		(
			kind
				match:	$)
			).
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testBracketStateCanDetectMatchingClosingCharacter [
	|
		braceState
	|

	braceState :=
		(
			FormatterToolingRudesheim
				bracketStatesStartingWith:	( Character value: 123 )
		) first.

	self
		assert:
		(
			braceState
				isClosingBracketCharacter:	( Character value: 125 )
		).

	self
		deny:
		(
			braceState
				isClosingBracketCharacter:	$)
		).
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testCharacterKindsCanBeSelectedAndCollectedThroughSharedInterface [
	|
		results
	|

	results :=
		FormatterToolingRudesheim characterKinds
			select:
			[ :each |
				each
					match:	$)
			]
			thenCollect:
			[ :each |
				each
					candidateIdentifierTerminatesWith:	$)
			].

	self
		assert:	results asArray
		equals:	{ true }.
]
