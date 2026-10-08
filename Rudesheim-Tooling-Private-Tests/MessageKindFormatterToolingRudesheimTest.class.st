"
Tests the KeywordMessageKindFormatterToolingRudesheim / BinaryMessageKindFormatterToolingRudesheim /
UnaryMessageKindFormatterToolingRudesheim dispatch, via OCMessageNode>>formatterKindForRudesheim and
FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'MessageKindFormatterToolingRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-Tooling-Private-Tests-MessageKind',
	#package : 'Rudesheim-Tooling-Private-Tests',
	#tag : 'MessageKind'
}

{ #category : 'accessing' }
MessageKindFormatterToolingRudesheimTest class >> targetClass [
	^ Rudesheim Tooling Formatter.
]

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testFormatterKindForRudesheimSelectsClassByMessageKind [
	self
		assert:
		(
			OCParser
				parseExpression:	'self foo: 1'
		) formatterKindForRudesheim
		equals:	KeywordMessageKindFormatterToolingRudesheim.

	self
		assert:
		(
			OCParser
				parseExpression:	'1 + 2'
		) formatterKindForRudesheim
		equals:	BinaryMessageKindFormatterToolingRudesheim.

	self
		assert:
		(
			OCParser
				parseExpression:	'self foo'
		) formatterKindForRudesheim
		equals:	UnaryMessageKindFormatterToolingRudesheim.
]

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testKeywordMessageReceiverKeepsOwnLineWhenAlreadyMultiline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'at: aClassSymbol ^ Smalltalk at: aClassSymbol'.

	expected := 'at: aClassSymbol' , String cr , String tab , '^ Smalltalk' , String cr , String tab , String tab , 'at:' , String tab , 'aClassSymbol.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testShortBinaryAndUnaryChainsStayInline [
	self
		assert:
		(
			self targetClass
				format:	'sum ^ 1 + 2 + 3'
		)
		equals:	'sum' , String cr , String tab , '^ 1 + 2 + 3.'.

	self
		assert:
		(
			self targetClass
				format:	'run ^ self foo bar'
		)
		equals:	'run' , String cr , String tab , '^ self foo bar.'.
]
