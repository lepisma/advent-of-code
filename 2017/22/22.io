#!/usr/bin/env io

posId := method(x, y, s, ((x * s) + y) asString)

Cluster := Object clone
Cluster setNode := method(key, value,
  if ((value > 0) or (nodes hasKey(key)),
    nodes atPut(key, value)
  )
)
Cluster getNode := method(key,
  if(nodes hasKey(key), nodes at(key), 0)
)
Cluster fromFile := method(name,
  nodes ::= Map clone
  lines := File with(name) openForReading readLines
  size ::= lines size
  for(x, 0, lines size - 1,
    for(y, 0, lines at(x) size - 1,
      setNode(posId(x, y, size), if(lines at(x) at(y) == 46, 0, 1))
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
  pid := posId(x, y, size)
  cls getNode(pid) switch(
    0, left; cls setNode(pid, 1); step; infected = infected + 1,
    1, right; cls setNode(pid, 0); step
  )
)

virus := Virus clone
cls := Cluster clone

cls fromFile("input.txt")
virus start(cls)
10000 repeat(virus burst)
"Part one: #{virus infected}" interpolate println

Virus burst := method(
  pid := posId(x, y, size)
  cls getNode(pid) switch(
    0, left; cls setNode(pid, 2); step,
    1, right; cls setNode(pid, 3); step,
    2, cls setNode(pid, 1); step; infected = infected + 1,
    3, right; right; cls setNode(pid, 0); step
  )
)

cls fromFile("input.txt")
virus start(cls)
10000000 repeat(virus burst)
"Part two: #{virus infected}" interpolate println
