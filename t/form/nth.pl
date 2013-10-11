% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

'fifth monday, July 2013' :-
    form_time([2013-07-Day, nth(5, dow(monday))]),
    Day =:= 29.

'second weekday, Februray 2002' :-
    form_time([2002-02-Day, nth(2, weekday)]),
    Day =:= 4.

'final weekday, August 2013' :-
    form_time([2013-08-Day, nth(-1, weekday)]),
    Day =:= 30.

'second and fourth Sunday' :-
    Form = nth([2,4], dow(sunday)),
    forall( member(X, [2013-08-11, 2013-08-25])
          , form_time([X,Form])
          ),
    forall( member(X, [2013-08-18, 2002-02-09])
          , \+ form_time([X,Form])
          ).
