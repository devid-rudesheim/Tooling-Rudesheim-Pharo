"
Tests formatter character kind dispatch.
"
Class {
	#name : 'CharacterKindFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Private-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testAssignmentKindDetectsAssignmentToken [
	|
		kind
	|

	kind := AssignmentCharacterKindFormatterToolingRudesheim.

	self
		assert:
		(
			kind
				isAssignmentStartCharacter:	$:
				followedBy:	$=
		).

	self
		deny:
		(
			kind
				isAssignmentStartCharacter:	$:
				followedBy:	Character space
		).
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testAssignmentKindStillMatchesEqualsCharacter [
	self
		assert:
		(
			AssignmentCharacterKindFormatterToolingRudesheim
				match:	$=
		).

	self
		deny:
		(
			AssignmentCharacterKindFormatterToolingRudesheim
				match:	$:
		).
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testBracketKindMatchesOpeningAndClosingCharacters [
	|
		kind
	|

	kind := ParenthesesCharacterKindFormatterToolingRudesheim.

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
			bracketStatesStartingWith:
			(
				Character
					value:	123
			)
	) first.

	self
		assert:
		(
			braceState
				isClosingBracketCharacter:
				(
					Character
						value:	125
				)
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
					match:	$).
			]
			thenCollect:
			[ :each |
				each
					candidateIdentifierTerminatesWith:	$).
			].

	self
		assert:	results asArray
		equals:
		{
			true
		}.
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testColonAndAssignmentKindsAreMutuallyExclusiveForBareColon [
	|
		matchingKinds
	|

	matchingKinds :=
		FormatterToolingRudesheim characterKinds
			select:
			[ :each |
				each
					match:	$:.
			].

	self
		assert:	matchingKinds size
		equals:	1.

	self
		assert:	matchingKinds first
		equals:	ColonCharacterKindFormatterToolingRudesheim.
]

{ #category : 'tests' }
CharacterKindFormatterToolingRudesheimTest >> testColonKindDistinguishesKeywordColonFromAssignment [
	|
		kind
	|

	kind := ColonCharacterKindFormatterToolingRudesheim.

	self
		assert:
		(
			kind
				isKeywordColonCharacter:	$:
				followedBy:	Character space
		).

	self
		deny:
		(
			kind
				isKeywordColonCharacter:	$:
				followedBy:	$=
		).
]
