import gleam/string
import gleam/list
import gleam/int
import gleam/io
import aoc.{type AoC, AoC}
import block.{type Block}
import segment.{type Segment}
import gleam/option.{None, Some}
import simplifile
import util

pub fn main() {
  let path = "inputs/day9.test"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let lengths =
    contents
    |> string.trim
    |> string.split("")
    |> list.map(fn(length) {
      let assert Ok(length) =
        length
        |> int.parse
      length
    })

  let segment_amount =
    lengths
    |> list.length

  let block_types =
    True
    |> list.repeat(segment_amount / 2 + 1)
    |> list.intersperse(False)

  let forwards =
    lengths
    |> list.zip(block_types)
    |> list.index_map(fn(segment, i) {
      let #(block_length, block_type) = segment
      case block_type {
        True -> {
          block.File(i / 2)
          |> list.repeat(block_length)
        }
        False -> {
          block.Empty
          |> list.repeat(block_length)
        }
      }
    })
    |> list.flatten
  // |> block.print

  let total =
    forwards
    |> list.length

  let backwards =
    forwards
    |> list.reverse
  // |> block.print

  let compressed =
    compress1(forwards, backwards, total, [])
    |> list.map(fn(value) {
      let assert block.File(i) = value
      i
    })

  compressed
  |> list.map(fn(value) { int.to_string(value) })
  |> string.join("")
  // |> io.println

  let part1_result =
    compressed
    |> list.index_map(fn(value, factor) { value * factor })
    |> util.sum

  let segments =
    block_types
    |> list.zip(lengths)
    |> list.index_map(fn(segment, i) {
      let #(block_type, length) = segment
      case block_type {
        True -> segment.File(length, i / 2)
        False -> segment.Empty(length)
      }
    })
    |> segment.print

  AoC(part1: Some(part1_result), part2: None)
}

fn compress2(segments: List(Segment)) {
  todo
}

fn compress1(
  forwards: List(Block),
  backwards: List(Block),
  total: Int,
  result: List(Block),
) {
  case
    total
    == result
    |> list.length
  {
    True -> result
    False -> {
      case forwards {
        [block.Empty, ..rest] -> {
          case backwards {
            [block.Empty, ..tail] ->
              compress1([block.Empty, ..rest], tail, total - 1, result)
            [head, ..tail] ->
              compress1(
                rest,
                tail,
                total - 1,
                result
                  |> list.append([head]),
              )
            [] -> result
          }
        }
        [first, ..rest] ->
          compress1(
            rest,
            backwards,
            total,
            result
              |> list.append([first]),
          )
        [] -> result
      }
    }
  }
}
