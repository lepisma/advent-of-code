#!/usr/bin/env ribosome.rb
lines = File.readlines('input.txt')
.regs = Hash.new 0
.mem = []
lines.each do |line|
  s = line.split ' '
  s[0] = "regs['#{s[0]}']"; s[4] = "regs['#{s[4]}']"
  s[1] = s[1] == 'inc' ? '+=' : '-='
.@{s.join " "}
.mem += regs.map { |k, v| v }
end
.puts "Part one: #{regs.map { |k, v| v }.max}\nPart two: #{mem.max}"
