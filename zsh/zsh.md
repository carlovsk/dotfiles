# ⚙️ ZSH Configs

After installing ubuntu, follow this steps as soon as possible.

## CURL

```
sudo apt install curl
```

Check if instalation was successful

```
curl --version
```

## Git

```
sudo apt-get install git
```

Check if instalation was successful

```
git --version
```

## ZSH

```
sudo apt install zsh
```

Check if instalation was successful

```
zsh --version
```

Define zsh as default shell

```
chsh -s $(which zsh)
```

Logout session to apply the changes

```
gnome-session-quit
```

After login again, check if zsh is the default shell

```
echo $SHELL
```

It has to return '/usr/bin/zsh'

## Oh My ZSH

Installing oh my zsh

```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
Installing dracula theme
```
sudo apt-get install dconf-cli
```
```
git clone https://github.com/dracula/gnome-terminal
```
```
cd gnome-terminal
```
```
./install.sh
```
Choose first color scheme, create terminal profile using dracula color scheme and choose 'I don't need any dircolors' on the last choice

### Fira Code
```
sudo apt install fonts-firacode fontconfig
```
Check installation
```
fc-list | grep FiraCode
```

### Spaceship theme
```
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
```
```
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```
Enter ./zshrc on Home and copy and paste zsh-config.txt content

### Plugins
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
```

