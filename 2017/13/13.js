const walls = require('fs').readFileSync('./input.txt', 'utf-8')
      .trim().split('\n')
      .map(line => line.split(': ').map(x => parseInt(x)))
      .map(wall => { return { p: wall[0], r: wall[1] } })

const checkHit = (({ p, r }) =>  p % (2 * (r - 1)) === 0)
const severity = walls.map(({ p, r }) => checkHit({ p, r }) ? p * r : 0).reduce((acc, b) => acc + b, 0)

let lag = 0
while (walls.some(({ p, r }) => checkHit({ p: p + lag, r }))) { lag += 1 }

console.log(`Part one: ${severity}\nPart two: ${lag}`)
