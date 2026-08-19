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
CurlyBracesCharacterKindFormatterToolingRudesheim >> closingCharacter [
	^ Character value: 125.
]

{ #category : 'accessing' }
CurlyBracesCharacterKindFormatterToolingRudesheim >> openingCharacter [
	^ Character value: 123.
]
