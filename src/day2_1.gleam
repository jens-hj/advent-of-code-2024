import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/string
import simplifile

pub type Option(a) {
  Some(a)
  None
}

pub fn main() {
  // let path = "inputs/day2.test"
  let path = "inputs/day2"

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

fn handle_contents(contents: String) -> Option(Int) {
  let allowed = [1, 2, 3]
  let diffs =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) { string.split(line, " ") })
    |> list.map(parse_line)
    |> list.filter(fn(line) { line != [] })
    |> list.map(fn(line) { list.window_by_2(line) })
    |> list.map(fn(line) {
      list.map(line, fn(window) {
        let first = pair.first(window)
        let second = pair.second(window)
        first - second
      })
    })

  let result1 =
    diffs
    |> list.map(fn(line) {
      list.all(line, fn(element) { element >= 0 })
      || list.all(line, fn(element) { element < 0 })
    })

  let result2 =
    diffs
    |> list.map(fn(line) {
      list.map(line, fn(element) {
        list.contains(allowed, int.absolute_value(element))
      })
    })
    |> list.map(fn(line) { list.all(line, fn(element) { element }) })

  let zip =
    list.zip(result1, result2)
    |> list.map(fn(p) { pair.first(p) && pair.second(p) })

  let result = list.count(zip, fn(element) { element })
  Some(result)
}

fn parse_line(line: List(String)) -> List(Int) {
  let parsed = list.map(line, int.parse)
  case
    list.all(parsed, fn(n) {
      case n {
        Ok(_) -> True
        Error(_) -> False
      }
    })
  {
    True ->
      list.map(parsed, fn(n) {
        case n {
          Ok(num) -> num
          Error(_) -> 0
        }
      })
    False -> []
  }
}
