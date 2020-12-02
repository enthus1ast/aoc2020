# 1-3 a: abcde
import parseutils, strutils
type
  Password = object
    ch: string
    posA: int
    posB: int
    pw: string

proc parsePassword(str: string): Password =
  var pos = 0
  pos += str.parseInt(result.posA, pos)
  pos += str.skip("-", pos)
  pos += str.parseInt(result.posB, pos)
  pos += str.skip(" ", pos)
  pos += str.parseUntil(result.ch, {':'} , pos)
  pos += str.skip(":", pos)
  pos += str.skipWhitespace(pos)
  result.pw = str[pos .. ^1]

proc valid(password: Password): bool =
  if $password.pw[password.posA - 1] == password.ch and $password.pw[password.posB - 1] == password.ch:
    # _both_ should not contains the same char
    return false
  if $password.pw[password.posA - 1] == password.ch:
    return true
  if $password.pw[password.posB - 1] == password.ch:
    return true
  return false

import os

proc main() =
  var valid = 0
  for line in lines(getAppDir() / "input.txt"):
    if line.parsePassword().valid():
      valid.inc
  echo "Solution: ", valid

main()

assert "1-3 a: abcde".parsePassword() == Password(ch: "a", posA: 1, posB: 3, pw: "abcde")
assert "1-3 b: cdefg".parsePassword() == Password(ch: "b", posA: 1, posB: 3, pw: "cdefg")
assert "2-9 c: ccccccccc".parsePassword() == Password(ch: "c", posA: 2, posB: 9, pw: "ccccccccc")

assert "1-3 a: abcde".parsePassword().valid() == true
assert "1-3 b: cdefg".parsePassword().valid() == false
assert "2-9 c: ccccccccc".parsePassword().valid() == false