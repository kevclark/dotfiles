# Simple aliases and functions

function ls
    exa --icons=auto $argv
end

function gl -d 'Git graph log of the current branch'
    git log --graph --format="%C(auto)%h%Cgreen %cd%C(auto)%d%Cblue %an%Creset %s" \
        --date=short
end

function gla -d 'Git graph log of all branch'
    git log --graph --all --format="%C(auto)%h%Cgreen %cd%C(auto)%d%Cblue %an%Creset %s" \
        --date=short
end


# abbreviations (expand on completion)
abbr gdiff 'git difftool -d --no-symlinks'
abbr gmerge 'git merge --no-ff'
