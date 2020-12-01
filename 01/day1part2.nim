import strutils, os
var inp = readFile(getAppDir() / "input.txt").splitLines()

for aa in inp:
  let anum = aa.strip.parseInt()
  for bb in inp:
    let bnum = bb.strip.parseInt()
    for cc in inp:
      let cnum = cc.strip.parseInt()
      let sum = anum + bnum + cnum
      if sum == 2020:
        let product = anum * bnum * cnum
        echo aa, " + ", bb, " + ", cc, " == ", sum, " solution: ", product
        break

