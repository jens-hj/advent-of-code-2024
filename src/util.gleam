import gleam/io
import gleam/list
import gleam/string
import gleam/int
import gleam/float

pub fn get_index(l: List(a), i: Int) -> Result(a, Nil) {
  l
  |> list.take(i + 1)
  |> list.last
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
  |> list.index_map(fn(amount, index) {
    print_progress("Creating Combination", index, length + 1)

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

pub fn print_progress(prefix: String, index: Int, total: Int) {
  let assert Ok(progress) =
    index
    |> int.add(1)
    |> int.to_float
    |> float.divide(
      total
      |> int.to_float,
    )
  io.println(
    [
      prefix,
      " ",
      "test ",
      index + 1
        |> int.to_string,
      "/",
      total
        |> int.to_string,
      " ",
      progress
        |> float.multiply(100.0)
        |> float.round
        |> int.to_string,
      "%",
    ]
    |> string.join(""),
  )
}
