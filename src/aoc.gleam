import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/int
import gleam/string

pub type AoC {
  AoC(part1: Option(Int), part2: Option(Int))
}

pub fn print(aoc: AoC) {
  io.println("")
  print_part("Day 1", aoc.part1)
  print_part("Day 2", aoc.part2)
}

pub fn print_part(prefix: String, part: Option(Int)) {
  io.println(
    [
      prefix,
      ": ",
      part
        |> fn(d) {
          case d {
            None -> "None"
            Some(d) ->
              d
              |> int.to_string
          }
        },
    ]
    |> string.join(""),
  )
}
