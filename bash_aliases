# vim: ft=sh sw=2 ts=2 expandtab

# gg goes to root projects folder (this alias has historical reasons)
gg() { cd ~/Projects/$1; }

# greps, vgr puts the results on 'quickfix' window of vim
gr() {
  FFOUND_PWD=${PWD}
  local index=0
  local last_file=""

  while read line; do
    file=$(echo ${line} | awk -F':' '{ print $1 }')

    if [[ ${file} != ${last_file} ]];then
      FFOUND[${index}]=${file}
      last_file=${file}
      ((index++))
    fi

    if [ -t 1 ]; then printf "% 4d " $index; fi
    echo $line

  done < <(egrep --color=always -RIn "$1" *)
}

vgr() { tmp=$(egrep -Rl "$1" * | xargs ) && vim -c  ":vimgrep /$1/ ${tmp} | :copen "; }

# ff (Find File) functions
myfind() {
  FFOUND_PWD=${PWD}
  eval FFOUND=($(find -L "$PWD"/ -iname "*$2*" -type "$1" | sed -e 's/.*/"&"/'))
  print_found
}
print_found() {
  local length=${#FFOUND[*]}
  local index=1
  while [ "$index" -le "$length" ]; do
    if [ -t 1 ]; then printf "% 4d " $index; fi
    fn $index
    ((index++))
  done
}

# output file path given a index (mnemonic File Number)
# for some aliases if a number if not given return the argument
# back.
fn() {
  if [[ "$1" && "$1" =~ ^[0-9]+$ ]]; then
    item=${FFOUND[$1-1]}
    if [ -z "$item" ]; then return; fi
    if [ "$PWD" != "$FFOUND_PWD" ]; then echo -n $FFOUND_PWD/; fi
    echo ${item##$FFOUND_PWD//}
  elif [ "$1" ]; then
    echo $1
  fi
}

ff() { myfind "f" "$1"; } # find file
fd() { myfind "d" "$1"; } # find directory
fl() { print_found; }     # file list
fv() { vim $(ff "$1"); }

# these are calls that support file index number
# "v 1" opens in vim the file that has index number 1
# "d 1" goes to the directory where the file is
v() { vim $(fn "$1");  }
d() { pushd "$(dirname "$(fn "$1")")"; }
c() { cat $(fn "$1"); }

# rails shorcuts
rr() {
  ARGS=($@) 
  command=${ARGS[0]}
  options=${ARGS[@]:1:${#ARGS[*]}}

  case ${command} in
    g)
      rails generate ${options}
    ;;
    *)
      rails ${ARGS[@]}
    ;;
  esac
}

# if the last arg is a number, try to expand
# to a file in file list (result from ff)
# used in VCS aliases
_expand_last_arg_if_number() {
    ARGS=($@)
    pos_of_last_argument=$(expr ${#ARGS[@]} - 1)
    last_argument=${ARGS[${pos_of_last_argument}]}

    if ! echo $last_argument | grep -q '^[0-9]\+$'; then
        "$@"
        return
    fi

    ARGS=(${ARGS[@]:0:$pos_of_last_argument})
    ${ARGS[@]} $(fn "${last_argument}")
}

# VCS short aliases
g() { _expand_last_arg_if_number $GIT_BIN $@; }
h() { _expand_last_arg_if_number $HG_BIN  $@; }
s() { _expand_last_arg_if_number $SVN_BIN $@; }

# just reload the profile (mnemonic bulls*)
bs() { echo "Sourcing ~/.bash_profile" && . ~/.bash_profile; }

# simple java version controlling
jv() {
  if [[ "$1" == "6" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
  elif [[ "$1" == "7" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi

  case ${1} in
    6)
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
    ;;
    7)
      export JAVA_HOME=$(/usr/libexec/java_home)
    ;;
    fast)
      export JAVA_OPTS="-Xmx1024m -client -d32 -Djruby.compile.mode=OFF"
    ;;
    big)
      export JAVA_OPTS="-Xmx1024m"
    ;;
    slow)
      unset JAVA_OPTS
    ;;
    *)
echo "
Usage jv [ARG] where ARG can be:
6         set java to version 6
7         set java to version 7
fast      set opts for fast startup on java 6
big       set opts for big max heap (1G)
slow      unset opts to default
"
    ;;
  esac
  echo JAVA_OPTS=${JAVA_OPTS}
  echo JAVA_HOME=${JAVA_HOME}
}

# simple aliases
alias vb="cd ${BASH_LOAD_ROOT}; vim bash_aliases; cd -" # edit these conf files
alias rm='rm -i'
alias mv='mv -i'
alias path='echo -e ${PATH//:/\\n}' # nice path printing
alias pd='popd'
alias pu='pushd'
alias jek='gg blog; jekyll --server --pygments'
alias ll='ls -laF'
alias ls='ls -F'
alias vg='vagrant'
alias r='rake' 
alias be='bundle exec'
alias ber='bundle exec rake'
alias hh='echo "Refresing history"; history -a; history -n'
alias cdd='cd ~/Downloads'
alias sudo='echo "What are you really trying to do???"'
alias photo_backup="rsync -rtuv --exclude='*.photolibrary' --exclude='Photo Booth Library' /Users/mvaltas/Pictures/ /Volumes/Riven/Vacations2013/"
