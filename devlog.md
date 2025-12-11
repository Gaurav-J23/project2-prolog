# Devlog — Project 2: Maze Solver (Prolog)

This devlog documents my progress, thoughts, plans, and debugging steps while completing CS4337 Project 2.

---

## 2025-12-10 — Project Setup (Session 1)
**Thoughts:**  
Today I started working on Project 2. I reviewed the PDF instructions and the example code provided (`example.pl` and `test.pl`). The project requires implementing `find_exit/2`, which must validate a maze, check a given movement sequence, or generate one.

**Plan for this session:**  
- Create GitHub repository and clone it using GitHub Desktop  
- Set up project folder structure in Cursor  
- Add project files: `project2.pl`, `example.pl`, `test.pl`, `README.md`, and this devlog  
- Begin writing basic helper predicates for maze validation  

**Work done:**  
- Created new GitHub repo and committed initial structure  
- Added the provided map and generator code into `example.pl` and `test.pl`  
- Wrote helper predicates: `count_cells/3`, `rectangular/2`, `all_cells_valid/1`  

---

## 2025-12-10 — Implementing Maze Validation (Session 2)
**Thoughts:**  
The assignment requires rejecting invalid mazes (`bad_map`, `bad_map2`, etc.). I needed to confirm exactly what makes a maze valid.

**Plan:**  
- Implement `valid_maze/1`  
- Ensure the maze is rectangular  
- Ensure it has exactly one `s` and at least one `e`  
- Ensure all symbols are from {w,f,s,e}  

**Work done:**  
- Completed `valid_maze/1`  
- Implemented rectangular checks and cell validity checks  
- Tested with:
  ```prolog
  ?- bad_map(M), valid_maze(M).  % should fail
