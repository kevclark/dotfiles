function fdx -d 'Fuzzy find and open with default X application'
    fd --hidden --exclude .git | fzf-tmux -p | xargs -d'\n' xdg-open
end
