#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define INPUT_A 783;
#define INPUT_B 325;

static void
update_num (int64_t *num, int mult)
{
  *num *= mult;
  *num %= 2147483647;
}

static int
iterate_one (int64_t *ga, int64_t *gb)
{
  update_num(ga, 16807);
  update_num(gb, 48271);
  return ((*ga & 0xffff) == (*gb & 0xffff));
}

static int
iterate_two (int64_t *ga, int64_t *gb)
{
  do
    update_num(ga, 16807);
  while (*ga % 4 != 0);

  do
    update_num(gb, 48271);
  while (*gb % 8 != 0);

  return ((*ga & 0xffff) == (*gb & 0xffff));
}

int
main ()
{
  int64_t ga = INPUT_A;
  int64_t gb = INPUT_B;
  int matches = 0;

  for (int i = 0; i < 40000000; i++)
    matches += iterate_one(&ga, &gb);
  printf("Part one: %d\n", matches);

  ga = INPUT_A;
  gb = INPUT_B;
  matches = 0;
  for (int i = 0; i < 5000000; i++)
    matches += iterate_two(&ga, &gb);
  printf("Part two: %d\n", matches);
}
