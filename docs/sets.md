---
layout: default
title: Tutorial - Time Sets
---

### More Than 1 Nanosecond

Not all times we care about represent a single nanosecond.  For example, we speak of "today" and "the year 1973", each of which represents _many_ nanoseconds.  Julian can represent those too:

```prolog
?- form_time(today, T).
T = datetime(56576, _G522),
_G522 in 0..86399999999999.
```

Again, this is Julian's internal representation.  The modified Julian day is known precisely (`56576`) but the nanosecond portion is not (`_G522 in 0..86399999999999`).  The [in/2](http://www.swi-prolog.org/pldoc/doc_for?object=clpfd:in/2) constraint says that we care about all times between midnight and the very last nanosecond of the day.

For our current purposes, think of the constraint as describing a set of all  nanoseconds we care about.  Maybe we only care about nanoseconds that have passed since today's midnight:

```prolog
?- form_time([today, before(now)], T).
_G464 in 0..70983007080191,
...
```

(I trimmed off some other constraints for the sake of clarity)  The nanosecond portion of `T` (`_G464`) is constrained to only some of today's nanoseconds.  The form `before(T)` matches all nanoseconds prior to time `T`.

The "year 1973" could be described with the form `1973-_-_`.


### Disjoint Sets

In the above examples, all the selected nanoseconds are contiguous.  We often care about times for which that's not the case.  For example, all Sundays in history:

```prolog
?- form_time(dow(sunday), T).
T = datetime(_G924, _G925),
_G924+2#=_G934,
_G934 mod 7#=6.
```

The internals just say that Sundays are those modified Julian days with a specific value `mod 7`.  This constraint has selected little chunks of the infinite timeline representing those nanoseconds which fall on a Sunday.  For example, "what dates are Sunday in October 2013?"

```prolog
?- form_time([dow(sunday), 2013-10-D], _T), date(_T).
D = 6 ;
D = 13 ;
D = 20 ;
D = 27 .
```

`date/1` unifies its argument with each unique day that matches the constraints, from earliest to most recent.  `date/1` and its friend `findall_dates/2` are especially helpful when we care about time at day resolution instead of nanosecond resolution.


Previous: [Basics](basics.html)
Next: [Constraints](constraints.html)
