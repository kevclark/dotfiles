function gla -d 'Git graph log of all branch'
    git log --graph --all --format="%C(auto)%h%Cgreen %cd%C(auto)%d%Cblue %an%Creset %s" \
        --date=short $argv
end
