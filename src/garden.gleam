import grid.{type Grid}
import util

pub type Garden =
  Grid(Plot)

pub type Plot =
  String

pub type Region(plot) {
  Region(plot: plot, area: Int, perimeter: Int)
}

pub fn print(garden: Garden) {
  garden
  |> grid.print(util.identity)
}
