import gleam/string
import gleam/list
import aoc.{type AoC, AoC}
import stone.{type Stone}
import gleam/option.{None, Some}
import simplifile

pub fn main() {
  let path = "inputs/day11"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let stones =
    contents
    |> string.trim
    |> string.split(" ")
    |> list.map(fn(s) { stone.from_string(s) })
    |> blink_times(75)

  AoC(
    part1: Some(
      stones
      |> list.length,
    ),
    part2: None,
  )
}

fn blink_times(stones: List(Stone), times: Int) -> List(Stone) {
  case times {
    0 -> stones
    _ ->
      blink_times(
        stones
          |> stone.blink,
        times - 1,
      )
  }
}
