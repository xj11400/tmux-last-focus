#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value="$(tmux show-option -gv "$option")"
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

main() {
    local key=$(get_tmux_option "@last-focus-key" "]")

    tmux set-option -g focus-events on
    tmux set-hook -g pane-focus-in "run-shell '$CURRENT_DIR/scripts/tmux_last_focus.sh --onfocus'"
    tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/tmux_last_focus.sh --focuslast"
}

main
