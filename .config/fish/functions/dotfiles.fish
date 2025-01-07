function dotfiles -d 'Git wrapper for dotfiles location'
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
end
