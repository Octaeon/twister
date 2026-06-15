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

// pub fn negative_index_wraparound_test() {
//   let perm = weaver.from_list([-1]) |> weaver.wraparound()
//   assert weaver.run(perm, ["whatever"]) == Ok(["whatever"]) as "Run | Negative index wraparound"
// }

pub fn run_out_of_bounds_default_test() {
  let perm = weaver.from_list([2])
  assert weaver.run(perm, ["whatever"]) == Error(Nil)
    as "Run | Out of bounds = Default error"
}

// pub fn out_of_bounds_modulo_test() {
//   let perm = weaver.from_list([2]) |> weaver.modulo()
//   assert weaver.run(perm, ["whatever"]) == Ok(["whatever"])
//     as "Run | Out of bounds index modulo"
// }

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
  assert weaver.run_default(perm, [], "both are empty") == ["both are empty"]
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

pub fn run_default_negative_index_default_test() {
  let perm = weaver.from_list([-1])
  assert weaver.run_default(perm, ["whatever"], "negative") == ["negative"]
    as "Run default | Negative index replaced with default"
}

pub fn run_default_out_of_bounds_default_test() {
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
