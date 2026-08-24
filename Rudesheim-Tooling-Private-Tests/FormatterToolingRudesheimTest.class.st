Class {
	#name : 'FormatterToolingRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'sourceString',
		'targetString',
		'target'
	],
	#category : 'Rudesheim-Tooling-Private-Tests',
	#package : 'Rudesheim-Tooling-Private-Tests'
}

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
		add:	3 -> ( 'includesKey:' , String tab , 'aClassSymbol' ).

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
		add:	6 -> ( 'superclass:' , String tab , 'Object;' ).

	specs
		add:	6 -> ( 'name:' , String tab , 'aClassSymbol;' ).

	specs
		add:	6 -> 'traits:'.

	specs
		add:	6 -> '{'.

	specs
		add:	7 -> 'Smalltalk'.

	specs
		add:	8 -> ( 'at:' , String tab , '#TMethodUtilityGPTAgent' ).

	specs
		add:	6 -> '};'.

	specs
		add:	6 -> ( 'slots:' , String tab , '{};' ).

	specs
		add:	6 -> ( 'package:' , String tab , '''AgentWorkspace''.' ).

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
		add:	3 -> ( 'at:' , String tab , 'aClassSymbol.' ).

	specs
		add:	0 -> ''.

	specs
		add:	1 -> 'TMethodUtilityGPTAgent'.

	specs
		add:	2 -> ( 'ensureLastUsedMethodsOn:' , String tab , 'cls.' ).

	stream :=
		WriteStream
			on:	String new.

	specs
		doWithIndex:
		[ :pair :idx |
			pair key > 0
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
		addCase:
		{
			( #sourceString -> self defaultSourceString ).
			( #targetString -> self defaultTargetString )
		};
		addCase:
		{
			( #sourceString -> 'sum ^ 1+2' ).
			( #targetString -> ( 'sum' , String cr , String tab , '^ 1 + 2.' ) )
		};
		yourself.
]

{ #category : 'accessing' }
FormatterToolingRudesheimTest >> defaultTarget [
	^ self targetClass new.
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> sourceString [
	^ sourceString
		ifNil:
		[
			self class defaultSourceString.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> sourceString: aString [
	sourceString := aString.
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

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> targetString [
	^ targetString
		ifNil:
		[
			self class defaultTargetString.
		].
]

{ #category : 'as yet unclassified' }
FormatterToolingRudesheimTest >> targetString: aString [
	targetString := aString.
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
FormatterToolingRudesheimTest >> testBinaryMessageChainKeepsExplicitGroupingParentheses [
	"Regression test for note/formatter-tooling-rudesheim-bugs.md's 2026-08-23 entry: the
	formatter was dropping parentheses around same-precedence binary sub-expressions, which
	changes the AST because Smalltalk binary messages are left-associative with equal
	precedence. Each `( ... = ... )` group here is semantically required and must survive
	formatting unchanged."
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '[' , String cr , String tab , String tab , '( rows first key = rows second key ) & ( rows first key = rows last key ) & ( rows first key = parameters first ).' , String cr , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testBinaryMessageChainKeepsExplicitGroupingParenthesesOnMultilineArgument [
	"Companion to testBinaryMessageChainKeepsExplicitGroupingParentheses: that test covers
	explicit parentheses disappearing from the receiver side of a binary chain; this one
	covers the argument side, which was a separate bug -- the argument of `&` here needs its
	own multiple lines (it has a hand-written line break), and the multiline path for a
	binary message's argument was dropping its parentheses instead of keeping them. Without
	the parentheses this would reparse as `((A & rows second value) = rows last)` instead of
	`(A & (rows second value = rows last))`, changing the AST."
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '^' , String cr , String tab , '( rows first value = rows second value ) &' , String cr , String tab , '(' , String cr , String tab , String tab , 'rows second value = rows last' , String cr , String tab , ').'.

	formatted :=
		self targetClass
			format:	expected.

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
FormatterToolingRudesheimTest >> testCommentBeforeTempsContainingAnEscapedQuoteIsPreserved [
	"Regression test for a real-world case found while re-verifying the formatter's fixes
	against the wider Rudesheim ecosystem: a comment before a method's `| temps |` bar (the
	one region formatSequenceLines:indent:'s own comment scan structurally cannot reach, so
	formatMethodNode: still uses aMethodNode firstPrecodeComment for it -- see that method's
	own comment) that itself contained a literal doubled quote lost its escaping when
	re-emitted, the same way formatCommentLinesInSource:from:to:indent: used to for every
	other comment position before it was fixed to double a comment's embedded quote
	characters back up on the way out (see doubleQuoteCharacterAsString). An unescaped quote
	prematurely closes the comment when reparsed, corrupting everything after it into code."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '"Example: write self ""x"" foo to show a comment inside an expression."' , String cr , String tab , '|' , String cr , String tab , String tab , 'value' , String cr , String tab , '|' , String cr , String cr , String tab , 'value := 1.' , String cr , String tab , '^ value.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCommentAfterLastStatementInBlockIsPreserved [
	"formatSequenceLines:indent: only emits the comments that sit *before* each statement in
	a sequence (formatCommentLinesInSource:from:to:indent:, called once per statement with the
	source range ending right before that statement starts); nothing ever looks at the range
	after the *last* statement, so a trailing comment -- here, inside a block -- is silently
	dropped."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '[' , String cr , String tab , String tab , 'self doSomething.' , String cr , String tab , String tab , '"event wait."' , String cr , String tab , '] value'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCommentAfterLastStatementInMethodIsPreserved [
	"Same bug as testCommentAfterLastStatementInBlockIsPreserved, but at the method's own
	top-level sequence instead of inside a block."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , 'self doSomething.' , String cr , String tab , '"event wait."'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testConsecutiveCommentsBeforeAStatementAreAllPreserved [
	"OCMethodNode>>firstPrecodeComment only exposes the first comment before the method's
	first statement, and OCSequenceNode>>sourceInterval starts at that first statement too
	(comments aren't real nodes, so nothing before the first statement is reflected in any
	node's own interval unless there's a `| temps |` bar to anchor it) -- so
	formatSequenceLines:indent:'s per-statement comment scan ends up asking for comments in an
	empty range, and only the one comment formatMethodNode: separately grabs via
	firstPrecodeComment survives. Every comment past the first, of any number, is dropped."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '"XOR=0, AND=0"' , String cr , String tab , '"XOR=1, AND=0"' , String cr , String tab , '"XOR=1, AND=0"' , String cr , String tab , '"XOR=0, AND=1"' , String cr , String tab , 'self doSomething.'.

	formatted :=
		self targetClass
			format:	expected.

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
FormatterToolingRudesheimTest >> testDynamicArrayKeywordMessageElementsDoNotGetWrappedInParentheses [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:
				'sample: aString nextChar: nextChar nextIndex: nextIndex size: size
	{
		self
			candidateIdentifierTerminatesWith: nextChar.
		1 + nextIndex <= size
			and:
			[
				self
					isAssignmentStartCharacter: nextChar
					followedBy: (aString at: 1 + nextIndex).
			]
	}'.

	expected := 'sample: aString' , String cr , 'nextChar: nextChar' , String cr , 'nextIndex: nextIndex' , String cr , 'size: size' , String cr , String tab , '{' , String cr , String tab , String tab , 'self' , String cr , String tab , String tab , String tab , 'candidateIdentifierTerminatesWith:' , String tab , 'nextChar.' , String cr , String tab , String tab , '1 + nextIndex <= size' , String cr , String tab , String tab , String tab , 'and:' , String cr , String tab , String tab , String tab , '[' , String cr , String tab , String tab , String tab , String tab , 'self' , String cr , String tab , String tab , String tab , String tab , String tab , 'isAssignmentStartCharacter:' , String tab , 'nextChar' , String cr , String tab , String tab , String tab , String tab , String tab , 'followedBy:' , String cr , String tab , String tab , String tab , String tab , String tab , '(' , String cr , String tab , String tab , String tab , String tab , String tab , String tab , 'aString' , String cr , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , '1 + nextIndex' , String cr , String tab , String tab , String tab , String tab , String tab , ').' , String cr , String tab , String tab , String tab , ']' , String cr , String tab , '}.'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
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
			deny:	self targetClass formatAsYouReadPolicy.

		self targetClass enableAsFormatter.

		self
			assert:	OCProgramNode formatterClass
			equals:	self targetClass.

		self targetClass
			formatAsYouReadPolicy:	true.

		self
			assert:	self targetClass formatAsYouReadPolicy.

		self targetClass disableAsFormatter.

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
			format:	self class sourceEnsureProcessingClassNamedExample.

	self
		assert:	formatted
		equals:	self class expectedEnsureProcessingClassNamedTarget.
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

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordArgumentShortBinaryMessageStaysInline [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample elementLines at: elementLines size put: elementLines last , ''.'''.

	expected := 'sample' , String cr , String tab , 'elementLines' , String cr , String tab , String tab , 'at:' , String tab , 'elementLines size' , String cr , String tab , String tab , 'put:' , String tab , 'elementLines last , ''.''.'.

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

	expected := 'store' , String cr , String tab , 'output' , String cr , String tab , String tab , 'at:' , String tab , 'index' , String cr , String tab , String tab , 'put:' , String cr , String tab , String tab , String tab , 'total +' , String cr , String tab , String tab , String tab , '(' , String cr , String tab , String tab , String tab , String tab , 'biases' , String cr , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , 'oc + 1' , String cr , String tab , String tab , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordMessageArgumentUnaryChainDoesNotBreakBeforeMultilineArgument [
	"Regression test for note/formatter-tooling-rudesheim-bugs.md's report that a newline
	could get inserted before a unary message chain written as one keyword message argument
	while a sibling argument of the same message forces the message onto multiple lines.
	`self basicTarget lastArguments` must stay on `assert:`'s own line even though `equals:`'s
	dynamic-array argument forces the rest of the message multiline."
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , 'self' , String cr , String tab , String tab , 'assert:' , String tab , 'self basicTarget lastArguments' , String cr , String tab , String tab , 'equals:' , String cr , String tab , String tab , '{' , String cr , String tab , String tab , String tab , '1.' , String cr , String tab , String tab , String tab , '2.' , String cr , String tab , String tab , String tab , '3' , String cr , String tab , String tab , '}.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordArgumentUnaryChainWithHandWrittenLineBreaksCollapsesInline [
	"Regression test for a real-world case found while reviewing Kernel-Rudesheim-Pharo PR #15
	(a repo-wide reformat with this Formatter): a keyword message argument that is a plain
	unary message chain (e.g. `root Column ForDateAndTime`, a chain of namespace-style unary
	sends) collapses onto one line when formatted as a bare statement or as a message
	receiver (see testKeywordReceiverUnaryChainStaysInline) regardless of how many lines it
	was originally hand-typed across, because a plain unary/binary chain's own
	needsMultilineForFormatterRudesheim: never depends on hand-written line breaks -- only on
	genuine structural need (a parenthesized receiver, etc). But
	formatKeywordPart:argument:indent: decided whether the keyword and its argument share a
	line via the general needsMultilineFor:, which also consults
	hasHandWrittenLineBreakFor: on the argument's *original* source span -- still containing
	the hand-typed breaks the argument's own rendering was about to eliminate -- so the
	keyword was pushed onto its own line above an argument that then rendered as a single
	line anyway. Reformatting that already-formatted result collapsed the two onto one line,
	proving the first pass was wrong: the formatter was not idempotent for this case."
	|
		formatted
		input
	|

	input := 'sample self foo: root' , String cr , String tab , 'Column' , String cr , String tab , String tab , 'ForDateAndTime.'.

	formatted :=
		self targetClass
			format:	input.

	self
		assert:	formatted
		equals:	'sample' , String cr , String tab , 'self' , String cr , String tab , String tab , 'foo:' , String tab , 'root Column ForDateAndTime.'.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordMessageInsideBlockKeepsEachKeywordPartOnOwnLine [
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '[' , String cr , String tab , String tab , 'self targetClass' , String cr , String tab , String tab , String tab , 'inClass:' , String tab , 'self class' , String cr , String tab , String tab , String tab , 'withCode:' , String tab , '''''' , String cr , String tab , String tab , String tab , 'doitFlag:' , String tab , 'false' , String cr , String tab , String tab , String tab , 'errorMessage:' , String tab , '''Message pattern expected''' , String cr , String tab , String tab , String tab , 'location:' , String tab , '1.' , String cr , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordMessageReceiverKeepsOwnRequiredMultilineInsteadOfCollapsing [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample: aString index: anIndex (aString at: anIndex) isAlphaNumeric ifFalse: [ ^ false ]'.

	expected := 'sample: aString' , String cr , 'index: anIndex' , String cr , String tab , '(' , String cr , String tab , String tab , 'aString' , String cr , String tab , String tab , String tab , 'at:' , String tab , 'anIndex' , String cr , String tab , ') isAlphaNumeric' , String cr , String tab , String tab , 'ifFalse:' , String cr , String tab , String tab , '[' , String cr , String tab , String tab , String tab , '^ false.' , String cr , String tab , String tab , '].'.

	self
		assert:	formatted
		equals:	expected.

	self
		deny:
		(
			formatted
				includesSubstring:	'at::'
		).
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
FormatterToolingRudesheimTest >> testLiteralArrayAsKeywordArgumentStaysAtKeywordIndent [
	"A literal array's own opening bracket is the two characters #( , which
	isOpeningBracketCharacter: (a single-character check) never matches -- without
	needsMultilineFor:-aware handling for this specific case in
	KeywordMessageKindFormatterToolingRudesheim class>>formatKeywordPart:argument:indent:,
	a multiline literal array keyword argument would get re-indented one level deeper
	instead of hanging at the keyword's own indent the way { and [ already do."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , 'self' , String cr , String tab , String tab , 'useNames:' , String cr , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , '''alpha''' , String cr , String tab , String tab , String tab , '''beta''' , String cr , String tab , String tab , ').'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testNestedLiteralArraysWithoutHandWrittenLineBreaksStayInline [
	"Unlike a dynamic array ({ ... }), a literal array must not go multiline just because it
	is non-empty or nested -- only when it (or a literal array nested inside it) was already
	written across multiple lines. This one has neither, at either nesting level, so it must
	collapse to a single line same as testLiteralArrayKeepsInsideSpaces's flat case."

	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'sample ^ #(#(1 2) #(3 4))'.

	expected := 'sample' , String cr , String tab , '^ #( #(1 2) #(3 4) ).'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testNestedLiteralArraysWithHandWrittenLineBreaksStayMultiline [
	"Regression test for a real-world case: a literal array of pairs, each pairing a
	repository name with its own nested literal array of package names, all originally
	hand-written across multiple lines. FormatterToolingRudesheim used to force every literal
	array through its single-line renderer unconditionally (formatLiteralArrayInline:, the
	only literal-array code path that existed), regardless of size or nesting -- collapsing
	something this large onto one very long line instead of respecting the structure the
	author wrote. See OCLiteralArrayNode.extension.st's
	needsMultilineForFormatterRudesheim: and LiteralArrayFormatterToolingRudesheim."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '^ #(' , String cr , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , '''Kernel-Rudesheim-Pharo''' , String cr , String tab , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , String tab , '''BaselineOfRudesheimKernel''' , String cr , String tab , String tab , String tab , String tab , '''Rudesheim-Kernel-Base''' , String cr , String tab , String tab , String tab , ')' , String cr , String tab , String tab , ')' , String cr , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , '''Utility-Rudesheim-Pharo''' , String cr , String tab , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , String tab , '''BaselineOfRudesheimUtility''' , String cr , String tab , String tab , String tab , String tab , '''Rudesheim-Utility-Base''' , String cr , String tab , String tab , String tab , ')' , String cr , String tab , String tab , ')' , String cr , String tab , ').'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testMultilineLiteralArrayAsAssignmentValueStaysMultiline [
	"Regression test for a real-world case found while re-verifying
	testNestedLiteralArraysWithHandWrittenLineBreaksStayMultiline's fix against the wider
	Rudesheim ecosystem: that fix only reaches a literal array through
	OCLiteralArrayNode>>acceptFormatterRudesheim:indent:, but
	AssignmentFormatterToolingRudesheim class>>formatAssignmentLines:indent: doesn't call that
	for its value at all unless
	OCLiteralArrayNode>>needsExpressionLinesAsAssignmentValueForFormatterRudesheim: says so --
	otherwise it renders the value with formatInline: unconditionally, which for a literal
	array means the always-single-line formatLiteralArrayInline:, bypassing this class's
	multiline support entirely regardless of how it was originally written. So
	`x := #( ... )` (this test) needed its own fix on top of `^ #( ... )`
	(testNestedLiteralArraysWithHandWrittenLineBreaksStayMultiline)."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '|' , String cr , String tab , String tab , 'source' , String cr , String tab , '|' , String cr , String cr , String tab , 'source :=' , String cr , String tab , String tab , '#(' , String cr , String tab , String tab , String tab , '#( #(0.0 0.0) #(0.0 0.0) )' , String cr , String tab , String tab , String tab , '"XOR=0, AND=0"' , String cr , String tab , String tab , String tab , '#( #(1.0 0.0) #(1.0 0.0) )' , String cr , String tab , String tab , String tab , '"XOR=1, AND=0"' , String cr , String tab , String tab , String tab , '#( #(0.0 1.0) #(1.0 0.0) )' , String cr , String tab , String tab , String tab , '"XOR=1, AND=0"' , String cr , String tab , String tab , String tab , '#( #(1.0 1.0) #(0.0 1.0) )' , String cr , String tab , String tab , String tab , '"XOR=0, AND=1"' , String cr , String tab , String tab , ').' , String cr , String cr , String tab , '^ source.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testByteArrayLiteralStaysByteArrayLiteralWhenMultiline [
	"A byte array literal (#[ ... ]) is a different type from a regular literal array
	(#( ... )) -- LiteralArrayFormatterToolingRudesheim class>>formatLiteralArrayLines:indent:
	used to always emit `#(` / `)` regardless of which kind aLiteralArrayNode actually was,
	silently turning a hand-written multiline ByteArray literal into a plain Array literal
	once it needed its own multiple lines (a short one on one line was unaffected, since that
	stays on formatLiteralArrayInline:'s unchanged path)."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '^ #[' , String cr , String tab , String tab , '1' , String cr , String tab , String tab , '2' , String cr , String tab , String tab , '3' , String cr , String tab , String tab , '4' , String cr , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCommentAfterOpeningParenthesisIsPreserved [
	"Regression test for a real-world case found while re-verifying the formatter's fixes
	against the wider Rudesheim ecosystem: a comment right after an opening parenthesis,
	before the wrapped expression's own first token (here, a keyword message argument
	written as `( ""comment"" receiver keywordPart: value )`), was silently dropped.
	FormatterToolingRudesheim class>>formatParenthesizedLines:indent: always builds its own
	'('/')' wrapper around aNode's rendering without ever looking at the source text between
	the parenthesis it just emitted and wherever aNode's own rendering begins -- comments
	aren't real nodes, so nothing in that rendering ever reflected one. See
	leadingCommentLinesInsideParenthesesFor:indent:."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , 'self species' , String cr , String tab , String tab , 'weightsRows:' , String cr , String tab , String tab , '(' , String cr , String tab , String tab , String tab , '"delta weights"' , String cr , String tab , String tab , String tab , 'gradient' , String cr , String tab , String tab , String tab , String tab , 'collect:' , String cr , String tab , String tab , String tab , String tab , '[ :each0 |' , String cr , String tab , String tab , String tab , String tab , String tab , 'inputs * each0.' , String cr , String tab , String tab , String tab , String tab , ']' , String cr , String tab , String tab , ')' , String cr , String tab , String tab , 'biases:' , String tab , 'gradient.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testCommentBetweenUnaryReceiverAndSelectorIsPreserved [
	"Regression test for a real-world case found while re-verifying the formatter's fixes
	against the wider Rudesheim ecosystem: a comment written between a unary message's
	receiver and its own selector (`self ""comment"" foo`) was silently dropped.
	MessageKindFormatterToolingRudesheim class>>formatUnaryOrBinaryChainLines:indent: only
	ever fuses each step's selector (and, for a binary step, its argument) onto the previous
	line or, when the step's own argument needs multiple lines, starts a fresh one for that
	argument -- it never looked at the source text between the previous content and the
	step's own selector at all, so a comment sitting there (comments aren't real nodes, so
	nothing in the receiver/argument structure this method reconstructs from ever reflected
	one) was silently dropped."

	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , 'self' , String cr , String tab , String tab , '"testEnqueueCopyFromOffsetToForRangeAsForWait0_0;' , String cr , String tab , String tab , 'tearDown;' , String cr , String tab , String tab , 'setUp;"' , String cr , String tab , String tab , 'testEnqueueCopyFromOffsetToForRangeAsForWait1_0.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testNestedConditionalInsideParenthesizedBlockConditionKeepsStructure [
	|
		formatted
		expected
		oneTab
		twoTabs
		threeTabs
		fourTabs
		fiveTabs
	|

	oneTab := String tab.
	twoTabs := oneTab , oneTab.
	threeTabs := twoTabs , oneTab.
	fourTabs := threeTabs , oneTab.
	fiveTabs := fourTabs , oneTab.
	expected := 'sample' , String cr , oneTab , '[' , String cr , twoTabs , '^' , String cr , twoTabs , '(' , String cr , threeTabs , 'fieldSelector isNil' , String cr , fourTabs , 'and:' , String cr , fourTabs , '[' , String cr , fiveTabs , 'aMessage selector isUnary.' , String cr , fourTabs , ']' , String cr , twoTabs , ')' , String cr , threeTabs , 'ifTrue:' , String cr , threeTabs , '[' , String cr , fourTabs , 'self class' , String cr , fiveTabs , 'table:' , String tab , 'tableIndex' , String cr , fiveTabs , 'field:' , String tab , 'aMessage selector.' , String cr , threeTabs , ']' , String cr , threeTabs , 'ifFalse:' , String cr , threeTabs , '[' , String cr , fourTabs , 'super' , String cr , fiveTabs , 'processMessage:' , String tab , 'aMessage.' , String cr , threeTabs , '].' , String cr , oneTab , '].'.

	formatted :=
		self targetClass
			format:	expected.

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
FormatterToolingRudesheimTest >> testParenthesizedKeywordArgumentChainKeepsEachLevelIndented [
	|
		formatted
		expected
		oneTab
		twoTabs
		threeTabs
		fourTabs
		fiveTabs
		sixTabs
		sevenTabs
		eightTabs
		nineTabs
		tenTabs
	|

	oneTab := String tab.
	twoTabs := oneTab , oneTab.
	threeTabs := twoTabs , oneTab.
	fourTabs := threeTabs , oneTab.
	fiveTabs := fourTabs , oneTab.
	sixTabs := fiveTabs , oneTab.
	sevenTabs := sixTabs , oneTab.
	eightTabs := sevenTabs , oneTab.
	nineTabs := eightTabs , oneTab.
	tenTabs := nineTabs , oneTab.
	expected := 'sample' , String cr , oneTab , '^ aService' , String cr , twoTabs , 'checkResponse:' , String cr , twoTabs , '(' , String cr , threeTabs , 'aStringParser' , String cr , fourTabs , 'fromString:' , String cr , fourTabs , '(' , String cr , fiveTabs , 'aHttpMethodRudesheim' , String cr , sixTabs , 'sendRequestBy:' , String cr , sixTabs , '(' , String cr , sevenTabs , 'aHttpMethodRudesheim' , String cr , eightTabs , 'convertClient:' , String cr , eightTabs , '(' , String cr , nineTabs , 'aService templateAsHttpClient' , String cr , tenTabs , 'url:' , String tab , 'aUrl;' , String cr , tenTabs , 'yourself' , String cr , eightTabs , ')' , String cr , eightTabs , 'withProperties:' , String tab , 'properties' , String cr , sixTabs , ')' , String cr , fourTabs , ')' , String cr , twoTabs , ').'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testPragmaWithIntegerArgumentIsPreserved [
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '<primitive: 60>' , String cr , String cr , String tab , '^ 1.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testPragmaWithNoArgumentsIsPreserved [
	"Regression test for note/formatter-tooling-rudesheim-bugs.md's 2026-08-23 entry:
	`FormatterToolingRudesheim class>>format:` silently drops every method pragma, including
	the `<baseline>` pragma every `BaselineOf...>>baseline:` method needs to actually run as
	a baseline. `<baseline>` is a unary (no-argument) pragma; see the other
	testPragma*Preserved tests for keyword pragmas with varying argument counts and value
	types."
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '<baseline>' , String cr , String cr , String tab , '^ 1.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testPragmaWithOneKeywordArgumentIsPreserved [
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '<example: ''one''>' , String cr , String cr , String tab , '^ 1.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testPragmaWithThreeKeywordArgumentsOfMixedTypesIsPreserved [
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '<example: ''one'' some: 2 more: #three>' , String cr , String cr , String tab , '^ 1.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testPragmaWithTwoKeywordArgumentsIsPreserved [
	|
		formatted
		expected
	|

	expected := 'sample' , String cr , String tab , '<example: ''one'' some: ''two''>' , String cr , String cr , String tab , '^ 1.'.

	formatted :=
		self targetClass
			format:	expected.

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
FormatterToolingRudesheimTest >> testShortBinaryExpressionWrittenAcrossLinesStaysMultiline [
	"The argument of `+` (`weight * value`) is itself a binary send, so `total + weight *
	value` (no parentheses) is not the same AST as `total + (weight * value)` -- Smalltalk
	binary messages are left-associative with equal precedence, so the unparenthesized form
	reparses as `(total + weight) * value`. This fixture used to drop those parentheses; see
	note/formatter-tooling-rudesheim-bugs.md's 2026-08-23 entry and the PR that fixed
	MessageKindFormatterToolingRudesheim class>>formatUnaryOrBinaryChainLines:indent: to keep
	them."
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:
				'total: total weight: weight value: value
	^ total +
		(
			weight
				*
				value
		)'.

	expected := 'total: total' , String cr , 'weight: weight' , String cr , 'value: value' , String cr , String tab , '^ total +' , String cr , String tab , '(' , String cr , String tab , String tab , 'weight * value' , String cr , String tab , ').'.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testShortBinaryExpressionWrittenOnOneLineStaysOnOneLine [
	|
		formatted
		expected
	|

	formatted :=
		self targetClass
			format:	'total: total weight: weight value: value ^ total + (weight * value)'.

	expected := 'total: total' , String cr , 'weight: weight' , String cr , 'value: value' , String cr , String tab , '^ total + ( weight * value ).'.

	self
		assert:	formatted
		equals:	expected.
]
{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeBaselineSpecCascadeFormatsStably [
	"Large-method regression test, pulled from a real production method:
	Table-Query-Rudesheim-Pharo''s BaselineOfRudesheimTableQuery>>baseline: -- a genuine
	Metacello baseline specification. Exercises a deeply nested cascade of keyword sends
	inside several nested blocks, literal arrays used as keyword arguments, and long chains
	of keyword parts (project:/with:/package:/requires:) -- a shape none of the smaller,
	single-construct tests above combine all at once. Verifies the formatter handles a large,
	real, multi-construct method without corrupting or destabilizing it: format: applied to
	this already-correctly-formatted method must reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'baseline: spec' , String cr ,
	String tab , '<baseline>' , String cr ,
	'' , String cr ,
	String tab , 'spec' , String cr ,
	String tab , String tab , 'for:' , String tab , '#common' , String cr ,
	String tab , String tab , 'do:' , String cr ,
	String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''RudesheimUtility''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://devid-rudesheim/Utility-Rudesheim-Pharo:develop''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'project:' , String tab , '''RudesheimUtilityTests''' , String cr ,
	String tab , String tab , String tab , String tab , 'copyFrom:' , String tab , '''RudesheimUtility''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'loads:' , String tab , '#( ''tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''RudesheimKernel''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''DMirror''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://ObjectProfile/DMirror:master/src''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''SQLite3''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://pharo-rdbms/Pharo-SQLite3:master/src''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'project:' , String tab , '''SQLite3Core''' , String cr ,
	String tab , String tab , String tab , String tab , 'copyFrom:' , String tab , '''SQLite3''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'loads:' , String tab , '#( ''Core'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''RudesheimUtility'' ''RudesheimKernel'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-InMemory-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-InMemory''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query'' ''Rudesheim-Table-Query-InMemory-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-InMemory-DMirror-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-InMemory-Private'' ''DMirror'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-InMemory-DMirror''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-InMemory'' ''Rudesheim-Table-Query-InMemory-DMirror-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-Private-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query'' ''RudesheimUtilityTests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-InMemory'' ''RudesheimUtilityTests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-InMemory-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-InMemory'' ''Rudesheim-Table-Query-InMemory-DMirror'' ''Rudesheim-Table-Query-Tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query'' ''Rudesheim-Table-Query-SQL-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-SQLite3-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-SQL-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-SQLite3''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-SQL'' ''Rudesheim-Table-Query-SQL-SQLite3-Private'' ''SQLite3Core'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-Private-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-SQL'' ''Rudesheim-Table-Query-Tests'' ''RudesheimUtilityTests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-SQL'' ''Rudesheim-Table-Query-SQL-Private-Tests'' ''Rudesheim-Table-Query-Tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-Table-Query-SQL-SQLite3-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-Table-Query-SQL-SQLite3'' ''Rudesheim-Table-Query-SQL-Tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#core' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-Table-Query'' ''Rudesheim-Table-Query-InMemory'' ''Rudesheim-Table-Query-SQL'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#sqlite3' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-Table-Query-SQL-SQLite3'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#dmirror' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-Table-Query-InMemory-DMirror'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#tests' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-Table-Query-Tests'' ''Rudesheim-Table-Query-InMemory-Tests'' ''Rudesheim-Table-Query-SQL-Tests'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#sqlite3Tests' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-Table-Query-SQL-SQLite3-Tests'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#default' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( #core ).' , String cr ,
	String tab , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeConv2DLayerBackwardMethodFormatsStably [
	"Large-method regression test, pulled from a real production method:
	NeuralNetwork-Rudesheim-Pharo''s Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim>>
	backward: -- a convolution layer''s backward pass. Exercises long chains of binary
	arithmetic, nested keyword messages over numeric buffers, and multiple nested blocks
	across a large real method body. Verifies the formatter handles a large, real,
	multi-construct method without corrupting or destabilizing it: format: applied to this
	already-correctly-formatted method must reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'backward: aTBackwardContextNeuralNetworkMachineLearningRudesheim' , String cr ,
	String tab , '|' , String cr ,
	String tab , String tab , 'cl' , String cr ,
	String tab , String tab , 'queue' , String cr ,
	String tab , String tab , 'inChannels' , String cr ,
	String tab , String tab , 'inRows' , String cr ,
	String tab , String tab , 'inColumns' , String cr ,
	String tab , String tab , 'outRows' , String cr ,
	String tab , String tab , 'outColumns' , String cr ,
	String tab , String tab , 'kernelRows' , String cr ,
	String tab , String tab , 'kernelColumns' , String cr ,
	String tab , String tab , 'inputCount' , String cr ,
	String tab , String tab , 'weightCount' , String cr ,
	String tab , String tab , 'inputBuffer' , String cr ,
	String tab , String tab , 'gradientBuffer' , String cr ,
	String tab , String tab , 'inputGradientBuffer' , String cr ,
	String tab , String tab , 'biasGradientBuffer' , String cr ,
	String tab , String tab , 'weightGradientBuffer' , String cr ,
	String tab , String tab , 'biasGradientKernel' , String cr ,
	String tab , String tab , 'weightGradientKernel' , String cr ,
	String tab , String tab , 'inputGradientKernel' , String cr ,
	String tab , '|' , String cr ,
	'' , String cr ,
	String tab , 'cl := Rudesheim MachineLearning NeuralNetwork OpenCL.' , String cr ,
	String tab , 'inChannels := window inputChannels.' , String cr ,
	String tab , 'inRows := window input rows.' , String cr ,
	String tab , 'inColumns := window input columns.' , String cr ,
	String tab , 'outRows := window output rows.' , String cr ,
	String tab , 'outColumns := window output columns.' , String cr ,
	String tab , 'kernelRows := window kernel rows.' , String cr ,
	String tab , 'kernelColumns := window kernel columns.' , String cr ,
	String tab , 'inputCount := inChannels * inRows * inColumns.' , String cr ,
	String tab , 'weightCount := outChannels * inChannels * kernelRows * kernelColumns.' , String cr ,
	String tab , 'queue := cl commandQueue.' , String cr ,
	'' , String cr ,
	String tab , 'inputBuffer :=' , String cr ,
	String tab , String tab , 'cl context' , String cr ,
	String tab , String tab , String tab , 'newCLBufferWith:' , String tab , 'aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray' , String cr ,
	String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	'' , String cr ,
	String tab , 'gradientBuffer :=' , String cr ,
	String tab , String tab , 'cl context' , String cr ,
	String tab , String tab , String tab , 'newCLBufferWith:' , String tab , 'aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray' , String cr ,
	String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	'' , String cr ,
	String tab , 'inputGradientBuffer :=' , String cr ,
	String tab , String tab , 'cl context' , String cr ,
	String tab , String tab , String tab , 'newCLBufferForElementCount:' , String tab , 'inputCount' , String cr ,
	String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	'' , String cr ,
	String tab , 'biasGradientBuffer :=' , String cr ,
	String tab , String tab , 'cl context' , String cr ,
	String tab , String tab , String tab , 'newCLBufferForElementCount:' , String tab , 'outChannels' , String cr ,
	String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	'' , String cr ,
	String tab , 'weightGradientBuffer :=' , String cr ,
	String tab , String tab , 'cl context' , String cr ,
	String tab , String tab , String tab , 'newCLBufferForElementCount:' , String tab , 'weightCount' , String cr ,
	String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	'' , String cr ,
	String tab , 'biasGradientKernel :=' , String cr ,
	String tab , String tab , 'cl' , String cr ,
	String tab , String tab , String tab , 'kernelAt:' , String tab , '''Conv2dBiasGradient''' , String cr ,
	String tab , String tab , String tab , 'parameterTypes:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , 'weightGradientKernel :=' , String cr ,
	String tab , String tab , 'cl' , String cr ,
	String tab , String tab , String tab , 'kernelAt:' , String tab , '''Conv2dWeightGradient''' , String cr ,
	String tab , String tab , String tab , 'parameterTypes:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType sint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType sint' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , 'inputGradientKernel :=' , String cr ,
	String tab , String tab , 'cl' , String cr ,
	String tab , String tab , String tab , 'kernelAt:' , String tab , '''Conv2dInputGradient''' , String cr ,
	String tab , String tab , String tab , 'parameterTypes:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType pointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType uint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType sint.' , String cr ,
	String tab , String tab , String tab , String tab , 'TFBasicType sint' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , '^' , String cr ,
	String tab , '[' , String cr ,
	String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , 'enqueueKernelAndWait:' , String tab , 'biasGradientKernel' , String cr ,
	String tab , String tab , String tab , 'forNDRange:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'outChannels' , String cr ,
	String tab , String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , 'withArguments:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'gradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'biasGradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'outChannels.' , String cr ,
	String tab , String tab , String tab , String tab , 'outRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'outColumns' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , 'enqueueKernelAndWait:' , String tab , 'weightGradientKernel' , String cr ,
	String tab , String tab , String tab , 'forNDRange:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'outChannels.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'inChannels' , String cr ,
	String tab , String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , 'withArguments:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'inputBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'gradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'weightGradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'inChannels.' , String cr ,
	String tab , String tab , String tab , String tab , 'inRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'inColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'outChannels.' , String cr ,
	String tab , String tab , String tab , String tab , 'outRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'outColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'kernelRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'kernelColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'window stride rows.' , String cr ,
	String tab , String tab , String tab , String tab , 'window stride columns.' , String cr ,
	String tab , String tab , String tab , String tab , 'window padding top.' , String cr ,
	String tab , String tab , String tab , String tab , 'window padding left' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , 'enqueueKernelAndWait:' , String tab , 'inputGradientKernel' , String cr ,
	String tab , String tab , String tab , 'forNDRange:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'inChannels.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'inRows.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'inColumns' , String cr ,
	String tab , String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , 'withArguments:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'weightsBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'gradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'inputGradientBuffer.' , String cr ,
	String tab , String tab , String tab , String tab , 'inChannels.' , String cr ,
	String tab , String tab , String tab , String tab , 'inRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'inColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'outChannels.' , String cr ,
	String tab , String tab , String tab , String tab , 'outRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'outColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'kernelRows.' , String cr ,
	String tab , String tab , String tab , String tab , 'kernelColumns.' , String cr ,
	String tab , String tab , String tab , String tab , 'window stride rows.' , String cr ,
	String tab , String tab , String tab , String tab , 'window stride columns.' , String cr ,
	String tab , String tab , String tab , String tab , 'window padding top.' , String cr ,
	String tab , String tab , String tab , String tab , 'window padding left' , String cr ,
	String tab , String tab , String tab , '}.' , String cr ,
	'' , String cr ,
	String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , String tab , 'readFrom:' , String tab , 'inputGradientBuffer' , String cr ,
	String tab , String tab , String tab , String tab , 'count:' , String tab , 'inputCount' , String cr ,
	String tab , String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float.' , String cr ,
	String tab , String tab , String tab , 'cl Layer Conv2D' , String cr ,
	String tab , String tab , String tab , String tab , 'weights:' , String cr ,
	String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'readFrom:' , String tab , 'weightGradientBuffer' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'count:' , String tab , 'weightCount' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float' , String cr ,
	String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , 'biases:' , String cr ,
	String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'queue' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'readFrom:' , String tab , 'biasGradientBuffer' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'count:' , String tab , 'outChannels' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'elementType:' , String tab , 'TFBasicType float' , String cr ,
	String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , 'window:' , String tab , 'window' , String cr ,
	String tab , String tab , '}.' , String cr ,
	String tab , ']' , String cr ,
	String tab , String tab , 'ensure:' , String cr ,
	String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , 'inputBuffer release.' , String cr ,
	String tab , String tab , String tab , 'gradientBuffer release.' , String cr ,
	String tab , String tab , String tab , 'inputGradientBuffer release.' , String cr ,
	String tab , String tab , String tab , 'biasGradientBuffer release.' , String cr ,
	String tab , String tab , String tab , 'weightGradientBuffer release.' , String cr ,
	String tab , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeFormatUnaryOrBinaryChainLinesMethodFormatsStably [
	"Large-method, self-hosting regression test: this pulls
	MessageKindFormatterToolingRudesheim class>>formatUnaryOrBinaryChainLines:indent: --
	part of this very Formatter''s own implementation -- and formats it with itself.
	Exercises thisContext-based early-return blocks, deeply nested conditionals, an
	embedded comment inside a cascade-like block, and a mix of unary/binary/keyword sends
	all in one large real method. Verifies the formatter can stably format its own source
	code without corrupting or destabilizing it: format: applied to this already-correctly-
	formatted method must reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'formatUnaryOrBinaryChainLines: aMessageNode' , String cr ,
	'indent: anIndentToolingRudesheim' , String cr ,
	String tab , '|' , String cr ,
	String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , 'steps' , String cr ,
	String tab , String tab , 'node' , String cr ,
	String tab , String tab , 'lines' , String cr ,
	String tab , String tab , 'receiverLines' , String cr ,
	String tab , String tab , 'receiverLinesAction' , String cr ,
	String tab , String tab , 'keepWalking' , String cr ,
	String tab , String tab , 'previousEnd' , String cr ,
	String tab , '|' , String cr ,
	'' , String cr ,
	String tab , 'formatter := Rudesheim Tooling Formatter.' , String cr ,
	String tab , 'steps := OrderedCollection new.' , String cr ,
	String tab , 'node := aMessageNode.' , String cr ,
	'' , String cr ,
	String tab , 'receiverLinesAction :=' , String cr ,
	String tab , '[' , String cr ,
	String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , 'formatSubexpressionLines:' , String tab , 'node' , String cr ,
	String tab , String tab , String tab , 'indent:' , String tab , 'anIndentToolingRudesheim.' , String cr ,
	String tab , '].' , String cr ,
	'' , String cr ,
	String tab , 'keepWalking := true.' , String cr ,
	String tab , '[' , String cr ,
	String tab , String tab , 'keepWalking' , String cr ,
	String tab , String tab , String tab , 'and:' , String cr ,
	String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'node' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'isKindOf:' , String tab , 'OCMessageNode' , String cr ,
	String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'and:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'node isKeyword not.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , '].' , String cr ,
	String tab , ']' , String cr ,
	String tab , String tab , 'whileTrue:' , String cr ,
	String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , 'steps' , String cr ,
	String tab , String tab , String tab , String tab , 'addFirst:' , String tab , 'node.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'continue' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'continue := thisContext.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'node receiver' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'isKindOf:' , String tab , 'OCMessageNode' , String cr ,
	String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'node receiver parentheses isEmpty' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '"The author wrote explicit parentheses around this receiver. Binary' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'messages are left-associative with equal precedence, so folding it into' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'the flat chain below would silently drop grouping the author asked for' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '(and, for a chain nested more than one level deep, can change the AST).' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'Stop walking here and format the parenthesized receiver as its own' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'subexpression instead of flattening through it."' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'receiverLinesAction :=' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatParenthesizedSubexpressionLines:' , String tab , 'node' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'indent:' , String tab , 'anIndentToolingRudesheim.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'keepWalking := false.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'node isBinary' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifTrue:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'node receiver isBinary' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'receiverLinesAction :=' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'formatParenthesizedLines:' , String tab , 'node' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'indent:' , String tab , 'anIndentToolingRudesheim.' , String cr ,
	String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'keepWalking := false.' , String cr ,
	String tab , String tab , String tab , '] value.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , 'node := node receiver.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , 'receiverLines := receiverLinesAction value.' , String cr ,
	String tab , 'lines := OrderedCollection new.' , String cr ,
	'' , String cr ,
	String tab , 'lines' , String cr ,
	String tab , String tab , 'addAll:' , String tab , 'receiverLines.' , String cr ,
	'' , String cr ,
	String tab , 'previousEnd := node sourceInterval last.' , String cr ,
	'' , String cr ,
	String tab , 'steps' , String cr ,
	String tab , String tab , 'do:' , String cr ,
	String tab , String tab , '[ :step |' , String cr ,
	String tab , String tab , String tab , '|' , String cr ,
	String tab , String tab , String tab , String tab , 'stepText' , String cr ,
	String tab , String tab , String tab , String tab , 'argument' , String cr ,
	String tab , String tab , String tab , String tab , 'stepAction' , String cr ,
	String tab , String tab , String tab , String tab , 'commentLines' , String cr ,
	String tab , String tab , String tab , String tab , 'appendStepTextAction' , String cr ,
	String tab , String tab , String tab , '|' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , 'commentLines :=' , String cr ,
	String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'formatCommentLinesInSource:' , String tab , 'aMessageNode source' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'from:' , String tab , 'previousEnd + 1' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'to:' , String tab , 'step selectorInterval first - 1' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'indent:' , String tab , 'anIndentToolingRudesheim oneLevelDeeper.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , 'appendStepTextAction :=' , String cr ,
	String tab , String tab , String tab , '[ :aStepTextString |' , String cr ,
	String tab , String tab , String tab , String tab , 'commentLines' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifEmpty:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'lines' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , 'lines size' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'put:' , String tab , 'lines last , '' '' , aStepTextString.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , ']' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifNotEmpty:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '"A comment sat between the previous content and this step -- e.g. `self' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '""comment"" foo` -- so this step can no longer simply be fused onto the' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'previous line; formatUnaryOrBinaryChainLines: never looked for such a' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'comment at all before, silently dropping it (comments aren''t real' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'nodes, so nothing in the receiver/argument structure this method' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'reconstructs from ever reflected it). Indented one level deeper than' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'the receiver, the same as any other place a keyword part or multiline' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'argument continues past the receiver''s own line."' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'lines' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'addAll:' , String tab , 'commentLines.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'lines' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'add:' , String tab , 'anIndentToolingRudesheim oneLevelDeeper asString , aStepTextString.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , 'stepAction :=' , String cr ,
	String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , 'stepText := step selector asString.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'step isBinary' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifTrue:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'stepText :=' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'step selector asString , '' '' ,' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatInline:' , String tab , 'step arguments first' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , ').' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'appendStepTextAction' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'value:' , String tab , 'stepText.' , String cr ,
	String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'continue' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'continue := thisContext.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'step isBinary' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'argument := step arguments first.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'needsMultilineFor:' , String tab , 'argument' , String cr ,
	String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'continue return.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'stepAction :=' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'appendStepTextAction' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'value:' , String tab , 'step selector asString.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'lines' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'addAll:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatter' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'formatMultilineBinaryArgumentLines:' , String tab , 'argument' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'indent:' , String tab , 'anIndentToolingRudesheim' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , ').' , String cr ,
	String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , '] value.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , 'stepAction value.' , String cr ,
	String tab , String tab , String tab , 'previousEnd := step sourceInterval last.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , '^ lines.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeTableKeyAccessorsMethodFormatsStably [
	"Large-method regression test, pulled from a real production method:
	Table-Query-Rudesheim-Pharo''s EqualityIntersectionPlanInMemoryBackendTableQueryRudesheim>>
	tableKeyAccessorsFrom: -- part of the in-memory query planner. Exercises nested blocks
	over collections, keyword messages with block arguments, and conditional guard clauses
	in one real method body. Verifies the formatter handles a real, multi-construct method
	without corrupting or destabilizing it: format: applied to this already-correctly-
	formatted method must reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'tableKeyAccessorsFrom: anExpressionTableQueryRudesheim' , String cr ,
	String tab , '|' , String cr ,
	String tab , String tab , 'equalities' , String cr ,
	String tab , String tab , 'keyAccessorsByTable' , String cr ,
	String tab , String tab , 'indexes' , String cr ,
	String tab , '|' , String cr ,
	'' , String cr ,
	String tab , 'equalities := OrderedCollection new.' , String cr ,
	'' , String cr ,
	String tab , 'anExpressionTableQueryRudesheim' , String cr ,
	String tab , String tab , 'collectWholeRowEqualitiesRudesheim:' , String tab , 'equalities' , String cr ,
	String tab , String tab , 'forPlan:' , String tab , 'self.' , String cr ,
	'' , String cr ,
	String tab , 'keyAccessorsByTable := Dictionary new.' , String cr ,
	'' , String cr ,
	String tab , 'equalities' , String cr ,
	String tab , String tab , 'do:' , String cr ,
	String tab , String tab , '[ :eachEquality |' , String cr ,
	String tab , String tab , String tab , 'eachEquality' , String cr ,
	String tab , String tab , String tab , String tab , 'do:' , String cr ,
	String tab , String tab , String tab , String tab , '[ :eachOperand |' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '|' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'tableIndex' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'keyAccessor' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '|' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'tableIndex := eachOperand tableIndex.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'keyAccessor := eachOperand keyAccessorPath.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'keyAccessorsByTable' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , 'tableIndex' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'ifPresent:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '[ :existingAccessor |' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'existingAccessor isEmpty' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'or:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'keyAccessor isEmpty' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'or:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'existingAccessor = keyAccessor.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , ']' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , ')' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'ifFalse:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'self' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'error:' , String tab , '''unsupported predicate''.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'existingAccessor' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'ifEmpty:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'keyAccessorsByTable' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , 'tableIndex' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'put:' , String tab , 'keyAccessor.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , ']' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'ifAbsentPut:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'keyAccessor.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , String tab , String tab , '].' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , 'indexes := keyAccessorsByTable keys asOrderedCollection.' , String cr ,
	'' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'requireConnectedIndexes:' , String tab , 'indexes' , String cr ,
	String tab , String tab , 'by:' , String cr ,
	String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , 'equalities' , String cr ,
	String tab , String tab , String tab , String tab , 'collect:' , String cr ,
	String tab , String tab , String tab , String tab , '[ :eachEquality |' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'eachEquality' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'collect:' , String tab , '#tableIndex.' , String cr ,
	String tab , String tab , String tab , String tab , ']' , String cr ,
	String tab , String tab , ').' , String cr ,
	'' , String cr ,
	String tab , '^ self' , String cr ,
	String tab , String tab , 'normalizeKeyAccessors:' , String tab , 'keyAccessorsByTable.'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]

{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeEnqueueKernelForWaitMethodFormatsStably [
	"Large-method regression test, pulled from a real production method:
	OpenCL-Rudesheim-Pharo''s CommandQueueOpenCLRudesheim>>enqueueKernel:forNDRange:
	withArguments:forWait: -- a 4-keyword-part method pattern (matching
	defaultSourceString/defaultTargetString''s 2-keyword-part precedent, but with more
	parts), whose body mixes dynamic arrays, nested blocks, an on:do: exception handler,
	and deeply nested keyword sends over native buffers. Verifies the formatter handles a
	large, real, multi-construct method without corrupting or destabilizing it: format:
	applied to this already-correctly-formatted method must reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'enqueueKernel: aCLKernel' , String cr ,
	'forNDRange: aNDRange' , String cr ,
	'withArguments: aCLBufferSequencialCollections' , String cr ,
	'forWait: anEventForWaitCollection' , String cr ,
	String tab , '|' , String cr ,
	String tab , String tab , 'cl' , String cr ,
	String tab , String tab , 'functions' , String cr ,
	String tab , String tab , 'ndRangePointes' , String cr ,
	String tab , String tab , 'sizeT' , String cr ,
	String tab , '|' , String cr ,
	'' , String cr ,
	String tab , '0 >= aNDRange size' , String cr ,
	String tab , String tab , 'ifTrue:' , String cr ,
	String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , '^ self.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , 'cl := Rudesheim OpenCL.' , String cr ,
	String tab , 'functions := cl Native Functions.' , String cr ,
	String tab , 'sizeT := TFBasicType sizeT.' , String cr ,
	'' , String cr ,
	String tab , 'aCLBufferSequencialCollections' , String cr ,
	String tab , String tab , 'withIndexDo:' , String cr ,
	String tab , String tab , '[ :each :index |' , String cr ,
	String tab , String tab , String tab , 'aCLKernel' , String cr ,
	String tab , String tab , String tab , String tab , 'at:' , String tab , 'index' , String cr ,
	String tab , String tab , String tab , String tab , 'put:' , String tab , 'each.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , 'sizeT := TFBasicType sizeT.' , String cr ,
	'' , String cr ,
	String tab , 'ndRangePointes :=' , String cr ,
	String tab , '(' , String cr ,
	String tab , String tab , '1' , String cr ,
	String tab , String tab , String tab , 'to:' , String tab , '3' , String cr ,
	String tab , ')' , String cr ,
	String tab , String tab , 'collect:' , String cr ,
	String tab , String tab , '[ :each |' , String cr ,
	String tab , String tab , String tab , 'ExternalAddress null.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , '(' , String cr ,
	String tab , String tab , 'aNDRange' , String cr ,
	String tab , String tab , String tab , 'collect:' , String cr ,
	String tab , String tab , String tab , '[ :each0 |' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'sizes' , String cr ,
	String tab , String tab , String tab , String tab , '|' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'sizes :=' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'ExternalAddress' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'gcallocate:' , String tab , '3 * sizeT byteSize.' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'each0' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'withIndexDo:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '[ :each1 :index |' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'sizes' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'uint64AtOffset:' , String tab , '( index - 1 ) * sizeT byteSize' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , String tab , 'put:' , String tab , 'each1.' , String cr ,
	String tab , String tab , String tab , String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , String tab , String tab , String tab , 'sizes.' , String cr ,
	String tab , String tab , String tab , ']' , String cr ,
	String tab , ')' , String cr ,
	String tab , String tab , 'withIndexDo:' , String cr ,
	String tab , String tab , '[ :each :index |' , String cr ,
	String tab , String tab , String tab , 'ndRangePointes' , String cr ,
	String tab , String tab , String tab , String tab , 'at:' , String tab , 'index' , String cr ,
	String tab , String tab , String tab , String tab , 'put:' , String tab , 'each tfPointerAddress.' , String cr ,
	String tab , String tab , '].' , String cr ,
	'' , String cr ,
	String tab , '^' , String cr ,
	String tab , '[' , String cr ,
	String tab , String tab , 'cl Event' , String cr ,
	String tab , String tab , String tab , 'newFromFunctionForEnqueue:' , String tab , 'functions functionOfEnqueueNDRangeKernel' , String cr ,
	String tab , String tab , String tab , 'withArguments:' , String cr ,
	String tab , String tab , String tab , '{' , String cr ,
	String tab , String tab , String tab , String tab , 'aCLKernel handlePointer.' , String cr ,
	String tab , String tab , String tab , String tab , 'aNDRange first size.' , String cr ,
	String tab , String tab , String tab , String tab , 'ndRangePointes' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , '3.' , String cr ,
	String tab , String tab , String tab , String tab , 'ndRangePointes' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , '1.' , String cr ,
	String tab , String tab , String tab , String tab , 'ndRangePointes' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'at:' , String tab , '2' , String cr ,
	String tab , String tab , String tab , '}' , String cr ,
	String tab , String tab , String tab , 'forWait:' , String tab , 'anEventForWaitCollection' , String cr ,
	String tab , String tab , String tab , 'on:' , String tab , 'self' , String cr ,
	String tab , String tab , String tab , 'by:' , String tab , 'self tfRunner.' , String cr ,
	String tab , ']' , String cr ,
	String tab , String tab , 'on:' , String tab , 'PrimitiveErrorNativeOpenCLRudesheim' , String cr ,
	String tab , String tab , 'do:' , String cr ,
	String tab , String tab , '[ :anError |' , String cr ,
	String tab , String tab , String tab , 'Rudesheim OpenCL Native Error EnqueueKernelFailed' , String cr ,
	String tab , String tab , String tab , String tab , 'signalForCause:' , String tab , 'anError' , String cr ,
	String tab , String tab , String tab , String tab , 'commandQueue:' , String tab , 'self' , String cr ,
	String tab , String tab , String tab , String tab , 'kernel:' , String tab , 'aCLKernel' , String cr ,
	String tab , String tab , String tab , String tab , 'ndRange:' , String tab , 'aNDRange.' , String cr ,
	String tab , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]
{ #category : 'tests' }
FormatterToolingRudesheimTest >> testLargeBaselineSpecWithPragmaFormatsStably [
	"Large-method regression test, pulled from a real production method:
	NeuralNetwork-Rudesheim-Pharo''s BaselineOfRudesheimNeuralNetwork>>baseline: -- another
	genuine Metacello baseline specification, distinct from
	testLargeBaselineSpecCascadeFormatsStably''s Table-Query one. Across all 8
	*-Rudesheim-Pharo repositories, the baseline pragma is the only pragma that appears in
	any real (non-test-fixture) method -- every baseline: spec method carries it -- so this
	is included specifically to keep a pragma-bearing method among the large golden
	fixtures, on top of the small, focused testPragmaWith*/testPragmaWithout* unit tests
	above. Verifies the formatter handles a real, pragma-bearing method without corrupting
	or destabilizing it: format: applied to this already-correctly-formatted method must
	reproduce it exactly."
	|
		formatted
		expected
	|

	expected :=
	'baseline: spec' , String cr ,
	String tab , '<baseline>' , String cr ,
	'' , String cr ,
	String tab , 'spec' , String cr ,
	String tab , String tab , 'for:' , String tab , '#common' , String cr ,
	String tab , String tab , 'do:' , String cr ,
	String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''RudesheimUtility''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://devid-rudesheim/Utility-Rudesheim-Pharo:develop''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'project:' , String tab , '''RudesheimUtilityTests''' , String cr ,
	String tab , String tab , String tab , String tab , 'copyFrom:' , String tab , '''RudesheimUtility''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'loads:' , String tab , '#( ''tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''RudesheimKernel''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''RudesheimOpenCL''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://devid-rudesheim/OpenCL-Rudesheim-Pharo:develop''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''Soil''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://ApptiveGrid/Soil:v5/src''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'project:' , String tab , '''SoilCore''' , String cr ,
	String tab , String tab , String tab , String tab , 'copyFrom:' , String tab , '''Soil''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'loads:' , String tab , '#( ''Soil-Core'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'baseline:' , String tab , '''OSSubprocess''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'repository:' , String tab , '''github://pharo-contributions/OSSubprocess:master/repository''.' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''RudesheimUtility'' ''RudesheimKernel'' ''SoilCore'' ''OSSubprocess'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-ONNX''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-OpenCL-Private''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork-Private'' ''RudesheimOpenCL'' ''RudesheimKernel'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-ONNX-OpenCL''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork-ONNX'' ''Rudesheim-NeuralNetwork-OpenCL-Private'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-Private-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork'' ''Rudesheim-NeuralNetwork-ONNX'' ''RudesheimUtilityTests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-OpenCL-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork-OpenCL-Private'' ''Rudesheim-NeuralNetwork-ONNX-OpenCL'' ''Rudesheim-NeuralNetwork-Private-Tests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'package:' , String tab , '''Rudesheim-NeuralNetwork-Tests''' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String cr ,
	String tab , String tab , String tab , String tab , '[' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'spec' , String cr ,
	String tab , String tab , String tab , String tab , String tab , String tab , 'requires:' , String tab , '#( ''Rudesheim-NeuralNetwork'' ''RudesheimUtilityTests'' ).' , String cr ,
	String tab , String tab , String tab , String tab , '];' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#core' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-Private'' ''Rudesheim-NeuralNetwork'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#onnx' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-ONNX'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#opencl' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-OpenCL-Private'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#onnxOpenCL' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-ONNX-OpenCL'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#tests' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-Private-Tests'' ''Rudesheim-NeuralNetwork-Tests'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#openclTests' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( ''Rudesheim-NeuralNetwork-OpenCL-Tests'' );' , String cr ,
	String tab , String tab , String tab , String tab , 'group:' , String tab , '#default' , String cr ,
	String tab , String tab , String tab , String tab , 'with:' , String tab , '#( #core ).' , String cr ,
	String tab , String tab , '].'.

	formatted :=
		self targetClass
			format:	expected.

	self
		assert:	formatted
		equals:	expected.
]
{ #category : 'tests' }
FormatterToolingRudesheimTest >> testKeywordArgumentsInStatementAndCascadeCollapseWhenHandWrittenMultiline [
	"Regression test for a real-world case pulled from Kernel-Rudesheim-Pharo:
	BasicColumnRudesheimTest>>read: (`self basicTarget evaluationForRead value: self
	sourceValue asValueHolder.`) and RudesheimTest>>testMembers''s cascade (`self assert:
	root Column Basic equals: BasicColumnRudesheim; assert: root Column ForDateAndTime
	equals: ColumnForDateAndTimeRudesheim.`) both had a keyword message argument hand-typed
	on its own line directly below the keyword, with the argument itself -- a plain unary
	chain -- written on a single line (unlike
	testKeywordArgumentUnaryChainWithHandWrittenLineBreaksCollapsesInline''s case, where the
	chain itself is *also* hand-typed across several lines). Because the hand-written break
	here sits between the keyword and the argument''s own source span rather than inside it,
	formatKeywordPart:argument:indent: already collapsed this particular shape correctly even
	before that fix; this test does not exercise it. Kept anyway as real-world coverage for a
	bare keyword send and a cascade of keyword sends collapsing together in one method."
	|
		formatted
		input
		expected
	|

	input :=
	'sample' , String cr ,
	String tab , String tab , String tab , 'self basicTarget evaluationForRead' , String cr ,
	String tab , String tab , String tab , String tab , 'value:' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'self sourceValue asValueHolder.' , String cr ,
	'' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String cr ,
	String tab , String tab , String tab , 'root Column Basic' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'BasicColumnRudesheim;' , String cr ,
	String tab , String tab , 'assert:' , String cr ,
	String tab , String tab , String tab , 'root Column ForDateAndTime' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'ColumnForDateAndTimeRudesheim.'.

	expected :=
	'sample' , String cr ,
	String tab , 'self basicTarget evaluationForRead' , String cr ,
	String tab , String tab , 'value:' , String tab , 'self sourceValue asValueHolder.' , String cr ,
	'' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String tab , 'root Column Basic' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'BasicColumnRudesheim;' , String cr ,
	String tab , String tab , 'assert:' , String tab , 'root Column ForDateAndTime' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'ColumnForDateAndTimeRudesheim.'.

	formatted :=
		self targetClass
			format:	input.

	self
		assert:	formatted
		equals:	expected.
]
{ #category : 'tests' }
FormatterToolingRudesheimTest >> testParenthesizedKeywordSendWithHandWrittenMultilineReceiverAndArgumentCollapses [
	"Regression test for a real-world case pulled from Kernel-Rudesheim-Pharo''s
	BasicColumnRudesheimTest: two assert:equals: statements each wrapping a parenthesized
	keyword send (`self basicTarget evaluationForRead value: self sourceValue
	asValueHolder` and `self basicTarget read: self sourceValue asValueHolder`), where the
	receiver''s own unary chain AND the keyword''s argument (also a unary chain) were both
	hand-typed one selector per line. Unlike
	testKeywordArgumentsInStatementAndCascadeCollapseWhenHandWrittenMultiline''s snippet
	(where the hand-written break sits only *between* the keyword and its argument''s own
	span), here the argument''s OWN internal sends (self / sourceValue / asValueHolder) are
	each on their own line -- the exact shape
	testKeywordArgumentUnaryChainWithHandWrittenLineBreaksCollapsesInline covers in
	isolation, and #28 fixed. Confirmed this genuinely depends on that fix: run against
	develop before #28, both keyword arguments stayed split onto their own line instead of
	collapsing."
	|
		formatted
		input
		expected
	|

	input :=
	'sample' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String tab , String cr ,
	String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , 'self' , String cr ,
	String tab , String tab , String tab , String tab , 'basicTarget' , String cr ,
	String tab , String tab , String tab , String tab , 'evaluationForRead' , String cr ,
	String tab , String tab , String tab , String tab , 'value:' , String tab , String cr ,
	String tab , String tab , String tab , String tab , 'self' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'sourceValue' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'asValueHolder' , String cr ,
	String tab , String tab , ')' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'self expectedValue.' , String cr ,
	'' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String tab , String cr ,
	String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , 'self basicTarget' , String cr ,
	String tab , String tab , String tab , String tab , 'read:' , String tab , String cr ,
	String tab , String tab , String tab , String tab , 'self' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'sourceValue' , String cr ,
	String tab , String tab , String tab , String tab , String tab , 'asValueHolder' , String cr ,
	String tab , String tab , ')' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'self expectedValue.'.

	expected :=
	'sample' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String cr ,
	String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , 'self basicTarget evaluationForRead' , String cr ,
	String tab , String tab , String tab , String tab , 'value:' , String tab , 'self sourceValue asValueHolder' , String cr ,
	String tab , String tab , ')' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'self expectedValue.' , String cr ,
	'' , String cr ,
	String tab , 'self' , String cr ,
	String tab , String tab , 'assert:' , String cr ,
	String tab , String tab , '(' , String cr ,
	String tab , String tab , String tab , 'self basicTarget' , String cr ,
	String tab , String tab , String tab , String tab , 'read:' , String tab , 'self sourceValue asValueHolder' , String cr ,
	String tab , String tab , ')' , String cr ,
	String tab , String tab , 'equals:' , String tab , 'self expectedValue.'.

	formatted :=
		self targetClass
			format:	input.

	self
		assert:	formatted
		equals:	expected.
]
