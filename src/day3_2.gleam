import gleam/list
import gleam/string
import simplifile

import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/regexp

pub fn main() {
  // let path = "inputs/day3_2.test"
  let path = "inputs/day3"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> None
  }

  case result {
    Some(result) -> {
      io.debug(result)
      Nil
    }
    None -> {
      io.debug("Something went wrong")
      Nil
    }
  }
}

pub fn handle_contents(contents: String) -> Option(Int) {
  let assert Ok(mul_pattern) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  let assert Ok(pattern) =
    regexp.from_string("(do(?:n't)?)\\(\\)([\\S\\s]*?)\\ ")
  let assert Ok(do_pattern) = regexp.from_string("do\\(\\)")
  let assert Ok(dont_pattern) = regexp.from_string("don't\\(\\)")

  let extra = "do()"

  let result =
    contents
    |> fn(c) { string.concat([extra, c, " "]) }
    |> regexp.replace(do_pattern, _, " do()")
    |> regexp.replace(dont_pattern, _, " don't()")
    |> regexp.scan(pattern, _)
    |> list.map(fn(match) {
      case match.submatches {
        [Some("do"), Some(rest)] -> {
          rest
        }
        _ -> ""
      }
    })
    |> string.concat
    |> regexp.scan(mul_pattern, _)
    |> list.map(fn(match) {
      case match.submatches {
        [Some(a), Some(b)] -> {
          let assert Ok(a) = int.parse(a)
          let assert Ok(b) = int.parse(b)
          a * b
        }
        _ -> 0
      }
    })
    |> list.fold(0, fn(acc, x) { acc + x })

  Some(result)
}
