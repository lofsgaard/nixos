#!/usr/bin/env bash

# Font Awesome bell icons - using printf for proper Unicode
ICON_BELL=$(printf '\uf0f3')
ICON_MUTED=$(printf '\uf1f6')

# Check if dunst is paused
if [ "$(dunstctl is-paused)" = "true" ]; then
    echo "%{T3}%{F#f38ba8}${ICON_MUTED}%{F-}%{T-} PAUSED"
else
    # Get the count of displayed notifications
    COUNT=$(dunstctl count displayed)
    if [ "$COUNT" -gt 0 ]; then
        echo "%{T3}%{F#89b4fa}${ICON_BELL}%{F-}%{T-} $COUNT"
    else
        echo "%{T3}%{F#6c7086}${ICON_BELL}%{F-}%{T-}"
    fi
fi
