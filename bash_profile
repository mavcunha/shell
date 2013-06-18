# vim: ft=sh sw=2 ts=2 expandtab

export EDITOR=vim # What else?

# git prompt
export PS1="\e[0;37m\h\e[0m:\W \[\033[0;33m\]\$(git_prompt)\[\033[0;0m\]\$ "

# "You anticipate the point in time where you will have accumulated so many
# commands in your history file that you will never have to type a new one."
# http://rjpower.org/wordpress/bash-isms-i-wish-i-knew-earlier/
unset HISTSIZE
unset HISTFILESIZE
shopt -s histappend # always append to history

export TMPDIR=/tmp # some apps need this

# EC2 environment
export EC2_ACCOUNT_ID=$(cat $HOME/.ec2/aws_account_id | sed s/-//g )
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem 2> /dev/null | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem 2> /dev/null | /usr/bin/head -1)"

# Android SDK
export ANDROID_SDK_HOME=/usr/local/opt/android-sdk
export ANDROID_HOME=${ANDROID_SDK_HOME}

# Amazon SES
export PERL5LIB=~/bin

# Postgres data directory
export PGDATA=/usr/local/var/postgres

# Java Home
export JAVA_HOME=$([ -x /usr/libexec/java_home ] && /usr/libexec/java_home -v 1.6)

# docbook catalog
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

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

# haskell cabal
_push_to_path "~/.cabal/bin"

# brew and local scripts.
_push_to_path "/usr/local/bin"
_push_to_path "/usr/local/sbin"

# brew ruby
_push_to_path "/usr/local/Cellar/ruby/1.9.3-p194/bin"

# MacTex binaries
_push_to_path "/usr/texbin"

# last but not least, system path
if [[ $(uname) == 'Darwin' ]]; then
  _push_to_path $(launchctl getenv PATH)
else
  _push_to_path "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
fi

_export_path
#######
