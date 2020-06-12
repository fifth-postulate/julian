---
layout: default
title: Tutorial - Constraints
---

### Beyond `form_time`

[form_time/2](http://www.swi-prolog.org/pack/file_details/julian/prolog/julian.pl) supports many useful forms.  No matter how powerful, specific applications will want to support additional, one-off constraints.  Because Julian is built on top of [library(clpfd)](http://www.swi-prolog.org/pldoc/man?section=clpfd), you can use its full power when working with dates.

For example, the [Wikipedia article on US presidential elections](https://en.wikipedia.org/wiki/United_States_presidential_election) says that they are held "quadrennially (the count beginning with the year 1792) on Election Day, the Tuesday between November 2 and 8".  How would we select all election days in US history?

```prolog
?- form_time([dow(tuesday), Y-11-D], _T),  % tuesday in November
|    Y #>= 1792,    % beginning with 1792
|    0 #= Y mod 4,  % quadrennially
|    D in 2..8,     % "between November 2 and 8"
|    date(_T).
Y = 1792,
D = 6 ;
Y = 1796,
D = 8 ;
Y = 1800,
D = 4 ;
...
```

### Extending `form_time`

An application or a library might want to define its own form as a shortcut for a custom constraint.  For example, we can imagine a hypothetical `library(julian/us/politics)`.  It wants to implement a form `presidential_election` which behaves like the example above.  Can it be done?

Yes. Fortunately, `form_time/2` is declared `multifile`.  The following should do the trick:

```prolog
:- multifile julian:form_time/2.
julian:form_time(presidential_election, Dt) :-
    datetime(Dt),
    !,  % help indexer: no other rules apply
    form_time([dow(tuesday), Y-11-D], Dt),
    Y #>= 1792,
    0 #= Y mod 4,
    D in 2..8.
```

Previous: [Time Sets](sets.html)
