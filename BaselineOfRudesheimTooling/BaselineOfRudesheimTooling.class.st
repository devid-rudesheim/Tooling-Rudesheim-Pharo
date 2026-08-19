Class {
	#name : 'BaselineOfRudesheimTooling',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRudesheimTooling',
	#package : 'BaselineOfRudesheimTooling'
}

{ #category : 'baselines' }
BaselineOfRudesheimTooling >> baseline: spec [
	<baseline>

	spec
		for: #common
		do:
		[
			spec
				baseline: 'RudesheimKernel'
				with: [ spec repository: 'github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop' ];

				baseline: 'RudesheimUtility'
				with: [ spec repository: 'github://devid-rudesheim/Utility-Rudesheim-Pharo:develop' ];

				project: 'RudesheimUtilityTests'
				copyFrom: 'RudesheimUtility'
				with: [ spec loads: #( 'tests' ) ];

				package: 'Rudesheim-Tooling-Private';

				package: 'Rudesheim-Tooling'
				with:
				[
					spec
						requires: #( 'RudesheimKernel' 'RudesheimUtility' 'Rudesheim-Tooling-Private' )
				];

				package: 'Rudesheim-Tooling-Private-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-Tooling' 'RudesheimUtilityTests' )
				];

				package: 'Rudesheim-Tooling-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-Tooling' 'RudesheimUtilityTests' )
				];

				group:		#core
				with:		#( 'Rudesheim-Tooling-Private' 'Rudesheim-Tooling' );

				group:		#tests
				with:		#( 'Rudesheim-Tooling-Private-Tests' 'Rudesheim-Tooling-Tests' );

				group:		#default
				with:		#( #core ).
		]
]
