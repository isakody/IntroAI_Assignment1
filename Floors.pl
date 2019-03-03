not_adjacent(X, Y, [X, Z | T]) :-
	Z \== Y,
	member(Y, T).
not_adjacent(X, Y, [Y, Z | T]) :-
	Z \== X,
	member(X, T).
not_adjacent(X, Y, [_ | T]) :-
	not_adjacent(X, Y, T).

    


floors :-
    Solution = [
        [1,_],
        [2,_],
        [3,_],
        [4,_],
        [5,_]
    ],
    member([A,adam], Solution), A \== 5,
    member([B,bill], Solution), B \== 1,
    member([C,claire], Solution), C \== 1, C \== 5,
    member([D,david], Solution), D > B, 
    member([E,eric], Solution),
    not_adjacent(E,C, [1,2,3,4,5]),
    not_adjacent(C,B, [1,2,3,4,5]),
    write(Solution). 