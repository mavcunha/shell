# vim: ft=sh sw=2 ts=2 expandtab

# plain lazyness to deal with PATH variable
unset partial_path
_push_to_path () {
	if [ -z "${partial_path}" ]; then
		partial_path="${1}"
	else
		partial_path="${partial_path}":"${1}"
	fi
}

_export_path () {
	export PATH=${partial_path}
	unset partial_path
}

# returns current branch if a git repo
function current_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

# changes to a give project or the root of all projects
_complete_projects() {
  local cur
  cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $( compgen -S/ -d ~/Projects/$cur | sed s/.*Projects.// ) )
}
