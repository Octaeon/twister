//// Tiny module containing utility helper functions.
//// 
//// Unless you have a specific use case and no better (already existing) way to solve it,
//// you should prefer other libraries or even your own code.
//// 

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

/// Get the element at specified index in the provided `List`, using 0-indexing
/// (element at index 0 is the first element)
/// 
/// If the index given is equal to or larger than the length of the `List`, return `Error(Nil)`.
/// 
/// If the index is less than zero, return `Error(Nil)`.
/// 
/// Otherwise return `Ok(a)` - the element at the given index.
/// 
/// ## Note
/// This function runs in `O(n)` where `n` is the index. This is due to the fact that Gleam
/// `List`s are linked-lists, not arrays, so to find a given index it's necessary to traverse
/// the `List` until encountering it.
/// 
pub fn at(in: List(a), index index: Int) -> Result(a, Nil) {
  let len = list.length(in)
  case index < len, index >= 0 {
    True, True -> at_loop(in, index)
    _, _ -> Error(Nil)
  }
}

fn at_loop(in: List(a), index: Int) -> Result(a, Nil) {
  case index, in {
    remaining, _ if remaining < 0 -> Error(Nil)
    _, [] -> Error(Nil)
    0, [head, ..] -> Ok(head)
    remaining, [_, ..rest] -> at(rest, remaining - 1)
  }
}

/// Given a `List` of `Int`s, find the largest element.
/// 
/// If the `List` is empty, return `None`.
/// 
/// ## Note
/// This function runs in `O(n)`, where `n` is the length of the list.
/// 
pub fn largest(indexes: List(Int)) -> Option(Int) {
  case indexes {
    [] -> None
    [first, ..rest] -> Some(largest_loop(rest, first))
  }
}

fn largest_loop(over: List(Int), max: Int) -> Int {
  case over {
    [] -> max
    [head, ..rest] -> largest_loop(rest, int.max(head, max))
  }
}
