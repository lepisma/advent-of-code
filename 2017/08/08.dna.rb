# ribosome.rb 08.dna.rb | xargs -0 python -c

lines = File.readlines('input.txt')
.from collections import defaultdict
.regs = defaultdict(int)
.mem = []
lines.each do |line|
  s = line.split(' ')
  s[0] = "regs['#{s[0]}']"
  s[4] = "regs['#{s[4]}']"
  s[1] = s[1] == 'inc' ? '+=' : '-='
.@{s.join" "} else 0
.mem += [r for r in regs.values()]
end
.print(f"Part one: {max([r for r in regs.values()])}")
.print(f"Part two: {max(mem)}")
