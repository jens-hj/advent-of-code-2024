import gleam/io
import gleam/list
import gleam/option.{type Option}
import gleam/string

pub type AoC {
  AoC(day1: Option(Int), day2: Option(Int))
}

pub fn get_index(l: List(a), i: Int) -> Result(a, Nil) {
  l
  |> list.take(i + 1)
  |> list.last
}

/// A grid of characters, that is each string is a single character
pub type Grid =
  List(List(String))

pub fn print_grid(grid: Grid) -> Grid {
  grid
  |> list.map(fn(row) {
    row
    |> string.join("")
    |> io.println
  })

  io.println("")

  grid
}

pub fn sum(l: List(Int)) -> Int {
  let assert Ok(sum) =
    l
    |> list.reduce(fn(acc, number) { acc + number })
  sum
}

pub fn identity(a: a) -> a {
  a
}

pub fn combinations_with_repititions(l: List(a), length: Int) -> List(List(a)) {
  let assert Ok(first) =
    l
    |> list.first
  let assert Ok(second) =
    l
    |> list.last
  list.range(0, length)
  |> list.map(fn(amount) {
    [
      first
        |> list.repeat(amount),
      second
        |> list.repeat(length - amount),
    ]
    |> list.flatten
    |> list.permutations
    |> list.unique
  })
  |> list.flatten
}
