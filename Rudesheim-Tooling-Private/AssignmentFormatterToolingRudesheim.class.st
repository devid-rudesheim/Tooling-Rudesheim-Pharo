"
Formats OCAssignmentNode lines for FormatterToolingRudesheim.
"
Class {
	#name : 'AssignmentFormatterToolingRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'formatting' }
AssignmentFormatterToolingRudesheim class >> assignmentPrefixForVariables: aVariableCollection [

	^ String
		streamContents:
		[ :writer |
			aVariableCollection
				doWithIndex:
				[ :value :index |
					1 < index
						ifTrue:
						[
							writer
								nextPutAll:	' := '.
						].

					writer
						nextPutAll:	value name.
				].

			writer
				nextPutAll:	' :='.
		].
]

{ #category : 'formatting' }
AssignmentFormatterToolingRudesheim class >> formatAssignmentLines: anAssignmentNode
indent: anIndentToolingRudesheim [
	|
		formatter
		vars
		value
		prefix
		inline
		lines
		valueLines
		firstValueLine
	|

	formatter := Rudesheim Tooling Formatter.
	vars := OrderedCollection new.
	value := anAssignmentNode.
	[
		value isAssignment.
	]
		whileTrue:
		[
			vars
				add:	value variable.

			value := value value.
		].

	prefix :=
		self
			assignmentPrefixForVariables:	vars.

	(
		value
			needsExpressionLinesAsAssignmentValueForFormatterRudesheim:	formatter
	)
		ifFalse:
		[
			inline :=
				formatter
					formatInline:	value.

			^
			{
				anIndentToolingRudesheim asString , prefix , ' ' , inline
			}.
		].

	lines := OrderedCollection new.

	lines
		add:
		anIndentToolingRudesheim asString , prefix.

	valueLines :=
		formatter
			formatExpressionLines:	value
			indent:	anIndentToolingRudesheim oneLevelDeeper.

	firstValueLine := valueLines first trimBoth.

	firstValueLine
		ifNotEmpty:
		[
			(
				formatter
					isOpeningBracketCharacter:	firstValueLine first
			)
				ifTrue:
				[
					valueLines :=
						formatter
							formatExpressionLines:	value
							indent:	anIndentToolingRudesheim.
				].
		].

	lines
		addAll:	valueLines.

	^ lines.
]
