Class {
	#name : 'FormatterToolingRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'sourceString',
		'targetString',
		'target'
	],
	#category : 'Rudesheim-Tooling-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

{ #category : 'accessing' }
FormatterToolingRudesheimTest >> defaultTarget [
	^ self targetClass new.
]

{ #category : 'accessing' }
FormatterToolingRudesheimTest >> target [
	^ target
		ifNil:
		[
			target := self defaultTarget.
		].
]

{ #category : 'accessing' }
FormatterToolingRudesheimTest >> target: anObject [
	target := anObject.
]

{ #category : 'accessing' }
FormatterToolingRudesheimTest >> targetClass [
	^ self class targetClass.
]

{ #category : 'tests-data' }
FormatterToolingRudesheimTest class >> defaultSourceString [
	^ 'writeStreamDo: aWritingBlockreadStreamDo: aReadingBlock	|		originStream		pipeStream		pipeStreams		join	|		originStream := PipeStreamsRudesheim new.	pipeStream := originStream.		commands		do:		[ :each |			|				processLocalStream			|					processLocalStream := pipeStream :=					PipeStreamsRudesheim						shiftStream: pipeStream.				[					[						each						executeWithPipeStream: processLocalStream.					]						ensure:						[							processLocalStream stdout close.						].				] fork		].		pipeStreams :=		PipeStreamsRudesheim			inputPipeStreams: pipeStream inverse			outputPipeStreams: originStream.		join := Semaphore new.	[		[			aWritingBlock				value: pipeStreams stdout.		]			ensure:			[				pipeStreams stdout close.				join signal.			].	] fork.	^	[		aReadingBlock			value: pipeStreams stdin.	]		ensure:		[			join wait		].'.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest class >> defaultTargetString [
	^ 'writeStreamDo: aWritingBlock
readStreamDo: aReadingBlock
	|
		originStream
		pipeStream
		pipeStreams
		join
	|

	originStream := PipeStreamsRudesheim new.
	pipeStream := originStream.

	commands
		do:
		[ :each |
			|
				processLocalStream
			|

			processLocalStream := pipeStream :=
				PipeStreamsRudesheim
					shiftStream:	pipeStream.
			[
				[
					each
						executeWithPipeStream:	processLocalStream.
				]
					ensure:
					[
						processLocalStream stdout close.
					].
			] fork
		].

	pipeStreams :=
		PipeStreamsRudesheim
			inputPipeStreams:	pipeStream inverse
			outputPipeStreams:	originStream.

	join := Semaphore new.
	[
		[
			aWritingBlock
				value:	pipeStreams stdout.
		]
			ensure:
			[
				pipeStreams stdout close.
				join signal.
			].
	] fork.

	^
	[
		aReadingBlock
			value:	pipeStreams stdin.
	]
		ensure:
		[
			join wait.
		].'.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest class >> expectedEnsureProcessingClassNamedTarget [
	|
		specs
		stream
	|

	specs := OrderedCollection new.

	specs
		add:	0 -> 'ensureProcessingClassNamed: aClassSymbol'.

	specs
		add:	1 -> '|'.

	specs
		add:	2 -> 'cls'.

	specs
		add:	1 -> '|'.

	specs
		add:	0 -> ''.

	specs
		add:	1 -> '('.

	specs
		add:	2 -> 'Smalltalk'.

	specs
		add:	3 -> ('includesKey:' , String tab , 'aClassSymbol').

	specs
		add:	1 -> ')'.

	specs
		add:	2 -> 'ifFalse:'.

	specs
		add:	2 -> '['.

	specs
		add:	3 -> 'Smalltalk classInstaller'.

	specs
		add:	4 -> 'make:'.

	specs
		add:	4 -> '[ :builder |'.

	specs
		add:	5 -> 'builder'.

	specs
		add:	6 -> ('superclass:' , String tab , 'Object;').

	specs
		add:	6 -> ('name:' , String tab , 'aClassSymbol;').

	specs
		add:	6 -> 'traits:'.

	specs
		add:	6 -> '{'.

	specs
		add:	7 -> '('.

	specs
		add:	8 -> 'Smalltalk'.

	specs
		add:	9 -> ('at:' , String tab , '#TMethodUtilityGPTAgent').

	specs
		add:	7 -> ')'.

	specs
		add:	6 -> '};'.

	specs
		add:	6 -> ('slots:' , String tab , '{};').

	specs
		add:	6 -> ('package:' , String tab , '''AgentWorkspace''.').

	specs
		add:	4 -> '].'.

	specs
		add:	2 -> '].'.

	specs
		add:	0 -> ''.

	specs
		add:	1 -> 'cls :='.

	specs
		add:	2 -> 'Smalltalk'.

	specs
		add:	3 -> ('at:' , String tab , 'aClassSymbol.').

	specs
		add:	0 -> ''.

	specs
		add:	1 -> 'TMethodUtilityGPTAgent'.

	specs
		add:	2 -> ('ensureLastUsedMethodsOn:' , String tab , 'cls.').

	stream :=
		WriteStream
			on:	String new.

	specs
		doWithIndex:
		[ :pair :idx |
			pair
				key
				> 0
				ifTrue:
				[
					stream
						nextPutAll:	
						(
							String
								new:	pair key
								withAll:	Character tab
						).
				].

			stream
				nextPutAll:	pair value.

			idx < specs size
				ifTrue:
				[
					stream cr.
				].
		].

	^ stream contents.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest class >> sourceEnsureProcessingClassNamedExample [
	^ 'ensureProcessingClassNamed: aClassSymbol | cls | (Smalltalk includesKey: aClassSymbol) ifFalse: [ Smalltalk classInstaller make: [ :builder | builder superclass: Object; name: aClassSymbol; traits: {(Smalltalk at: #TMethodUtilityGPTAgent)}; slots: {}; package: ''AgentWorkspace''. ] ]. cls := Smalltalk at: aClassSymbol. TMethodUtilityGPTAgent ensureLastUsedMethodsOn: cls.'.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest class >> targetClass [
	^ FormatterToolingRudesheim.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase:	{(#sourceString -> self defaultSourceString) .  (#targetString -> self defaultTargetString)};
		addCase:	{(#sourceString -> 'sum ^ 1+2') .  (#targetString -> ('sum' , String cr , String tab , '^ 1 + 2.'))};
		yourself.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> sourceString [
	^ sourceString
		ifNil:
		[
			self
				class
				defaultSourceString.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> sourceString: aString [
	sourceString := aString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> targetString [
	^ targetString
		ifNil:
		[
			self
				class
				defaultTargetString.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> targetString: aString [
	targetString := aString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testChainedUnaryMessagesStayInline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'run ^ self foo bar'.

	expected := 'run' , String cr , String tab , '^ self foo bar.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testShortBinaryChainStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sum ^ 1 + 2 + 3'.

	expected := 'sum' , String cr , String tab , '^ 1 + 2 + 3.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testAssignmentBracketStartsAtAssignmentIndent [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'run | block total | block := [ 1 ]. total := (1 + 2)'.

	expected := 'run' , String cr , String tab , '|' , String cr , String tab , String tab , 'block' , String cr , String tab , String tab , 'total' , String cr , String tab , '|' , String cr , String cr , String tab , 'block :=' , String cr , String tab , '[' , String cr , String tab , String tab , '1.' , String cr , String tab , '].' , String cr , String cr , String tab , 'total := 1 + 2.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testDynamicArrayAlwaysUsesMultilineElements [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'ranges ^ { self rows. self columns }'.

	expected := 'ranges' , String cr , String tab , '^' , String cr , String tab , '{' , String cr , String tab , String tab , 'self rows.' , String cr , String tab , String tab , 'self columns' , String cr , String tab , '}.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testBinaryArgumentKeywordMessageKeepsParenthesizedMultiline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sum ^ total + (items inject: 0 into: [ :sum :each | sum + each ])'.

	expected := 'sum' , String cr , String tab , '^ total +' , String cr , String tab , '(' , String cr , String tab , String tab , 'items' , String cr , String tab , String tab , String tab , 'inject:' , String tab , '0' , String cr , String tab , String tab , String tab , 'into:' , String cr , String tab , String tab , String tab , '[ :sum :each |' , String cr , String tab , String tab , String tab , String tab , 'sum + each.' , String cr , String tab , String tab , String tab , ']' , String cr , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordArgumentStartingWithVariableIndentsOneLevelDeeper [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'store output at: index put: total + (biases at: oc + 1)'.

	expected := 'store' , String cr , String tab , 'output' , String cr , String tab , String tab , 'at:' , String tab , 'index' , String cr , String tab , String tab , 'put:' , String tab , String cr , String tab , String tab , String tab , 'total +' , String cr , String tab , String tab , String tab , '(' , String cr , String tab , String tab , String tab , String tab , 'biases' , String cr , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , 'oc + 1' , String cr , String tab , String tab , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordReceiverUnaryChainStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ Rudesheim MachineLearning NeuralNetwork TensorLayout forOutput: self output'.

	expected := 'sample' , String cr , String tab , '^ Rudesheim MachineLearning NeuralNetwork TensorLayout' , String cr , String tab , String tab , 'forOutput:' , String tab , 'self output.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCommentsArePreserved [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample "method comment" | value | "before assignment" value := 1. "before return" ^ value'.

	expected := 'sample' , String cr , String tab , '"method comment"' , String cr , String tab , '|' , String cr , String tab , String tab , 'value' , String cr , String tab , '|' , String cr , String cr , String tab , '"before assignment"' , String cr , String tab , 'value := 1.' , String cr , String tab , '"before return"' , String cr , String tab , '^ value.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLiteralArrayKeepsInsideSpaces [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'numbers ^ #( 1 2 3 )'.

	expected := 'numbers' , String cr , String tab , '^ #( 1 2 3 ).'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testParenthesizedInlineExpressionKeepsInsideSpaces [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ columnTotal + (weight * value)'.

	expected := 'sample' , String cr , String tab , '^ columnTotal + ( weight * value ).'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testParenthesisSpacingDoesNotChangeStringLiteralContents [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ ''(keep)'' , (1 + 2)'.

	expected := 'sample' , String cr , String tab , '^ ''(keep)'' , ( 1 + 2 ).'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testParenthesisSpacingDoesNotChangeCharacterLiteralContents [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ $) = $('.

	expected := 'sample' , String cr , String tab , '^ $) = $(.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testBinaryAfterParenthesizedMultilineReceiverStaysOnClosingParenthesis [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ (self formatInlineParenthesesIn: text trimBoth) = $"'.

	expected := 'sample' , String cr , String tab , '^' , String cr , String tab , '(' , String cr , String tab , String tab , 'self' , String cr , String tab , String tab , String tab , 'formatInlineParenthesesIn:' , String tab , 'text trimBoth' , String cr , String tab , ') = $".'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordParenthesizedMultilineArgumentStartsOnNextLine [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ self text: (self formatInlineParenthesesIn: text trimBoth)'.

	expected := 'sample' , String cr , String tab , '^ self' , String cr , String tab , String tab , 'text:' , String cr , String tab , String tab , '(' , String cr , String tab , String tab , String tab , 'self' , String cr , String tab , String tab , String tab , String tab , 'formatInlineParenthesesIn:' , String tab , 'text trimBoth' , String cr , String tab , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordParenthesizedBinaryArgumentIndentsAsExpression [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample self formatCommentLinesInSource: source from: previousEnd + 1 to: (self cascadeMessageStartFor: message) - 1 indent: keywordIndent'.

	expected := 'sample' , String cr , String tab , 'self' , String cr , String tab , String tab , 'formatCommentLinesInSource:' , String tab , 'source' , String cr , String tab , String tab , 'from:' , String tab , 'previousEnd + 1' , String cr , String tab , String tab , 'to:' , String cr , String tab , String tab , '(' , String cr , String tab , String tab , String tab , 'self' , String cr , String tab , String tab , String tab , String tab , 'cascadeMessageStartFor:' , String tab , 'message' , String cr , String tab , String tab , ') - 1' , String cr , String tab , String tab , 'indent:' , String tab , 'keywordIndent.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testDynamicArrayAssignmentWithLiteralArraysStaysMultiline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample | output | output := { "inside dynamic array" #( 10 20 ). #( ''a'' ''b'' ) }'.

	expected := 'sample' , String cr , String tab , '|' , String cr , String tab , String tab , 'output' , String cr , String tab , '|' , String cr , String cr , String tab , 'output :=' , String cr , String tab , '{' , String cr , String tab , String tab , '"inside dynamic array"' , String cr , String tab , String tab , '#( 10 20 ).' , String cr , String tab , String tab , '#( ''a'' ''b'' )' , String cr , String tab , '}.'. 

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testAssignmentBinaryWithLiteralArrayKeywordArgumentStaysMultiline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'total | ranges | total := (ranges at: 1) + (#( 4 5 6 ) inject: 0 into: [ :sum :each | "inside block" sum + each ])'.

	expected := 'total' , String cr , String tab , '|' , String cr , String tab , String tab , 'ranges' , String cr , String tab , '|' , String cr , String cr , String tab , 'total :=' , String cr , String tab , '(' , String cr , String tab , String tab , 'ranges' , String cr , String tab , String tab , String tab , 'at:' , String tab , '1' , String cr , String tab , ') +' , String cr , String tab , '(' , String cr , String tab , String tab , '#( 4 5 6 )' , String cr , String tab , String tab , String tab , 'inject:' , String tab , '0' , String cr , String tab , String tab , String tab , 'into:' , String cr , String tab , String tab , String tab , '[ :sum :each |' , String cr , String tab , String tab , String tab , String tab , '"inside block"' , String cr , String tab , String tab , String tab , String tab , 'sum + each.' , String cr , String tab , String tab , String tab , ']' , String cr , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCascadeCommentsArePreserved [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample | builder | builder := Object new. builder "before name" name: #Foo; "before values" values: #( 1 2 3 ); yourself'.

	expected := 'sample' , String cr , String tab , '|' , String cr , String tab , String tab , 'builder' , String cr , String tab , '|' , String cr , String cr , String tab , 'builder := Object new.' , String cr , String cr , String tab , 'builder' , String cr , String tab , String tab , '"before name"' , String cr , String tab , String tab , 'name:' , String tab , '#Foo;' , String cr , String tab , String tab , '"before values"' , String cr , String tab , String tab , 'values:' , String tab , '#( 1 2 3 );' , String cr , String tab , String tab , 'yourself.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testFormatAsYouReadPolicyAndFormatterSwitch [
	|
		previousClass
		previousPolicy
	|

	previousClass := OCProgramNode formatterClass.
	previousPolicy := self targetClass formatAsYouReadPolicy.
	[
		self targetClass
			formatAsYouReadPolicy:	false.

		self
			assert:	
			self
				targetClass
				formatAsYouReadPolicy
			equals:	false.

		self
			targetClass
			enableAsFormatter.

		self
			assert:	OCProgramNode formatterClass
			equals:	self targetClass.

		self targetClass
			formatAsYouReadPolicy:	true.

		self
			assert:	
			self
				targetClass
				formatAsYouReadPolicy
			equals:	true.

		self
			targetClass
			disableAsFormatter.

		self
			assert:	OCProgramNode formatterClass
			equals:	OCSimpleFormatter.
	]
		ensure:
		[
			self targetClass
				formatAsYouReadPolicy:	previousPolicy.

			OCProgramNode
				formatterClass:	previousClass.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testFormatClassSelectorMatchesFormatString [
	|
		methodSource
		formatted
		expected
	|

	methodSource :=
		FormatterToolingRudesheimTest
			sourceCodeAt:	#sourceString.

	formatted :=
		self targetClass
			formatClass:	FormatterToolingRudesheimTest
			selector:	#sourceString.

	expected :=
		self targetClass
			formatString:	methodSource.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testFormatsEnsureProcessingClassNamedExample [
	|
		formatted
	|

	formatted :=
		self targetClass
			format:	
			self
				class
				sourceEnsureProcessingClassNamedExample.

	self
		assert:	formatted
		equals:	
		self
			class
			expectedEnsureProcessingClassNamedTarget.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testFormatsSourceToTarget [
	|
		formatted
	|

	formatted :=
		self targetClass
			format:	self sourceString.

	self
		assert:	formatted
		equals:	self targetString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testInstanceFormatDelegates [
	|
		formatted
	|

	formatted :=
		self target
			format:	self sourceString.

	self
		assert:	formatted
		equals:	self targetString.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testKeywordMessageSplitsWithTabAfterColon [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'checkKey: aKey ^ Smalltalk includesKey: aKey'.

	expected := 'checkKey: aKey' , String cr , String tab , '^ Smalltalk' , String cr , String tab , String tab , 'includesKey:' , String tab , 'aKey.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testReturnBracketedMultilineKeepsNewlineAfterCaret [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'makeBlock ^ [ 1 + 1 ]'.

	expected := 'makeBlock' , String cr , String tab , '^' , String cr , String tab , '[' , String cr , String tab , String tab , '1 + 1.' , String cr , String tab , '].'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testReturnNonBracketMultilineJoinsFirstLine [
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> testReturnSimpleValueStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'flag ^ true'.

	expected := 'flag' , String cr , String tab , '^ true.'.

	self
		assert:	formatted
		equals:	expected.
]
