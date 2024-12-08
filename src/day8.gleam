import gleam/io
import gleam/string
import gleam/list
import util.{type AoC, AoC}
import gleam/option.{None}
import simplifile

pub fn main() {
  let path = "inputs/day8.tet"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> util.AoC(day1: None, day2: None)
  }

  io.debug(result)
}

fn handle_contents(contents: String) -> AoC {
  io.println("HI THERE")

  contents
  |> io.debug
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split("")
  })
  |> util.print_grid

  AoC(day1: None, day2: None)
}
