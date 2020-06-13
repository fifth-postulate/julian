# julian
A date and time library for Prolog.

*Warning*:  This is _alpha_ quality software.  APIs will change.  There are bugs.  Use with caution.  Time zones are not yet supported and semantics that should account for time zone choose arbitrary, unpredictable behavior.

With that out of the way, the library can do a lot of useful stuff.  See the [in-depth tutorial][tutorial] for examples.

## Synopsis

```
:- use_module(library(julian)).
:- use_module(library(clpfd)).
solution(Year) :-
    % Eisenhower presidency had Fourth of July on Sunday in ...
    form_time([dow(sunday), Year-07-04]),
    Year in 1953..1961.
    
?- solution(Y).
Y = 1954.
```

## Installation

Using SWI-Prolog 7.1.18 or later:

```
?- pack_install(julian).
```

This module uses [semantic versioning][versioning].

Source code available and pull requests accepted at [`http://github.com/fifth-postulate/julian`][project]

[tutorial]: http://fifth-postulate.github.io/julian/
[versioning]: http://semver.org/
[project]: http://github.com/fifth-postulate/julian`