import sets, strutils, tables

proc groups(str: string): seq[string] =
  return str.split("\p\p")

proc cntyes(str: string): seq[HashSet[char]] =
  for group in str.groups():
    var hset = initHashSet[char]()
    for ch in group:
      if Letters.contains ch:
        hset.incl ch
    result.add hset

proc solve1(str: string): int =
  result = 0
  for hset in cntyes(str):
    result.inc hset.len

proc solve2(str: string): int =
  result = 0
  for group in groups(str):
    let members = group.splitLines().len
    var cntt = initCountTable[char]()
    for member in group.splitLines():
      for ch in member:
        if Letters.contains ch:
          cntt.inc ch
    for cnt in cntt.values:
      if cnt == members: result.inc

when isMainModule:
  import os
  let inp = readFile(getAppDir() / "input.txt")
  echo "Solution1: ", solve1(inp)
  echo "Solution2: ", solve2(inp)