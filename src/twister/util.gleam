import gleam/int
import gleam/option.{type Option, None, Some}

pub fn at(in: List(a), index index: Int) -> Result(a, Nil) {
  case index, in {
    remaining, _ if remaining < 0 -> Error(Nil)
    _, [] -> Error(Nil)
    0, [head, ..] -> Ok(head)
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
