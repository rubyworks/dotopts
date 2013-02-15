# RELEASE HISTORY

## 0.2.0 / 2013-02-15

Rethought overall design and reimplemented parser. The syntax of option
files is essentially the same, but now arguments are only applied if
there are no arguments provided on the command line. In other words,
it is assumed that if the user supplies their own arguments, then
they don't require any from DotOpts. This redesign prevents a lot of
potential headaches with how prepend/append options can interact 
with options proved by the end user. In the future, we might adds some
additional flexibility, of argument substitutions.

Changes:

* Rethink when arguments are applied.
* Reimplemented parser.


## 0.1.3 / 2013-01-30

Environment settings were not being applied. This release improves the code
that handles application of options and fixes the environment setting issue.
This release also adds a debug log option, so one can see what DotOpts is doing
by setting `dotopts_debug`.

Changes:

* Fix environment setting, ensuring their application.
* Add debug log when `doptopts_debug` is set.


## 0.1.2 / 2013-01-29

Accidental release. Yanked.


## 0.1.1 / 2013-01-29

This release simply fixes the missing optional argument on the
`DotOpts#configure!` method's interface.

Changes:

* Fix `DotOpts#configure!` method. [bug]


## 0.1.0 / 2013-01-28

First release of DotOpts.

Changes:

* It's Your Birthday!

