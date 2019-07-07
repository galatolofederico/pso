#!/bin/sh

CONFIG_FILE="$HOME./config/pso.config"

[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"

[ -z "$PSO_REGEX_CONFIG" ] && PSO_REGEX_CONFIG="$HOME/.config/pso.regex.config"
[ -z "$PSO_MIME_CONFIG" ] && PSO_MIME_CONFIG="$HOME/.config/pso.mime.config"
[ -z "$PSO_URI_CONFIG" ] && PSO_URI_CONFIG="$HOME/.config/pso.uri.config"



show_help(){
    echo "Pretty Straightforward file Opener"
    echo "Usage ./pso.sh [-h] [-d] file|uri"
    echo "-h : Show this help"
    echo "-d : Run in debug mode (dry run)"
}

exec_cmd(){
    exec_cmd=$(printf "$cmd" "$resource")
    exec $exec_cmd
    opened=1 
}

try_config(){
    while IFS=: read -r mime cmd; do
    if [ "$mime" = "$resource_mime" ]; then
        if [ "$opened" -eq 0 ] && [ "$debug" -eq 0 ]; then
            exec_cmd "$cmd" "$resource"
        fi
        [ "$debug" -eq 1 ] && echo "mime: $mime cmd: $cmd (from $PSO_MIME_CONFIG)"
    fi
    done <"$PSO_MIME_CONFIG"
}


OPTIND=1

debug=0
while getopts "hd?:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    d)  debug=1
        ;;
    esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

resource=$@
resource_mime=$(file -b --mime-type "$resource")

opened=0

try_config

#echo $resource_mime