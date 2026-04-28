_completions_selaos() {
    local cur prev words cword
    _init_completion || return

    case "${words[1]}" in
        hardware)
            COMPREPLY=( $(compgen -W "--show --save --notification" -- "$cur") )
            ;;
        update)
            COMPREPLY=()
            ;;
        help)
            COMPREPLY=()
            ;;
        *)
            COMPREPLY=( $(compgen -W "hardware update help" -- "$cur") )
            ;;
    esac
}

complete -F _completions_selaos selaos