# Rudesheim Tooling for Pharo

[![GitHub release](https://img.shields.io/github/release/devid-rudesheim/Tooling-Rudesheim-Pharo.svg)](https://github.com/devid-rudesheim/Tooling-Rudesheim-Pharo/releases/latest)
[![Unit Tests](https://github.com/devid-rudesheim/Tooling-Rudesheim-Pharo/actions/workflows/tests.yml/badge.svg)](https://github.com/devid-rudesheim/Tooling-Rudesheim-Pharo/actions/workflows/tests.yml)

[![Pharo 13](https://img.shields.io/badge/Pharo-13-informational)](https://pharo.org)

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
