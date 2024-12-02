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

pub type Safety {
  Safe
  Unsafe
}

pub type Step {
  Increasing
  Decreasing
  Same
}

pub type Order {
  Ascending
  Descending
}

const allowed = [1, 2, 3]

pub fn main() {
  let path = "inputs/day2.1.test"
  // let path = "inputs/day2.1"

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
    |> io.debug

  let result1 =
    diffs
    |> list.map(fn(line) {
      let order = direction(line)
      case order {
        Ascending -> line
        Descending -> list.map(line, fn(diff) { -diff })
      }
      |> list.map(fn(diff) { diff >= 0 })
    })
    |> io.debug

  let result2 =
    diffs
    |> list.map(fn(line) {
      list.map(line, fn(element) {
        list.contains(allowed, int.absolute_value(element))
      })
    })
    |> io.debug

  // list.zip(result1, result2)
  // |> list.map(fn(p) {
  //   list.zip(pair.first(p), pair.second(p))
  //   |> list.map(fn(p) { pair.first(p) && pair.second(p) })
  // })
  // |> io.debug

  Some(0)
  // let zip =
  //   list.zip(result1, result2)
  //   |> list.map(fn(p) { pair.first(p) && pair.second(p) })

  // let result = list.count(zip, fn(element) { element })
  // Some(result)
}

pub fn evaluate_safety(line: List(Int)) -> Safety {
  let evaluate_singular = fn(first: Int, last: Int, order: Order) -> Bool {
    let check = allowed |> list.contains(first - last)
    case order {
      Ascending if last > first && check -> True
      Descending if last < first && check -> True
      _ -> False
    }
  }

  let evaluate_safety_inner = fn(line: List(Int), order: Order) -> Safety {
    case line {
      [first, last] -> evaluate_singular(first, last, order)
      [first, second, ..rest] ->
        case evaluate_singular(first, second, order) {
          True -> evaluate_safety_inner([second, ..rest], order)
          False -> Unsafe
        }
      _ -> Safe
    }
  }

  case line {
    [first, second, ..rest] if second > first ->
      evaluate_safety_inner([second, ..rest], Ascending)
    [first, second, ..rest] if second < first ->
      evaluate_safety_inner([second, ..rest], Descending)
    _ -> Safe
  }
}

/// Returns the direction of the diffs either [`Ascending`] or [`Descending`]
fn direction(diffs: List(Int)) -> Order {
  // if most of the diffs are positive or 0, return ascending
  // if most of the diffs are negative, return descending
  let positive = list.count(diffs, fn(diff) { diff >= 0 })
  let negative = list.count(diffs, fn(diff) { diff < 0 })

  case positive, negative {
    _, _ if positive >= negative -> Ascending
    _, _ -> Descending
  }
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
