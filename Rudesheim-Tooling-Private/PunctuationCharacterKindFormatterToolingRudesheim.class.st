"
Character category for one punctuation character.
"
Class {
	#name : 'PunctuationCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
PunctuationCharacterKindFormatterToolingRudesheim >> character [
	self subclassResponsibility.
]

{ #category : 'testing' }
PunctuationCharacterKindFormatterToolingRudesheim >> candidateIdentifierTerminatesWith: aCharacter [
	^ true.
]

{ #category : 'testing' }
PunctuationCharacterKindFormatterToolingRudesheim >> match: aCharacter [
	^ aCharacter = self character.
]
