# 1-3 a: abcde
import parseutils, strutils
type
  Password = object
    ch: string
    mini: int
    maxi: int
    pw: string

proc parsePassword(str: string): Password =
  var pos = 0
  pos += str.parseInt(result.mini, pos)
  pos += str.skip("-", pos)
  pos += str.parseInt(result.maxi, pos)
  pos += str.skip(" ", pos)
  pos += str.parseUntil(result.ch, {':'} , pos)
  pos += str.skip(":", pos)
  pos += str.skipWhitespace(pos)
  result.pw = str[pos .. ^1]

proc valid(password: Password): bool =
  let cntCh = password.pw.count(password.ch)
  if cntCh < password.mini: return false
  if cntCh > password.maxi: return false
  return true

import os

proc main() =
  var valid = 0
  for line in lines(getAppDir() / "input.txt"):
    if line.parsePassword().valid():
      valid.inc
  echo "Solution: ", valid

main()

assert "1-3 a: abcde".parsePassword() == Password(ch: "a", mini: 1, maxi: 3, pw: "abcde")
assert "1-3 b: cdefg".parsePassword() == Password(ch: "b", mini: 1, maxi: 3, pw: "cdefg")
assert "2-9 c: ccccccccc".parsePassword() == Password(ch: "c", mini: 2, maxi: 9, pw: "ccccccccc")

assert "1-3 a: abcde".parsePassword().valid() == true
assert "1-3 b: cdefg".parsePassword().valid() == false
assert "2-9 c: ccccccccc".parsePassword().valid() == true