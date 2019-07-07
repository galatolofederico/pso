#!/bin/sh

CONFIG_FILE="$HOME/.config/pso.config"

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
}

try_regex(){
    grep "^[^#]" $1 |
    while IFS=: read -r regex cmd; do
        echo $resource $regex
        echo "$resource" | grep -E "$regex" > /dev/null
        if [ "$?" -eq 0 ]; then
            if [ "$debug" -eq 0 ]; then
                exec_cmd "$cmd" "$resource"
            fi
            [ "$debug" -eq 1 ] && echo "regex: $regex cmd: $cmd (from $1)"
        fi
    done
}


try_mime(){
    grep "^[^#]" "$1" |
    while IFS=: read -r mime cmd; do
        if [ "$mime" = "$resource_mime" ]; then
            if [ "$debug" -eq 0 ]; then
                exec_cmd "$cmd" "$resource"
            fi
            [ "$debug" -eq 1 ] && echo "mime: $mime cmd: $cmd (from $1)"
        fi
    done
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

if [ -f "$resource" ]; then 
    try_regex "$PSO_REGEX_CONFIG"
    try_mime "$PSO_MIME_CONFIG"
else
    try_regex "$PSO_URI_CONFIG"
fi