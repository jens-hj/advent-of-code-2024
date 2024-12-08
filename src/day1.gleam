import gleam/string
import gleam/list
import gleam/int
import aoc.{type AoC, AoC}
import gleam/option.{None, Some}
import simplifile
import util

pub fn main() {
  let path = "inputs/day1"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let #(lefts, rights) =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.split("   ")
      |> fn(pair) {
        let assert [left, right] = pair
        let assert Ok(left) = int.parse(left)
        let assert Ok(right) = int.parse(right)
        #(left, right)
      }
    })
    |> list.unzip

  let sorted_lefts =
    lefts
    |> list.sort(int.compare)

  let sorted_rights =
    rights
    |> list.sort(int.compare)

  let diffs =
    sorted_lefts
    |> list.zip(sorted_rights)
    |> list.map(fn(pair) {
      let #(left, right) = pair
      int.absolute_value(left - right)
    })

  let similarity =
    lefts
    |> list.map(fn(number) {
      let matches =
        rights
        |> list.filter(fn(n) { n == number })
        |> list.length
      number * matches
    })

  AoC(
    part1: Some(
      diffs
      |> util.sum,
    ),
    part2: Some(
      similarity
      |> util.sum,
    ),
  )
}
