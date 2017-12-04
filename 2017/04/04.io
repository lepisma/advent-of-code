#!/usr/bin/env io
# Advent of code day 4

List validOne := method(self size == self unique size)
List validTwo := method(sorted := self map(i, i asMutable sort); sorted validOne)
List boolToInt := method(self map(p, if(p, 1, 0)))

lines := File with("./input.txt") openForReading readLines
tokens := lines map(split)

tokens map(validOne) boolToInt sum println
tokens map(validTwo) boolToInt sum println