"
Represents an indent level for FormatterToolingRudesheim's line-based formatting methods.
"
Class {
	#name : 'IndentToolingRudesheim',
	#superclass : 'Object',
	#instVars : [ 'indent' ],
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'instance creation' }
IndentToolingRudesheim class >> level: anInteger [
	|
		instance
	|

	anInteger isNumber
		ifFalse:
		[
			self error: 'anInteger must be a number'.
		].

	instance := self new.

	instance
		indent:	anInteger max: 0.

	^ instance.
]

{ #category : 'accessing' }
IndentToolingRudesheim >> indent [
	^ indent.
]

{ #category : 'accessing' }
IndentToolingRudesheim >> indent: anInteger [
	indent := anInteger.
]

{ #category : 'converting' }
IndentToolingRudesheim >> asString [
	0 = self indent
		ifTrue:
		[
			^ ''.
		].

	^ String
		new:	self indent
		withAll:	Character tab.
]

{ #category : 'operations' }
IndentToolingRudesheim >> oneLevelDeeper [
	^ self class
		level:	1 + self indent.
]
