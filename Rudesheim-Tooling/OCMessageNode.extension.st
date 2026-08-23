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
OCMessageNode >> hasParenthesizedBinaryReceiverForFormatterRudesheim [
	"Binary messages are left-associative with equal precedence, so a receiver at the very
	start of a chain never structurally needs parentheses -- but a receiver further inside the
	same chain can carry parentheses the author wrote to group an inner send
	(e.g. `(a = b) & (c = d)`). The chain-formatting code that walks this same receiver spine
	(MessageKindFormatterToolingRudesheim class>>formatUnaryOrBinaryChainLines:indent:)
	already stops and preserves such a receiver's parentheses instead of flattening through
	it, but only once it is actually reached via the multiline path -- this answers whether
	that will happen, so a message short enough to otherwise stay on one inline line is still
	routed through the chain formatting instead of losing those parentheses."

	self isBinary
		ifFalse:
		[
			^ false.
		].

	(
		self receiver
			isKindOf:	OCMessageNode
	)
		ifFalse:
		[
			^ false.
		].

	self receiver parentheses isEmpty
		ifFalse:
		[
			^ true.
		].

	^ self receiver
		hasParenthesizedBinaryReceiverForFormatterRudesheim.
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

	self hasParenthesizedBinaryReceiverForFormatterRudesheim
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
