import gleam/io
import gleam/list
import gleam/string

/// A grid of characters, that is each string is a single character
pub type Grid(a) =
  List(List(a))

pub fn print(grid: Grid(a), to_string: fn(a) -> String) -> Grid(a) {
  grid
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) { to_string(cell) })
    |> string.join("")
    |> io.println
  })

  io.println("")

  grid
}
