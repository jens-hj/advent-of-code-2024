import gleam/io
import gleam/string
import gleam/list
import aoc.{type AoC, AoC}
import coordinate.{type Coordinate, Position}
import gleam/option.{type Option, None, Some}
import simplifile
import grid

pub fn main() {
  let path = "inputs/day6.test"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

fn handle_contents(contents: String) -> AoC {
  let grid =
    contents
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.split("")
      |> list.map(fn(c) {
        let assert Ok(environment) = to_environment(c)
        environment
      })
    })

  grid
  |> grid.print(environment_to_string)

  let assert Ok(Some(position)) =
    grid
    |> list.index_map(fn(row, r) {
      row
      |> list.index_map(fn(col, c) {
        case col {
          Agent(_) -> Some(Position(c, r))
          _ -> None
        }
      })
    })
    |> list.flatten
    |> list.find(fn(o) { o != None })

  position
  |> coordinate.to_string
  |> io.println

  let obstacles =
    get_all_obstacles(grid)
    |> io.debug
    |> get_next_obstacle(position, Up)
    |> io.debug

  AoC(part1: None, part2: None)
}

fn get_next_obstacle(
  obstacles: List(Coordinate),
  position: Coordinate,
  direction: Direction,
) -> Option(Coordinate) {
  let cmp = case direction {
    Up -> fn(a: Coordinate, b: Coordinate) { a.x == b.x && a.y < b.y }
    Down -> fn(a: Coordinate, b: Coordinate) { a.x == b.x && a.y > b.y }
    Left -> fn(a: Coordinate, b: Coordinate) { a.y == b.y && a.x < b.x }
    Right -> fn(a: Coordinate, b: Coordinate) { a.y == b.y && a.x > b.x }
  }

  direction
  |> io.debug

  obstacles
  |> list.filter(fn(o) { cmp(o, position) })
  |> io.debug

  None
  // walk(position)
}

fn get_all_obstacles(grid: List(List(Environment))) -> List(Coordinate) {
  grid
  |> list.index_map(fn(row, r) {
    row
    |> list.index_map(fn(col, c) {
      case col {
        Obstacle -> Some(Position(c, r))
        _ -> None
      }
    })
    |> list.filter_map(fn(o) {
      case o {
        Some(position) -> Ok(position)
        None -> Error("No obstacle")
      }
    })
  })
  |> list.flatten
}

type Environment {
  Empty
  Obstacle
  Agent(Direction)
}

fn to_environment(c: String) -> Result(Environment, String) {
  let direction = to_direction(c)

  case c {
    "." -> Ok(Empty)
    "#" -> Ok(Obstacle)
    _ ->
      case direction {
        Ok(direction) -> Ok(Agent(direction))
        Error(reason) -> Error(reason)
      }
  }
}

fn environment_to_string(e: Environment) -> String {
  case e {
    Empty -> "."
    Obstacle -> "#"
    Agent(direction) -> direction_to_string(direction)
  }
}

type Direction {
  Up
  Down
  Left
  Right
}

fn to_direction(c: String) -> Result(Direction, String) {
  case c {
    "^" -> Ok(Up)
    "v" -> Ok(Down)
    "<" -> Ok(Left)
    ">" -> Ok(Right)
    _ -> Error("Invalid direction")
  }
}

fn direction_to_string(d: Direction) -> String {
  case d {
    Up -> "^"
    Down -> "v"
    Left -> "<"
    Right -> ">"
  }
}
