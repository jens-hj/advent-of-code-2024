import gleam/order.{type Order}
import gleam/int
import gleam/string

pub type Coordinate {
  Position(x: Int, y: Int)
  Bounds(x: Int, y: Int)
  Distance(x: Int, y: Int)
}

pub fn cmp(a: Coordinate, b: Coordinate) -> Order {
  order.break_tie(cmp_x(a, b), cmp_y(a, b))
}

pub fn cmp_x(a: Coordinate, b: Coordinate) -> Order {
  int.compare(a.x, b.x)
}

pub fn cmp_y(a: Coordinate, b: Coordinate) -> Order {
  int.compare(a.y, b.y)
}

pub fn to_string(c: Coordinate) -> String {
  [
    "(",
    c.x
      |> int.to_string,
    ",",
    c.y
      |> int.to_string,
    ")",
  ]
  |> string.join("")
}

pub fn distance(a: Coordinate, b: Coordinate) -> Coordinate {
  Distance(x: a.x - b.x, y: a.y - b.y)
}

pub fn apply_op(
  a: Coordinate,
  b: Coordinate,
  op: fn(Int, Int) -> Int,
) -> Coordinate {
  Position(x: op(a.x, b.x), y: op(a.y, b.y))
}

pub fn apply_op_each(
  a: Coordinate,
  b: Int,
  op: fn(Int, Int) -> Int,
) -> Coordinate {
  Position(x: op(a.x, b), y: op(a.y, b))
}

pub fn add(a: Coordinate, b: Coordinate) -> Coordinate {
  apply_op(a, b, int.add)
}

pub fn subtract(a: Coordinate, b: Coordinate) -> Coordinate {
  apply_op(a, b, int.subtract)
}

pub fn scale(a: Coordinate, b: Int) -> Coordinate {
  apply_op_each(a, b, int.multiply)
}

pub fn within_bounds(c: Coordinate, bounds: Coordinate) -> Bool {
  c.x >= 0 && c.x < bounds.x && c.y >= 0 && c.y < bounds.y
}
