# vim: ft=sh sw=2 ts=2 expandtab

# gg goes to root projects folder (this alias has historic reasons)
gg() { cd ~/Projects/$1 ; }

# greps, vgr puts the results on 'quickfix' window of vim
gr() { egrep -RIn "$1" *; }
vgr() { tmp=$(egrep -Rl "$1" * | xargs ) && vim -c  ":vimgrep /$1/ ${tmp} | :copen "; }

# ff (Find File) functions
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

# output file path given a index (mnemonic File Number)
fn() {
   [ ! -z ${FFOUND[$1-1]} ] && echo ${FFOUND_PWD}/${FFOUND[$1-1]};
}

ff() { myfind "f" "$1"; } # find file
fd() { myfind "d" "$1"; } # find directory
fl() { print_found; }     # file list

# these are calls that support file index number
# "v 1" opens in vim the file that has index number 1
# "d 1" goes to the directory where the file is
v() { vim $(fn "$1");  }
gv() { gvim $(fn "$1"); }
d() { pushd $(dirname $(fn "$1")); }
c() { cat $(fn "$1"); }

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

# simple aliases
alias vb="cd ${BASH_LOAD_ROOT}; gvim ${BASH_LOAD_ROOT}; cd -" # edit these conf files
alias rm='rm -i'
alias mv='mv -i'
alias path='echo -e ${PATH//:/\\n}' # nice path printing
alias pd='popd'
alias jek='gg blog; jekyll --server --pygments'
