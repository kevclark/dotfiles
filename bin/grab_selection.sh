#!/usr/bin/bash

maim -s ~/Pictures/screenshots/`date +%Y-%m-%d_%H-%M-%S`.png && xclip -selection clipboard -t image/png -i ~/Pictures/screenshots/`ls -1 -t ~/Pictures/screenshots | head -1`

