"
Character category for square brackets.
"
Class {
	#name : 'SquareBracketsCharacterKindFormatterToolingRudesheim',
	#superclass : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
SquareBracketsCharacterKindFormatterToolingRudesheim class >> closingCharacter [
	^ $].
]

{ #category : 'accessing' }
SquareBracketsCharacterKindFormatterToolingRudesheim class >> openingCharacter [
	^ $[.
]
