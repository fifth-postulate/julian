# Synopsis

    :- use_module(library(julian)).
    :- use_module(library(clpfd)).
    solution(Year) :-
        % Eisenhower presidency had Fourth of July on Sunday in ...
        form_time([dow(sunday), Year-07-04]),
        Year in 1953..1961.

    ?- solution(Y).
    Y = 1954.

# Description

*Warning*:  This is _alpha_ quality software.  APIs will change.  There are bugs.  Use with caution.  Time zones are not yet supported and semantics that should account for time zone choose arbitrary, unpredictable behavior.

With that out of the way, the library can do a lot of useful stuff.  See the [in-depth tutorial](http://mndrix.github.io/julian/) for examples.

# Installation

Using SWI-Prolog 7.1.18 or later:

    ?- pack_install(julian).

This module uses [semantic versioning](http://semver.org/).

Source code available and pull requests accepted at
http://github.com/mndrix/julian

@author Michael Hendricks <michael@ndrix.org>
@license BSD
