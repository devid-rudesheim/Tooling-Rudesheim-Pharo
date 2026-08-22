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
		formatter
		lines
		header
		argumentNames
		argumentString
		temps
	|

	formatter := Rudesheim Tooling Formatter.
	lines := OrderedCollection new.
	argumentNames := aBlockNode argumentNames.
	header := anIndentToolingRudesheim asString , '['.

	argumentNames
		ifNotEmpty:
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

	temps
		ifNotEmpty:
		[
			lines
				addAll:
				(
					formatter
						formatTempsLinesFor:	temps
						indent:	anIndentToolingRudesheim oneLevelDeeper
				).

			lines
				add:	''.
		].

	lines
		addAll:
		(
			formatter
				formatSequenceLines:	aBlockNode body
				indent:	anIndentToolingRudesheim oneLevelDeeper
		).

	lines
		add:
		anIndentToolingRudesheim asString , ']'.

	^ lines.
]
