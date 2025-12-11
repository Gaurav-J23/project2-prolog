# Devlog — Project 2: Maze Solver (Prolog)

This devlog documents my progress, thoughts, plans, and debugging steps while completing CS4337 Project 2.

---

## 2025-12-10 18:24:00 — Project Initialization

**What I know about the project:**

This project requires implementing a Prolog program that can solve mazes. The main predicate is `find_exit/2`, which takes a maze representation and either:
- Verifies a given sequence of actions (when Actions is bound)
- Generates a sequence of actions to solve the maze (when Actions is unbound)

The maze is represented as a list of rows, where each row is a list of cells. Valid cell types are:
- `w` - wall (cannot be traversed)
- `f` - floor (empty space, can be traversed)  
- `s` - start position (exactly one required)
- `e` - exit position (at least one required)

Actions are: `up`, `down`, `left`, `right`, which move the current position accordingly.

The project includes:
- `example.pl` - Contains example mazes and a `display_map/1` predicate for visualization
- `test.pl` - Contains `gen_map/4` for generating random mazes for testing

**Overall planning:**

1. **Maze Validation**: Implement validation to ensure mazes are:
   - Rectangular (all rows same length)
   - Have exactly one start (`s`)
   - Have at least one exit (`e`)
   - Contain only valid cell types

2. **Path Verification**: When Actions is bound, verify that:
   - The path starts at the start position
   - Each action is valid (doesn't go out of bounds or into walls)
   - The path ends at an exit

3. **Path Generation**: When Actions is unbound, use a search algorithm (likely DFS) to:
   - Find a path from start to exit
   - Avoid revisiting cells (prevent cycles)
   - Return the sequence of actions

4. **Testing**: Test with:
   - Simple example mazes from `example.pl`
   - Invalid mazes to ensure proper rejection
   - Randomly generated mazes from `test.pl`

5. **Documentation**: Create a comprehensive README.md explaining usage and examples.

I'm planning to use Prolog's natural backtracking mechanism for the path generation, which should make the implementation elegant. The key challenge will be tracking visited cells to avoid infinite loops in the search.
