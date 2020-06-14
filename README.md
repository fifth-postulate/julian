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

## Development

### Testing
Test are written with the _Test Anything Protocol_ ([TAP][tap]) and use the [`fnogatz/tap`][pack(tap)] library.

To install the tap pack run

```prolog
?- pack_install(tap).
```

A TAP test harness should be used to run the tests in this project. To run the `t/types.pl` test on could execute

```sh
prove -v -e 'swipl -q -t main -s' t/types.pl
```

To run all test one could use

```sh
prove -v -e 'swipl -q -t main -s' t/**.pl
```


[tutorial]: http://fifth-postulate.github.io/julian/
[versioning]: http://semver.org/
[project]: http://github.com/fifth-postulate/julian
[tap]: http://testanything.org/tap-specification.html
[pack(tap)]: https://github.com/fnogatz/tap