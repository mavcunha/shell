# vim: ft=sh sw=2 ts=2 expandtab

# make bash work in vi mode
set -o vi

# git prompt
export PS1="\W \[\033[0;33m\]\$(current_git_branch)\[\033[0;0m\]\$ "

export TMPDIR=/tmp # some apps need this
export EDITOR=vim  # my default editor is Vim

# setting autocomplete for 'gg' alias
complete -o nospace -F _complete_projects gg

# some bash completion files
for completion in  \
  "/usr/local/etc/bash_completion.d/tmux-iterm2" \
  "/usr/local/etc/bash_completion.d/hg-completion.bash"; do
  [ -f ${completion} ] && . ${completion}
done

######
# Add to PATH, in this order!

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
#######
