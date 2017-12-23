#!/usr/bin/env io

posId := method(x, y, "#{x}-#{y}" interpolate)

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
  for(x, 0, lines size - 1,
    for(y, 0, lines at(x) size - 1,
      setNode(posId(x, y), if(lines at(x) at(y) == 46, 0, 1))
    )
  )
  size ::= lines size
)

Position := Object clone
Position start := method(s,
  m := (s / 2) floor;
  x ::= m; y ::= m; dir ::= 1
)
Position left := method(dir = (dir + 1) % 4)
Position right := method(dir = if(dir == 0, 3, dir - 1))
Position move := method(
  dir switch(
    0, y = (y + 1),
    1, x = (x - 1),
    2, y = (y - 1),
    3, x = (x + 1)
  )
)

Virus := Object clone
Virus start := method(cls, pos,
  cls ::= cls; pos ::= pos; infected ::= 0
)
Virus step := method(
  pid := posId(pos x, pos y)
  cls getNode(pid) switch(
    0, pos left; cls setNode(pid, 1); pos move; infected = infected + 1,
    1, pos right; cls setNode(pid, 0); pos move
  )
)

cls := Cluster clone
cls fromFile("input.txt")

pos := Position clone
pos start(cls size)

virus := Virus clone
virus start(cls, pos)

10000 repeat(virus step)
"Part one: #{virus infected}" interpolate println

// Part two virus
Virus step := method(
  pid := posId(pos x, pos y)
  cls getNode(pid) switch(
    0, pos left; cls setNode(pid, 2); pos move,
    1, pos right; cls setNode(pid, 3); pos move,
    2, cls setNode(pid, 1); pos move; infected = infected + 1,
    3, pos right; pos right; cls setNode(pid, 0); pos move
  )
)

cls := Cluster clone
cls fromFile("input.txt")

pos := Position clone
pos start(cls size)

virus := Virus clone
virus start(cls, pos)

10000000 repeat(virus step)
"Part two: #{virus infected}" interpolate println
