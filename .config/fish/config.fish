# nvim is in the path for current user but when sudo is used root does not inherit
# the current user path
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR (which nvim)
fish_add_path $HOME/bin
# ignore grc wrapper for ls and use our own override functin for ls
set -U grc_plugin_ignore_execs ls

set fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init --cmd cd fish | source
    source (starship init fish --print-full-init | psub)
    fastfetch
end
