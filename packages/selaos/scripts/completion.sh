completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # 1. Level: Die Hauptbefehle
    case "$prev" in
        selaos)
            opts="hardware update help"
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;
        hardware)
            # 2. Level: Optionen für hardware
            opts="--show --save --notification"
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;
        update)
            return 0
            ;;
    esac
}

complete -F completions selaos