# abbreviations (expand on completion)
abbr gdiff 'git difftool -d --no-symlinks'
abbr gmerge 'git merge --no-ff'
abbr cpwd 'pwd | xclip -r -selection p'
abbr mtlvim 'nvim -c DiffviewOpen'
abbr dtst 'dt status'
abbr dtd 'dt diff'
abbr dta 'dt add . -u'
abbr dtcm 'dt commit -m'
abbr dtrhh 'dt reset --hard'
abbr dtpsh 'dt push'
abbr dtpll 'dt pull'
abbr gsha 'git rev-parse HEAD'

# Get the Linux distribution family ID
set dist_family_id (grep '^ID_LIKE=' /etc/os-release | cut -d '=' -f 2-)

# Simple aliases
alias se=sudoedit
alias lg=lazygit
# set the following alias on Debian or Ubuntu systems only
if [ "$dist_family_id" = "debian" ]
    alias bat=batcat
    alias fd=fdfind
end
alias dt=yadm
