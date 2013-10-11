% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

'random dates all match' :-
    get_time(Now),
    forall( between(1,100,_)
          , ( X is 2 * random_float * Now
            , form_time([unix(X), true])
            )
          ).
