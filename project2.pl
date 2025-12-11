% project2.pl
%
% Main predicate:
%   find_exit(+Map, ?Actions)
%
% Map is a list of rows, each a list of cells:
%   w = wall
%   f = floor
%   s = start (exactly one)
%   e = exit  (at least one)
%
% Actions is a list of:
%   up, down, left, right
%
% Examples (with example.pl loaded):
%
% ?- basic_map(M), display_map(M), find_exit(M, A).
% ?- basic_map(M), find_exit(M, [down,left,down]).
% ?- gen_map(4,10,10,M), display_map(M), find_exit(M, A).

%%%%%%%%%%%%%%%%%%%%
%% Public predicate
%%%%%%%%%%%%%%%%%%%%

find_exit(Map, Actions) :-
    valid_maze(Map),
    start_coord(Map, Start),
    (   var(Actions)
    ->  % generate a path
        path_to_exit_generate(Map, Start, Actions)
    ;   % check a given path
        path_to_exit_check(Map, Start, Actions)
    ).

%%%%%%%%%%%%%%%%%%%%
%% Maze validation
%%%%%%%%%%%%%%%%%%%%

% Maze is valid if:
%  - non empty
%  - rectangular (all rows same length, cols > 0)
%  - exactly one start 's'
%  - at least one exit 'e'
%  - all cells are one of [w,f,s,e]

valid_maze(Map) :-
    nonvar(Map),
    Map = [FirstRow|_],
    FirstRow \= [],
    length(FirstRow, Cols),
    Cols > 0,
    rectangular(Map, Cols),
    count_cells(Map, s, SCount),
    SCount =:= 1,
    count_cells(Map, e, ECount),
    ECount >= 1,
    all_cells_valid(Map).

rectangular([], _).
rectangular([Row|Rest], Cols) :-
    length(Row, Cols),
    rectangular(Rest, Cols).

all_cells_valid([]).
all_cells_valid([Row|Rest]) :-
    all_row_cells_valid(Row),
    all_cells_valid(Rest).

all_row_cells_valid([]).
all_row_cells_valid([Cell|Rest]) :-
    member(Cell, [w,f,s,e]),
    all_row_cells_valid(Rest).

% count_cells(Map, Value, Count)

count_cells(Map, Value, Count) :-
    maplist(count_in_row(Value), Map, RowCounts),
    sum_list(RowCounts, Count).

count_in_row(Value, Row, Count) :-
    include(=(Value), Row, Filtered),
    length(Filtered, Count).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Access helpers and coords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start_coord(+Map, -Coord)

start_coord(Map, coord(R,C)) :-
    nth0(R, Map, Row),
    nth0(C, Row, s),
    !.  % there is exactly one, so cut after finding it

% cell_at(+Map, +Coord, -Cell)

cell_at(Map, coord(R,C), Cell) :-
    nth0(R, Map, Row),
    nth0(C, Row, Cell).

% dimensions(+Map, -Rows, -Cols)

dimensions(Map, Rows, Cols) :-
    length(Map, Rows),
    Map = [FirstRow|_],
    length(FirstRow, Cols).

% in_bounds(+Map, +Coord)

in_bounds(Map, coord(R,C)) :-
    R >= 0, C >= 0,
    dimensions(Map, Rows, Cols),
    R < Rows,
    C < Cols.

%%%%%%%%%%%%%%%%%%%%
%% Actions / moves
%%%%%%%%%%%%%%%%%%%%

valid_action(up).
valid_action(down).
valid_action(left).
valid_action(right).

% move(+Action, +Coord0, -Coord1)

move(up,    coord(R,C), coord(R1,C)) :- R1 is R - 1.
move(down,  coord(R,C), coord(R1,C)) :- R1 is R + 1.
move(left,  coord(R,C), coord(R,C1)) :- C1 is C - 1.
move(right, coord(R,C), coord(R,C1)) :- C1 is C + 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mode 1: Check given path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path_to_exit_check(+Map, +Start, +Actions)
% Succeeds if following Actions from Start ends at an exit
% and never goes off map or onto a wall.

path_to_exit_check(Map, Start, Actions) :-
    walk_actions(Map, Start, Actions, FinalCoord),
    cell_at(Map, FinalCoord, Cell),
    Cell = e.

% walk_actions(+Map, +Coord0, +Actions, -CoordFinal)

walk_actions(_, Coord, [], Coord).
walk_actions(Map, Coord0, [A|As], CoordFinal) :-
    valid_action(A),
    move(A, Coord0, Coord1),
    in_bounds(Map, Coord1),
    cell_at(Map, Coord1, Cell),
    Cell \= w,                    % cannot move onto a wall
    walk_actions(Map, Coord1, As, CoordFinal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mode 2: Generate a path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path_to_exit_generate(+Map, +Start, -Actions)
% Generates a sequence of actions that leads from Start to an exit
% Never revisits the same cell (simple path).

path_to_exit_generate(Map, Start, Actions) :-
    path_dfs(Map, Start, [Start], Actions).

% path_dfs(+Map, +Current, +Visited, -Actions)

% Base case: current cell is exit, no more actions.
path_dfs(Map, Coord, _, []) :-
    cell_at(Map, Coord, Cell),
    Cell = e.

% Recursive case: current not exit, choose a move and continue.
path_dfs(Map, Coord0, Visited, [A|As]) :-
    cell_at(Map, Coord0, Cell0),
    Cell0 \= e,
    valid_action(A),
    move(A, Coord0, Coord1),
    in_bounds(Map, Coord1),
    \+ member(Coord1, Visited),
    cell_at(Map, Coord1, Cell1),
    Cell1 \= w,
    path_dfs(Map, Coord1, [Coord1|Visited], As).
