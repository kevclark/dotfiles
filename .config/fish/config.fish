export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
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
