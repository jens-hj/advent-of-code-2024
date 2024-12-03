import gleam/list
import simplifile

import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/regexp

pub fn main() {
  // let path = "inputs/day3.test"
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
  let assert Ok(pattern) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  let result =
    regexp.scan(pattern, contents)
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
