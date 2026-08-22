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
		formatter
		indentString
		exprLines
		firstLineBody
	|

	formatter := Rudesheim Tooling Formatter.
	indentString := anIndentToolingRudesheim asString.

	exprLines :=
		formatter
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

	firstLineBody
		ifEmpty:
		[
			^ OrderedCollection new
				add:	indentString , '^ ' , firstLineBody;
				addAll:	exprLines allButFirst;
				yourself.
		].

	(
		formatter
			isOpeningBracketCharacter:	firstLineBody first
	)
		ifFalse:
		[
			^ OrderedCollection new
				add:	indentString , '^ ' , firstLineBody;
				addAll:	exprLines allButFirst;
				yourself.
		].

	1 < exprLines size
		ifFalse:
		[
			^ OrderedCollection new
				add:	indentString , '^ ' , firstLineBody;
				addAll:	exprLines allButFirst;
				yourself.
		].

	^ OrderedCollection new
		add:	indentString , '^';
		addAll:	exprLines;
		yourself.
]
