% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

midnight :-
    form_time(00:00:00, Dt),
    datetime(Dt, _, 0).
