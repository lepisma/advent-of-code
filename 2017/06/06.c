// Advent of code day 06

#include <stdio.h>
#include <stdlib.h>

#define INPUT_SIZE 16
#define STORE_SIZE 10000

int argmax(int *array) {
  int amax = INPUT_SIZE - 1;
  int vmax = array[amax];
  for (int i = amax - 1; i >= 0; i--) {
    if (array[i] >= vmax) {
      amax = i;
      vmax = array[i];
    }
  }
  return amax;
}

int index_in_store(int store[][INPUT_SIZE], int array[]) {
  int idx = -1;
  for (int i = 0; i < STORE_SIZE; i++) {
    int match = 0;
    for (int j = 0; j < INPUT_SIZE; j++) {
      if (store[i][j] == array[j]) { match++; }
    }
    if (match == INPUT_SIZE) {
      idx = i;
      break;
    }
  }
  return idx;
}

void add_to_store(int store[][INPUT_SIZE], int array[], int pos) {
  for (int i = 0; i < INPUT_SIZE; i++) {
    store[pos][i] = array[i];
  }
}

void read_input(char file_name[], int array[]) {
  FILE *fs = NULL;
  if (NULL == (fs = fopen(file_name, "r"))) {
    perror("Error in reading file\n");
    exit(EXIT_FAILURE);
  }
  for (int i = 0; !feof(fs) && i < INPUT_SIZE ; i++) {
    fscanf(fs, " %d", &array[i]);
  }
}

void evolve(int array[]) {
  int max_idx = argmax(array);
  int val = array[max_idx];
  array[max_idx] = 0;

  for (int i = 0; i < val; i++) {
    array[(max_idx + i + 1) % INPUT_SIZE] += 1;
  }
}

int main() {
  int input[INPUT_SIZE];
  int store[STORE_SIZE][INPUT_SIZE];
  read_input("input.txt", input);

  int store_idx;
  int store_counter = 0;

  while (1) {
    if ((store_idx = index_in_store(store, input)) >= 0) {
      printf("%d\n", store_idx);
      printf("Part one %d\nPart two %d\n", store_counter, store_counter - store_idx);
      return 0;
    } else {
      add_to_store(store, input, store_counter++);
      evolve(input);
    }
  }
}
