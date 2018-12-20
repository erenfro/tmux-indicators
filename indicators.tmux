#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

indicator_interpolation=(
  "\#{prefix}"
  "\#{synchronized}"
  "\#{sharedsession}"
)

indicator_commands=(
  "#[color]#{?client_prefix,#[text],}"
  "#[color]#{?pane_synchronized,#[text],}"
  "#[color]#{?session_many_attached,#[text],}"
)

# Possible configurations
prefix_text_config='@prefix_text'
prefix_fg_config='@prefix_fg'
prefix_bg_config='@prefix_bg'
prefix_attr_config='@prefix_attr'
synchronized_text_config='@synchronized_text'
synchronized_fg_config='@synchronized_fg'
synchronized_bg_config='@synchronized_bg'
synchronized_attr_config='@synchronized_attr'
sharedsession_text_config='@sharedsession_text'
sharedsession_fg_config='@sharedsession_fg'
sharedsession_bg_config='@sharedsession_bg'
sharedsession_attr_config='@sharedsession_attr'

# Defaults
default_prefix="⌨️  "
default_prefix_fg=""
default_prefix_bg=""
default_prefix_attr=""
default_synchronized="🔁 "
default_synchronized_fg=""
default_synchronized_bg=""
default_synchronized_attr=""
default_sharedsession="👓 "
default_sharedsession_fg=""
default_sharedsession_bg=""
default_sharedsession_attr=""

set_tmux_option() {
  local opion=$1
  local value=$2
  echo tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local all_interpolated="$1"
  local indicator
  
  for ((i=0; i<${#indicator_commands[@]}; i++)); do
    case "${indicator_interpolation[$i]}" in
      "\#{prefix}")
          indicator="${indicator_commands[$i]/\#\[color\]/$prefix_highlight_color}"
          indicator="${indicator/\#\[text\]/$prefix_highlight_text}"
          ;;
      "\#{synchronized}")
          indicator="${indicator_commands[$i]/\#\[color\]/$synchronized_highlight_color}"
          indicator="${indicator/\#\[text\]/$synchronized_highlight_text}"
          ;;
      "\#{sharedsession}")
          indicator="${indicator_commands[$i]/\#\[color\]/$sharedsession_highlight_color}"
          indicator="${indicator/\#\[text\]/$sharedsession_highlight_text}"
          ;;
      *)
          continue
          ;;
    esac
    all_interpolated=${all_interpolated/${indicator_interpolation[$i]}/${indicator}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option=$1
  local option_value=$(get_tmux_option "$option")
  local new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
  local -r \
    prefix_highlight_fg=$(get_tmux_option "$prefix_fg_config" "$default_prefix_fg") \
    prefix_highlight_bg=$(get_tmux_option "$prefix_bg_config" "$default_prefix_bg") \
    prefix_highlight_attr=$(get_tmux_option "$prefix_attr_config" "$default_prefix_attr") \
    prefix_highlight_text=$(get_tmux_option "$prefix_text_config" "$default_prefix") \
    synchronized_highlight_fg=$(get_tmux_option "$synchronized_fg_config" "$default_synchronized_fg") \
    synchronized_highlight_bg=$(get_tmux_option "$synchronized_bg_config" "$default_synchronized_bg") \
    synchronized_highlight_attr=$(get_tmux_option "$synchronized_attr_config" "$default_synchronized_attr") \
    synchronized_highlight_text=$(get_tmux_option "$synchronized_text_config" "$default_synchronized") \
    sharedsession_highlight_fg=$(get_tmux_option "$sharedsession_fg_config" "$default_sharedsession_fg") \
    sharedsession_highlight_bg=$(get_tmux_option "$sharedsession_bg_config" "$default_sharedsession_bg") \
    sharedsession_highlight_attr=$(get_tmux_option "$sharedsession_attr_config" "$default_sharedsession_attr") \
    sharedsession_highlight_text=$(get_tmux_option "$sharedsession_text_config" "$default_sharedsession")
  
  prefix_highlight_color="${prefix_highlight_fg:+fg=$prefix_highlight_fg}${prefix_highlight_bg:+${$prefix_highlight_fg:+,}bg=$prefix_highlight_bg}"
  synchronized_highlight_color="${synchronized_highlight_fg:+fg=$synchronized_highlight_fg}${synchronized_highlight_bg:+${synchronized_highlight_fg:+,}bg=$synchronized_highlight_bg}"
  sharedsession_highlight_color=${sharedsession_highlight_fg:+fg=$sharedsession_highlight_fg}${sharedsession_highlight_bg:+${sharedsession_highlight_fg:+,}bg=$sharedsession_highlight_bg}

  prefix_highlight_color="${prefix_highlight_color:+#[$prefix_highlight_color${prefix_highlight_attr:+,$prefix_highlight_attr}]}"
  synchronized_highlight_color="${synchronized_highlight_color:+#[$synchronized_highlight_color${synchronized_highlight_attr:+,$synchronized_highlight_attr}]}"
  sharedsession_highlight_color="${sharedsession_highlight_color:+#[$synchronized_highlight_color${synchronized_highlight_attr:+,$synchronized_highlight_attr}]}"

  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main
