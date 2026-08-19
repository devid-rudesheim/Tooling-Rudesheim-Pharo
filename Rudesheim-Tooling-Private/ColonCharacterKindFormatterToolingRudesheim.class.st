"
Character category for colons.
"
Class {
	#name : 'ColonCharacterKindFormatterToolingRudesheim',
	#superclass : 'PunctuationCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
ColonCharacterKindFormatterToolingRudesheim >> character [
	^ $:.
]

{ #category : 'testing' }
ColonCharacterKindFormatterToolingRudesheim >> isKeywordColonCharacter: aCharacter
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
		AssignmentCharacterKindFormatterToolingRudesheim new
			isAssignmentStartCharacter:	aCharacter
			followedBy:	anotherCharacter
	) not.
]
