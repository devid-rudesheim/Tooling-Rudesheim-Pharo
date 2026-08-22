Extension { #name : 'OCMessageNode' }

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> acceptFormatterRudesheim: aFormatter
indent: anIndentToolingRudesheim [
	^ self formatterKindForRudesheim
		formatLines:	self
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> acceptFormatterRudesheimAsSubexpression: aFormatter
indent: anIndentToolingRudesheim [
	self isKeyword
		ifTrue:
		[
			^ aFormatter
				formatParenthesizedLines:	self
				indent:	anIndentToolingRudesheim.
		].

	^ self
		acceptFormatterRudesheim:	aFormatter
		indent:	anIndentToolingRudesheim.
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> formatterKindForRudesheim [
	|
		messageKind
	|

	messageKind := Rudesheim Tooling Formatter MessageKind.

	self isKeyword
		ifTrue:
		[
			^ messageKind Keyword.
		].

	self isBinary
		ifTrue:
		[
			^ messageKind Binary.
		].

	^ messageKind Unary.
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> isBlockStatementForFormatterRudesheim [
	^ self receiver isBlock.
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ self
		needsMultilineForFormatterRudesheim:	aFormatter.
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> needsMultilineForFormatterRudesheim: aFormatter [
	|
		conditions
	|

	self isKeyword
		ifTrue:
		[
			^ true.
		].

	conditions :=
	{
		self receiver
	} asOrderedCollection.

	self isBinary
		ifTrue:
		[
			conditions
				addFirst:	self arguments first.
		].

	^ conditions
		anySatisfy:
		[ :each |
			each
				needsMultilineForFormatterRudesheim:	aFormatter.
		].
]
