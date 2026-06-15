# twister

[![Package Version](https://img.shields.io/hexpm/v/twister)](https://hex.pm/packages/twister)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/twister/)

Twister is a simple, minimal Gleam library for working with permutations.
While writing `mesv`, I found myself needing a way to incrementally build permutations to later execute, while guaranteeing runtime safety and with a relatively simple API.

I created a type for it and a few functions, but ultimately decided it would be better to split off the code into another package, which is this one.

It is a minimal library that only does a few things, but I hope it can be useful to someone other than me.

## Installation

```sh
gleam add twister@1
```

## Examples
Simplest way to create and use a permutation is to create it from a list and run it on an arbitrary `List`.
```gleam
import twister

pub fn main() -> Nil {
  // Create a `Permutation` from a `List` of indices
  let perm = twister.from_list([1, 4, 2, 0, 3, 5])

  // Run it on the given `List` of arbitrary elements
  let result = twister.run(perm, [0, 1, 2, 3, 4, 5])

  // If the given `List` is longer than the biggest index
  // inside the `Permutation`, it will succeed.
  assert result == Ok([1, 4, 2, 0, 3, 5])
}
```

For more, look at the singular module of the documentation on [HexDocs](https://hexdocs.pm/twister/twister.html).
