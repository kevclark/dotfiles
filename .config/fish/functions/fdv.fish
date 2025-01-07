function fdv -d 'Fuzzy find and open with vim'
    fd --hidden --exclude .git | fzf | xargs -d'\n' vim
end
