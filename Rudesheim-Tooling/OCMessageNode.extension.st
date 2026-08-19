Extension { #name : 'OCMessageNode' }

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger [
	^ aFormatter formatMessageLines: self indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> acceptFormatterRudesheimAsSubexpression: aFormatter indent: anIndentLevelInteger [
	self isKeyword
		ifTrue: [ ^ aFormatter formatParenthesizedLines: self indent: anIndentLevelInteger ].
	^ self acceptFormatterRudesheim: aFormatter indent: anIndentLevelInteger
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> isBlockStatementForFormatterRudesheim [
	^ self receiver isBlock
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> needsExpressionLinesAsAssignmentValueForFormatterRudesheim: aFormatter [
	^ self needsMultilineForFormatterRudesheim: aFormatter
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> needsMultilineForFormatterRudesheim: aFormatter [
	self isKeyword
		ifTrue: [ ^ true ].
	(
		self isBinary
			and:
			[
				self arguments first
					needsMultilineForFormatterRudesheim:	aFormatter.
			]
	)
		ifTrue: [ ^ true ].
	^ self receiver needsMultilineForFormatterRudesheim: aFormatter
]

{ #category : '*Rudesheim-Tooling' }
OCMessageNode >> unaryBinaryChainLengthForFormatterRudesheim: aFormatter [
	self isKeyword
		ifTrue: [ ^ 0 ].
	^ 1 + (self receiver unaryBinaryChainLengthForFormatterRudesheim: aFormatter)
]
