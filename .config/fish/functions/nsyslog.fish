function nsyslog -d 'Display the nth boot log with arg 0 (current boot) to -N'
    sudo journalctl -o short-precise -k -b $argv
end
