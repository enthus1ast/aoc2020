const testmap = """
..##.........##.........##.........##.........##.........##.......
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#
"""

import strutils

type
  Map = seq[seq[char]]
  Vec2 = tuple[xx, yy: int]

const
  TREE = '#'
  EMPTY = '.'
  WAS_TREE = 'X'
  WAS_EMPTY = 'O'

proc parseMap(mapStr: string): Map =
  for row in mapStr.splitLines():
    if row.len == 0: continue
    result.add @[]
    for elem in row:
      result[^1].add elem

proc height(map: Map): int = map.len
proc width(map: Map): int = map[0].len # Assume col is always given and rows are same size ;)

proc `[]`(map: Map, pos: Vec2): char =
  map[pos.yy][pos.xx mod map.width]

proc `[]=`(map: var Map, pos: Vec2, elem: char) =
  map[pos.yy][pos.xx mod map.width] = elem


proc `$`(map: Map): string =
  result = ""
  for col in map:
    for elem in col:
      result.add elem
    result.add "\n"

proc solve(mapIn: Map, slope: Vec2): int =
  var map = mapIn
  var pos: Vec2 = (0,0)
  var trees = 0
  while pos.yy < map.height - 1:
    pos.yy += slope.yy
    pos.xx += slope.xx
    if map[pos] == TREE:
      trees.inc
      map[pos] = WAS_TREE
    else:
      map[pos] = WAS_EMPTY
  result = trees
  # echo map

# let map = parseMap(testmap)

when isMainModule:
  import os
  var map = parseMap((getAppDir() / "input.txt").readFile())
  block First:
    echo "First part:", map.solve((3, 1))
  echo "######################"

  block Second:
    var slopes: seq[Vec2] = @[]
    slopes.add((1, 1))
    slopes.add((3, 1))
    slopes.add((5, 1))
    slopes.add((7, 1))
    slopes.add((1, 2))
    var product = 1
    for slope in slopes:
      echo slope
      let curSolution = map.solve(slope)
      echo curSolution
      product *= curSolution
      echo "===="
    echo "Solution: ", product



# when isMainModule:
#   block:
#     var map = parseMap(testmap)
#     assert map[(0,0)] == '.'
#     assert map[(0,1)] == '#'
#     assert map[(3,0)] == '#'
#     echo map.solve()

  # map[(0,0)] = 'O'
  # echo $map