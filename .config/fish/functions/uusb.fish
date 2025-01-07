function uusb -d 'Unmount USB disk'
    udisksctl unmount -b $argv 
end
