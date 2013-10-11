% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).


'dow(thursday), forward' :-
    form_time(gregorian(1970,1,1), Dt),
    form_time(dow(thursday), Dt).
'dow(thursday), backward' :-
    form_time(gregorian(1970,1,1), Dt),
    form_time(dow(Weekday), Dt),
    Weekday = thursday.
'dow(thursday), compound' :-
    form_time([dow(Weekday), gregorian(1970,1,1)], _),
    Weekday = thursday.


'several days' :-
    form_time(dow([monday,tuesday]), Dt),
    forall( member(YMD,[2013-07-29, 2013-07-30])
          , form_time(YMD, Dt)
          ),
    forall( member(YMD,[2013-07-28])
          , \+ form_time(YMD, Dt)
          ).
