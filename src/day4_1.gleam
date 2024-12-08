import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/string
import simplifile
import grid.{type Grid}
import util.{get_index}

pub fn main() {
  let path = "inputs/day4.test"
  //   let path = "inputs/day4"

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
      io.debug("No result")
      Nil
    }
  }
}

pub fn handle_contents(contents: String) -> Option(Int) {
  let assert Ok(pattern) = regexp.from_string("X(?=MAS)|S(?=AMX)")
  //   let assert Ok(n_pattern) = regexp.from_string("\n")
  let grid =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.to_graphemes
    })
    |> grid.print(util.identity)

  let grid_permutations =
    [
      grid,
      grid
        |> list.transpose,
      grid
        |> rotate45,
    ]
    |> list.map(fn(g) {
      g
      |> grid.print(util.identity)
    })

  grid
  |> list.map(fn(row) {
    regexp.scan(
      pattern,
      row
        |> string.join(""),
    )
    |> list.length
  })
  |> io.debug

  let result =
    grid_permutations
    |> list.map(fn(g) {
      g
      |> list.map(fn(row) {
        regexp.scan(
          pattern,
          row
            |> string.join(""),
        )
        |> list.length
      })
      |> list.fold(0, fn(acc, x) { acc + x })
    })
    |> list.fold(0, fn(acc, x) { acc + x })
    |> io.debug

  Some(result)
}

pub fn rotate45(grid: Grid(a)) -> Grid(a) {
  let max = list.length(grid) - 1
  let first_half =
    list.range(0, max)
    |> list.map(fn(i) {
      list.range(0, i)
      |> list.reverse
    })
    |> io.debug

  let assert Ok(second_half) =
    first_half
    |> list.reverse
    |> list.rest
  let second_half =
    second_half
    |> list.map(fn(row) {
      row
      |> list.map(fn(col) {
        let assert Ok(last) = list.last(first_half)
        col + list.length(last) - list.length(row)
      })
    })

  let combined =
    list.append(first_half, second_half)
    |> io.debug

  let result =
    combined
    |> list.index_map(fn(row, r) {
      let offset_fn = case r {
        _ if r > max -> fn(x) { max - x }
        _ -> fn(x) { x }
      }
      row
      |> list.index_map(fn(col, c) {
        let assert Ok(l) = get_index(grid, col)
        io.debug(offset_fn(c))
        let assert Ok(item) = get_index(l, offset_fn(c))
        item
      })
    })
  // |> print_grid(util.identity)

  result
}
