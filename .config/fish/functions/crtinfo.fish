function crtinfo -d 'Display x509 cert info on supplied cert'
    openssl x509 -in $argv -noout -text
end
