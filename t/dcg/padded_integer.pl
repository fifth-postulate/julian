% vim: ft=prolog
:- use_module(library(julian)).
:- use_module(library(tap)).

:- set_prolog_flag(double_quotes, codes).

'parsing a four digit year' :-
    phrase(julian:padded_integer(4,N), "2013"),
    N =:= 2013.

'building a four digit year' :-
    phrase(julian:padded_integer(4,2013), Year),
    Year == "2013".

'parsing two digits with a leading 0' :-
    phrase(julian:padded_integer(2,N), "03"),
    N =:= 3.

'building two digits with a leading 0' :-
    phrase(julian:padded_integer(2,3), Month),
    Month == "03".

'parsing unknown digits with a leading 0' :-
    phrase(julian:padded_integer(W,N), "03"),
    W =:= 2,
    N =:= 3.

'parsing a 3-digit zero' :-
    phrase(julian:padded_integer(3,N), "000"),
    N =:= 0.

'building a 3-digit zero' :-
    phrase(julian:padded_integer(3,0), Zero),
    Zero == "000".

'parsing an unknown zero' :-
    phrase(julian:padded_integer(W,N), "000"),
    W =:= 3,
    N =:= 0.

'parsing leading numbers' :-
    phrase(julian:padded_integer(W,N), "2013-", "-"),
    W =:= 4,
    N =:= 2013.
