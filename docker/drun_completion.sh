drunComplete () {
    local cmd="${1##*/}"
    local word=${COMP_WORDS[COMP_CWORD]}
    local line=${COMP_LINE}
    pushd $(drun -s) >/dev/null
    COMPREPLY=($(compgen -f -- "${word}"))
    popd >/dev/null
}
complete -F drunComplete drun
