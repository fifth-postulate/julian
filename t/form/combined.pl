% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

'may, second friday' :-
    X = [month(may),nth(2,dow(friday))],
    form_time(2013-M-D, Dt),
    form_time(X, Dt),
    M =:= 5,
    D =:= 10.

% this test fails because the nth/2 constraint comes before the
% month/1 constraint.  either order should work fine
'second friday, may'(todo('fix order dependence')) :-
    X = [nth(2,dow(friday)), month(may)],
    form_time(2013-M-D, Dt),
    form_time(X, Dt),
    M =:= 5,
    D =:= 10.
