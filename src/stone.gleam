import gleam/int
import gleam/list
import gleam/string
import gleam/io

pub type Stone {
  EvenDigits(Int)
  Other(Int)
}

fn show(stone: Stone) -> String {
  case stone {
    EvenDigits(n) ->
      n
      |> int.to_string
    Other(n) ->
      n
      |> int.to_string
  }
}

pub fn print(stones: List(Stone)) {
  stones
  |> list.map(fn(s) { show(s) })
  |> string.join(" ")
  |> io.println

  stones
}

pub fn is_even_digits(n: Int) -> Bool {
  n
  |> int.to_string
  |> string.split("")
  |> list.length
  |> int.is_even
}

pub fn from_string(n: String) -> Stone {
  case n {
    _ -> {
      let assert Ok(n_int) = int.parse(n)
      case
        n_int
        |> is_even_digits
      {
        True -> EvenDigits(n_int)
        False -> Other(n_int)
      }
    }
  }
}

fn split(n: Int) -> #(Int, Int) {
  let int_list_string =
    n
    |> int.to_string
    |> string.split("")
  let assert Ok(half_length) =
    int_list_string
    |> list.length
    |> int.divide(2)

  let assert Ok(first) =
    int_list_string
    |> list.take(half_length)
    |> string.join("")
    |> int.parse
  let assert Ok(second) =
    int_list_string
    |> list.reverse
    |> list.take(half_length)
    |> list.reverse
    |> string.join("")
    |> int.parse

  #(first, second)
}

pub fn transform(stone: Stone) -> List(Stone) {
  case stone {
    Other(0) -> [Other(1)]
    EvenDigits(n) -> {
      let assert Ok(half_length) =
        n
        |> int.to_string
        |> string.split("")
        |> list.length
        |> int.divide(2)

      let #(first, second) = split(n)

      case
        #(
          half_length
            |> int.is_even,
          second
            |> is_even_digits,
        )
      {
        #(True, False) -> [EvenDigits(first), Other(second)]
        #(True, True) -> [EvenDigits(first), EvenDigits(second)]
        #(False, True) -> [Other(first), EvenDigits(second)]
        #(False, _) -> [Other(first), Other(second)]
      }
    }
    Other(n) -> {
      let new_number = n * 2024
      case
        new_number
        |> is_even_digits
      {
        True -> [EvenDigits(new_number)]
        False -> [Other(new_number)]
      }
    }
  }
}

pub fn blink(stones: List(Stone)) -> List(Stone) {
  stones
  |> list.map(fn(s) { transform(s) })
  |> list.flatten
}
