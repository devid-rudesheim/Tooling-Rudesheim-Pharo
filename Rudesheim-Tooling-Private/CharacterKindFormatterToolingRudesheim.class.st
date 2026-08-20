"
Shared protocol for formatter character categories.
"
Class {
	#name : 'CharacterKindFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Assignment [
	^ AssignmentCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> CharacterLiteral [
	^ CharacterLiteralCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Colon [
	^ ColonCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> CurlyBraces [
	^ CurlyBracesCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> DoubleQuote [
	^ DoubleQuoteCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Parentheses [
	^ ParenthesesCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Period [
	^ PeriodCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Semicolon [
	^ SemicolonCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> Separator [
	^ SeparatorCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> SingleQuote [
	^ SingleQuoteCharacterKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
CharacterKindFormatterToolingRudesheim class >> SquareBrackets [
	^ SquareBracketsCharacterKindFormatterToolingRudesheim.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> candidateIdentifierTerminatesWith: aCharacter [
	^ false.
]

{ #category : 'formatting' }
CharacterKindFormatterToolingRudesheim class >> formatInlineParenthesesIn: aString
at: anIndexInteger
on: aWriteStream [
	aWriteStream
		nextPut:
		(
			aString
				at:	anIndexInteger
		).

	^ anIndexInteger + 1.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> isAssignmentStartCharacter: aCharacter
followedBy: anotherCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> isClosingBracketCharacter: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> isKeywordColonCharacter: aCharacter
followedBy: anotherCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> isOpeningBracketCharacter: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> match: aCharacter [
	^ false.
]

{ #category : 'testing' }
CharacterKindFormatterToolingRudesheim class >> openingBracketMatches: aCharacter [
	^ false.
]
