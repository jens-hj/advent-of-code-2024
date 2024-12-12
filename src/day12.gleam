import simplifile
import gleam/string
import gleam/list
import gleam/io
import gleam/option.{None, Some}
import grid
import coordinate.{Coordinate}
import garden.{type Garden, type Plot, type Region, Region}
import aoc.{type AoC, AoC}
import stone.{type Stone}

pub fn main() {
  let path = "inputs/day12.test"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let garden: Garden =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(s) {
      s
      |> string.split("")
    })

  garden
  |> garden.print

  let neighbours =
    grid.neighbours(garden, Coordinate(x: 3, y: 0))
    |> io.debug

  AoC(part1: None, part2: None)
}
