"
Character category for Smalltalk character literals.
"
Class {
	#name : 'CharacterLiteralCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
CharacterLiteralCharacterKindFormatterToolingRudesheim class >> formatInlineParenthesesIn: aString
at: anIndexInteger
on: aWriteStream [
	aWriteStream
		nextPut:
		(
			aString
				at:	anIndexInteger
		).

	anIndexInteger < aString size
		ifTrue:
		[
			aWriteStream
				nextPut:
				(
					aString
						at:	anIndexInteger + 1
				).

			^ anIndexInteger + 2.
		].

	^ anIndexInteger + 1.
]

{ #category : 'testing' }
CharacterLiteralCharacterKindFormatterToolingRudesheim class >> match: aCharacter [
	^ aCharacter = $$.
]
