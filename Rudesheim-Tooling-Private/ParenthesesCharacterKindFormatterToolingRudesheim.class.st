"
Character category for parentheses.
"
Class {
	#name : 'ParenthesesCharacterKindFormatterToolingRudesheim',
	#superclass : 'BracketPairCharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
ParenthesesCharacterKindFormatterToolingRudesheim class >> closingCharacter [
	^ $).
]

{ #category : 'formatting' }
ParenthesesCharacterKindFormatterToolingRudesheim class >> formatInlineParenthesesIn: aString
at: anIndexInteger
on: aWriteStream [
	|
		character
		nextCharacter
	|

	character :=
		aString
			at:	anIndexInteger.

	character = self openingCharacter
		ifTrue:
		[
			aWriteStream
				nextPut:	character.

			anIndexInteger < aString size
				ifTrue:
				[
					nextCharacter :=
						aString
							at:	anIndexInteger + 1.

					nextCharacter = Character space
						ifFalse:
						[
							nextCharacter = self closingCharacter
								ifFalse:
								[
									aWriteStream space.
								].
						].
				].

			^ anIndexInteger + 1.
		].

	aWriteStream position > 0
		ifTrue:
		[
			aWriteStream contents last = Character space
				ifFalse:
				[
					aWriteStream contents last = self openingCharacter
						ifFalse:
						[
							aWriteStream space.
						].
				].
		].

	aWriteStream
		nextPut:	character.

	^ anIndexInteger + 1.
]

{ #category : 'accessing' }
ParenthesesCharacterKindFormatterToolingRudesheim class >> openingCharacter [
	^ $(.
]
