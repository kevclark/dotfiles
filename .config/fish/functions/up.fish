function up -d 'cd up a level N times - no args will go up one level'
    if test (count $argv) -eq 0
        set count 1  # Default to 1 if no argument is provided
    else
        set count $argv[1]  # Use the provided argument
    end

    # Construct the relative path
    set path (string repeat -n $count ../)

    # Change to the constructed path
    cd $path
end
