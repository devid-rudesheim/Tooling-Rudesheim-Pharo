"
Character category for assignment token.
"
Class {
	#name : 'AssignmentCharacterKindFormatterToolingRudesheim',
	#superclass : 'CharacterKindFormatterToolingRudesheim',
	#category : 'Rudesheim-Tooling-Private',
	#package : 'Rudesheim-Tooling-Private'
}

{ #category : 'accessing' }
AssignmentCharacterKindFormatterToolingRudesheim class >> assignmentFirstCharacter [
	^ $:.
]

{ #category : 'accessing' }
AssignmentCharacterKindFormatterToolingRudesheim class >> assignmentSecondCharacter [
	^ $=.
]

{ #category : 'testing' }
AssignmentCharacterKindFormatterToolingRudesheim class >> isAssignmentStartCharacter: aCharacter
followedBy: anotherCharacter [
	aCharacter = self assignmentFirstCharacter
		ifFalse:
		[
			^ false.
		].

	^ anotherCharacter = self assignmentSecondCharacter.
]

{ #category : 'testing' }
AssignmentCharacterKindFormatterToolingRudesheim class >> match: aCharacter [
	^ aCharacter = self assignmentSecondCharacter.
]
