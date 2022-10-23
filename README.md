# About

A place to store your dotfiles and move them around different machines.

# Setup

```
git archive --remote=https://github.com/kevclark/dotfiles.git HEAD .dotfiles-scripts/makehome.py | tar -xO | python3
```
## Stuff to apt install
```
sudo apt install vim vim-gtk xclip byobu zsh zsh-autosuggestions zsh-syntax-highlighting \
git htop minicom tree autojump python3-pip taskwarrior nitrogen numlockx xautolock \
libcanberra-gtk-module rofi dmenu thunar i3lock-fancy lxappearance awesome awesome-extra \
golang rustc light
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
sudo curl -sL https://deb.nodesource.com/setup_14.x | bash -
sudo apt install nodejs
sudo npm install -g neovim
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
