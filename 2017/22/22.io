#!/usr/bin/env io

Cluster := Object clone
Cluster setNode := method(x, y, value,
  xid := x asString
  if(nodes at(xid) == nil,
    nodes atPut(xid, Map clone)
  )
  nodes at(xid) atPut(y asString, value)
)
Cluster getNode := method(x, y,
  xMap := nodes at(x asString)
  if(xMap,
    val := xMap at(y asString)
    if(val, val, 0),
    0
  )
)
Cluster fromLines := method(lines,
  nodes ::= Map clone
  size ::= lines size
  for(x, 0, lines size - 1,
    if(x == 0,
      nodes atPut(x asString, Map clone)
    )
    for(y, 0, lines at(x) size - 1,
      if(lines at(x) at(y) == 35,
        setNode(x, y, 1)
      )
    )
  )
)

Virus := Object clone
Virus start := method(cls, pos,
  cls ::= cls
  size ::= cls size
  m := (size / 2) floor
  x ::= m; y ::= m; dir ::= 1
  infected ::= 0
)
Virus left := method(dir = (dir + 1) % 4)
Virus right := method(dir = if(dir == 0, 3, dir - 1))
Virus step := method(
  dir switch(
    0, y = (y + 1),
    1, x = (x - 1),
    2, y = (y - 1),
    3, x = (x + 1)
  )
)
Virus burst := method(
  cls getNode(x, y) switch(
    0, left; cls setNode(x, y, 1); step; infected = infected + 1,
    1, right; cls setNode(x, y, 0); step
  )
)

virus := Virus clone
cls := Cluster clone
lines := File with("input.txt") openForReading readLines

cls fromLines(lines)
virus start(cls)
10000 repeat(virus burst)
"Part one: #{virus infected}" interpolate println

Virus burst := method(
  cls getNode(x, y) switch(
    0, left; cls setNode(x, y, 2); step,
    1, right; cls setNode(x, y, 3); step,
    2, cls setNode(x, y, 1); step; infected = infected + 1,
    3, right; right; cls setNode(x, y, 0); step
  )
)

cls fromLines(lines)
virus start(cls)
10000000 repeat(virus burst)
"Part two: #{virus infected}" interpolate println
