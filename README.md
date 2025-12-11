# CS4337 Project 2 - Prolog Maze Solver

A Prolog program that solves mazes by finding paths from a start position to an exit.

## Overview

This project implements a maze solver in Prolog that can:
- **Find a path** from start to exit when given an unbound variable for actions
- **Verify a path** when given a specific list of actions
- **Validate mazes** to ensure they meet the required constraints

## Main Predicate

### `find_exit/2`

```prolog
find_exit(+Map, ?Actions)
```

- **Map**: A list of rows, where each row is a list of cells
- **Actions**: A list of actions (`up`, `down`, `left`, `right`) that solve the maze

When `Actions` is unbound, the predicate finds a path from start to exit.  
When `Actions` is bound, the predicate verifies that the given path is valid.

## Maze Representation

A maze is a list of rows, with each row being a list of cells. Valid cell types:

- `w` - wall (cannot be traversed)
- `f` - floor (empty space, can be traversed)
- `s` - start (exactly one required)
- `e` - exit (at least one required)

## Actions

- `left` - Move to the previous column
- `right` - Move to the next column
- `up` - Move to the previous row
- `down` - Move to the next row

## Requirements

- SWI-Prolog (tested with version 9.2.9)
- Install with: `brew install swi-prolog` (macOS) or your system's package manager

## Usage

### Loading the Program

```prolog
?- consult([project2,example]).
```

### Finding a Path

```prolog
?- simple_map(M), display_map(M), find_exit(M, A).
```

This will display the maze and find a path, binding `A` to the list of actions.

### Verifying a Path

```prolog
?- basic_map(M), find_exit(M, [down,left,down]).
```

This verifies that the given path is valid (succeeds) or invalid (fails).

### Generating Random Mazes

```prolog
?- consult([project2,test]).
?- gen_map(4, 10, 10, M), display_map(M), find_exit(M, A).
```

The `gen_map/4` predicate generates random mazes:
- First argument: complexity (4 is a good value)
- Second argument: number of rows
- Third argument: number of columns
- Fourth argument: the generated maze

## Example Mazes

The `example.pl` file contains several test mazes:

- `simple_map/1` - A simple 1x3 maze
- `basic_map/1` - A 3x3 maze with walls
- `basic_map2/1` - A 4x3 maze
- `bad_map/1`, `bad_map2/1`, `bad_map3/1`, `bad_map4/1` - Invalid mazes (for testing validation)

## Validation

The program validates that mazes:
- Are non-empty and rectangular (all rows same length)
- Have exactly one start (`s`)
- Have at least one exit (`e`)
- Contain only valid cell types (`w`, `f`, `s`, `e`)

Invalid mazes or paths will cause the predicate to fail.

## Testing

Run tests from the command line:

```bash
# Test with simple map
swipl -g "consult([project2,example]), simple_map(M), display_map(M), find_exit(M, A), write(A), nl, halt."

# Test path verification
swipl -g "consult([project2,example]), basic_map(M), find_exit(M, [down,left,down]), write('SUCCESS'), nl, halt."

# Test with random maze
swipl -g "consult([project2,test]), gen_map(4, 6, 6, M), find_exit(M, A), length(A, L), write(L), nl, halt."
```

## Implementation Details

- Uses depth-first search (DFS) to find paths
- Tracks visited cells to avoid cycles
- Validates each move (bounds checking, wall checking)
- Uses Prolog's backtracking to explore all possible paths

## Files

- `project2.pl` - Main implementation with `find_exit/2` predicate
- `example.pl` - Example mazes and `display_map/1` for pretty printing
- `test.pl` - Random maze generator (`gen_map/4`)

Gaurav Jena

CS4337 Project 2 - Fall 2025

