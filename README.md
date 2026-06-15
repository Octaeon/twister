# twister

[![Package Version](https://img.shields.io/hexpm/v/twister)](https://hex.pm/packages/twister)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/twister/)

Twister is a simple, minimal Gleam library for working with permutations.

While writing [`mesv`](https://github.com/Octaeon/mesv), I found myself needing a way to incrementally build permutations to later execute. So, I wrote some code for it, without much thought.

However, I ultimately decided it would be better to split off the code into another package, which is this one.

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
  let permutation =
    twister.from_list([1, 4, 2, 0, 3, 5])

  // Run it on the given `List` of arbitrary elements
  let result =
    twister.run(permutation, [0, 1, 2, 3, 4, 5])

  // If the given `List` is longer than the biggest index
  // inside the `Permutation`, it will succeed.
  assert result == Ok([1, 4, 2, 0, 3, 5])
}
```

For more, look at the main module of the documentation on [HexDocs](https://hexdocs.pm/twister/twister.html).

## Performance
Here, I need to give a disclaimer - this library does not have good performance.

Most optimistically, it has a time complexity of `O(n*m)`, where `n` is the length of the list of indices, and `m` is the length of the input (or more accurately, the largest index in the `Permutation`).

This is because the function to get an element at a specific index from a `List` runs in `O(n)` time, where `n` is that index; and that is because `List`s in Gleam are linked lists, not contiguous arrays.

I am certain there are ways to make this library faster, both using pure Gleam and by using external libraries, but since my use case is for `Permutation`s of lengths less than 10 on `List`s of at most 100, performance isn't my biggest concern.

Nevertheless, if I am given suggestions on how to improve performance and some theoretical foundation for them (ie, alternative ways to represent a `Permutation` as a data type, specific algorithms to optimize element retrieval, or libraries I could use in place of standard Gleam), I would be happy to try and implement them.

## Note
Lastly, you might notice that internally, the list of indices is stored in reverse order.

This is because Gleam only supports `List` matching on `[head, ..rest]`, not the opposite. Furthermore, when executing a `Permutation`, the recursive function outputs the permuted `List` in reverse order once again.

As such, it's easier to simply store the indices back to front instead of calling `list.append` to add an element to the end of the indices when building, then reversing the output after running a `Permutation` on some `List`.
