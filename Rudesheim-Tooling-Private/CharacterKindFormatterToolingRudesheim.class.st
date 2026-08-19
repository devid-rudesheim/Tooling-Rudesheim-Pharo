"
Shared protocol for formatter character categories.
"
Class {
	#name : 'CharacterKindFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> candidateIdentifierTerminatesWith: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> isAssignmentStartCharacter: aCharacter
followedBy: anotherCharacter [
	^ false.
]

{ #category : 'formatting' }
CharacterKindFormatterToolingRudesheim >> formatInlineParenthesesIn: aString
at: anIndexInteger
on: aWriteStream [
	aWriteStream
		nextPut:
		(
			aString
				at:	anIndexInteger
		).

	^ anIndexInteger + 1.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> match: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> isClosingBracketCharacter: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> isOpeningBracketCharacter: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> isKeywordColonCharacter: aCharacter
followedBy: anotherCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim >> openingBracketMatches: aCharacter [
	^ false.
]
