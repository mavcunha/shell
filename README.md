### What is this thing?

These are simple functions and aliases that I use on my daily shell
interactions. Most of them are shortcuts for commands that I issue too often.
You might check [Taking Laziness
Seriously](http://marcovaltas.com/2011/03/28/taking-laziness-seriously.html)
for some of my notes on this.

### How to use

In order to keep the files in another place other than my home directory I load
all scripts with `load_bash`, note that `BASH_LOAD_ROOT` is a variable that needs
to be called this way since it's used in other places.

To use add to your home __.bash_profile__ this:

		BASH_LOAD_ROOT=/path/to/where/bash/project/is
		. ${BASH_LOAD_ROOT}/load_bash

