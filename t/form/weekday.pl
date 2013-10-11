% vim: ft=prolog
:- use_module(library(clpfd)).
:- use_module(library(julian)).
:- use_module(library(tap)).

form_time([2013-07-09, weekday]).
form_time([2013-07-01, weekday]).
form_time([2013-07-26, weekday]).
form_time([2013-07-31, weekday]).

'saturday is not a weekday'(fail) :-
    form_time([1996-11-16, weekday]).

'weekdays in second week of 1984' :-
    Day in 9..15,   % second week
    form_time([1984-09-Day, weekday], Dt),
    forall( member(DOW, [monday,tuesday,wednesday,thursday,friday])
          , form_time(dow(DOW), Dt)
          ),
    forall( member(DOW, [sunday,saturday])
          , \+ form_time(dow(DOW), Dt)
          ).
