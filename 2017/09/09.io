#!/usr/bin/env io

Stream := Object clone do(
  text ::= nil
  pos ::= 0
  score ::= 0
  nesting ::= 0
  garbage ::= 0
  inGarbage ::= false
  char := method(text at(pos))
  move := method(pos = pos + 1; self)
  step := method(
    if(inGarbage,
      char switch(
        33, move,
        62, inGarbage = false,
        garbage = garbage + 1
      ),
      char switch(
        60, inGarbage = true,
        123, nesting = nesting + 1,
        125, score = score + nesting; nesting = nesting - 1
      )
    )
    move
  )
)

st := Stream clone
st setText(File with("./input.txt") openForReading readLines at(0))

while(st pos < st text size, st step)
"Part one: #{st score}" interpolate println
"Part two: #{st garbage}" interpolate println