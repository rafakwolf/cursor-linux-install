#!/bin/bash
nohup "$HOME/Applications/cursor.AppImage" --no-sandbox "$@" > /dev/null 2>&1 &
disown
