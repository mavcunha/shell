# vim: ft=sh sw=2 ts=2 expandtab

# changes to a give project or the root of all projects
_cd_project() {
  proj=~/Projects${1:+"/$1"}
  [ "${proj}" != "$PWD" ] && pushd ${proj} || echo "You are already there!" >&2
}

## greps ##
gr() { egrep -RIn "$1" *; }
vgr() { tmp=$(egrep -Rl "$1" * | xargs ) && vim -c  ":vimgrep /$1/ ${tmp} | :copen "; }

# find functions
myfind() {
   FFOUND_PWD=${PWD}
   FFOUND=($(find . -iname "*$2*" -type "$1" | sort ))
   print_found
}
print_found() {
   if [ "${#FFOUND[*]}" -eq 0 ]; then return; fi
   local index=1
   echo ${FFOUND[*]} | tr -s ' ' '\n' | while read line; do
       if [ -t 1 ]; then printf "% 4d " $index; fi
       echo $line
       index=$((index + 1))
   done
}

ff() { myfind "f" "$1"; } # find file
fd() { myfind "d" "$1"; } # find directory

# return file given its index
fn() {
   [ ! -z ${FFOUND[$1-1]} ] && echo ${FFOUND_PWD}/${FFOUND[$1-1]};
}

# these are calls that support file index number
# "v 1" opens in vim the file that has index number 1
# "d 1" goes to the directory where the file is
v() { vim $(fn "$1");  }
gv() { gvim $(fn "$1"); }
d() { pushd $(dirname $(fn "$1")); }
c() { cat $(fn "$1"); }

fl() { print_found; }
g() { 
    ARGS=($@)
    pos_of_last_argument=$(expr ${#ARGS[@]} - 1)
    last_argument=${ARGS[${pos_of_last_argument}]}

    if ! echo $last_argument | grep -q '^[0-9]\+$'; then
        `which git` "$@"
        return
    fi

    ARGS=(${ARGS[@]:0:$pos_of_last_argument})
    `which git` ${ARGS[@]} $(fn "${last_argument}")
}

# gg goes to projects folder
gg() { _cd_project "$1"; }

# dealing with aliases and profile
bs() { 
  echo "Sourcing ~/.bash_profile" && . ~/.bash_profile
}

# more aliases...
alias vb="pushd ${BASH_LOAD_ROOT}; gvim ${BASH_LOAD_ROOT}; popd" # vim bash stuff, bring me to the root dir
alias rm='rm -i'
alias mv='mv -i'
alias path='echo -e ${PATH//:/\\n}' # nice path printing
