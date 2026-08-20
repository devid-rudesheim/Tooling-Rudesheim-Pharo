"
Character category for a bracket pair.
"
Class {
	#name : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> candidateIdentifierTerminatesWith: aCharacter [
	^ aCharacter = self closingCharacter.
]

{ #category : 'accessing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> closingCharacter [
	self subclassResponsibility.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> isClosingBracketCharacter: aCharacter [
	^ aCharacter = self closingCharacter.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> isOpeningBracketCharacter: aCharacter [
	^ aCharacter = self openingCharacter.
]

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> match: aCharacter [
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

{ #category : 'testing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> openingBracketMatches: aCharacter [
	^ self
		isOpeningBracketCharacter:	aCharacter.
]

{ #category : 'accessing' }
BracketPairCharacterKindFormatterToolingRudesheim class >> openingCharacter [
	self subclassResponsibility.
]
