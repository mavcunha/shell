# vim: ft=sh sw=2 ts=2 expandtab

export EDITOR=vim # What else?

# git prompt
export PS1="\e[0;37m\h\e[0m:\W \[\033[0;33m\]\$(current_git_branch)\[\033[0;0m\]\$ "

# "You anticipate the point in time where you will have accumulated so many
# commands in your history file that you will never have to type a new one."
# http://rjpower.org/wordpress/bash-isms-i-wish-i-knew-earlier/
export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend # always append to history

export TMPDIR=/tmp # some apps need this

# AWS environment
export AWS_CREDENTIAL_FILE=~/.ec2/access.pl
export AWS_CREDENTIALS_FILE=~/.ec2/access.pl
export AWS_CLOUDFORMATION_HOME=/usr/local/Cellar/aws-cfn-tools/1.0.9/jars
# EC2 environment
export EC2_HOME=/usr/local/Library/LinkedKegs/ec2-api-tools/jars
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem 2> /dev/null | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem 2> /dev/null | /usr/bin/head -1)"

# Amazon SES 
export PERL5LIB=~/bin

# Java Home
export JAVA_HOME=$([ -x /usr/libexec/java_home ] && /usr/libexec/java_home)

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

# local scripts.
_push_to_path "~/bin"

# haskell cabal
_push_to_path "~/.cabal/bin"

# brew and local scripts.
_push_to_path "/usr/local/bin"

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
