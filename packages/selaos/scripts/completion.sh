completions() {
local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in
        selaos)
            COMPREPLY=( $(compgen -W "hardware update help" -- "$cur") )
            return 0
            ;;
        hardware)
            COMPREPLY=( $(compgen -W "--show --save --notification" -- "$cur") )
            return 0
            ;;
        *)
            return 0
            ;;
    esac
}

complete -F completions selaos