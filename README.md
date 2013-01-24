[![Build Status](https://secure.travis-ci.org/rubyworks/dotopts.png)](http://travis-ci.org/rubyworks/dotopts)


# DotOpts (for Ruby)

**Univeral Command Options Configuration (for Ruby Executables)**

[Website](http://rubyworks.github.com/dotopts) /
[Report Issue](http://github.com/rubyworks/dotopts/issues) /
[Source Code](http://github.com/rubyworks/dotopts)


DotOpts is an automatic command line argument augmentor.


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


## Copyrights & Licensing

DotOpts is copyrighted open-source software.

*Copyright (c) 2013 Rubyworks. All rights reserved.*

It can be modified and redistributed in accordance with the [BSD-2-Clause](http://spdex.org/licenses/bsd-2-clause) license.

