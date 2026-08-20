"
Character category for separators.
"
Class {
	#name : 'SeparatorCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'testing' }
SeparatorCharacterKindFormatterToolingRudesheim class >> candidateIdentifierTerminatesWith: aCharacter [
	^ true.
]

{ #category : 'testing' }
SeparatorCharacterKindFormatterToolingRudesheim class >> match: aCharacter [
	^ aCharacter isSeparator.
]
