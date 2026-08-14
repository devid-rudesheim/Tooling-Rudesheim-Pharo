# Rudesheim Tooling for Pharo

Rudesheim Tooling is an AST-based Smalltalk source formatter (`FormatterToolingRudesheim`, an
`OCAbstractFormatter` compatible entry point) along with a small set of `OpenCompiler` AST node
and `ClassDescription` extensions used to support it.

## Installation

Load the default project group with Metacello:

```smalltalk
Metacello new
	baseline: 'RudesheimTooling';
	repository: 'github://devid-rudesheim/Tooling-Rudesheim-Pharo:main';
	load
```

This also loads the required `RudesheimKernel` and `RudesheimUtility` dependencies from GitHub.

## Usage

The formatter is reached through the `Rudesheim` root namespace:

```smalltalk
Rudesheim Tooling Formatter formatString: 'foo ^ 1 + 2'
```

`Rudesheim Tooling Formatter` resolves to the `FormatterToolingRudesheim` class.
