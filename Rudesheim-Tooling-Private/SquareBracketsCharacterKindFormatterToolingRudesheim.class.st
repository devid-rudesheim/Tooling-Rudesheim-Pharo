"
Character category for square brackets.
"
Class {
	#name : 'SquareBracketsCharacterKindFormatterToolingRudesheim',
	#superclass : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private-CharacterKind',
	#package : 'Rudesheim-Tooling-Private',
	#tag : 'CharacterKind'
}

{ #category : 'accessing' }
SquareBracketsCharacterKindFormatterToolingRudesheim class >> closingCharacter [
	^ $].
]

{ #category : 'accessing' }
SquareBracketsCharacterKindFormatterToolingRudesheim class >> openingCharacter [
	^ $[.
]
