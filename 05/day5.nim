import strutils

type
  SeatLocation = tuple[row: int, col: int]
  SeatIds = seq[int]

proc toNum(str: string): SeatLocation =
  var rowbin, colbin = ""
  for ch in str:
    case ch
    of 'F': rowbin.add("0")
    of 'B': rowbin.add("1")
    of 'R': colbin.add("1")
    of 'L': colbin.add("0")
    else: discard
  return (parseBinInt(rowbin), parseBinInt(colbin))

proc seatId(sl: SeatLocation): int =
  (sl.row * 8) + sl.col

proc findSeat(seatIds: SeatIds): int =
  var prev: int = 0
  for seat in seatIds:
    if seat == prev + 2: return seat - 1
    prev = seat

when isMainModule:
  import os
  var highest = 0
  for line in lines(getAppDir() / "input.txt"):
    let cur = line.toNum().seatId()
    if cur > highest: highest = cur
  echo "Solution1: ", highest

when isMainModule:
  import os, algorithm
  var seatIds: SeatIds = @[]
  for line in lines(getAppDir() / "input.txt"):
    seatIds.add line.toNum().seatId()
  seatIds.sort()
  echo "Solution2: ", seatIds.findSeat

when isMainModule:
  assert toNum("FBFBBFFRLR")  == (44, 5)
  assert toNum("FBFBBFFRLR").seatId  == 357
  assert toNum("BFFFBBFRRR") == (70, 7)
  assert toNum("BFFFBBFRRR").seatId == 567
  assert toNum("FFFBBBFRRR") == (14, 7)
  assert toNum("FFFBBBFRRR").seatId == 119
  assert toNum("BBFFBBFRLL") == (102, 4)
  assert toNum("BBFFBBFRLL").seatId == 820