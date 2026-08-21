"
Formats OCReturnNode lines for FormatterToolingRudesheim.
"
Class {
	#name : 'ReturnFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
ReturnFormatterToolingRudesheim class >> formatReturnLines: aReturnNode
indent: anIndentToolingRudesheim [
	|
		indentString
		exprLines
		firstLineBody
	|

	indentString := anIndentToolingRudesheim asString.

	exprLines :=
		FormatterToolingRudesheim
			formatExpressionLines:	aReturnNode value
			indent:	anIndentToolingRudesheim.

	firstLineBody := exprLines first.

	(
		firstLineBody
			beginsWith:	indentString
	)
		ifTrue:
		[
			firstLineBody :=
				firstLineBody
					copyFrom:	1 + indentString size
					to:	exprLines first size.
		].

	firstLineBody notEmpty
		ifTrue:
		[
			(
				FormatterToolingRudesheim
					isOpeningBracketCharacter:	firstLineBody first
			)
				ifTrue:
				[
					1 < exprLines size
						ifTrue:
						[
							^ OrderedCollection new
								add:	indentString , '^';
								addAll:	exprLines;
								yourself.
						].
				].
		].

	^ OrderedCollection new
		add:	indentString , '^ ' , firstLineBody;
		addAll:	exprLines allButFirst;
		yourself.
]
