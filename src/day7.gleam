import gleam/io
import gleam/string
import gleam/list
import gleam/int
import util.{type AoC}
import gleam/option.{None, Some}
import simplifile

pub fn main() {
  let path = "inputs/day7"

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

type Results {
  Results(target: Int, candidates: List(Int))
}

const operators = [int.add, int.multiply]

pub fn handle_contents(contents: String) -> AoC {
  let result =
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
        |> util.combinations_with_repititions(operators, _)

      // t.input
      // |> io.debug
      // op_count
      // |> io.debug
      // op_seqs
      // |> list.map(fn(op_seq) {
      //   op_seq
      //   |> io.debug
      // })
      Combinations(input: t.input, opseqs: op_seqs, output: t.output)
    })
    // |> list.map(fn(c) { print_combinations(c) })
    |> list.map(fn(c) {
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

  util.AoC(
    day1: Some(
      result
      |> util.sum,
    ),
    day2: None,
  )
}
// fn print_combinations(combinations: Combinations) -> Combinations {
//   let inputs =
//     combinations.input
//     |> list.map(fn(i) {
//       i
//       |> int.to_string
//     })
//     |> string.join(" ")

//   io.print("inputs = ")
//   io.println(inputs)

//   io.println("operators = ")
//   combinations.opseqs
//   |> list.map(fn(opseq) {
//     opseq
//     |> io.debug
//   })

//   io.print("target = ")
//   io.println(
//     combinations.output
//     |> int.to_string,
//   )

//   combinations
// }
