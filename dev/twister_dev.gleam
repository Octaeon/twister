import gleam/int
import twister

pub fn main() -> Nil {
  let perm = twister.from_list([1, 4, 2, 0, 3, 5])

  assert twister.run_generate(perm, ["a", "b", "c", "d", "e"], int.to_string)
    == ["b", "e", "c", "a", "d", "5"]
  // Index outside the bounds    ^^^ replaced with generated value
}
