## What is this thing?

These are simple functions and aliases that I use on my daily shell
interactions. Most of them are shortcuts for commands that I issue too often.
You might check [Taking Laziness
Seriously](http://marcovaltas.com/2011/03/28/taking-laziness-seriously.html)
for some of my notes on this.

## How it works

### Loading functions and aliases

In order to keep the files in another place other than my home directory I load
all scripts with `load_bash`, note that `BASH_LOAD_ROOT` is a variable that needs
to be called this way since it's used in other places.

To use add to your home __.bash_profile__ this:

		BASH_LOAD_ROOT=/path/to/where/bash/project/is
		. ${BASH_LOAD_ROOT}/load_bash

Than `load_bash` takes care of loading all scripts, aliases and etc. Mind that
every directory defined in  `load_bash` will be sourced recursively.

### Directory organization

You will find some directories:

`common/` - it gets loaded first, common data and settings go here.
`scripts/` - this is the main directory almost all functions are defined here.
`bin/` - all purpose scripts not only bash ones, it gets added to your path.

This structure is just what I currently use you can redefine and reorganize just
by editing the `load_bash` script to add/rename/remove directories.

### Things that can't go to github or be public.

Some aliases or functions end up to be too particular to a project I'm working
or have sensitive information. These go into the `private` directory which is
ignored by default from git. The trade off is that I don't keep these under version
control, because of that you might see functions that refer to variables that are
not on this repository, that's why.
