# make bash work in vi mode
set -o vi

# bash env variables 
export TMPDIR=/tmp
export EDITOR=vim

# local scripts.
_push_to_path "~/bin"

# haskell cabal
_push_to_path "~/.cabal/bin"

# brew and local scripts.
_push_to_path "/usr/local/bin"

# brew ruby
_push_to_path "/usr/local/Cellar/ruby/1.9.3-p125/bin"
_push_to_path "/usr/local/Cellar/ruby/1.9.3-p194/bin"

# last but not least, system path
_push_to_path $(launchctl getenv PATH) # on OSX the default path of launchd

_export_path
