% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

midnight :-
    form_time(midnight, T),
    form_time(H:M:S, T),
    H =:= 0,
    M =:= 0,
    S =:= 0.

noon :-
    form_time(noon, T),
    form_time(H:M:S, T),
    H =:= 12,
    M =:= 0,
    S =:= 0.

final_moment :-
    form_time(final_moment, T),
    form_time(H:M:S, T),
    H =:= 23,
    M =:= 59,
    S > 59.999.
