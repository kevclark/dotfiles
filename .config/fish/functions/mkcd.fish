function mkcd
    # Create the directory
    mkdir -p $argv[1]

    # Change into the newly created directory
    cd $argv[1]
end
