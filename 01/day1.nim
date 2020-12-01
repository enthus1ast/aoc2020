import strutils, os
var inp = readFile(getAppDir() / "input.txt").splitLines()

for aa in inp:
  let anum = aa.strip.parseInt()
  for bb in inp:
    let bnum = bb.strip.parseInt()
    let sum = anum + bnum
    if sum == 2020:
      let product = anum * bnum
      echo aa, " + ", bb, " == ", sum, " solution: ", product
      break