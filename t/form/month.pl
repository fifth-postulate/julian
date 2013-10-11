% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).


'month(april), forward' :-
    form_time(gregorian(1970,4,1), Dt),
    form_time(month(april), Dt).
'month(april), backward' :-
    form_time(gregorian(1970,4,1), Dt),
    form_time(month(Month), Dt),
    Month = april.
'month(april), compound' :-
    form_time([month(Month), gregorian(1970,4,1)], _),
    Month = april.


'multiple months' :-
    form_time(month([january,august]), Dt),
    forall( member(YMD,[2013-08-29, 2013-01-30])
          , form_time(YMD, Dt)
          ),
    forall( member(YMD,[2013-06-28])
          , \+ form_time(YMD, Dt)
          ).
