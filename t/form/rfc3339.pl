% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

:- set_prolog_flag(double_quotes, codes).

parsing :-
    form_time(rfc3339("2013-07-26T17:58:08.000Z"), Dt),
    form_time(2013-07-26, Dt),
    form_time(17:58:08.000, Dt).

'parsing at midnight' :-
    form_time(rfc3339("2013-07-28T00:00:00.000Z"), Dt),
    form_time(Y-Mon-D, Dt),
    Y =:= 2013,
    Mon =:= 7,
    D =:= 28,
    form_time(H:Min:S, Dt),
    H =:= 0,
    Min =:= 0,
    S =:= 0.

formatting :-
    form_time(unix(1374876170), Dt), form_time(rfc3339(T), Dt),
    T = "2013-07-26T22:02:50".

'formatting with fractional seconds' :-
    form_time(unix(1374876170.2), Dt), form_time(rfc3339(T), Dt),
    T = "2013-07-26T22:02:50.200000".

'formatting with zero seconds' :-
    form_time(rfc3339(T), datetime(56220, 43260000000000)),
    T == "2012-10-20T12:01:00".
