### What is this thing?

These are simple functions and aliases that I use on my daily shell
interactions. Most of them are shortcuts for commands that I issue too often.
You might check [Taking Laziness
Seriously](http://marcovaltas.com/2011/03/28/taking-laziness-seriously.html)
for some of my notes on this.

### What is this __load_bash__?

I used to work with too different OS's, one with OSX and another with Linux and
for different types of work. I ended up creating a loader that is "machine
aware", where it loads first the scripts on the root directory and then proceeds
to the machine specific ones. 

Nowadays I don't use this anymore, first because I mainly work on an OSX, and
second because it takes some maintenance time to keep it updated.

### How to use

Add to your home __.bash_profile__ this:

		BASH_LOAD_ROOT=/path/to/where/bash/project/is
		. ${BASH_LOAD_ROOT}/load_bash

It's important to define the variable BASH_LOAD_ROOT as some functions maybe be
using it.
