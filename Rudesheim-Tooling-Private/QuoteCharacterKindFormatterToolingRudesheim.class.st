"
Character category for Smalltalk quoted ranges.
"
Class {
	#name : 'QuoteCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
QuoteCharacterKindFormatterToolingRudesheim >> formatInlineParenthesesIn: aString
at: anIndexInteger
on: aWriteStream [
	|
		closed
		index
		character
		quoteAction
	|

	closed := false.

	aWriteStream
		nextPut:	self quoteCharacter.

	index := anIndexInteger + 1.
	[
		[
			|
				conditionBreak
			|

			conditionBreak := thisContext.

			index <= aString size
				ifTrue:
				[
					conditionBreak
						return:	closed not.
				].

			false.
		] value
	]
		whileTrue:
		[
			character :=
				aString
					at:	index.

			aWriteStream
				nextPut:	character.

			index := index + 1.

			character = self quoteCharacter
				ifTrue:
				[
					quoteAction :=
					[
						closed := true.
					].

					index <= aString size
						ifTrue:
						[
							( aString at: index ) = self quoteCharacter
								ifTrue:
								[
									quoteAction :=
									[
										aWriteStream
											nextPut:
											(
												aString
													at:	index
											).

										index := index + 1.
									].
								].
						].

					quoteAction value.
				].
		].

	^ index.
]

{ #category : 'testing' }
QuoteCharacterKindFormatterToolingRudesheim >> match: aCharacter [
	^ aCharacter = self quoteCharacter.
]

{ #category : 'accessing' }
QuoteCharacterKindFormatterToolingRudesheim >> quoteCharacter [
	self subclassResponsibility.
]
