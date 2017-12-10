#!/usr/bin/env io
# Advent of code day 4

List allUnique := method(self size == self unique size)
List anagramUnique := method(sorted := self map(i, i asMutable sort); sorted allUnique)
List boolToInt := method(self map(p, if(p, 1, 0)))

lines := File with("./input.txt") openForReading readLines
tokens := lines map(split)

"Part one: #{tokens map(allUnique) boolToInt sum}" interpolate println
"Part two: #{tokens map(anagramUnique) boolToInt sum}" interpolate println