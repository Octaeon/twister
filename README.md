# weaver

[![Package Version](https://img.shields.io/hexpm/v/weaver)](https://hex.pm/packages/weaver)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/weaver/)

Weaver is a simple library for working with permutations.
While writing `mesv`, I found myself needing a way to incrementally build permutations to later execute, while guaranteeing runtime safety and with a relatively simple API.

I created a type for it and a few functions, but ultimately decided it would be better to split off the code into another package, which is this one.

It is a minimal library that only does a few things, but I hope it can be useful to someone other than me.

## Installation

```sh
gleam add weaver@1
```
