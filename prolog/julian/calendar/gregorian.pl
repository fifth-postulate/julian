:- module(julian_calendar_gregorian,
          [ gregorian/3
          , month_number/2
          ]
         ).
:- use_module(library(clpfd)).
:- use_module(library(delay), [delay/1]).

%%	gregorian(?Year, ?Month, ?Day) is semidet.
%
%	Constrain Year, Month and Day to a valid date in the Gregorian
%	calendar.  For example, one could iterate all leap years
%	since 1950 with this:
%
%	==
%	gregorian(Y, 2, 29), Y #> 1950, indomain(Y).
%	==
%
%	Because it just constrains Year, Month and Day to have the
%	proper relation one to another, one can bind as many or
%	as few of the arguments as desired.
gregorian(Y,M,D) :-
    Y in -4713..3267,
    M in 1..12,
    (   (D in 1..28)
    #\/ (M #\= 2 #/\ D in 29..30)
    #\/ (M in 1 \/ 3 \/ 5 \/ 7 \/ 8 \/ 10 \/ 12 #/\ D #= 31)
    #\/ (M #= 2 #/\ D #= 29 #/\ Y mod 400 #= 0)
    #\/ (M #= 2 #/\ D #= 29 #/\ Y mod 4 #= 0 #/\ Y mod 100 #\= 0)
    ).


%%	month_number(+Month:atom, -Number:integer) is semidet.
%%	month_number(-Month:atom, +Number:integer) is semidet.
%%	month_number(-Month:atom, -Number:integer) is multi.
%
%   True if Number is the number for Month. 1 is January, 12 is
%   December. Month is an atom like `march`, `august`, etc.
%
%   This predicate supports `library(delay)`.
:- multifile delay:mode/1.
delay:mode(julian_calendar_gregorian:month_number(ground,_)).
delay:mode(julian_calendar_gregorian:month_number(_,ground)).
month_number(january,   1).
month_number(february,  2).
month_number(march,     3).
month_number(april,     4).
month_number(may,       5).
month_number(june,      6).
month_number(july,      7).
month_number(august,    8).
month_number(september, 9).
month_number(october,  10).
month_number(november, 11).
month_number(december, 12).
