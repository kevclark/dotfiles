#!/bin/sh
if ! pgrep -x gtklock; then
    gtklock -d;
fi
