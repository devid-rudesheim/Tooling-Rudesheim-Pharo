"
Character category for separators.
"
Class {
	#name : 'SeparatorCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'testing' }
SeparatorCharacterKindFormatterToolingRudesheim >> candidateIdentifierTerminatesWith: aCharacter [
	^ true.
]

{ #category : 'testing' }
SeparatorCharacterKindFormatterToolingRudesheim >> match: aCharacter [
	^ aCharacter isSeparator.
]
