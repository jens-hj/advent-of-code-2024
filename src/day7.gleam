import gleam/io
import gleam/string
import gleam/list
import gleam/int
import aoc.{type AoC, AoC}
import gleam/option.{None, Some}
import simplifile
import util

pub fn main() {
  let path = "inputs/day7"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

type Test {
  TestInput(input: List(Int), output: Int)
}

type Combinations {
  Combinations(
    input: List(Int),
    output: Int,
    opseqs: List(List(fn(Int, Int) -> Int)),
  )
}

type Results {
  Results(target: Int, candidates: List(Int))
}

const operators = [int.add, int.multiply]

pub fn handle_contents(contents: String) -> AoC {
  let tests =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.split(":")
      |> list.map(fn(element) {
        element
        |> string.trim
      })
      |> fn(line) {
        let assert Ok(output) =
          line
          |> list.first
        let assert Ok(output) =
          output
          |> int.parse
        let assert Ok(input) =
          line
          |> list.last
        let input =
          input
          |> string.split(" ")
          |> list.map(fn(in) {
            let assert Ok(in_as_int) =
              in
              |> int.parse
            in_as_int
          })
        TestInput(input: input, output: output)
      }
    })

  io.println("Parsing Inputs: 100%")

  let total_tests =
    tests
    |> list.length

  io.println(
    [
      "Total tests = ",
      total_tests
        |> int.to_string,
    ]
    |> string.join(""),
  )

  let result =
    tests
    |> list.index_map(fn(t, index) {
      let op_count =
        t.input
        |> list.length
        |> int.add(-1)
      io.println(
        [
          op_count
            |> int.to_string,
          " operators",
        ]
        |> string.join(""),
      )
      let op_seqs =
        op_count
        |> util.combinations_with_repititions(operators, _)
      util.print_progress("Combinations: ", index, total_tests)
      Combinations(input: t.input, opseqs: op_seqs, output: t.output)
    })
    // |> list.map(fn(c) { print_combinations(c) })
    |> list.index_map(fn(c, index) {
      let assert [first, ..rest] = c.input
      let candidates =
        c.opseqs
        |> list.map(fn(opseq) {
          rest
          |> list.index_fold(first, fn(acc, item, index) {
            let assert Ok(op) =
              opseq
              |> util.get_index(index)
            op(acc, item)
          })
        })
      util.print_progress("Results: ", index, total_tests)
      Results(target: c.output, candidates: candidates)
    })
    |> list.map(fn(results) {
      case
        results.candidates
        |> list.contains(results.target)
      {
        True -> results.target
        False -> 0
      }
    })
    |> io.debug

  AoC(
    part1: Some(
      result
      |> util.sum,
    ),
    part2: None,
  )
}
