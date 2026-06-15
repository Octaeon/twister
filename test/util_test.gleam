import gleam/option.{None, Some}
import weaver/util

pub fn get_index_first_element_test() -> Nil {
  let l = [0, 1, 2, 3, 4]
  assert util.at(l, 0) == Ok(0) as "Get Index | First element"
}

pub fn get_index_middle_element_test() -> Nil {
  let l = [0, 1, 2, 3, 4]
  assert util.at(l, 3) == Ok(3) as "Get Index | Middle element"
}

pub fn get_index_last_element_test() -> Nil {
  let l = [0, 1, 2, 3, 4]
  assert util.at(l, 4) == Ok(4) as "Get Index | Last element"
}

pub fn get_index_negative_test() -> Nil {
  let l = [0, 1, 2, 3, 4]
  assert util.at(l, -1) == Error(Nil) as "Get Index | Negative index"
}

pub fn get_index_out_of_bounds_test() -> Nil {
  let l = [0, 1, 2, 3, 4]
  assert util.at(l, 5) == Error(Nil) as "Get Index | Out of bounds"
}

pub fn largest_empty_test() -> Nil {
  let l = []
  assert util.largest(l) == None as "Largest | Empty list"
}

pub fn largest_single_element_test() -> Nil {
  let l = [1]
  assert util.largest(l) == Some(1) as "Largest | Single element list"
}

pub fn largest_return_first_test() -> Nil {
  let l = [100, 20, 49, 69, 67]
  assert util.largest(l) == Some(100) as "Largest | Return first"
}

pub fn largest_return_last_test() -> Nil {
  let l = [100, 20, 49, 69, 67, 1000]
  assert util.largest(l) == Some(1000) as "Largest | Return last"
}

pub fn largest_negative_elements_test() -> Nil {
  let l = [-20, -4, -15, -2, -5]
  assert util.largest(l) == Some(-2) as "Largest | Negative integers"
}

pub fn largest_identical_elements_test() -> Nil {
  let l = [100, 100, 100, 100, 100]
  assert util.largest(l) == Some(100) as "Largest | Identical Elements"
}
