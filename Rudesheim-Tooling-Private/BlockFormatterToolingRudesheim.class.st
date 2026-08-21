"
Formats OCBlockNode lines for FormatterToolingRudesheim.
"
Class {
	#name : 'BlockFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
BlockFormatterToolingRudesheim class >> formatBlockLines: aBlockNode
indent: anIndentToolingRudesheim [
	|
		lines
		header
		argumentNames
		argumentString
		temps
	|

	lines := OrderedCollection new.
	argumentNames := aBlockNode argumentNames.
	header := anIndentToolingRudesheim asString , '['.

	argumentNames notEmpty
		ifTrue:
		[
			argumentString :=
				String
					streamContents:
					[ :writer |
						argumentNames
							doWithIndex:
							[ :eachArgumentName :index |
								index > 1
									ifTrue:
									[
										writer space.
									].

								writer
									nextPut:	$:.

								writer
									nextPutAll:	eachArgumentName.
							].
					].

			header := header , ' ' , argumentString , ' |'.
		].

	lines
		add:	header.

	temps := aBlockNode temporaryNames.

	temps notEmpty
		ifTrue:
		[
			lines
				addAll:
				(
					FormatterToolingRudesheim
						formatTempsLinesFor:	temps
						indent:	anIndentToolingRudesheim oneLevelDeeper
				).

			lines
				add:	''.
		].

	lines
		addAll:
		(
			FormatterToolingRudesheim
				formatSequenceLines:	aBlockNode body
				indent:	anIndentToolingRudesheim oneLevelDeeper
		).

	lines
		add:
		anIndentToolingRudesheim asString , ']'.

	^ lines.
]
