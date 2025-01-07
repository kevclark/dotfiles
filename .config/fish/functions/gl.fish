function gl -d 'Git graph log of the current branch'
    git log --graph --format="%C(auto)%h%Cgreen %cd%C(auto)%d%Cblue %an%Creset %s" \
        --date=short $argv
end
