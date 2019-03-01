# Pitchfork

Pitchfork is a lightweight interface for manipulating storage stack.

- Aims to collaborate various OSS modules.
- Builds devices, and composes a device stack on your machine.
- Enables idempotent operations based on the special YAML file.


## Dependency

Prepare packages below:

- ruby 2.0 higher
- rubygem
- bundler 1.13 higher (1.11.x is NOT applicable)


## Installation

To build & install on local system, execute:

    : with bundler
    $ bundle exec rake install:local

or

    : without bundler
    $ gem build pitchfork.gemspec
    $ gem install pitchfork-*.gem


## Usage

If you wanna see show how to use, just run:

    $ pf

Then, kinds of modes & options will be shown in your terminal.

If you want to build a stack of devices, run:

    $ pf build /path/to/device_you_want.yml 

or, to destroy it, run:

    $ pf destory /path/to/device_to_discard.yml


## For Developper

If you want to build, install, test on the bundler context, execute:

    : require bundler
    $ bundle install

then run test by:

    : require bundler
    $ bundle exec rake test


## YAML Syntax

> `Specification will be fixed & described in future`
