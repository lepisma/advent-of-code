// Advent of code day 06

#include <stdio.h>
#include <stdlib.h>

#define INPUT_SIZE 16
#define STORE_INIT_SIZE 1000

typedef struct {
  int size;
  int capacity;
  int *data;
} Store;

void store_init(Store *store) {
  store->size = 0;
  store->capacity = STORE_INIT_SIZE;
  store->data = malloc(sizeof(int) * store->capacity * INPUT_SIZE);
}

void store_add(Store *store, int array[]) {
  if (store->size >= store->capacity) {
    store->capacity *= 2;
    store->data = realloc(store->data, sizeof(int) * store->capacity * INPUT_SIZE);
  }

  store->size++;
  for (int i = 0; i < INPUT_SIZE; i++) {
    store->data[(store->size - 1) * INPUT_SIZE + i] = array[i];
  }
}

int store_index(Store *store, int array[]) {
  int idx = -1;
  for (int i = 0; i < store->size; i++) {
    int match = 0;
    for (int j = 0; j < INPUT_SIZE; j++) {
      if (store->data[(i * INPUT_SIZE) + j] == array[j]) match++;
    }
    if (match == INPUT_SIZE) {
      idx = i;
      break;
    }
  }
  return idx;
}

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
  read_input("input.txt", input);
  Store store;
  store_init(&store);

  int store_idx;
  while (1) {
    if ((store_idx = store_index(&store, input)) >= 0) {
      printf("Part one %d\nPart two %d\n", store.size, store.size - store_idx);
      return 0;
    } else {
      store_add(&store, input);
      evolve(input);
    }
  }
}
