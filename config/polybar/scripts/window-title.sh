#!/usr/bin/env bash

# Get the monitor this polybar instance is on
monitor="${MONITOR}"

# Get the focused workspace on this monitor
focused_ws=$(i3-msg -t get_workspaces | jq -r ".[] | select(.output==\"$monitor\" and .visible==true) | .name")

# Get the focused window title from i3's tree
if [ -n "$focused_ws" ]; then
    title=$(i3-msg -t get_tree | jq -r '.. | select(.focused?==true) | .name // empty' | head -n1)
    
    if [ -n "$title" ] && [ "$title" != "null" ]; then
        echo "$title"
    fi
fi
