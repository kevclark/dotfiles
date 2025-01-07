function aptphased -d 'Check for phased APT updates these will not be upgraded'
    apt list --upgradable 2>/dev/null | cut -d '/' -f1 | tail -n +2 | xargs apt-cache policy | rg -B4 phased
end
