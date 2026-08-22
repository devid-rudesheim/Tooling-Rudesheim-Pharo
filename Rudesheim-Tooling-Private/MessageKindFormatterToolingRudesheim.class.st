"
Shared protocol for OCMessageNode kind formatting (keyword/binary/unary). Binary and unary
messages share this implementation as-is; KeywordMessageKindFormatterToolingRudesheim overrides
formatLines:indent: with keyword-specific formatting.
"
Class {
	#name : 'MessageKindFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
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

				node isBinary
					ifTrue:
					[
						continue return.
					].

				(
					node receiver
						isKindOf:	OCMessageNode
				)
					ifFalse:
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

	steps
		do:
		[ :step |
			|
				stepText
				argument
				stepAction
			|

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

				lines
					at:	lines size
					put:	lines last , ' ' , stepText.
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
					lines
						at:	lines size
						put:	lines last , ' ' , step selector asString.

					lines
						addAll:
						(
							formatter
								formatSubexpressionLines:	argument
								indent:	anIndentToolingRudesheim
						).
				].
			] value.

			stepAction value.
		].

	^ lines.
]
