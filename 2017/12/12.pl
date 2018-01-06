connected(X, X).
connected(X, Y) :- edge(X, Y).
connected(X, Y) :- not(edge(X, Y)), edge(Y, X).

reachable(X, Y, Visited, [X|Visited]) :- connected(X, Y).
reachable(X, Y, Visited, Path) :-
    connected(X, Z),
    Z \== Y,
    \+member(Z, Visited),
    reachable(Z, Y, [Z|Visited], Path).

ingroup(X, Y) :- reachable(X, Y, [X], _).
partone(N) :- setof(X, ingroup(0, X), L), length(L, N).
