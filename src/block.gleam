import gleam/int
import gleam/list
import gleam/io
import gleam/string

pub type Block {
  File(Int)
  Empty
}

pub fn to_string(block: Block) -> String {
  case block {
    File(i) -> int.to_string(i)
    Empty -> "."
  }
}

pub fn print(blocks: List(Block)) {
  blocks
  |> list.map(to_string)
  |> string.join("")
  |> io.println

  blocks
}
