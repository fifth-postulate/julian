% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).


% single dates
form_time(gregorian(2013,3,16), datetime(56367, _)).

form_time(gregorian(1970,1,1), datetime(40587, _)).
