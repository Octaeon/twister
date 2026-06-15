//// The main module of `weaver`, containing basically all of the relevant API.
//// 
//// ## Introduction
//// To use this library, you first need to create a [`Permutation`](weaver.html#Permutation), using one of the provided methods:
//// 1. Create it from a `List` of indexes directly, using the [`from_list`](weaver.html#from_list) function
//// 2. Create it using a builder pattern by first initializing it with [`blank`](weaver.html#blank), then adding indexes to the end one by one with [`add`](weaver.html#add).
//// 
//// ### Examples
//// ```gleam
//// // TODO
//// ```
//// 
//// Afterwards
//// 

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import weaver/util

// ==== Types ====

/// Type encoding a permutation.
/// 
/// To create, prefer using the initialization function [`from_list`](weaver.html#from_list) or the builder functions - first [`blank`](weaver.html#blank), then [`add`](weaver.html#add).
/// 
/// To run a permutation *on* a given `List`, use the [`run`](weaver.html#run) or [`run_default`](weaver.html#run_default) functions.
/// 
/// To learn more, look at he documentation for the functions in question.
/// 
/// ## Note
/// Although the type is not `opaque`, you shouldn't modify it yourself unless you really need to, and there's no other way to achieve your goal.
/// 
pub type Permutation {
  Permutation(max_index: Option(Int), output: List(Int))
}

// ==== API Functions ====

// => Initialization

/// Create a new `Permutation` from a given list of indexes.
/// 
/// When later running a permutation *on* some `List`, that `List` must have a length more than or equal to the largest index in the list of indexes within, or it will return `Error(Nil)`.
/// 
pub fn from_list(indexes l: List(Int)) -> Permutation {
  Permutation(max_index: util.largest(l), output: list.reverse(l))
}

/// Create a new, blank `Permutation`.
/// 
/// This function is meant to be used as the starting point for constructing a `Permutation` using the builder pattern, by using the [`add`](weaver.html#add) function to add a new index at the end of the list of indexes.
/// 
pub fn blank() -> Permutation {
  Permutation(max_index: None, output: [])
}

// => Builder

/// Add an index to the end of a `Permutation`.
/// 
/// This function is meant to be used after creating a blank `Permutation` using the [`blank`](weaver.html#blank) function, but there's nothing stopping you from using it to add elements to a `Permutation` created using the [`from_list`](weaver.html#from_list) function.
/// 
/// When later running a permutation *on* some `List`, that `List` must have a length more than or equal to the largest index in the list of indexes within, or it will return `Error(Nil)`.
/// 
pub fn add(perm: Permutation, index i: Int) -> Permutation {
  let Permutation(old_max, output) = perm
  let new_max = case old_max {
    Some(prev_max) -> int.max(prev_max, i)
    None -> i
  }
  Permutation(Some(new_max), [i, ..output])
}

// => Execution

/// Run a created `Permutation` on some `List`.
/// 
/// This function returns a `Result` because there's no guarantee that the provided `List` contains enough elements to build the permuted output.
/// 
/// For example, if I have a `Permutation` like `[0, 2, 5]` and I pass in `["a", "b"]`, there simply aren't enough elements in the `List` to find the element at index 5, or even 2. So this function returns `Error(Nil)`.
/// 
/// If you wish to guarantee that a `Permutation` always returns a `List` the exact same length as the `List` of specified indexes, use the [`run_default`](weaver.html#run_default) function, and choose a default value to return when the index is out of bounds.
/// 
pub fn run(perm: Permutation, on l: List(a)) -> Result(List(a), Nil) {
  case perm, list.length(l) {
    Permutation(_, []), _ -> Ok([])
    Permutation(None, _), _ -> Error(Nil)
    Permutation(Some(max), non_empty), len if len >= max ->
      run_loop(l, non_empty, [])
    Permutation(Some(_), _), _ -> Error(Nil)
  }
}

fn run_loop(
  over: List(a),
  indexes: List(Int),
  acc: List(a),
) -> Result(List(a), Nil) {
  case indexes {
    [] -> Ok(acc)
    [index, ..rest] ->
      case util.at(over, index) {
        Ok(el) -> run_loop(over, rest, [el, ..acc])
        Error(Nil) -> Error(Nil)
      }
  }
}

/// Run a created `Permutation` on some `List`.
/// 
/// This function always returns a `List(a)` by simply putting the provided `default` argument in the returned `List` whenever the requested index is out of bounds.
/// 
pub fn run_default(
  perm: Permutation,
  on l: List(a),
  default default: a,
) -> List(a) {
  run_default_loop(l, perm.output, default, [])
}

fn run_default_loop(
  over: List(a),
  indexes: List(Int),
  default: a,
  acc: List(a),
) -> List(a) {
  case indexes {
    [] -> acc
    [index, ..rest] ->
      run_default_loop(over, rest, default, [
        case util.at(over, index) {
          Ok(el) -> el
          Error(Nil) -> default
        },
        ..acc
      ])
  }
}
