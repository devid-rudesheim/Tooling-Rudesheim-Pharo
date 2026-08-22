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

{ #category : 'formatting' }
MessageKindFormatterToolingRudesheim class >> formatLines: aMessageNode
indent: anIndentToolingRudesheim [
	aMessageNode receiver isBlock
		ifTrue:
		[
			|
				receiverLines
				argumentString
			|

			receiverLines :=
				BlockFormatterToolingRudesheim
					formatBlockLines:	aMessageNode receiver
					indent:	anIndentToolingRudesheim.

			argumentString := ''.
			aMessageNode isBinary
				ifTrue:
				[
					argumentString :=
						' ' ,
						(
							FormatterToolingRudesheim
								formatInline:	aMessageNode arguments first
						).
				].

			receiverLines
				at:	receiverLines size
				put:	receiverLines last , ' ' , aMessageNode selector asString , argumentString.

			^ receiverLines.
		].

	(
		FormatterToolingRudesheim
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
			FormatterToolingRudesheim
				formatInline:	aMessageNode
		)
	}.
]

{ #category : 'formatting' }
MessageKindFormatterToolingRudesheim class >> formatUnaryOrBinaryChainLines: aMessageNode
indent: anIndentToolingRudesheim [
	|
		steps
		node
		lines
		receiverLines
		receiverLinesAction
		keepWalking
	|

	steps := OrderedCollection new.
	node := aMessageNode.

	receiverLinesAction :=
	[
		FormatterToolingRudesheim
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
					]
			]
	]
		whileTrue:
		[
			steps
				addFirst:	node.

			node isBinary not
				ifTrue:
				[
					(
						node receiver
							isKindOf:	OCMessageNode
					)
						ifTrue:
						[
							node receiver isBinary
								ifTrue:
								[
									receiverLinesAction :=
									[
										FormatterToolingRudesheim
											formatParenthesizedLines:	node
											indent:	anIndentToolingRudesheim.
									].

									keepWalking := false.
								].
						].
				].

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
								FormatterToolingRudesheim
									formatInline:	step arguments first
							).
					].

				lines
					at:	lines size
					put:	lines last , ' ' , stepText.
			].

			step isBinary
				ifTrue:
				[
					argument := step arguments first.

					(
						FormatterToolingRudesheim
							needsMultilineFor:	argument
					)
						ifTrue:
						[
							stepAction :=
							[
								lines
									at:	lines size
									put:	lines last , ' ' , step selector asString.

								lines
									addAll:
									(
										FormatterToolingRudesheim
											formatSubexpressionLines:	argument
											indent:	anIndentToolingRudesheim
									).
							].
						].
				].

			stepAction value.
		].

	^ lines.
]
