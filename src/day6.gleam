import gleam/string
import gleam/io
import gleam/list
import aoc.{type AoC, AoC}
import coordinate.{type Coordinate, Position}
import gleam/option.{None, Some}
import simplifile
import grid.{type Grid}

pub fn main() {
  let path = "inputs/day6"

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

  let bounds =
    grid
    |> grid.bounds

  grid
  |> grid.print(environment_to_string)

  let assert Ok(Some(#(direction, position))) =
    grid
    |> list.index_map(fn(row, r) {
      row
      |> list.index_map(fn(col, c) {
        case col {
          Agent(direction) -> Some(#(direction, Position(c, r)))
          _ -> None
        }
      })
    })
    |> list.flatten
    |> list.find(fn(o) { o != None })

  let obstacles = get_all_obstacles(grid)
  let path = walk(position, direction, obstacles, [])

  let assert Ok(#(direction, last_position)) =
    path
    |> list.last

  let visited =
    path
    |> list.append(to_edge(
      last_position,
      direction
        |> turn_right,
      bounds,
    ))
    |> list.map(fn(p) { p.1 })
    |> list.unique
  // |> list.map(fn(p) {
  //   io.print(coordinate.to_string(p))
  //   p
  // })

  visited
  |> set_visited(position, grid)
  |> grid.print(environment_to_string)

  AoC(
    part1: Some(
      visited
      |> list.length,
    ),
    part2: None,
  )
}

fn to_edge(
  position: Coordinate,
  direction: Direction,
  bounds: Coordinate,
) -> List(#(Direction, Coordinate)) {
  let bound = case direction {
    Up -> Position(position.x, 0)
    Down -> Position(position.x, bounds.y - 1)
    Left -> Position(0, position.y)
    Right -> Position(bounds.x - 1, position.y)
  }

  lerp(position, bound)
  |> list.map(fn(p) { #(direction, p) })
}

fn set_visited(
  visited: List(Coordinate),
  position: Coordinate,
  grid_result: Grid(Environment),
) -> Grid(Environment) {
  case visited {
    [first, ..rest] -> {
      grid_result
      |> grid.set(first, Visited)
      |> set_visited(rest, position, _)
    }
    [] -> grid_result
  }
}

fn walk(
  position: Coordinate,
  direction: Direction,
  obstacles: List(Coordinate),
  result: List(#(Direction, Coordinate)),
) -> List(#(Direction, Coordinate)) {
  let next_obstacle =
    obstacles
    |> get_next_obstacle(position, direction)

  let position_from = case direction {
    Up -> fn(obstacle: Coordinate) {
      Position(x: obstacle.x, y: obstacle.y + 1)
    }
    Down -> fn(obstacle: Coordinate) {
      Position(x: obstacle.x, y: obstacle.y - 1)
    }
    Left -> fn(obstacle: Coordinate) {
      Position(x: obstacle.x + 1, y: obstacle.y)
    }
    Right -> fn(obstacle: Coordinate) {
      Position(x: obstacle.x - 1, y: obstacle.y)
    }
  }

  case next_obstacle {
    Ok(obstacle) -> {
      let new_position = position_from(obstacle)
      walk(
        new_position,
        direction
          |> turn_right,
        obstacles,
        result
          |> list.append(
            lerp(position, new_position)
            |> list.map(fn(p) { #(direction, p) }),
          ),
      )
    }
    Error(_) -> result
  }
}

fn lerp(a: Coordinate, b: Coordinate) -> List(Coordinate) {
  let x_range = list.range(a.x, b.x)
  let y_range = list.range(a.y, b.y)

  x_range
  |> list.map(fn(x) {
    y_range
    |> list.map(fn(y) { Position(x, y) })
  })
  |> list.flatten
}

fn turn_right(direction: Direction) -> Direction {
  case direction {
    Up -> Right
    Down -> Left
    Left -> Up
    Right -> Down
  }
}

type OutsideOrInside {
  Outside(Coordinate)
  Inside(Coordinate)
}

fn get_next_obstacle(
  obstacles: List(Coordinate),
  position: Coordinate,
  direction: Direction,
) -> Result(Coordinate, String) {
  let filter = case direction {
    Up -> fn(a: Coordinate, b: Coordinate) { a.x == b.x && a.y < b.y }
    Down -> fn(a: Coordinate, b: Coordinate) { a.x == b.x && a.y > b.y }
    Left -> fn(a: Coordinate, b: Coordinate) { a.y == b.y && a.x < b.x }
    Right -> fn(a: Coordinate, b: Coordinate) { a.y == b.y && a.x > b.x }
  }

  let cmp = case direction {
    Up -> fn(a: Coordinate, b: Coordinate) { coordinate.compare_y(a, b) }
    Down -> fn(a: Coordinate, b: Coordinate) { coordinate.compare_y(b, a) }
    Left -> fn(a: Coordinate, b: Coordinate) { coordinate.compare_x(a, b) }
    Right -> fn(a: Coordinate, b: Coordinate) { coordinate.compare_x(b, a) }
  }

  let result =
    obstacles
    |> list.filter(fn(o) { filter(o, position) })
    |> list.sort(cmp)
    |> list.reverse
    |> list.first

  case result {
    Ok(coordinate) -> Ok(coordinate)
    Error(_) -> Error("No obstacles")
  }
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
  Visited
}

fn to_environment(c: String) -> Result(Environment, String) {
  let direction = to_direction(c)

  case c {
    "." -> Ok(Empty)
    "#" -> Ok(Obstacle)
    "X" -> Ok(Visited)
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
    Visited -> "X"
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
