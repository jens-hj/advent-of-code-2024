import gleam/list
import gleam/io

pub fn main() {
  [1, 2]
  |> combinations_with_repititions(3)
  |> io.debug
}

pub fn combinations_with_repititions(
  l: List(Int),
  length: Int,
) -> List(List(Int)) {
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
