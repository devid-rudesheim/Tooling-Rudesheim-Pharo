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
						processLocalStream
							stdout
							close.
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
				pipeStreams
					stdout
					close.

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
		add:	6 -> ('traits:' , String tab).

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
FormatterToolingRudesheimTest >> testChainedUnaryMessagesEachOnOwnLine [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'run ^ self foo bar'.

	expected := 'run' , String cr , String tab , '^ self' , String cr , String tab , String tab , 'foo' , String cr , String tab , String tab , 'bar.'.

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
