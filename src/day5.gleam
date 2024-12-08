import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import simplifile
import util
import aoc.{type AoC, AoC}

pub fn main() {
  let path = "inputs/day5.test"

  let result = case simplifile.read(path) {
    Ok(contents) -> handle_contents(contents)
    Error(_reason) -> AoC(part1: None, part2: None)
  }

  aoc.print(result)
}

pub type Rule {
  Rule(before: Int, after: Int)
}

pub type Count {
  Count(before: List(Int), number: Int, after: List(Int))
}

pub type Update {
  List(Int)
}

pub fn handle_contents(contents: String) -> AoC {
  let lines =
    contents
    |> string.trim
    |> string.split("\n\n")
    |> list.map(fn(section) {
      section
      |> string.split("\n")
    })
  // |> io.debug

  io.println("1.1. After split")

  let assert Ok(rules) = list.first(lines)
  let assert Ok(updates) = list.last(lines)

  let rules =
    rules
    |> list.map(fn(rule) {
      rule
      |> string.split("|")
      |> list.map(fn(r) {
        let assert Ok(a) = int.parse(r)
        a
      })
      |> fn(rule_as_list) {
        let assert [a, b] = rule_as_list
        Rule(before: a, after: b)
      }
    })
  // |> io.debug

  io.println("1.2. Rules parsed")

  let updates =
    updates
    |> list.map(fn(update) {
      update
      |> string.split(",")
      |> list.map(fn(u) {
        let assert Ok(a) = int.parse(u)
        a
      })
    })
  // |> io.debug

  io.println("1.3. Updates parsed")

  let all_numbers =
    rules
    |> list.flat_map(fn(rule) { [rule.before, rule.after] })
    |> list.unique
  // |> io.debug

  io.println("1.4. All numbers")

  // sort all numbers according to the rules
  let number_counts =
    all_numbers
    |> list.map(fn(number) {
      let before =
        rules
        |> list.filter(fn(rule) { rule.after == number })
        |> list.map(fn(rule) { rule.before })
      let after =
        rules
        |> list.filter(fn(rule) { rule.before == number })
        |> list.map(fn(rule) { rule.after })
      Count(before: before, after: after, number: number)
    })
    |> io.debug

  io.println("1.5. Number counts")

  let result =
    updates
    |> list.map(fn(update) {
      update
      |> list.window_by_2
      |> list.map(fn(window) {
        let #(before, after) = window

        let assert Ok(check_after) =
          number_counts
          |> list.find(fn(count) { count.number == before })

        let assert Ok(check_before) =
          number_counts
          |> list.find(fn(count) { count.number == after })

        list.contains(check_before.before, before)
        && list.contains(check_after.after, after)
      })
    })
    |> list.map(fn(adheres_to_rules) {
      adheres_to_rules
      |> list.all(util.identity)
    })
    |> list.zip(updates)
    |> list.map(fn(tuple) {
      let #(adheres_to_rules, update) = tuple
      case adheres_to_rules {
        True -> get_middle_number(update)
        False -> 0
      }
    })
  // |> io.debug

  io.println("1.6. Result")

  // place_numbers([], number_counts)
  AoC(
    part1: Some(
      result
      |> util.sum,
    ),
    part2: None,
  )
}

// fn place_numbers(acc: List(Int), l: List(Count)) {
//   case l {
//     [first, ..rest] -> {
//       acc
//       |> insert_at()
//     }
//   }
// }

fn get_middle_number(update: List(Int)) -> Int {
  let length = list.length(update)
  let middle = length / 2
  let assert Ok(middle_number) = util.get_index(update, middle)
  middle_number
}
