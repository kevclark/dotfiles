function aptcheck -d 'Check for pending APT updates'
    apt list --upgradable 2>/dev/null
end
