# Development Notes

## 2013-02-14 More Flexibility Is Needed

Well, it turns out that just appending arguments is not going to cut it.
Prepending would be better, but its still not perfect as some options
are concatitive, rather than replacing.

In all, there would seem to be a number of possible manipulations
someone might want to make:

* Default arguments (when no others are provided)
* Append arguments
* Prepend arguments
* Remove arguments
* Replace arguments
* Append arguments conditionally
* Prepend arguments conditionally
* Remove arguments conditionally
* Default non-option arguments (when no non-option arguments are provided)

Of course we could get as complex as any programming language, but that
about covers the vast majority of use-cases. The first four are the most
basic and most common, and if we supported only those it would suffice.
The last five are all conditional and a bit more complex. The last in 
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

Basically, the key is as follows:

* `$` - environment variables
* `+` - defaults
* `>` - prepend
* `<` - append 
* `!` - remove

Then again, given how esoteric that is, maybe we should just spell it out
instead.

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

I was hoping to avoid that, but it looks like we are going to ultimately
need this level of flexibility, and unless there some other genius notation
then this seems the clearest approach.

We could turn the thing inside out if we wanted, but that's probably worse:

```
ENVIRONMENT
  yardoc
  yard doc
    foo=100

DEFAULT
  yardoc
  yard doc
    lib
    -
    *.md
    *.txt

PREPEND
  yardoc
  yard doc
    --output-dir doc

APPEND
  yardoc
  yard doc
    --readme README.md
    --title DotOpts
    --protected

REMOVE
  yardoc
  yard doc
    --private ?
```

My only other thought at this point, is perhaps a tool like sed would be useful
here.
