"
Character category for curly braces.
"
Class {
	#name : 'CurlyBracesCharacterKindFormatterToolingRudesheim',
	#superclass : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
CurlyBracesCharacterKindFormatterToolingRudesheim class >> closingCharacter [
	^ Character value: 125.
]

{ #category : 'accessing' }
CurlyBracesCharacterKindFormatterToolingRudesheim class >> openingCharacter [
	^ Character value: 123.
]
