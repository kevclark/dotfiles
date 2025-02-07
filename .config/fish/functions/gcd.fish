function gcd -d "For each dir if found to be a git folder run the supplied cmd as an arg to git"
    for dir in (find . -type d)
        if test -d "$dir/.git"
            cd $dir
            git $argv
            pwd
            cd -
        end
    end
end
