export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
fish_add_path $HOME/bin

set fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init --cmd cd fish | source
    source (starship init fish --print-full-init | psub)
    fastfetch
end
