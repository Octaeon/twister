import gleam/int
import gleam/option.{type Option, None, Some}

pub fn at(in: List(a), index index: Int) -> Result(a, Nil) {
  case index, in {
    0, [head, ..] -> Ok(head)
    _, [] -> Error(Nil)
    remaining, [_, ..rest] -> at(rest, remaining - 1)
  }
}

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
