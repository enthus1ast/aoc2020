const testdata = """ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"""

import strutils, tables, parseutils, sets

type
  Passport = Table[string, string]

const allowedEcl = toHashSet(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

iterator passportLines(str: string): string =
  var lines = ""
  for line in str.splitLines():
    if line == "":
      yield lines
      lines = ""
    else: lines.add line & " "
  yield lines # the last one

func toTab(str: string): Passport =
  var pos = 0
  var key, val: string
  while pos < str.len:
    pos += str.parseUntil(key, ':', pos)
    pos += str.skip(":", pos)
    pos += str.parseUntil(val, " ", pos)
    pos += str.skipWhitespace(pos)
    result[key] = val

func validFields(passport: Passport): bool =
  if not passport.hasKey("ecl"): return false
  if not passport.hasKey("pid"): return false
  if not passport.hasKey("eyr"): return false
  if not passport.hasKey("hcl"): return false
  if not passport.hasKey("byr"): return false
  if not passport.hasKey("iyr"): return false
  if not passport.hasKey("hgt"): return false
  return true

func valNum(str: string, digits = 4, minNum, maxNum: int): bool =
  if str.len != digits: return false
  var num = 0
  try:
    num = parseInt(str)
  except:
    return false
  return num >= minNum and num <= maxNum

func validByr(str: string): bool =
  return str.valNum(4, 1920, 2002)

func validIyr(str: string): bool =
  return str.valNum(4, 2010, 2020)

func validEyr(str: string): bool =
  return str.valNum(4, 2020, 2030)

func validHgt(str: string): bool =
  if str.len < 3: return false
  let num = str[0..^3].parseInt()
  let unit = str[^2..^1]
  case unit
  of "cm":
    return num >= 150 and num <= 193
  of "in":
    return num >= 59 and num <= 76
  else:
    return false

func validHcl(str: string): bool =
  if str.len != 7: return false
  if str[0] != '#': return false
  try:
    var num: int
    discard parseHex(str[1..^1], num)
    return true
  except:
    return false

proc validEcl(str: string): bool =
  allowedEcl.contains(str.toLower())

func validPid(str: string): bool =
  if str.len != 9: return false
  try:
    var num = 0
    discard parseInt(str, num)
    return true
  except:
    return false

proc valid2(passport: Passport): bool =
  if not passport.validFields(): return false
  if not passport["byr"].validByr(): return false
  if not passport["iyr"].validIyr(): return false
  if not passport["eyr"].validEyr(): return false
  if not passport["hgt"].validHgt(): return false
  if not passport["hcl"].validHcl(): return false
  if not passport["ecl"].validEcl(): return false
  if not passport["pid"].validPid(): return false
  return true

proc solve1(path: string) =
  var valids = 0
  for lines in passportLines(readFile(path)):
    if lines.toTab().validFields(): valids.inc
  echo "Solution1: ", valids

proc solve2(path: string) =
  var valids = 0
  for lines in passportLines(readFile(path)):
    if lines.toTab().valid2(): valids.inc
  echo "Solution2: ", valids

when isMainModule:
  import os
  solve1(getAppDir() / "input.txt")
  solve2(getAppDir() / "input.txt")

when isMainModule and false:
  import sequtils
  var tsts: seq[Passport]
  for lines in passportLines(testdata):
    # echo lines
    let tab = lines.toTab()
    # echo tab
    tsts.add tab

  assert tsts[0] == {
    "ecl": "gry",
    "pid": "860033327",
    "eyr": "2020",
    "hcl": "#fffffd",
    "byr": "1937",
    "iyr": "2017",
    "cid": "147",
    "hgt": "183cm",
  }.toTable()

  assert tsts[1] == {
    "iyr": "2013",
    "ecl": "amb",
    "cid": "350",
    "eyr": "2023",
    "pid": "028048884",
    "hcl": "#cfa07d",
    "byr": "1929",
  }.toTable()

  assert tsts[2] == {
    "hcl": "#ae17e1",
    "iyr": "2013",
    "eyr": "2024",
    "ecl": "brn",
    "pid": "760753108",
    "byr": "1931",
    "hgt": "179cm",
  }.toTable()

  assert tsts[3] == {
    "hcl": "#cfa07d",
    "eyr": "2025",
    "pid": "166559648",
    "iyr": "2011",
    "ecl": "brn",
    "hgt": "59in",
  }.toTable()

  assert tsts[0].valid == true # all eight fields here
  assert tsts[1].valid == false # missing hgt
  assert tsts[2].valid == true # missing cid but still valid
  assert tsts[3].valid == false # byr missing