:- module(julian_util, [dow_number/2]).

%%	dow_number(+DayOfWeek:atom, -Number:integer) is semidet.
%%	dow_number(-DayOfWeek:atom, +Number:integer) is semidet.
%%	dow_number(-DayOfWeek:atom, -Number:integer) is multi.
%
%	True if Number is the ISO number for DayOfWeek.
%   0 is Monday, 6 is Sunday. DayOfWeek is an atom like `monday`,
%   `tuesday`, `sunday`, etc.
%
%   This predicate supports `library(delay)`.
:- multifile delay:mode/1.
delay:mode(julian_util:dow_number(ground,_)).
delay:mode(julian_util:dow_number(_,ground)).

dow_number(monday,    0).
dow_number(tuesday,   1).
dow_number(wednesday, 2).
dow_number(thursday,  3).
dow_number(friday,    4).
dow_number(saturday,  5).
dow_number(sunday,    6).
