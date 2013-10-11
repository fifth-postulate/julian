% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

future :-
    form_time(now, Now),
    form_time(future, Future),
    compare_time(<,Now,Future),
    \+ compare_time(=,Now,Future),
    \+ compare_time(>,Now,Future).

past :-
    form_time(past, Past),
    form_time(now, Now),
    compare_time(<,Past,Now),
    \+ compare_time(=,Past,Now),
    \+ compare_time(>,Past,Now).

after :-
    form_time(after([2014-09-17,final_moment]), A),
    forall( member(X, [2014-09-18, 2015-_-_])
          , form_time(X, A)
          ),
    forall( member(X, [2014-09-16, [2014-09-17,noon]])
          , \+ form_time(X, A)
          ).

before :-
    form_time(before([2014-09-17,noon]), A),
    forall( member(X, [2014-09-16, [2014-09-17,midnight],2013-_-_])
          , form_time(X, A)
          ),
    forall( member(X, [2014-09-18, 2015-_-_])
          , \+ form_time(X, A)
          ).
