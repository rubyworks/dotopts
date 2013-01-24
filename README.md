[![Build Status](https://secure.travis-ci.org/rubyworks/dotopts.png)](http://travis-ci.org/rubyworks/dotopts)


# DotOpts (for Ruby)

**Univeral Command Options Configuration (for Ruby Executables)**

[Website](http://rubyworks.github.com/dotopts) /
[Report Issue](http://github.com/rubyworks/dotopts/issues) /
[Source Code](http://github.com/rubyworks/dotopts)

## About

DotOpts is an automatic command line argument augmentor. I looks for a local
local `.opts` configuration file and applies the appropriate arguments
when a matching command is invoked.


## Features

* Works with any all Ruby-based executables.
* Supports conditional augmentation using environment settings.
* Can set environment variables in addition to arguments.
* Supports environment variable substitutions.


## Usage

### Setting Arguments

A simple example of a projects `.opts` file:

    yardoc
    yard doc
      --title="Bad Ass Program"

This simply says, that whenever `yardoc` or `yard doc` is executed then
add the `--title="Bad Ass Program"` argument to the end of the command
line arguments (internally `ARGV`).


### Setting Environment Variables

Environment variables can also be set by prepending first and subsequent
lines with `$ `.

    yardoc
    yard doc
      $ RUBYOPTS="-rbadass"
      --title="Bad Ass Program"

The space after the cash sign is important! Otherwise it will be interpreted 
as a variable substitution.


### Conditional Profiles

The `.opts` configuration file support profiles via the square brackets.
Profiles are chosen via the `$profile` or `$p` environment variable.

```
  [cov]
  [coverage]
  rubytest
    -r simplecov
```

So the above means that `-r simplecov` should be added the argument list when
`rubytest` is executed, but only if `$profile` or `$p` is equal to `"cov"` or
`"coverage"`.

Square brackets can alse be used to match against any environment variable
by using the `=` sign.

```
  [RUBY_ENGINE=jruby]
  rake test
    -r jruby-sandbox
```

To condition a configuration on multiple environment settings, add each
to the square brackets separated by a space. 

```
  [cov RUBY_ENGINE=jruby]
  rubytest
    -r jruby-sandbox
    -r simplecov
```

## Development

## Universal Solution?

It would be awesome if it were possible to have DotOpts apply to *all* executables,
not just Ruby-based executables. But I do not know of such a solution for Bash, Zsh
or any other shell. Of course, each scripting language could potentially have
its own implememtnation of DotOpts, which would cover many more executables, but it
would still not cover all of them.

If you are a shell genius and have an epihany on how it might be done, please 
drop me a note via [Issues](http://github.com/rubyworks/dotopts/issues). I'd be more
than happy to code and maintain it.


## Copyrights & Licensing

DotOpts is copyrighted open-source software.

*Copyright (c) 2013 Rubyworks. All rights reserved.*

It can be modified and redistributed in accordance with the [BSD-2-Clause](http://spdex.org/licenses/bsd-2-clause) license.

