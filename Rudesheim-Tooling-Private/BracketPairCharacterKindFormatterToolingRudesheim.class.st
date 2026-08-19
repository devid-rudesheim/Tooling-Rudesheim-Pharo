"
Character category for a bracket pair.
"
Class {
	#name : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
BracketPairCharacterKindFormatterToolingRudesheim >> closingCharacter [
	self subclassResponsibility.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim >> candidateIdentifierTerminatesWith: aCharacter [
	^ aCharacter = self closingCharacter.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim >> isClosingBracketCharacter: aCharacter [
	^ aCharacter = self closingCharacter.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim >> isOpeningBracketCharacter: aCharacter [
	^ aCharacter = self openingCharacter.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim >> match: aCharacter [
	(
		self
			isOpeningBracketCharacter:	aCharacter
	)
		ifTrue:
		[
			^ true.
		].

	^ self
		isClosingBracketCharacter:	aCharacter.
]

{ #category : 'accessing' }
BracketPairCharacterKindFormatterToolingRudesheim >> openingCharacter [
	self subclassResponsibility.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim >> openingBracketMatches: aCharacter [
	^ self
		isOpeningBracketCharacter:	aCharacter.
]
