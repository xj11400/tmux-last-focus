#!/bin/bash

function tmux_last_focuse_onfocus() {
  current=$(tmux display-message -p "#{session_id} #{window_id} #{pane_id}")

  tracked_current=$(tmux show-option -gv @last_focus_internal_current 2>/dev/null)

  if [[ "$current" != "$tracked_current" ]]; then
    if [[ -n "$tracked_current" ]]; then
      tmux set-option -g @last_focus_internal_previous "$tracked_current"
    fi

    tmux set-option -g @last_focus_internal_current "$current"
  fi
}

function tmux_last_focuse_focuslast() {
  prev=$(tmux show-option -gv @last_focus_internal_previous 2>/dev/null)

  if [[ -z "$prev" ]]; then
    tmux display-message -d 2000 "No last focus saved"
    exit 0
  fi

  read -r prev_session prev_window prev_pane <<< "$prev"

  # Check if the target pane still exists
  if ! tmux list-panes -a -F "#{session_id} #{window_id} #{pane_id}" | grep -q "^${prev_session} ${prev_window} ${prev_pane}$"; then
    tmux display-message -d 2000 "Last focus pane no longer exists"
    exit 0
  fi

  # Check if already there
  current_info=$(tmux display-message -p "#{session_id} #{window_id} #{pane_id}")

  if [[ "$current_info" == "${prev_session} ${prev_window} ${prev_pane}" ]]; then
    tmux display-message -d 2000 "Already in last focus pane"
    exit 0
  fi

  # Switch to the last focus
  current_session=${current_info%% *}
  if [[ "$current_session" == "${prev_session}" ]]; then
    tmux select-window -t "${prev_window}"
    tmux select-pane -t "${prev_pane}"
  else
    tmux switch-client -t "${prev_pane}"
  fi

  # Optional: Visual feedback (flashing) after switch
  flash_enabled=$(tmux show-option -gv @last-focus-flash 2>/dev/null)
  flash_enabled=${flash_enabled:-"off"}
  flash_color=$(tmux show-option -gv @last-focus-flash-color 2>/dev/null)
  flash_color=${flash_color:-"#101010"}

  if [[ "$flash_enabled" == "on" ]] && [[ $(tmux list-panes | wc -l) -gt 1 ]]; then
    tmux selectp -P bg="${flash_color}"
    sleep 0.1
    tmux selectp -P bg=default
  fi
}

case $1 in
--onfocus)
  tmux_last_focuse_onfocus
  ;;
--focuslast)
  tmux_last_focuse_focuslast
  ;;
esac
