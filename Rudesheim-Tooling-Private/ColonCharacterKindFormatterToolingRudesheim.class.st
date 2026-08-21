"
Character category for colons.
"
Class {
	#name : 'ColonCharacterKindFormatterToolingRudesheim',
	#superclass : 'PunctuationCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
ColonCharacterKindFormatterToolingRudesheim class >> character [
	^ $:.
]

{ #category : 'testing' }
ColonCharacterKindFormatterToolingRudesheim class >> isKeywordColonCharacter: aCharacter
followedBy: anotherCharacter [
	(
		self
			match:	aCharacter
	)
		ifFalse:
		[
			^ false.
		].

	^
	(
		Rudesheim Tooling CharacterKind Assignment
			isAssignmentStartCharacter:	aCharacter
			followedBy:	anotherCharacter
	) not.
]
