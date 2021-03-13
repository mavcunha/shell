## What this is

These are simple functions and aliases that I use on my daily shell
interactions. Most of them are shortcuts for commands that I type often.  You
might check this blog post [Taking Laziness
Seriously](http://marcovaltas.com/2011/03/28/taking-laziness-seriously.html)
for some information behind my motivation for creating this.

### Loading functions and aliases

In order to keep the files in another place other than my home directory I load
all scripts with `load_bash`.

You can add the follow to your __.bash_profile__:

		BASH_LOAD_ROOT=/path/to/this/project
		. ${BASH_LOAD_ROOT}/load_bash

Then `load_bash` takes care of loading all shortcuts, aliases and etc. Mind
that every directory defined in `load_bash` will be sourced recursively,
mistakes made on the scripts can lead you to a immediately closing terminal
(see bellow for tips on how to fix it).

### Directory organization

You will find some directories:

`common/` - it gets loaded first, common data and settings go here.
`shortcuts/` - this is the main directory almost all functions are defined here.
`bin/` - all purpose scripts not only bash ones, it gets added to your path.
`dotfiles/` - I migrated some of my dotfiles into this repository, so things like `vimrc` and `gitconfig` can be found here.

This directory structure is my personal choice. You can redefine and reorganize
it by editing the `load_bash` script to add/rename/remove directories it should
clear how to do it.

Look into the `shortcuts` directory and explore you might find something
useful for you.

### "Got myself in trouble, my terminal closes immediately"

I got myself in this situation, sometimes mistakes are made and your bash just
closes before you have a chance of fixing it. There are several ways to fix it
depending on the tools available to you. Here's a couple of alternatives:

If you can invoke `bash` from another place like a `run on terminal...` UI just
go for:

```bash
>/usr/bin/bash --noprofile --norc
```

Use an GUI editor to take the offending line from the script and start the
terminal again.

If you have another terminal window open just use that window and fix the
problem without loading.
