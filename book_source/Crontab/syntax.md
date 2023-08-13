### Crontab Syntax
A crontab file has five fields for specifying day , date and time followed by the command to be run at that interval.

![crontab](https://i.imgur.com/am6Yokm.png)
`*` in the value field above means all legal values as in braces for that column.

The value column can have a `*` or a list of elements separated by commas. An element is either a number in the ranges shown above or two numbers in the range separated by a hyphen (meaning an inclusive range).

Notes:  
1. Repeat pattern like `/2` for every 2 minutes or `/10` for every 10 minutes is not supported by all operating systems. If you try to use it and crontab complains it is probably not supported.

2. The specification of days can be made in two fields: `month day` and `weekday`. If both are specified in an entry, they are cumulative meaning both of the entries will get executed.
