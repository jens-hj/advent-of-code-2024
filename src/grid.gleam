import gleam/io
import gleam/list
import gleam/string
import coordinate.{type Coordinate, Bounds}

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

pub fn set(grid: Grid(a), position: Coordinate, value: a) -> Grid(a) {
  grid
  |> list.index_map(fn(row, r) {
    row
    |> list.index_map(fn(col, c) {
      case r == position.y && c == position.x {
        True -> value
        False -> col
      }
    })
  })
}

pub fn bounds(grid: Grid(a)) -> Coordinate {
  Bounds(
    x: list.length(grid),
    y: grid
      |> fn(g) {
        let assert Ok(first) = list.first(g)
        list.length(first)
      },
  )
}
