## What this is

These are simple functions and aliases that I use on my daily shell
interactions. Most of them are shortcuts for commands that I issue too often.
You might check this blog post [Taking Laziness
Seriously](http://marcovaltas.com/2011/03/28/taking-laziness-seriously.html)
for more information.

### Loading functions and aliases

In order to keep the files in another place other than my home directory I load
all scripts with `load_bash`.

To use add to your home __.bash_profile__ this:

		BASH_LOAD_ROOT=/path/to/where/this/project/is
		. ${BASH_LOAD_ROOT}/load_bash

Then `load_bash` takes care of loading all scripts, aliases and etc. Mind that
every directory defined in `load_bash` will be sourced recursively.

### Directory organization

You will find some directories:

`common/` - it gets loaded first, common data and settings go here.
`scripts/` - this is the main directory almost all functions are defined here.
`private/` - is the same as scripts but `.gitignore` is ignoring it
`bin/` - all purpose scripts not only bash ones, it gets added to your path.

This structure is just what I currently use you can redefine and reorganize just
by editing the `load_bash` script to add/rename/remove directories.
