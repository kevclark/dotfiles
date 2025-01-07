function rget -d 'Recursive wget'
    set cutdirs (echo $argv | tr -dc '/' | wc -c)
    set cutdirs (math "$cutdirs - 3")
    echo "wget --recursive -R index.html* -np -nc -nH --cut-dirs=$cutdirs --random-wait --wait 1 -e robots=off $argv"
    wget --recursive -R "index.html*" -np -nc -nH --cut-dirs=$cutdirs --random-wait --wait 1 -e robots=off $argv
end
