import gleam/io
import gleam/string
import gleam/list
import gleam/int
import util.{type AoC}
import gleam/option.{None, Some}
import simplifile

pub fn main() {
  let path = "inputs/day7.test"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> util.AoC(day1: None, day2: None)
  }

  io.debug(result)
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
    |> list.map(fn(t) {
      let op_count =
        t.input
        |> list.length
        |> int.add(-1)
      let op_seqs =
        op_count
        |> list.combinations(operators, _)
      Combinations(input: t.input, opseqs: op_seqs, output: t.output)
    })
    |> list.map(fn(c) {
      // dont window apply functions, fold with the function, so the previous result is carried to the next function
      c.opseqs
      |> list.map(fn(ops) {
        ops
        |> list.strict_zip(
          c.input
          |> list.window_by_2,
        )
      })
    })
    |> io.debug

  util.AoC(day1: None, day2: None)
}
