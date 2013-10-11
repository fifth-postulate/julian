% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(julian/calendar/gregorian)).
:- use_module(library(tap)).

% Correct dates in the Gregorian calendar
gregorian(1970,5,1).
gregorian(2013,3,16).


% Incorrect dates in the Gregorian calendar
'32nd of May'(fail) :-
    gregorian(2012,5,32).

'zeroth day of a month'(fail) :-
    gregorian(1927,11,0).

'thirteenth month of a year'(fail) :-
    gregorian(1956,13,19).


% Test leap year rules
'1900'(fail) :-
    gregorian(1900,2,29).

'2000' :-
    gregorian(2000,2,29).

'2012' :-
    gregorian(2012,2,29).

'2013'(fail) :-
    gregorian(2013,2,29).

'2014'(fail) :-
    gregorian(2014,2,29).

'2016' :-
    gregorian(2016,2,29).
