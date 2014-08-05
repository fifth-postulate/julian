% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

:- set_prolog_flag(double_quotes, codes).

'ns(_) : precise times'(todo('parse fractional seconds')) :-
    form_time(rfc3339("2000-01-02T03:04:05.0678"), A),
    form_time(rfc3339("2001-02-03T04:05:06.0789"), B),
    delta_time(A, ns(Nanos), B),
    Nanos =:= 34390861011100000.

'ns(_) : precise forms'(todo('parse fractional seconds')) :-
    delta_time( rfc3339("2000-01-02T03:04:05.0678")
              , ns(Nanos)
              , rfc3339("2001-02-03T04:05:06.0789")
              ),
    Nanos =:= 34390861011100000.

's(_) : precise times' :-
    form_time([1999-12-31,23:59:59], NewYears),
    form_time([2000-01-01,00:00:00], Y2K),
    delta_time(NewYears, s(Seconds), Y2K),
    Seconds =:= 1.

'ms(_) : precise forms' :-
    delta_time( rfc3339("2000-01-02T03:04:05.0678")
              , ms(Millis)
              , rfc3339("2001-02-03T04:05:06.0789")
              ),
    Millis =:= 34390861011.

'adding seconds' :-
    form_time([2012-10-20, 12:00:13], Start),
    delta_time(Start, s(47), rfc3339(End)),
    End == "2012-10-20T12:01:00".

'subtracting seconds' :-
    form_time([2012-10-20,12:01:00], End),
    delta_time(rfc3339(Start), s(47), End),
    Start == "2012-10-20T12:00:13".


'days(_) : precise dates' :-
    form_time([1999-12-31], NewYears),
    form_time([2000-01-01], Y2K),
    delta_time(NewYears, days(Days), Y2K),
    Days =:= 1.

'adding days' :-
    form_time([2012-10-20], Start),
    delta_time(Start, days(47), Y-M-D),
    Y =:= 2012,
    M =:= 12,
    D =:= 6.

'subtracting days' :-
    form_time([2012-12-06], End),
    delta_time(Y-M-D, days(47), End),
    Y =:= 2012,
    M =:= 10,
    D =:= 20.
