"
Tests the KeywordMessageKindFormatterToolingRudesheim / BinaryMessageKindFormatterToolingRudesheim /
UnaryMessageKindFormatterToolingRudesheim dispatch, via OCMessageNode>>formatterKindForRudesheim and
FormatterToolingRudesheim's public entry point.
"
Class {
	#name : 'MessageKindFormatterToolingRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testFormatterKindForRudesheimSelectsClassByMessageKind [
	self
		assert:
		(
			(
				OCParser parseExpression: 'self foo: 1'
			) formatterKindForRudesheim
		)
		equals:	KeywordMessageKindFormatterToolingRudesheim.

	self
		assert:
		(
			(
				OCParser parseExpression: '1 + 2'
			) formatterKindForRudesheim
		)
		equals:	BinaryMessageKindFormatterToolingRudesheim.

	self
		assert:
		(
			(
				OCParser parseExpression: 'self foo'
			) formatterKindForRudesheim
		)
		equals:	UnaryMessageKindFormatterToolingRudesheim.
]

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testKeywordMessageReceiverKeepsOwnLineWhenAlreadyMultiline [
	|
		formatted
		expected
	|

	formatted :=
		FormatterToolingRudesheim
			format:	'at: aClassSymbol ^ Smalltalk at: aClassSymbol'.

	expected :=
		'at: aClassSymbol' , String cr , String tab , '^ Smalltalk' , String cr ,
		String tab , String tab , 'at:' , String tab , 'aClassSymbol.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
MessageKindFormatterToolingRudesheimTest >> testShortBinaryAndUnaryChainsStayInline [
	self
		assert:
		(
			FormatterToolingRudesheim
				format:	'sum ^ 1 + 2 + 3'.
		)
		equals:	'sum' , String cr , String tab , '^ 1 + 2 + 3.'.

	self
		assert:
		(
			FormatterToolingRudesheim
				format:	'run ^ self foo bar'.
		)
		equals:	'run' , String cr , String tab , '^ self foo bar.'.
]
