# shellcheck shell=bash

config_value() {
    local value
    value="$(beet get-config "$1")" || :
    if [ "$value" = null ]; then
        if [ $# -eq 2 ]; then
            echo "$2"
        else
            echo null
            return 1
        fi
    else
        echo "$value"
    fi
}

config_true () {
    # Boolean
    local value
    value="$(config_value "$@")"
    case "$value" in
        null|false|0|'')
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}
