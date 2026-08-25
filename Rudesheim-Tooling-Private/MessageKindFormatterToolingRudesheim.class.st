"
Shared protocol for OCMessageNode kind formatting (keyword/binary/unary). Binary and unary
messages share this implementation as-is; KeywordMessageKindFormatterToolingRudesheim overrides
formatLines:indent: with keyword-specific formatting.
"
Class {
	#name : 'MessageKindFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private-MessageKind',
	#package : 'Rudesheim-Tooling-Private',
	#tag : 'MessageKind'
}

{ #category : 'namespace' }
MessageKindFormatterToolingRudesheim class >> Binary [
	^ BinaryMessageKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
MessageKindFormatterToolingRudesheim class >> Keyword [
	^ KeywordMessageKindFormatterToolingRudesheim.
]

{ #category : 'namespace' }
MessageKindFormatterToolingRudesheim class >> Unary [
	^ UnaryMessageKindFormatterToolingRudesheim.
]

{ #category : 'formatting' }
MessageKindFormatterToolingRudesheim class >> formatLines: aMessageNode
indent: anIndentToolingRudesheim [
	|
		formatter
	|

	formatter := Rudesheim Tooling Formatter.

	aMessageNode receiver isBlock
		ifTrue:
		[
			|
				receiverLines
				argumentString
			|

			receiverLines :=
				formatter Block
					formatBlockLines:	aMessageNode receiver
					indent:	anIndentToolingRudesheim.

			argumentString := ''.

			aMessageNode isBinary
				ifTrue:
				[
					argumentString :=
						' ' ,
						(
							formatter
								formatInline:	aMessageNode arguments first
						).
				].

			receiverLines
				at:	receiverLines size
				put:	receiverLines last , ' ' , aMessageNode selector asString , argumentString.

			^ receiverLines.
		].

	(
		formatter
			needsMultilineFor:	aMessageNode
	)
		ifTrue:
		[
			^ self
				formatUnaryOrBinaryChainLines:	aMessageNode
				indent:	anIndentToolingRudesheim.
		].

	^
	{
		anIndentToolingRudesheim asString ,
		(
			formatter
				formatInline:	aMessageNode
		)
	}.
]

{ #category : 'formatting' }
MessageKindFormatterToolingRudesheim class >> formatUnaryOrBinaryChainLines: aMessageNode
indent: anIndentToolingRudesheim [
	|
		formatter
		steps
		node
		lines
		receiverLines
		receiverLinesAction
		keepWalking
		previousEnd
	|

	formatter := Rudesheim Tooling Formatter.
	steps := OrderedCollection new.
	node := aMessageNode.

	receiverLinesAction :=
	[
		formatter
			formatSubexpressionLines:	node
			indent:	anIndentToolingRudesheim.
	].

	keepWalking := true.
	[
		keepWalking
			and:
			[
				(
					node
						isKindOf:	OCMessageNode
				)
					and:
					[
						node isKeyword not.
					].
			].
	]
		whileTrue:
		[
			steps
				addFirst:	node.

			[
				|
					continue
				|

				continue := thisContext.

				(
					node receiver
						isKindOf:	OCMessageNode
				)
					ifFalse:
					[
						continue return.
					].

				node receiver parentheses isEmpty
					ifFalse:
					[
						"The author wrote explicit parentheses around this receiver. Binary
						messages are left-associative with equal precedence, so folding it into
						the flat chain below would silently drop grouping the author asked for
						(and, for a chain nested more than one level deep, can change the AST).
						Stop walking here and format the parenthesized receiver as its own
						subexpression instead of flattening through it."
						receiverLinesAction :=
						[
							formatter
								formatParenthesizedSubexpressionLines:	node
								indent:	anIndentToolingRudesheim.
						].

						keepWalking := false.
						continue return.
					].

				node isBinary
					ifTrue:
					[
						continue return.
					].

				node receiver isBinary
					ifFalse:
					[
						continue return.
					].

				receiverLinesAction :=
				[
					formatter
						formatParenthesizedLines:	node
						indent:	anIndentToolingRudesheim.
				].

				keepWalking := false.
			] value.

			node := node receiver.
		].

	receiverLines := receiverLinesAction value.
	lines := OrderedCollection new.

	lines
		addAll:	receiverLines.

	previousEnd := node sourceInterval last.

	steps
		do:
		[ :step |
			|
				stepText
				argument
				stepAction
				commentLines
				appendStepTextAction
			|

			commentLines :=
				formatter
					formatCommentLinesInSource:	aMessageNode source
					from:	previousEnd + 1
					to:	step selectorInterval first - 1
					indent:	anIndentToolingRudesheim oneLevelDeeper.

			appendStepTextAction :=
			[ :aStepTextString |
				commentLines
					ifEmpty:
					[
						lines
							at:	lines size
							put:	lines last , ' ' , aStepTextString.
					]
					ifNotEmpty:
					[
						"A comment sat between the previous content and this step -- e.g. `self
						""comment"" foo` -- so this step can no longer simply be fused onto the
						previous line; formatUnaryOrBinaryChainLines: never looked for such a
						comment at all before, silently dropping it (comments aren't real
						nodes, so nothing in the receiver/argument structure this method
						reconstructs from ever reflected it). Indented one level deeper than
						the receiver, the same as any other place a keyword part or multiline
						argument continues past the receiver's own line."
						lines
							addAll:	commentLines.

						lines
							add:	anIndentToolingRudesheim oneLevelDeeper asString , aStepTextString.
					].
			].

			stepAction :=
			[
				stepText := step selector asString.

				step isBinary
					ifTrue:
					[
						stepText :=
							step selector asString , ' ' ,
							(
								formatter
									formatInline:	step arguments first
							).
					].

				appendStepTextAction
					value:	stepText.
			].
			[
				|
					continue
				|

				continue := thisContext.

				step isBinary
					ifFalse:
					[
						continue return.
					].

				argument := step arguments first.

				(
					formatter
						needsMultilineFor:	argument
				)
					ifFalse:
					[
						continue return.
					].

				stepAction :=
				[
					appendStepTextAction
						value:	step selector asString.

					lines
						addAll:
						(
							formatter
								formatMultilineBinaryArgumentLines:	argument
								indent:	anIndentToolingRudesheim
						).
				].
			] value.

			stepAction value.
			previousEnd := step sourceInterval last.
		].

	^ lines.
]
