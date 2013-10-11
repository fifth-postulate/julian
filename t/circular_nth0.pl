% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

'lookup: works like nth0' :-
    Xs = [a,b,c,d,e],
    julian:circular_nth0(0, Xs, A),
    julian:circular_nth0(1, Xs, B),
    julian:circular_nth0(2, Xs, C),
    julian:circular_nth0(3, Xs, D),
    julian:circular_nth0(4, Xs, E),
    \+ julian:circular_nth0(5, Xs, _),
    A == a,
    B == b,
    C == c,
    D == d,
    E == e.

'lookup: negative indexes' :-
    Xs = [a,b,c,d,e],
    julian:circular_nth0(-5, Xs, A),
    julian:circular_nth0(-4, Xs, B),
    julian:circular_nth0(-3, Xs, C),
    julian:circular_nth0(-2, Xs, D),
    julian:circular_nth0(-1, Xs, E),
    \+ julian:circular_nth0(-6, Xs, _),
    A == a,
    B == b,
    C == c,
    D == d,
    E == e.
