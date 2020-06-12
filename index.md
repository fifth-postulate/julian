---
layout: default
title: Date and time library for Prolog
---

### Introduction

`library(julian)` is a date and time library for Prolog.  It allows one to parse, generate and work with dates and times.

It also supports complex relations and queries on dates.  Do you want to know in which year of Dwight Eisenhower's presidency the Fourth of July holiday fell on a Sunday?  That's easy:

```prolog
?- form_time([dow(sunday), Year-07-04]), Year in 1953..1961.
Year = 1954.
```


### Tutorial

A tutorial is available which describes most of Julian's features.

  * [Basics](basics.html)
  * [Time Sets](sets.html)
  * [Constraints](constraints.html)


### Installation

Using SWI-Prolog 6.3 or later:

```prolog
?- pack_install(julian).
```
