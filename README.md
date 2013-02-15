# DotOpts

**Automated Command-line Options (for Ruby Executables)**

[Website](http://rubyworks.github.com/dotopts) /
[Report Issue](http://github.com/rubyworks/dotopts/issues) /
[Source Code](http://github.com/rubyworks/dotopts) /
[![Build Status](https://secure.travis-ci.org/rubyworks/dotopts.png)](http://travis-ci.org/rubyworks/dotopts) /
[![Gem Version](https://badge.fury.io/rb/dotopts.png)](http://badge.fury.io/rb/dotopts)

## About

DotOpts is an automatic command-line argument augmenter. It looks for a
project's local `.option` (or `.opts`) configuration file and applies the 
appropriate arguments when a matching command is invoked.


## Features

* Works with any and all Ruby-based executables.
* Can be used to set environment variables in addition to arguments.
* Supports environment variable substitution.
* Supports conditional augmentation using environment settings.
* Simple and easy to understand plain-text configuration format.


## Install

If you are using an application that depends on DotOpts for configuration,
there is nothing you have to do. Installing the said application via
RubyGems should also install DotOpts and require it as needed.

### General Setup

To use DotOpts universally, even for command-line applications that do not
directly utilize it, you can install DotOpts via RubyGems:

    gem install dotopts

Then add `-rdotopts` to your `RUBYOPT` environment variable.

    export RUBYOPT="-rdotopts"

This ensures DotOpts is used whenever Ruby is used.

### Special Setup

Another approach is to use DotOpts per-project development project using
via Bundler, adding DotOpts to your project's Gemfile.

    gem 'dotopts'

This will allow DotOpts to work whenever using `bundle exec` or Bundler
created binstub.


## Usage

### Setting Arguments

A simple example of a projects `.option` file:

    yardoc
    yard doc
      --title="Bad Ass Program"

This simply says, that whenever `yardoc` or `yard doc` is executed, and
no other arguments are given, then add the `--title="Bad Ass Program"`
argument to the end of the command's arguments (internally `ARGV`).


### Setting Environment Variables

Environment variables can also be set by prepending first and subsequent
lines with `$ `.

    yardoc
    yard doc
      $ RUBYOPT="-rbadass"
      --title="Bad Ass Program"

The space after the cash sign is important! Otherwise it will be interpreted 
as a variable substitution.


### Conditional Profiles

The `.option` configuration file supports profiles via the square brackets.
Profiles are chosen via the `$profile` or `$p` environment variable.

```
  [coverage]
  rubytest
    -r microtest
```

So the above means that `-r micortest` should be added the argument list when
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
    -r microtest
```

Finally, environment values can be matched against simple regular expressions
using a tilde (`~`) before the value. Be sure to put the value in quotes when
using regular expressions.

```
  [~"cov(erage)?" RUBY_ENGINE=~"jruby|rubinius"]
  rubytest
    -r jruby-sandbox
    -r microtest
```

### Tool Support

Ruby tool developers can support DotOpts out-of-the-box simple by running
`require 'dotopts'` in their program before parsing ARGV. DotOpts
simply injects arguments into `ARGV` so it can work with any command-line
options parser.


## Development

### Suggestions & Contributions

DotOpts is a brand new application, and still rather wet behind the ears, so to
speak. So your input is critical to making it better. Any and all suggestions and
contributions are much appreciated. If you have any ideas on how to improve DotOpts,
or find any flaws in its design that need address, please drop a comment on the
[Issues](http://github.com/rubyworks/dotopts/issues) page. Or even better, be proactive!
Fork the project and submit a pull request. Thanks.

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

