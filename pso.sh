#!/bin/sh

if [ -z "$PSO_MIME_CONFIG" ]; then 
    PSO_MIME_CONFIG="$HOME/.config/pso.mime.config"
fi

if [ -z "$PSO_REGEX_CONFIG" ]; then 
    PSO_REGEX_CONFIG="$HOME/.config/pso.regex.config"
fi

show_help(){
    echo "Pretty Straightforward file Opener"
    echo "Usage ./pso.sh [-h] [-d] file|uri"
    echo "-h : Show this help"
    echo "-d : Run in debug mode (dry run)"
}


try_config(){
    while IFS=: read -r mime app; do
    if [ "$mime" = "$resource_mime" ]; then
        if [ "$opened" -eq 0 ] && [ "$debug" -eq 0 ]; then
            cmd=$(printf "$app" "$resource")
            exec "$cmd"
            opened=1 
        fi
        [ "$debug" -eq 1 ] && echo "mime: $mime app: $app (from $PSO_MIME_CONFIG)"
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