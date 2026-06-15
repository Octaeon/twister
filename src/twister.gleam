//// The main module of `twister`, containing basically all of the relevant API.
//// 
//// ## Introduction
//// To use this library, you first need to create a [`Permutation`](twister.html#Permutation),
//// using one of the provided methods:
//// 1. Create it from a `List` of indexes directly, using the
////    [`from_list`](twister.html#from_list) function
//// 2. Create it using a builder pattern by first initializing it with
////    [`blank`](twister.html#blank), then adding indexes to the end one by one with
////    [`add`](twister.html#add).
//// 
//// ## Examples
//// 
//// ### Creating a Permutation
//// 
//// > *Note* : Inside of the `Permutation` data type, the list of indices is stored in reverse order. This is because when running one, the order is also reversed. So, instead of needlessly reversing the internal List, it's just stored back to front.
//// Using a List of indices
//// ```gleam
//// // Create a `Permutation` from a `List` of indices
//// twister.from_list([1, 4, 2, 0, 3, 5])
//// // -> Permutation(False, Some(5), [5, 3, 0, 2, 4, 1])
//// //      This is the important part ^^^^^^^^^^^^^^^^
//// ```
//// Using the builder
//// ```gleam
//// // Create a `Permutation` using a builder
//// twister.blank()
//// |> twister.add(1)
//// |> twister.add(4)
//// |> twister.add(2)
//// |> twister.add(0)
//// |> twister.add(3)
//// |> twister.add(5)
//// // -> Permutation(False, Some(5), [5, 3, 0, 2, 4, 1])
//// // Same as before, just more annoying. But sometimes useful
//// ```
//// 
//// ### Using a Permutation
//// Using [`twister.run`](twister.html#run) returns a `Result(List(a), Nil)`;
//// - `Ok(List(a))` if all of the indices are smaller than the length of the input `List`
//// - `Error(Nil)` if some of the indices were outside the bounds of the input `List`
//// ```gleam
//// let perm = twister.from_list([1, 4, 2, 0, 3, 5])
//// // Call it with run to get a `Result(List(a), Nil)`.
//// assert twister.run(perm, ["a", "b", "c", "d", "e", "f"])
////   == Ok(["b", "e", "c", "a", "d", "f"])
//// ```
//// 
//// Otherwise, you can use [`twister.run_default`](twister.html#run_default) or [`twister.run_generate`](twister.html#run_generate) to replace missing elements if indices are outside of the bounds of the input `List`.
//// ```gleam
//// let perm = twister.from_list([1, 4, 2, 0, 3, 5])
//// 
//// assert twister.run_generate(perm, ["a", "b", "c", "d", "e"], int.to_string)
////   == ["b", "e", "c", "a", "d", "5"]
//// //   Index outside the bounds  ^^^ replaced with generated value
//// assert twister.run_default(perm, ["a", "b", "c", "d", "e"], "")
////   == ["b", "e", "c", "a", "d", ""]
//// //   Index outside the bounds  ^^ replaced with default value
//// ```
//// 
//// ### Appendinx
//// Lastly, there are a few functions to get the propertiese of a given Permutation ([`get_fixed_points`](twister.html#get_fixed_points) and [`bijection_for_length`](twister.html#bijection_for_length)), but as they're not the use case I wrote this library for, they're not very well developed or extensively tested.
//// 

import gleam/int
import gleam/list.{Continue, Stop}
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set
import twister/util

// ==== Types ====

/// Type encoding a permutation.
/// 
/// To create, prefer using the initialization function [`from_list`](twister.html#from_list) or the builder functions - first [`blank`](twister.html#blank), then [`add`](twister.html#add).
/// 
/// To run a permutation *on* a given `List`, use the [`run`](twister.html#run) or [`run_default`](twister.html#run_default) functions.
/// 
/// To learn more, look at he documentation for the functions in question.
/// 
/// ## Note
/// Although the type is not `opaque`, you shouldn't modify it yourself unless you really need to, and there's no other way to achieve your goal.
/// 
pub type Permutation {
  Permutation(modulo: Bool, max_index: Option(Int), output: List(Int))
}

// ==== API Functions ====

// => Initialization

/// Create a new `Permutation` from a given list of indexes.
/// 
/// When later running a permutation *on* some `List`, that `List` must have a length more than or equal to the largest index in the list of indexes within, or it will return `Error(Nil)`.
/// 
pub fn from_list(indexes l: List(Int)) -> Permutation {
  Permutation(
    modulo: False,
    max_index: util.largest(l),
    output: list.reverse(l),
  )
}

/// Create a new, blank `Permutation`.
/// 
/// This function is meant to be used as the starting point for constructing a `Permutation` using the builder pattern, by using the [`add`](twister.html#add) function to add a new index at the end of the list of indexes.
/// 
pub fn blank() -> Permutation {
  Permutation(modulo: False, max_index: None, output: [])
}

// => Builder

/// Add an index to the end of a `Permutation`.
/// 
/// This function is meant to be used after creating a blank `Permutation` using the [`blank`](twister.html#blank) function, but there's nothing stopping you from using it to add elements to a `Permutation` created using the [`from_list`](twister.html#from_list) function.
/// 
/// When later running a permutation *on* some `List`, that `List` must have a length more than or equal to the largest index in the list of indexes within, or it will return `Error(Nil)`.
/// 
pub fn add(perm: Permutation, index i: Int) -> Permutation {
  let Permutation(modulo, old_max, output) = perm
  let new_max = case old_max {
    Some(prev_max) -> int.max(prev_max, i)
    None -> i
  }
  Permutation(modulo, Some(new_max), [i, ..output])
}

pub fn set_modulo(perm: Permutation, to: Bool) -> Permutation {
  Permutation(..perm, modulo: to)
}

// => Execution

/// Run a created `Permutation` on some `List`.
/// 
/// This function returns a `Result` because there's no guarantee that the provided `List` contains enough elements to build the permuted output.
/// 
/// For example, if I have a `Permutation` like `[0, 2, 5]` and I pass in `["a", "b"]`, there simply aren't enough elements in the `List` to find the element at index 5, or even 2. So this function returns `Error(Nil)`.
/// 
/// If you wish to guarantee that a `Permutation` always returns a `List` the exact same length as the `List` of specified indexes, use the [`run_default`](twister.html#run_default) function, and choose a default value to return when the index is out of bounds.
/// 
pub fn run(perm: Permutation, on l: List(a)) -> Result(List(a), Nil) {
  case perm, list.length(l) {
    Permutation(_, _, []), _ -> Ok([])
    Permutation(_, None, _), _ -> Error(Nil)
    Permutation(False, Some(max), non_empty), len if len >= max ->
      run_loop(l, non_empty, [])
    Permutation(True, Some(_), non_empty), len if len > 0 ->
      run_loop(l, non_empty |> map_modulo(list.length(l)), [])
    Permutation(_, Some(_), _), _ -> Error(Nil)
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
/// ## Note
/// If while creating the `Permutation`, the [`set_modulo`](twister.html#set_modulo) function was used, this function will behave identically to [`run`](twister.html#run), as all of the indexes will definitely be within the bounds of the provided `List`.
/// 
pub fn run_default(
  perm: Permutation,
  on l: List(a),
  default default: a,
) -> List(a) {
  case perm {
    Permutation(_, _, []) -> []
    Permutation(False, _, non_empty) ->
      run_generate_loop(l, non_empty, fn(_) { default }, [])
    Permutation(True, _, non_empty) ->
      run_generate_loop(
        l,
        non_empty |> map_modulo(list.length(l)),
        fn(_) { default },
        [],
      )
  }
}

/// Run a created `Permutation` on some `List`.
/// 
/// This function always returns a `List(a)` by simply generating a value in the returned `List` whenever the requested index is out of bounds, with the index in question as the input argument.
/// 
/// ## Note
/// If while creating the `Permutation`, the [`set_modulo`](twister.html#set_modulo) function was used, this function will behave identically to [`run`](twister.html#run), as all of the indexes will definitely be within the bounds of the provided `List`.
/// 
pub fn run_generate(
  perm: Permutation,
  on l: List(a),
  generate fun: fn(Int) -> a,
) -> List(a) {
  case perm {
    Permutation(_, _, []) -> []
    Permutation(False, _, non_empty) -> run_generate_loop(l, non_empty, fun, [])
    Permutation(True, _, non_empty) ->
      run_generate_loop(l, non_empty |> map_modulo(list.length(l)), fun, [])
  }
}

fn run_generate_loop(
  over: List(a),
  indexes: List(Int),
  fun: fn(Int) -> a,
  acc: List(a),
) -> List(a) {
  case indexes {
    [] -> acc
    [index, ..rest] ->
      run_generate_loop(over, rest, fun, [
        case util.at(over, index) {
          Ok(el) -> el
          Error(Nil) -> fun(index)
        },
        ..acc
      ])
  }
}

// => Permutation transformations

/// Transform two `Permutation`s into a third, by executing the first one, then the second one.
/// 
/// Importantly, the first permutation must have an internal length of `n + 1`, where `n` is the largest index of the second, and its' length will be that of the second one.
/// 
/// Lastly, the resulting `Permutation` will essentially be a new one, not inheriting the properties of the input ones (specifically the modulo from [`set_modulo`](twister.html#set_modulo)).
/// 
pub fn compose(
  first: Permutation,
  with second: Permutation,
) -> Result(Permutation, Nil) {
  run(second, first.output)
  |> result.map(fn(indexes) { from_list(indexes) })
}

// / Transform a `Permutation` by shifting its' indices over while wrapping around.
// / 
// / ## Examples
// / Shifting by 0 does nothing - acts like an identity function.
// / 
// / Shifting by a positive number shifts the indices to the right.
// / 
// / Shifting by a negative number shifts the indices to the left.
// / 
// pub fn shift(perm: Permutation, by c: Int) -> Permutation {
//   todo
// }

// => Properties of permutations

/// Given a Permutation, check up to what length of input it is a bijection.
/// 
/// For a Permutation to be a bijection for a given length `n`, the internal `List` of indices must have a length at least `n + 1`, as well as contain all of the integers smaller than `n` at least once.
/// 
/// This way, it is guaranteed to be possible to reverse the permutation given its output; if those requirements are not satisfied, some elements of the original `List` that was permuted will be dropped, and not present in the output, making reversing the operation impossible.
/// 
pub fn bijection_for_length(perm: Permutation) -> Int {
  perm.output
  |> set.from_list()
  |> set.to_list()
  |> list.sort(int.compare)
  |> list.fold_until(0, fn(acc, i) {
    case i == acc {
      True -> Continue(acc + 1)
      False -> Stop(acc)
    }
  })
}

/// Given a Permutation, get which elements are unchanged.
/// 
/// That is, the elements of the list of indices where their index equals their value.
/// 
/// The output is a `List` of indices which do not change when a Permutation is performed.
/// 
pub fn get_fixed_points(perm: Permutation) -> List(Int) {
  perm.output
  |> list.reverse()
  |> list.index_map(fn(a, b) { #(a, b) })
  |> list.filter_map(fn(c) {
    case c.0 == c.1 {
      True -> Ok(c.0)
      False -> Error(Nil)
    }
  })
}

// ==== Private utility functions ====

fn map_modulo(indexes: List(Int), modulo: Int) -> List(Int) {
  indexes
  |> list.map(fn(i) { int.modulo(i, modulo) |> result.unwrap(0) })
}
