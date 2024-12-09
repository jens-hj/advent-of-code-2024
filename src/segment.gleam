import gleam/int
import gleam/list
import gleam/io
import gleam/string

pub type Segment {
  File(size: Int, id: Int)
  Empty(size: Int)
}

pub fn to_string(segment: Segment) -> String {
  case segment {
    File(size, id) ->
      id
      |> int.to_string
      |> list.repeat(size)
      |> string.join("")
    Empty(size) ->
      "."
      |> list.repeat(size)
      |> string.join("")
  }
}

pub fn print(segments: List(Segment)) {
  segments
  |> list.map(to_string)
  |> string.join("")
  |> io.println

  segments
}
