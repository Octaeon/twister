//// Module containing functions to test for properties of a given `Permutation`.
//// 
//// ## Note
//// These are something of an afterthought, and not the use case I wrote this library for;
//// as such, take care when using them, since they're not very well documented or extensively
//// tested.
//// 

import gleam/int
import gleam/list.{Continue, Stop}
import gleam/set
import twister.{type Permutation}

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

/// Given a Permutation, check up to what length of input it is a bijection.
/// 
/// For a Permutation to be a bijection for a given length `n`, the internal `List` of indices
/// must have a length at least `n + 1`, as well as contain all of the integers smaller than
/// `n` at least once.
/// 
/// This way, it is guaranteed to be possible to reverse the permutation given its output;
/// if those requirements are not satisfied, some elements of the original `List` that was
/// permuted will be dropped, and not present in the output, making reversing the operation
/// impossible.
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
