# ribosome.rb 08.dna.rb | xargs -0 python -c

lines = File.readlines('input.txt')
.regs = set()
lines.each do |line|
.regs.add("@{line.split(' ')[0]}")
end
.regs = [[r, 0] for r in regs]
.names = [r[0] for r in regs]
.mem = []
lines.each do |line|
s = line.split(' ')
.regs[names.index("@{s[0]}")][1] @{(s[1] === 'inc') ? '+=' : '-='} @{s[2]}
./+ if regs[names.index("@{s[4]}")][1] @{s[5]} @{s[6]} else 0
.mem += [r[1] for r in regs]
end
.print(f"Part one: {max([r[1] for r in regs])}")
.print(f"Part two: {max(mem)}")
