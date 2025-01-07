function fdc -d 'Fuzzy find and copy to clipboard'
    fd --hidden --exclude .git | fzf | xclip -r -selection p
end
