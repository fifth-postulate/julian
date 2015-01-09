:- module(julian, [ compare_time/3
                  , date/1
                  , datetime/1
                  , datetime/3
                  , delta_time/3
                  , findall_dates/2
                  , form_time/2
                  , form_time/1
                  ]).
:- use_module(library(julian/calendar/gregorian), [gregorian/3, month_number/2]).
:- use_module(library(julian/util), [dow_number/2]).

:- use_module(library(clpfd)).
:- use_module(library(error), []).
:- use_module(library(typedef)).
:- use_module(library(when), [when/2]).
:- use_module(library(dcg/basics), [float//1, integer//1, string//1]).
:- use_module(library(list_util), [xfy_list/3]).
:- use_module(library(delay), [delay/1]).

% many clpfd constraints trigger this warning.
% disable it for now.
:- style_check(-no_effect).

% define types
:- multifile error:has_type/2.
error:has_type(datetime, Dt) :-
    datetime(Dt).
:- type duration ---> days(integer)
                    ; s(integer)
                    ; ms(integer)
                    ; ns(integer)
                    .


% This module represents times, dates and sets of those using
% terms of the form =|datetime(MJD, Nano)|=.  =MJD= is an
% integer representing the modified Julian day.  =Nano= is an
% integer representing the number of nanoseconds since midnight
% on that day.
%
% We indicate a date without time by leaving =Nano= as an
% unbound variable.  We indicate times without a date by
% leaving =MJD= unbound.  Arbitrary datetime sets are represented
% by using library(clpfd) constraints on =MJD= and =Nano=.
%
% This representation should make it very easy to implement
% datetime arithmetic predicates, although I've not yet done
% that below.


%%	mjd(?MJD:integer) is semidet.
%
%	True if MJD is a valid modified Julian day number.
mjd(MJD) :-
    MJD in -2400328 .. 514671.

%%	nano(?Nano:integer) is semidet.
%
%	True if Nano is a valid number of nanoseconds since midnight.
nano(Nano) :-
    Nano in 0 .. 86_399_999_999_999.

%%  datetime(?Datetime:datetime, ?MJD:positive_integer,
%%  ?Nano:positive_integer) is semidet.
%
%   True if Datetime falls on modified Julian day MJD and occurs Nano
%   nanoseconds after midnight.
datetime(datetime(MJD, Nano), MJD, Nano) :-
    mjd(MJD),
    nano(Nano).

%%	datetime(?Datetime) is semidet.
%
%	True if Datetime is a datetime term.
datetime(Dt) :-
    datetime(Dt, _, _).


%%	form_time(?Form, ?Datetime:datetime)
%
%	True if Datetime can be described by Form.  Form is
%	a sugary representation of a set of datetimes.  This
%	predicate is the workhorse for converting between
%	datetime values and other date representations. It's
%	also the workhorse for further constraining a datetime
%	value.
%
%	Here are some acceptable values of Form.
%
%       * `today` - the set of all nanoseconds in the local day
%       * `now` - the current nanosecond
%       * `dow(tuesday)` - the set of all Tuesdays in history
%       * `dow([saturday,sunday])` - set of all weekends in history
%       * `weekday` - like `dow([monday,...,friday])` but faster
%       * `month(july)` - the set of all Julys in history
%       * `month([june,july])` - the set of all Junes and Julys ever
%       * `unix(EpochSeconds)` - floating point seconds since the Unix
%         epoch
%       * `[foo,bar]` - both `foo` and `bar` forms apply
%       * `gregorian(Year,Month,Day)` - all seconds in a Gregorian
%	  date of the given form.  For example, `gregorian(_,3,_)`
%	  represents the set of all the months of March in history.
%       * `Year-Month-Day` - same as `gregorian(Year,Month,Day)`
%       * `Hours:Minutes:Seconds`
%       * `midnight` - shortcut for `00:00:00`
%       * `noon` - shortcut for `12:00:00`
%       * `final_moment` - shortcut for `23:59:59.99999999999999`
%       * `after(Form)` - all times after Form
%       * `before(Form)` - all times before Form
%       * `future` - alias for `after(now)`
%       * `past` - alias for `before(now)`
%       * `rfc3339(Text)` - the nanosecond indicated by the RFC 3339
%         date string.  Text can be atom or codes or string.
%       * `nth(N,Form)` - Nth day (1-based) that matches Form in the
%         month.  N can be a list of days in which case form_time/2
%         is multi.  This form isn't yet as flexible in different modes
%         as I'd like.
%       * `true` - noop constraint that matches all dates
%       * `Datetime` - a datetime itself can be used as a form
%       * `mjn(Mjn)` - modified Julian nanoseconds
%
%
%   This predicate is multifile because other modules can support
%   different calendars, different holiday schedules, extra sugar, etc.
:- multifile form_time/2.
form_time(Var, _) :-
    var(Var),
    !,
    throw('form_time/2 doesn''t yet support a variable first argument').
form_time([], Dt) :-
    datetime(Dt).
form_time([H|T], Dt) :-
    form_time(H, Dt),
    form_time(T, Dt).
form_time(true, Dt) :-
    datetime(Dt).
form_time(today, Dt) :-
    get_time(Now),
    stamp_date_time(Now, date(Year, Month, Day, _,_,_,_,_,_), local),
    form_time(gregorian(Year,Month,Day), Dt).
form_time(now, Dt) :-
    get_time(Now),
    form_time(unix(Now), Dt).
form_time(dow(Days), Dt) :-
    ground(Days),
    maplist(dow_number, Days, DayNumbers),
    datetime(Dt, MJD, _),
    !,
    % compile DayNumbers into clpfd domain constraint
    xfy_list(\/, Domain, DayNumbers),
    DayNumber in Domain,
    (MJD+2) mod 7 #= DayNumber.
form_time(weekday, Dt) :-
    datetime(Dt,MJD,_),
    DayNumber in 0..4,
    (MJD+2) mod 7 #= DayNumber.
form_time(dow(DayOfWeek), datetime(MJD, _)) :-
    (MJD+2) mod 7 #= DayNumber,
    delay(dow_number(DayOfWeek, DayNumber)),
    !.
form_time(month(Months), Dt) :-
    ground(Months),
    datetime(Dt),
    maplist(month_number, Months, MonthNumbers),
    !,
    % compile MonthNumbers into clpfd domain constraint
    xfy_list(\/, Domain, MonthNumbers),
    MonthNumber in Domain,
    form_time(gregorian(_,MonthNumber,_), Dt).
form_time(month(Month), Dt) :-
    delay(month_number(Month, Number)),
    form_time(gregorian(_,Number,_), Dt).
form_time(Year-Month-Day, Dt) :-
    !,
    form_time(gregorian(Year,Month,Day), Dt).
form_time(gregorian(Year, Month, Day), Dt) :-
    gregorian(Year, Month, Day),
    datetime(Dt, MJD, _Nano),
    E #= 4 * ((194800*MJD+467785976025)//194796) + 3,
    H #= mod(E, 1461)//4*5 + 2,
    Day #= mod(H, 153)//5 + 1,
    Month #= mod(H//153+2, 12) + 1,
    Year #= E//1461 + (14 - Month)//12 - 4716,

    % help clpfd in cases we know can be resolved better
    ( ground(Year), ground(Month), ground(Day), var(MJD) ->
        labeling([leftmost, up, bisect], [MJD])
    ; true ->
        when(ground(Year), ignore(contract_mjd(Year,Month,MJD)))
    ).
form_time(Hours:Minutes:FloatSeconds, datetime(_, Nanos)) :-
    Second = 1_000_000_000,
    seconds_nanos(FloatSeconds, N),
    Hours   in 0 .. 23,
    Minutes in 0 .. 59,
    N       in 0 .. 59_999_999_999,
    Nanos #= Hours*60*60*Second + Minutes*60*Second + N.
form_time(midnight, Dt) :-
    form_time(00:00:00, Dt).
form_time(noon, Dt) :-
    form_time(12:00:00, Dt).
form_time(final_moment, Dt) :-
    datetime(Dt, _, 86_399_999_999_999).
form_time(unix(UnixEpochSeconds), datetime(Days, Nanos)) :-
    DayInNanos = 86_400_000_000_000,
    seconds_nanos(UnixEpochSeconds, N),
    ExtraDays #= N // DayInNanos,
    ExtraNanos #= N rem DayInNanos,

    % form_time([1970-01-01,00:00:00], datetime(40587,0))
    Days #= 40587 + ExtraDays,
    Nanos #= 0 + ExtraNanos.
form_time(mjn(Mjn), Dt) :-
    datetime(Dt, Mjd, Nano),
    DayInNanos = 86_400_000_000_000,
    Mjn #= Mjd*DayInNanos + Nano.
form_time(future, Dt) :-
    form_time(after(now), Dt).
form_time(past, Dt) :-
    form_time(before(now), Dt).
form_time(after(Form), Dt) :-
    form_time(Form, Threshold),
    compare_time(>,Dt,Threshold).
form_time(before(Form), Dt) :-
    form_time(Form, Threshold),
    compare_time(<,Dt,Threshold).
form_time(nth(Ns0,Form), Dt) :-
    nonvar(Form),
    datetime(Dt),
    ( Form = dow(Dow), integer(Ns0) ->
        nth_dow(Dt,Dow,Ns0)
    ; % general case ->
        nth_generic(Dt, Form, Ns0)
    ).
form_time(datetime(Mjd,Nano), datetime(Mjd,Nano)).
form_time(rfc3339(Text0), Dt) :-
    ( ground(Text0) ->
        ( is_list(Text0) -> string_codes(Text,Text0); Text=Text0 ),
        parse_time(Text,iso_8601,Epoch),
        form_time(unix(Epoch),Dt)
    ; ground(Dt) ->
        form_time(unix(Epoch),Dt),
        stamp_date_time(Epoch,DateTime,'UTC'),
        Frac is Epoch - floor(Epoch),  % are there fractional seconds
        ( Frac > 0 -> Format="%FT%T.%6f"; Format="%FT%T" ),
        format_time(codes(Text0),Format,DateTime)
    ; true ->
        when(ground(Text0);ground(Dt), form_time(rfc3339(Text0),Dt))
    ).


% handle general case of nth/2 form
nth_generic(Dt,Form,Ns0) :-
    form_time(Year-Month-_, Dt),
    form_time([Year-Month-_, Form], X),
    findall_dates(X, Dates),
    ( is_list(Ns0) -> Ns=Ns0 ; Ns=[Ns0] ),
    member(N0, Ns),
    ( N0 > 0 -> N is N0-1 ; N=N0 ),
    circular_nth0(N, Dates, Dt).

% optimization of nth/2 for dow/1 second argument
nth_dow(Dt,Dow,N) :-
    % constrain to the proper day of the week
    form_time(dow(Dow), Dt),

    % constrain day to the proper place within the month
    Day1 in 1..7,
    Day - (N-1)*7 #= Day1,
    form_time(_-_-Day, Dt),

    % help clpfd recognize opportunities to contract
    datetime(Dt, MJD, _),
    clpfd:contracting([MJD]).


%%	form_time(+Form) is semidet.
%
%	True if a date exists which satisfies Form.  For example,
%	"is May 1, 1979 a Tuesday?" would be
%
%	    form_time([1979-05-01,dow(tuesday)])
form_time(Form) :-
    form_time(Form, _).


% Gregorian date calculations use large numbers and many mod/2
% constraints. That combination makes it inefficient for clpfd to
% propagate constraints perfectly. We could call clpfd:contracting/1
% to contract MJD's domain, but that's relatively slow. Fortunately,
% these problems only seem to arise in cases like Note_compare. When the
% Year is known, we have a very efficient way of finding the lower and
% upper bound for MJD. The lower is January 1st. The upper is December
% 31st.
% Fails if this optimization doesn't apply.
contract_mjd(Year,Month,MJD) :-
    ground(Year),
    var(Month),  % no point in optimization if ground(Month)
    form_time(gregorian(Year,1,1), datetime(MinMJD,_)),
    form_time(gregorian(Year,12,31), datetime(MaxMJD,_)),
    MJD in MinMJD..MaxMJD.


% TODO factor this out to list_util and use delay:length/2 and
% delay:plus/3 to implement it.
circular_nth0(Index, List, Element) :-
    Index >= 0,
    !,
    nth0(Index, List, Element).
circular_nth0(Index0, List, Element) :-
    length(List, Len),
    plus(Index0, Len, Index),
    nth0(Index, List, Element).

%%  findall_dates(+Dt:datetime, -Dts:list)
%
%   True if Dts is all individual days in the set Dt. Dts is in order
%   from oldest to most recent.
findall_dates(Dt, Dts) :-
    findall(Dt, date(Dt), Dts).

%%  date(?Dt:datetime) is nondet.
%
%   Assign a single date based on the constraints of Dt.  This can
%   be used to iterate all values of Dt.
date(Dt) :-
    datetime(Dt, MJD, _),
    labeling([leftmost,up,bisect], [MJD]).


%%	seconds_nanos(?Seconds:float, ?Nanos:integer) is semidet.
%
%   True if Seconds is a floating point representation of Nanos
%   nanoseconds.
seconds_nanos(Seconds, Nanos) :-
    when( (   ground(Seconds)
          ;   ground(Nanos)
          )
        , seconds_nanos_(Seconds, Nanos)
        ).
seconds_nanos_(Seconds, Nanos) :-
    number(Seconds),
    !,
    Nanos is floor(Seconds * 1_000_000_000).
seconds_nanos_(Seconds, Nanos) :-
    integer(Nanos),
    Seconds is Nanos / 1_000_000_000.


%%	compare_time(+Order, ?A:datetime, ?B:datetime) is semidet.
%%	compare_time(-Order, ?A:datetime, ?B:datetime) is nondet.
%
%	True if the chronological relation between A and B is described by Order.
%	None of the arguments needs to be bound.  When Order is not bound,
%	compare_time/3 iterates all possible values of Order on backtracking.
%	In other words, the relation is not stored as contraints on Order.
%
%	A and B can be given as datetime values or forms.  For example,
%	this is a legitimate goal:
%
%	    compare_time(Order, now, unix(1375475330.414)).
compare_time(Order, A0, B0) :-
    ( var(A0) -> A=A0 ; form_time(A0, A) ),
    ( var(B0) -> B=B0 ; form_time(B0, B) ),
    compare_time_(Order, A, B).
compare_time_(Order, A, B) :-
    form_time(mjn(MjnA), A),
    form_time(mjn(MjnB), B),
    zcompare(Order, MjnA, MjnB),

    % See Note_compare
    ( var(Order) ->
        findall(Order,member(Order,[<,=,>]), Orders),
        member(Order, Orders)
    ; % otherwise ->
        true
    ).

/* Note_compare:

Using zcompare/3 with modified Julian nanoseconds is the purest way to decribe
the relationship between two times and an order.  In most circumstances, it
works exactly as expected.  However, in some common cases like

    form_time([2000-02-29], A),
    form_time([1999-_-_], B),
    compare(Order, A, B).

zcompare/3 fails to notice that A must always be greater than B.  Fortunately,
if we ask zcompare/3 "is it less? is it equal? is it greater?" it always
answers correctly.  If that series of questions gets a single answer, we want
to pretend that zcompare/3 found it by itself without leaving any extra
choicepoints.  If there are multiple right answers, we want a choicepoint
for each one.  The `findall(...),member(...)` construct behaves like that.

*/


%%	delta_time(?A:datetime, ?Delta:duration, ?B:datetime)
%
%	True if datetime A plus duration Delta equals datetime B.
%	Delta is a compound term representing a duration in various
%	convenient forms.  Acceptable forms are:
%
%	  * `days(Days)` - integer days (ignores all time components)
%	  * `ns(Nanoseconds)` - integer nanoseconds
%	  * `ms(Millis)` - integer milliseconds
%	  * `s(Seconds)` - integer seconds
delta_time(A0, Delta, B0) :-
    ( var(A0) -> A=A0 ; form_time(A0, A) ),
    ( var(B0) -> B=B0 ; form_time(B0, B) ),
    delta_time_(A, Delta, B).

delta_time_(A,days(Days),B) :-
    datetime(A, MjdA, _),
    datetime(B, MjdB, _),
    Days #= MjdB - MjdA,
    !.
delta_time_(A,ns(Nanos),B) :-
    form_time(mjn(MjnA), A),
    form_time(mjn(MjnB), B),
    Nanos #= MjnB - MjnA,
    !.
delta_time_(A,ms(Millis),B) :-
    Millis #= Nanos // 1_000_000,
    delta_time_(A,ns(Nanos),B),
    once(label([Nanos])),  % decide rounding ambiguity
    !.
delta_time_(A,s(Seconds),B) :-
    Seconds #= Nanos // 1_000_000_000,
    delta_time_(A,ns(Nanos),B),
    once(label([Nanos])),  % decide rounding ambiguity
    !.
