---
layout: post
title:  "common date and time misconceptions"
date:   2017-06-17
tags:
- datetime
---

# A note on common date and time misconceptions #

## some background (sort of) ##

- 12 (a dozen) is easily divisible by 1, 2, 3, 4, and 6, 12.
- 60 (a sexagena) is divisible by 1, 2, 3, 4, 5, 6, and 10, 12, 15, 20, 30, 60.
 
Both are highly composite numbers
[wiki/Highly_composite_number](https://en.wikipedia.org/wiki/Highly_composite_number)
and were not chosen by accident when we had to divide the day into 12 hours and further each hour into 60 minutes.

## false assumptions ##
 
### every year has 365 days ###

false; every leap year has 366 days.

### every 4th year has one additional day ###

false; it's every year divisible by 4, except divisible by 100, unless divisible by 400.

### every month has a set number of days ###

correct; but, needs a clarification that the leap years have February 29, but otherwise February has 28 days.
 
### every minute has 60 seconds ###
 
false! Remember leap seconds. Periodically, UTC is adjusted by a second (+1 second or -1 second) so it does more accurately represent the position of earth around the sun.
 
### no two days can have the same date ###
 
false, when you travel across the 180&#176; longitude you can leave your day once again.
See [wiki/International_Date_Line](https://en.wikipedia.org/wiki/International_Date_Line)
 
### there is only one calendar ###
 
oh no, that would be too boring! See [wiki/Adoption_of_the_Gregorian_calendar](https://en.wikipedia.org/wiki/Adoption_of_the_Gregorian_calendar)
 
### week starts from Monday or Sunday? ###
 
yes.
 
### weekend is Saturday and Sunday ###
 
In some countries, yes.
 
### daylight savings time starts on the same day ###
 
no, every jurisdiction has different regulations and some have no daylight savings.

### timezones are offsets from UTC in hours ###

no, some are 30 or 45 minutes.

## in software engineering ##

all above have further implications in computer programs (not only java):
 
### every newer timestamp is larger than an older one ###
 
false!

- the precision of timestamp might be limited (accuracy),
- the leap second,
- timezone changes and daylight savings can be implemented​ as a jumps in time (the time may have gaps, or overlapping periods)
 
### you can use timestamps as unique keys (in db) ###
 
no, since these values are never unique.

- nanosecond precision can be not available on some systems, or cached (sic!) on other

Also it is a terrible idea in general.
 
### you can use timestamps to calculate how much time has passed to complete a operation ### 
 
no, since there are leap seconds, or a time adjustment may occur during the process (NTS sync), this may fail.

Note \"May\" is OK in most cases.
 
### time is the same everywhere ### 
 
yes, if you remember about timezones, different ways to cope with leap seconds, delays in communication, and many many more problems like server time synchronization

### time zone is information ### 

In some cases \"2005-10-30 T 10:45 UTC\" and \"2005-10-30 T 11:45 +1\" may represent the same information in some cases, or different in other.

- although both represent the same moment in time, the TZ information itself may be important
- if you store a time in a \"+1\" TZ you may expect to receive it in the same TZ

This can be error-prone in system integration.
