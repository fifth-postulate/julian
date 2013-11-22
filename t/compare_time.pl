% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

:- set_prolog_flag(double_quotes, codes).

'precisely known times' :-
    form_time(rfc3339("2000-01-02T03:04:05.0678"), A),
    form_time(rfc3339("2001-02-03T04:05:06.0789"), B),
    compare_time(<,A,B),
    \+ compare_time(=,A,B),
    \+ compare_time(>,A,B),
    compare_time(O,A,B),
    O == (<).

'minutes of adjacent days' :-
    form_time([2006-12-09, 08:17:_], A),
    form_time([2006-12-10, 08:17:_], B),
    compare_time(<,A,B),
    \+ compare_time(=,A,B),
    \+ compare_time(>,A,B),
    compare_time(O,A,B),
    O == (<).

'adjacent days' :-
    form_time([1983-02-28], A),
    form_time([1983-03-01], B),
    compare_time(<,A,B),
    \+ compare_time(=,A,B),
    \+ compare_time(>,A,B),
    compare_time(O,A,B),
    O == (<).

'a day and the preceding year' :-
    form_time([2000-02-29], A),
    form_time([1999-_-_], B),
    \+ compare_time(<,A,B),
    \+ compare_time(=,A,B),
    compare_time(>,A,B),
    compare_time(O,A,B),
    O == (>).

'describing future dates' :-
    form_time(2013-08-02, Today),
    compare_time(<,Today,Future),
    forall( member(YMD, [2013-08-03, 2013-08-04, 2014-_-_])
          , form_time(YMD, Future)
          ),
    forall( member(YMD, [2013-08-01, 2013-07-31, 2012-_-_])
          , \+ form_time(YMD, Future)
          ).

'form against form' :-
    compare_time( O
                , rfc3339("2007-06-05T04:03:01")
                , rfc3339("1970-12-31T23:47:18.729")
                ),
    O == (>).
