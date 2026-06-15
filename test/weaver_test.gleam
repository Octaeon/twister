import gleam/int
import gleam/list
import gleeunit
import weaver

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn run_empty_permutation_test() {
  let perm = weaver.blank()
  assert weaver.run(perm, ["whatever"]) == Ok([]) as "Run | Empty permutation"
}

pub fn run_empty_list_test() {
  let perm = weaver.from_list([0])
  assert weaver.run(perm, []) == Error(Nil) as "Run | Empty list"
}

pub fn run_both_empty_test() {
  let perm = weaver.blank()
  assert weaver.run(perm, []) == Ok([]) as "Run | Both empty"
}

pub fn run_singleton_test() {
  let perm = weaver.from_list([0])
  assert weaver.run(perm, ["whatever"]) == Ok(["whatever"])
    as "Run | Single element"
}

pub fn run_negative_index_default_test() {
  let perm = weaver.from_list([-1])
  assert weaver.run(perm, ["whatever"]) == Error(Nil)
    as "Run | Negative index = Default Error"
}

pub fn run_out_of_bounds_default_test() {
  let perm = weaver.from_list([2])
  assert weaver.run(perm, ["whatever"]) == Error(Nil)
    as "Run | Out of bounds = Default error"
}

pub fn run_modulo_negative_index_test() {
  let perm =
    weaver.from_list([-1])
    |> weaver.set_modulo(True)
  assert weaver.run(perm, [0, 1, 2]) == Ok([2])
    as "Run | Modulo negative index wraparound"
}

pub fn run_out_of_bounds_modulo_test() {
  let perm =
    weaver.from_list([0, 4])
    |> weaver.set_modulo(True)
  assert weaver.run(perm, [0, 1, 2]) == Ok([0, 1])
    as "Run | Modulo out of bounds remainder"
}

pub fn run_modulo_empty_permutation_test() {
  let perm =
    weaver.blank()
    |> weaver.set_modulo(True)
  assert weaver.run(perm, [0]) == Ok([]) as "Run | Modulo empty permutation"
}

pub fn run_modulo_empty_list_test() {
  let perm =
    weaver.from_list([0])
    |> weaver.set_modulo(True)
  assert weaver.run(perm, []) == Error(Nil) as "Run | Modulo empty list"
}

pub fn run_modulo_both_empty_test() {
  let perm =
    weaver.blank()
    |> weaver.set_modulo(True)
  assert weaver.run(perm, []) == Ok([]) as "Run | Modulo both empty"
}

pub fn run_repeater_test() {
  let perm = weaver.from_list([0, 0, 0, 0])
  assert weaver.run(perm, ["whatever"])
    == Ok(["whatever", "whatever", "whatever", "whatever"])
    as "Run | Repeater permutation"
}

pub fn run_normal_from_list_test() {
  let perm = weaver.from_list([0, 2, 1, 4])
  assert weaver.run(perm, [0, 1, 2, 3, 4]) == Ok([0, 2, 1, 4])
    as "Run | From List, Normal permutation"
}

pub fn run_normal_builder_test() {
  let perm =
    weaver.blank()
    |> weaver.add(0)
    |> weaver.add(2)
    |> weaver.add(1)
    |> weaver.add(4)
  assert weaver.run(perm, [0, 1, 2, 3, 4]) == Ok([0, 2, 1, 4])
    as "Run | Builder, Normal permutation"
}

pub fn run_default_empty_permutation_test() {
  let perm = weaver.blank()
  assert weaver.run_default(perm, ["whatever"], "empty") == []
    as "Run default | Empty permutation"
}

pub fn run_default_empty_list_test() {
  let perm = weaver.from_list([0])
  assert weaver.run_default(perm, [], "there's nothing T-T")
    == ["there's nothing T-T"]
    as "Run default | Empty list"
}

pub fn run_default_both_empty_test() {
  let perm = weaver.blank()
  assert weaver.run_default(perm, [], "both are empty") == []
    as "Run default | Both empty"
}

pub fn run_default_singleton_test() {
  let perm = weaver.from_list([0])
  assert weaver.run_default(perm, ["whatever"], "empty") == ["whatever"]
    as "Run default | Single element"
}

pub fn run_default_negative_index_test() {
  let perm = weaver.from_list([-1])
  assert weaver.run_default(perm, ["whatever"], "negative") == ["negative"]
    as "Run default | Negative index replaced with default"
}

pub fn run_default_out_of_bounds_test() {
  let perm = weaver.from_list([2])
  assert weaver.run_default(perm, ["whatever"], "out of bounds")
    == ["out of bounds"]
    as "Run default | Out of bounds replaced with default"
}

pub fn run_default_repeater_test() {
  let perm = weaver.from_list([0, 0, 0, 0])
  assert weaver.run_default(perm, ["whatever"], "huh?")
    == ["whatever", "whatever", "whatever", "whatever"]
    as "Run default | Repeater permutation"
}

pub fn run_default_modulo_negative_index_test() {
  let perm =
    weaver.from_list([-1])
    |> weaver.set_modulo(True)
  assert weaver.run_default(perm, [0, 1, 2], -1) == [2]
    as "Run default | Modulo negative index wraparound"
}

pub fn run_default_out_of_bounds_modulo_test() {
  let perm =
    weaver.from_list([0, 4])
    |> weaver.set_modulo(True)
  assert weaver.run_default(perm, [0, 1, 2], -1) == [0, 1]
    as "Run default | Modulo out of bounds remainder"
}

pub fn run_default_modulo_empty_permutation_test() {
  let perm =
    weaver.blank()
    |> weaver.set_modulo(True)
  assert weaver.run_default(perm, [0], -1) == []
    as "Run default | Modulo empty permutation"
}

pub fn run_default_modulo_empty_list_test() {
  let perm =
    weaver.from_list([0])
    |> weaver.set_modulo(True)
  assert weaver.run_default(perm, [], -1) == [-1]
    as "Run default | Modulo empty list"
}

pub fn run_default_modulo_both_empty_test() {
  let perm =
    weaver.blank()
    |> weaver.set_modulo(True)
  assert weaver.run_default(perm, [], -1) == []
    as "Run default | Modulo both empty"
}

pub fn run_default_normal_from_list_test() {
  let perm = weaver.from_list([0, 2, 1, 4])
  assert weaver.run_default(perm, [0, 1, 2, 3, 4], -1) == [0, 2, 1, 4]
    as "Run default | From List, Normal permutation"
}

pub fn run_default_normal_builder_test() {
  let perm =
    weaver.blank()
    |> weaver.add(0)
    |> weaver.add(2)
    |> weaver.add(1)
    |> weaver.add(4)
  assert weaver.run_default(perm, [0, 1, 2, 3, 4], -1) == [0, 2, 1, 4]
    as "Run default | Builder, Normal permutation"
}

pub fn builder_equivalence_test() {
  let built =
    weaver.blank()
    |> weaver.add(0)
    |> weaver.add(2)
    |> weaver.add(1)
    |> weaver.add(4)
  assert built == weaver.from_list([0, 2, 1, 4])
    as "Builder equivalent to from_list"
}

pub fn run_generate_negative_index_test() {
  let perm = weaver.from_list([-1])
  assert weaver.run_generate(perm, ["whatever"], int.to_string) == ["-1"]
    as "Run generate | Negative index generated"
}

pub fn run_generate_out_of_bounds_test() {
  let perm = weaver.from_list([2])
  assert weaver.run_generate(perm, ["whatever"], int.to_string) == ["2"]
    as "Run generate | Out of bounds generated"
}

pub fn fixed_point_empty_test() {
  let perm = weaver.blank()
  assert weaver.get_fixed_points(perm) == []
    as "Fixed points | Empty permutation"
}

pub fn fixed_point_singleton_test() {
  let perm = weaver.from_list([0])
  assert weaver.get_fixed_points(perm) == [0]
    as "Fixed points | Singleton permutation"
}

pub fn fixed_point_none_test() {
  let perm = weaver.from_list([1, 0])
  assert weaver.get_fixed_points(perm) == [] as "Fixed points | No fixed points"
}

pub fn fixed_point_identity_permutation_test() {
  let identity = [0, 1, 2, 3, 4, 5]
  let perm = weaver.from_list(identity)
  assert weaver.get_fixed_points(perm) == identity
    as "Fixed points | Identity permutation"
}

pub fn fixed_point_shifted_test() {
  let perm = weaver.from_list([1, 2, 3, 4, 5, 0])
  assert weaver.get_fixed_points(perm) == [] as "Fixed points | Shifted"
}

pub fn bijection_empty_test() {
  let perm = weaver.blank()
  assert weaver.bijection_for_length(perm) == 0
    as "Bijection | Empty permutation"
}

pub fn bijection_singleton_test() {
  let perm = weaver.from_list([0])
  assert weaver.bijection_for_length(perm) == 1
    as "Bijection | Singleton permutation"
}

pub fn bijection_no_0_test() {
  let perm = weaver.from_list([1, 2, 3])
  assert weaver.bijection_for_length(perm) == 0 as "Bijection | No 0"
}

pub fn bijection_no_2_test() {
  let perm = weaver.from_list([0, 1, 3])
  assert weaver.bijection_for_length(perm) == 2 as "Bijection | No 2"
}

pub fn bijection_reverse_test() {
  let reverse = [0, 1, 2, 3, 4, 5] |> list.reverse()
  let perm = weaver.from_list(reverse)
  assert weaver.bijection_for_length(perm) == 6 as "Bijection | Reversed"
}
