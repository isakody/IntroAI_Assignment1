:- dynamic
wumpusAlive/1.

    %%% FACTS %%%

% game info %
mapSize(5).
gold(5,5).
agent(1,1).
wumpus(5,4).
wumpusAlive(true).
pit(3,1). 
pit(1,5).
pit(4,2).


play :-
    resetGame(),
    format("THE GAME STARTS~n~n"),
    format("With this board:~n"),
    printMap([]),
    agent(X, Y),
    checkCell(X, Y, [], []).

% check cell %
/*  check if there is the gold, 
    if not, check if the cell is good:
    * not visited already.
    * no close to a pit because I'd die.
    * kill wumpus if its near.
    if everything good then move.
*/
checkCell(X, Y, VisitedList, MoveList) :-
    (glitter(X, Y) ->
        % if gold is found, print the board and the moves.
        (   printMap(VisitedList), 
            print(MoveList), 
            format('~n'),
            printScore(MoveList),
            printWumpusKilled()
        ); 
        % if not, add cell to visited list and move.
        (   \+member((X,Y), VisitedList),   % cell not visited
            \+breeze(X,Y),                  % no pit near
            (stench(X,Y) -> 
                % if wumpus near, shoot arrow and kill it, then move.
                (   shoot(X,Y),
                    append([(X,Y)], VisitedList, NewVisitedList),
                    move(X,Y,NewVisitedList, MoveList)
                );
                % if no wumpus near, add cell to visited list and move.  
                (   append([(X,Y)], VisitedList, NewVisitedList),
                    move(X,Y,NewVisitedList, MoveList)
                )
            )
        )
    ).    


    %%% Moves %%%
/* for each move:
    * 1: check position not out of map.
    * 2: add direction to moveList.
    * 3: checkCell.
*/

% Right
move(X, Y, VisitedList, MoveList) :-
    NewY is Y + 1, mapSize(MapSize), NewY =< MapSize, 
    append(MoveList, ["right"], NewMoveList),
    checkCell(X, NewY, VisitedList, NewMoveList).

% Up
move(X, Y, VisitedList, MoveList) :-
    NewX is X + 1, mapSize(Size), NewX =< Size, 
    append(MoveList, ["up"], NewMoveList), 
    checkCell(NewX, Y, VisitedList, NewMoveList).  
    

% Left
move(X, Y, VisitedList, MoveList) :-
    NewY is Y - 1, NewY > 0,    
    append(MoveList, ["left"], NewMoveList),
    checkCell(X, NewY, VisitedList, NewMoveList).

% Down
move(X, Y, VisitedList, MoveList) :-
    NewX is X - 1, NewX > 0,    
    append(MoveList, ["down"], NewMoveList),
    checkCell(NewX, Y, VisitedList, NewMoveList).



    %%% Shoot %%%
% Right
shoot(X,Y) :-
    NewY is Y + 1, mapSize(MapSize), NewY =< MapSize,
    (wumpus(X,NewY) -> 
        retractall(wumpusAlive(_)),
        assertz(wumpusAlive(false))
    ). 

% Up
shoot(X,Y) :-
    NewX is X + 1, mapSize(Size), NewX =< Size, 
    (wumpus(NewX,Y) -> 
        retractall(wumpusAlive(_)),
        assertz(wumpusAlive(false))
    ). 

% Left
shoot(X,Y) :-
    NewY is Y - 1, NewY > 0,  
    (wumpus(X,NewY) -> 
        retractall(wumpusAlive(_)),
        assertz(wumpusAlive(false))
    ). 

% Down
shoot(X,Y) :-
    NewX is X - 1, NewX > 0, 
    (wumpus(NewX,Y) -> 
        retractall(wumpusAlive(_)),
        assertz(wumpusAlive(false))
    ). 




    %%% Percepts %%%

% if the player is in the same cell as the gold.
glitter(X,Y) :-
    gold(X, Y).

% if the player is near a pit
breeze(X,Y) :-
    Right is X + 1,
    Left is X - 1,
    Up is Y + 1,
    Down is Y - 1,
    (pit(Right,Y); pit(Left,Y); pit(X,Up); pit(X,Down)).

% if the player is near the wumpus
stench(X,Y) :-
    wumpusAlive(true),
    Right is X + 1,
    Left is X - 1,
    Up is Y + 1,
    Down is Y - 1,
    (wumpus(Right,Y); wumpus(Left,Y); wumpus(X,Up); wumpus(X,Down)).


    %%% AUX %%%
resetGame() :-
    retractall(wumpusAlive(_)),
    assertz(wumpusAlive(true)).


    %%% OUTPUT %%%

% printMap prints the board.
printMap(VisitedList) :-
    mapSize(N),
    printMapRows(N, VisitedList).

% printMapRows recursively prints all rows from 5 to 1 (top to bottom).
printMapRows(CurrentRow, VisitedList) :-
    printMapCols(CurrentRow, 1, VisitedList),
    NewRow is CurrentRow - 1,
    NewRow >= 1 -> printMapRows(NewRow, VisitedList);
    format('~n').

% printMapCols recursively prints all columns from 1 to 5 (left to right).
printMapCols(CurrentRow, CurrentColumn, VisitedList) :-
    printMapCell(CurrentRow, CurrentColumn, VisitedList),
    NewColumn is CurrentColumn + 1,
    mapSize(Y), 
    NewColumn =< Y -> printMapCols(CurrentRow, NewColumn, VisitedList); 
    format('~n'). 

% printMapCell prints the cell
/*  * P for pits.           * G for gold.
    * W for alive wumpus.   * X for dead wumpus.
    * _ for empty space.    * O for player's path.
*/
printMapCell(CurrentX, CurrentY, VisitedList) :-
    wumpus(CurrentX, CurrentY) ->  
        (wumpusAlive(true) -> 
            format("W ");
            (member((CurrentX, CurrentY), VisitedList) ->
                format("% ");
                format("X ")
            )
        );
    member((CurrentX, CurrentY), VisitedList) -> format("O ");
    pit(CurrentX, CurrentY) ->  format("P ");
    gold(CurrentX, CurrentY) ->  format("G ");  
    format("_ ").

printScore(MoveList) :-
    length(MoveList, N),
    format("The player found the gold in "),
    format(N),
    format(" moves."),
    format('~n').

printWumpusKilled() :-
    wumpusAlive(true) ->
        format("Wumpus was not killed by the player.");
        format("Wumpus was killed by the player.").
