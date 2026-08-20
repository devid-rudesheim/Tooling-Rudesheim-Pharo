"
Character category for one punctuation character.
"
Class {
	#name : 'PunctuationCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'testing' }
PunctuationCharacterKindFormatterToolingRudesheim class >> candidateIdentifierTerminatesWith: aCharacter [
	^ true.
]

{ #category : 'accessing' }
PunctuationCharacterKindFormatterToolingRudesheim class >> character [
	self subclassResponsibility.
]

{ #category : 'testing' }
PunctuationCharacterKindFormatterToolingRudesheim class >> match: aCharacter [
	^ aCharacter = self character.
]
