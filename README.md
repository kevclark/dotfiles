# About

A place to store your dotfiles and move them around different machines.

# Setup

```
curl https://raw.githubusercontent.com/kevclark/dotfiles/master/.dotfiles-scripts/makehome.py | python3
```

## Stuff to apt install
```
sudo apt install vim vim-gtk xclip tmux zsh zsh-autosuggestions zsh-syntax-highlighting \
git htop btop minicom tree autojump python3-pip taskwarrior nitrogen numlockx xautolock \
libcanberra-gtk-module rofi dmenu thunar i3lock-fancy lxappearance awesome awesome-extra \
golang rust-all light libfuse2 bat fd-find python-is-python3 maim xdotool
```
Further stuff to install since moving to Neovim
```
sudo apt install flake8 black
```
Grab `Stylua` from https://github.com/JohnnyMorganz/StyLua/releases

Unpack the binary `~/bin` and `chmod +x`

## Stuff to install from other sources
[nvim](https://github.com/neovim/neovim)

[awesomewm](https://github.com/awesomeWM/awesome) (for fixes ahead of the version offered
by Canonical - compile from source).

### Appman for Appimages
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/APP-MANAGER -O ~/.local/bin/appman && chmod a+x ~/.local/bin/appman
```
When launching `appman` for the first time it will ask where should appimages be installed. Create the following directory for this:
```
~/tools/appimages/
```
Install some appimages
```
appman -i nvim
appman -i wezterm
appman -i obsidian
appman -i via
appman -i vial
appman -i zen-browser
```
After install they will be in the path under `~/.local/bin/`

### Building Awesome
`build-dep` will install all source dev packages required to build awesome
```
sudo apt build-dep awesome
git clone https://github.com/awesomewm/awesome
cd awesome
make
sudo make install
```
build-dep wasn't enough to allow the build of awesome.  The following packages are also required:
```
sudo apt install libxcb-xfixes0-dev
```
> **Warning**
> Firefox can take upto 25sec to boot from cold due to `xdg-desktop-portal` being installed\
> when using awesomewm.
>
> Axe em:\
> `apt remove "xdg-desktop-portal*"`

[Ripgrep](https://github.com/BurntSushi/ripgrep)

[Fzf](https://github.com/junegunn/fzf)

[python-poetry](https://github.com/python-poetry/install.python-poetry.org)

[Starship prompt](https://github.com/starship/starship)

### Oh my zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh/

### Nvim dependencies
npm from apt store is too old to work with lsp python server (pywright), so needs installing
from upstream.
```
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
sudo apt install nodejs
sudo npm install -g neovim

### Better terminal
Install Alacritty
```
sudo snap install alacritty --edge --classic
```
```
## Stuff to configure
### Roots Crontab
Install the following into roots crontab to update Awesomemw apt update status every 2 hours.
```
sudo crontab-e
0 */2 * * * /usr/bin/apt update -q > /var/log/automaticupdates.log
```
### For Laptops
Installing deb package `light` to control laptop backlight also requires the local user to be
added to the *video* group.

When using Awesomewm single tapping the touchpad does not result in a mouse click.
`xinput` can be used to find the touchpad, then enable the options required, however
this is not transferable to other laptops. For example the following would be needed
for the Dell XPS
```
xinput
# touchpad  is id 10, now list its properties
xinput list-props 10
# finds that id 362 is single tap enable and id 346 is natural scrolling
xinput set-prop 10 362 1
xinput set-prop 10 346 1
```
Instead make the following change to Xorg config
```
sudo mkdir -p /etc/X11/xorg.conf.d/
# Add the following contents to a file called 90-touchpad.cond

Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "on"
        Option "ScrollMethod" "twofinger"
EndSection
```
Then restart `gdm3` or reboot and the touchpad will work as expected.
