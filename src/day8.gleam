import gleam/string
import gleam/list
import gleam/int
import gleam/dict
import gleam/option.{None, Some}
import simplifile
import aoc.{type AoC, AoC}
import util
import coordinate.{type Coordinate, Bounds, Position}
import grid

pub fn main() {
  let path = "inputs/day8"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let grid =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.split("")
    })

  let bounds =
    grid
    |> grid.bounds

  let antenna_pairs =
    grid
    |> list.index_map(fn(row, r) {
      row
      |> list.index_map(fn(col, c) { #(col, Position(c, r)) })
    })
    // |> util.print_grid(fn(cp) {
    //   [cp.0, "@", util.coordinate_to_string(cp.1), " "]
    //   |> string.join("")
    // })
    |> list.flatten
    |> list.group(fn(cp) {
      case cp {
        #(".", _) -> "discard"
        #(a, _) -> a
      }
    })
    |> dict.filter(fn(v, _) { v != "discard" })
    |> dict.values
    |> list.map(fn(l) {
      l
      |> list.map(fn(cp) { cp.1 })
      |> list.combinations(2)
    })
    |> list.flatten

  let result1 =
    antenna_pairs
    |> list.map(fn(pair) {
      let assert [a, b] = pair
      let distance = coordinate.distance(a, b)
      [
        a
          |> coordinate.add(distance),
        b
          |> coordinate.subtract(distance),
      ]
    })

  let result2 =
    antenna_pairs
    |> list.map(fn(pair) {
      let assert [a, b] = pair
      let distance = coordinate.distance(a, b)
      [
        a
          |> walk_until_out_of_bounds(distance, bounds, coordinate.add),
        b
          |> walk_until_out_of_bounds(distance, bounds, coordinate.subtract),
      ]
      |> list.flatten
    })

  AoC(
    part1: result1
      |> count_result(bounds)
      |> Some,
    part2: result2
      |> count_result(bounds)
      |> Some,
  )
}

fn count_result(result: List(List(Coordinate)), bounds: Coordinate) -> Int {
  result
  |> list.flatten
  |> list.unique
  |> list.map(fn(c) {
    c
    |> coordinate.within_bounds(bounds)
  })
  |> list.count(util.identity)
}

fn walk_until_out_of_bounds(
  start: Coordinate,
  offset: Coordinate,
  bounds: Coordinate,
  op: fn(Coordinate, Coordinate) -> Coordinate,
) -> List(Coordinate) {
  let x_max = bounds.x / offset.x
  let y_max = bounds.y / offset.y

  list.range(0, int.max(x_max, y_max))
  |> list.map(fn(i) {
    start
    |> op(coordinate.scale(offset, i))
  })
}
