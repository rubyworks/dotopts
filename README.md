# DotOpts

**Automated Commandline Options (for Ruby Executables)**

[Website](http://rubyworks.github.com/dotopts) /
[Report Issue](http://github.com/rubyworks/dotopts/issues) /
[Source Code](http://github.com/rubyworks/dotopts) /
[![Build Status](https://secure.travis-ci.org/rubyworks/dotopts.png)](http://travis-ci.org/rubyworks/dotopts) /
[![Gem Version](https://badge.fury.io/rb/dotopts.png)](http://badge.fury.io/rb/dotopts)

## About

DotOpts is an automatic commandline argument augmenter. It looks for a
project's local `.option` configuration file and applies the appropriate
arguments when a matching command is invoked.


## Features

* Works with any and all Ruby-based executables.
* Can be used to set environment variables in addition to arguments.
* Supports environment variable substitution.
* Supports conditional augmentation using environment settings.
* Simple and easy to use plain-text configuration format.


## Install

DotOpts can be install via RubyGems:

    gem install dotopts

There are two wasy to setup DotOpts for use by all Ruby tools (regardless
of whether they have built-in support for DotOpts or not). The most
univeral approach is to add `-rdotopts` to you `RUBYOPT` environment
variable.

    export RUBYOPT="-rdotopts"

This ensures DotOpts is required whenever Ruby is used. The other
approach is to use Bundler by adding DotOpts to your project's Gemfile.

    gem 'dotopts'

This will allow dotopts to run whenever using `bundle exec`.


## Usage

### Setting Arguments

A simple example of a projects `.option` file:

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

The `.option` configuration file support profiles via the square brackets.
Profiles are chosen via the `$profile` or `$p` environment variable.

```
  [coverage]
  rubytest
    -r simplecov
```

So the above means that `-r simplecov` should be added the argument list when
`rubytest` is executed, but only if `$profile` or `$p` is equal to `"coverage"`.

Square brackets can also be used to match against any environment variable
by using the `=` sign.

```
  [RUBY_ENGINE=jruby]
  rake test
    -r jruby-sandbox
```

To condition a configuration on multiple environment settings, add each
to the square brackets separated by a space. 

```
  [coverage RUBY_ENGINE=jruby]
  rubytest
    -r jruby-sandbox
    -r simplecov
```

Finally, environment values can be matched against simple regular expressions
using a tilde (`~`) before the value. Be sure to out the value in quotes when
using regular expressions.

```
  [~"cov(erage)?" RUBY_ENGINE=~"jruby|rubinius"]
  rubytest
    -r jruby-sandbox
    -r simplecov
```

### Tool Support

Ruby tool developers can support dotopts out-of-the-box simple by running
`require 'dotopts'` in their program before parsing the commandline. DotOpts
simply injects arguments into `ARGV` so it can work with any commandline
option parser.


## Development

### Suggestions & Contributions

DotOpts is a brand new application, and still rather wet behind the years, so to
speak. So your input is critical to making it better. Any and all suggestions and
contributions are much appreciated. If you have any ideas on how to improve DotOpts,
or find any flaws in its design that need address, please drop a comment on the
[Issues](http://github.com/rubyworks/dotopts/issues) page. Or even better, be proactive!
Fork the project submit a pull request. Thanks.

### Universal Solution?

It would be awesome if it were possible to have DotOpts apply to *all* executables,
not just Ruby-based executables. But I do not know how this can be done for Bash, Zsh
or any other shell. Of course, each scripting language could potentially have
its own implementation of DotOpts, which would cover many more executables, but it
would still not cover all of them.

If you are a shell genius and have an epiphany on how it might be done, please 
drop me a note via [Issues](http://github.com/rubyworks/dotopts/issues). I'd be more
than happy to code and maintain it.


## Copyrights & Licensing

DotOpts is copyrighted open-source software.

*Copyright (c) 2013 Rubyworks. All rights reserved.*

It can be modified and redistributed in accordance with the [BSD-2-Clause](http://spdex.org/licenses/bsd-2-clause) license.

