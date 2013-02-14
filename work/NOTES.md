# Development Notes

## 2013-02-14 More Flexability Is Needed

Well, it turns out that just appending arguments is not going to cut it.
Prepending would be better, but its still not perfect as some arguments
are concatitive, rather than replacing.

In all, there would seem to be a number of possible manipulations
someone might want to make:

* Append arguments
* Prepend arguments
* Remove arguments
* Default arguments (when no others are provided)
* Replace arguments
* Append arguments conditionally
* Prepend arguments conditionally
* Default non-option arguments (when no non-option arguments are provided)

Of course we could get as complex as any programming language, but that
about covers the vast majority of use-cases. The first four are the most
basic and most common, and if we supported only those it would suffice.
The last four are all conditional and a bit more complex. The last in 
particular has a caveat in that it is not possible to be 100% sure if
a command has non-option arguments or not, b/c some options take arguments
themselves.

I worked out one possible notation, but I can't say I find it all that
wondeful:

```
yardoc
yard doc
  $ foo=100
  + lib
    -
    *.md
    *.txt
  > --output-dir doc
  < --readme README.md
    --title DotOpts
    --protected
  ! --private ?
```

Basically, `$` means environment variables, `+` means defaults, `>` means
prepend, `<` means append and `!` means remove. Of course, maybe we should
just spell it out instead.

```
yardoc
yard doc
  ENVIRONMENT
    foo=100
  DEFAULT
    lib
    -
    *.md
    *.txt
  PREPEND
    --output-dir doc
  APPEND
    --readme README.md
    --title DotOpts
    --protected
  REMOVE
    --private ?
```

