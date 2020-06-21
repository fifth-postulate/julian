### Model of Time

Julian thinks of time as an sequence of nanoseconds extending forever into the past and forever into the future.

Some of those nanoseconds are interesting and some aren't.  Some nanoseconds have convenient names.  For example, "now" might refer to the 65,633,104,895,232nd nanosecond since midnight on 11 October 2013.  Nanoseconds on the timeline are related, such as one occurring before another.

Most of what you do in Julian is selecting interesting subsets of the infinite timeline.  Sometimes those sets have only a single member.  Sometimes they have billions of contiguous members.  Othertimes they're discontiguous.


### Installation

Julian is distributed as an [SWI-Prolog pack](http://www.swi-prolog.org/pack/list?p=julian).  Using SWI-Prolog version 6.3 or later you can run the following command at a prompt to install it:

```prolog
?- pack_install(julian).
```

Most of the examples in this tutorial will be execute at the prompt.  Before they'll work, you have to import the Julian module.  Although it's not mandatory, it's often helpful to load `library(clpfd)` when working with Julian.  Many of the example is this tutorial use it.

```prolog
?- use_module(library(julian)).
?- use_module(library(clpfd)).
```


### A Single Moment

If everything worked, you can ask Julian about the current time:

```prolog
?- form_time(now, T).
T = datetime(56576, 67144791508992).
```

`T` represents a single moment on the infinite timeline.  Specifically, it's the 67144791508992nd nanosecond since midnight on modified Julian day number 56576.  That's an unpleasant way to view dates.  Let's try something more conventional:

```prolog
?- form_time(now, _T),
|  form_time(rfc3339(RFC), _T).
RFC = "2013-10-11T18:50:37.193167872".
```

I named the variable `_T` so that its value doesn't show up in the output.  The `|` character indicates that I pressed `Enter` after the comma on the first line.

Now `RFC` holds the current time formatted as an RFC3339 date string.


### How's That?

Julian has two representations of time.  One, called a "form", is a human-readable description like `now` or `2013-07-19`.  The other, called a "time", is the internal `datetime/2` term representation.  The predicate `form_time/2` describes the relationship between them.

In the previous example, I said that `now` and `_T` are the same thing.  I then said that `rfc3339(RFC)` is also the same thing.  For both statements to be true, `RFC` must unify with `"2013-10-11T18:50:37.193167872"`.

It's quite common to relate several forms to each other.  `form_time/1` does just that.  It takes a list of forms, each describing the same time.  The previous example could be written

```prolog
?- form_time([now, rfc3339(RFC)]).
RFC = "2013-10-11T19:02:18.62176896".
```

In English, that goal might be phrased as, "How is the current time represented in RFC3339 format?"  We don't care about Julian's internal representation, so it's not present anywhere in the query.


### Unix Epoch, `Y-M-D` and `H:M:S`

No time library is complete until it can handle Unix epoch seconds.  Julian's form for standard unix time is `unix(Seconds)`.  Let's relate a Unix time to an RFC3339 time, and vice versa:

```prolog
?- form_time([unix(1381518297), rfc3339(RFC)]).
RFC = "2013-10-11T19:04:57".

?- form_time([rfc3339("2013-10-11T19:04:57"), unix(U)]).
U = 1381518297.
```

_WARNING_: Unfortunately, form order does matter for some forms.  That's considered a bug.

`form_time` relations are multi-directional.  They can be used to convert a Unix time into an RFC3339 time or parse an RFC3339 time into a Unix time.  This works regardless which form you're using.

For example, the forms `Y-M-D` and `H:M:S` describe the year, month, day, hour, minute and second components of a time, respectively.

```prolog
?- form_time([unix(1381518297),Y-M-D]).
Y = 2013,
M = 10,
D = 11.

?- form_time([unix(1381518297),H:M:S]).
H = 19,
M = 4,
S = 57.

?- form_time([2013-10-11, 19:04:57, unix(U)]).
U = 1381518297.
```

Of course, this is Prolog.  One doesn't have to provide all components of a form.  Let's ask the question, "Is the current year 2012?"

```prolog
?- form_time([now, 2012-_-_]).
false.
```

Next: [Time Sets](sets.html)

