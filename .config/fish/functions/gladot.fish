function gladot -d 'Git graph log of all branch on dotfiles'
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME log --graph --all \
        --format="%C(auto)%h%Cgreen %cd%C(auto)%d%Cblue %an%Creset %s" \
        --date=short $argv
end
