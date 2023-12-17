#=============================== Appimage/Bin dependencies ===============================#

[ ! -e $HOME/.local/share/sixelrice ] && {

  printf "Enter sudo password to install dependencies (deps are only installed on archlinux and debian based systems): " && read -s PASSWORD
  [ -e /bin/pacman ] && echo $PASSWORD | su -c "pacman -Sy --needed --noconfirm git less libsixel unzip xclip zsh" # npm required by Mason.nvim
  [ -e /bin/apt    ] && echo $PASSWORD | su -c "apt update -y && apt install -y curl file gcc g++ git less libarchive-tools libglib2.0-bin libsixel-bin locales make sudo unzip xclip zsh" # xz-utils required by nixpkgs
	curl -L https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage                                          --create-dirs --output    "$HOME/.local/share/sixelrice/nvim" && chmod +x "$HOME/.local/share/sixelrice/nvim"
	curl -L https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh                                     --create-dirs --output    "$HOME/.local/share/sixelrice/fzf-key-bindings/key-bindings.zsh"
	curl -L https://github.com/junegunn/fzf/releases/download/0.42.0/fzf-0.42.0-linux_amd64.tar.gz                          | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/zellij-org/zellij/releases/download/v0.39.2/zellij-x86_64-unknown-linux-musl.tar.gz          | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz           | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/gokcehan/lf/releases/download/r31/lf-linux-amd64.tar.gz                                      | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/Aloxaf/fzf-tab/archive/refs/heads/master.zip                                                 | bsdtar -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v0.7.0.tar.gz                                | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.10.0.tar.gz                                      | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.55.tar.gz                    | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/starship/starship/releases/download/v1.16.0/starship-x86_64-unknown-linux-gnu.tar.gz         | tar    -xzf- --directory="$HOME/.local/share/sixelrice/"
	curl -L https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-unknown-linux-gnu.tar.gz            | tar    -xzf- --directory="/tmp" && cp "/tmp/bat-v0.23.0-x86_64-unknown-linux-gnu/bat"    "$HOME/.local/share/sixelrice/"
	curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.0.3/ripgrep-14.0.3-x86_64-unknown-linux-musl.tar.gz  | tar    -xzf- --directory="/tmp" && cp "/tmp/ripgrep-14.0.3-x86_64-unknown-linux-musl/rg" "$HOME/.local/share/sixelrice/"
	rm -rf /tmp/bat* /tmp/ripgrep* # /tmp inside docker doesn't get removed

  # locales for zsh-autosuggestions:
  echo $PASSWORD | su -c "sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && locale-gen"

  # use zsh as default shell:
  [ "$(id -u)" = 0 ] && export USER="root"
  echo $PASSWORD | su -c "chsh -s $(which zsh) $USER"

} && $MULTIMEDIA && {

	# [ ! -e /nix           ] && yes | sh <(curl -L https://nixos.org/nix/install) --daemon; echo $PASSWORD | su -c "source ~/.nix-profile/etc/profile.d/nix.sh; nix-env --install -E 'f: (import <nixpkgs> {}).mpv-unwrapped.override { sixelSupport = true; }'" # nixpkgs doesn't support gpu
	# [ -e /bin/pacman      ] && echo $PASSWORD | su -c "curl -L https://github.com/Jguer/yay/releases/download/v12.1.2/yay_12.1.2_x86_64.tar.gz | tar -xzf- --strip-components=1 --directory=/usr/local/bin yay_12.1.2_x86_64/yay"
  [ -e /bin/pacman        ] && echo $PASSWORD | su -c "pacman -Sy --needed --noconfirm imagemagick ghostscript mpv pipewire-pulse poppler && yes | pacman -Scc" # xdg-open ffmpegthumbnailer required by yazi
  [ -e /bin/apt           ] && echo $PASSWORD | su -c "apt install -y imagemagick ghostscript mpv pipewire-pulse poppler-utils && apt autoremore -y"            # pipewire-pulse is only required by mpv outside docker
  [ -e /etc/ImageMagick-6 ] && echo $PASSWORD | su -c "mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.old"                                      # ubuntu's imagemagick pdf-conversion is old and restricted

	# curl -L https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/WezTerm-20230712-072601-f4abf8fd-Ubuntu20.04.AppImage --create-dirs --output "$HOME/.local/share/sixelrice/wezterm" && chmod +x "$HOME/.local/share/sixelrice/wezterm"
	# curl -L https://github.com/ivan-hc/MPV-appimage/releases/download/continuous/MPV-Media-Player_0.36.0-1-archimage2.1-4-x86_64.AppImage   --create-dirs --output "$HOME/.local/share/sixelrice/mpv"     && chmod +x "$HOME/.local/share/sixelrice/mpv"     # doesn't work inside docker
	curl -L https://raw.githubusercontent.com/occivink/mpv-gallery-view/master/script-modules/gallery.lua                                     --create-dirs --output "$HOME/.config/mpv/script-modules/gallery.lua"
	curl -L https://raw.githubusercontent.com/occivink/mpv-gallery-view/master/scripts/gallery-thumbgen.lua                                   --create-dirs --output "$HOME/.config/mpv/scripts/gallery-thumbgen.lua"
	curl -L https://raw.githubusercontent.com/occivink/mpv-gallery-view/master/scripts/playlist-view.lua                                      --create-dirs --output "$HOME/.config/mpv/scripts/playlist-view.lua"
	curl -L https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook.lua                                                              --create-dirs --output "$HOME/.config/mpv/scripts/pdf_hook.lua"
	curl -L https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook-worker.lua                                                       --create-dirs --output "$HOME/.config/mpv/scripts/pdf_hook-worker-1.lua"
	curl -L https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook-worker.lua                                                       --create-dirs --output "$HOME/.config/mpv/scripts/pdf_hook-worker-2.lua"
	mkdir /tmp/mpv-pdf

} && echo "Dependencies successfully installed, you need to relogin" && exit

#==================================== Zsh configs ========================================#

alias  ll="ls -lha --hyperlink=auto --color=auto --group-directories-first"
alias  ls="ls      --hyperlink=auto --color=auto --group-directories-first"
alias  grep="grep --color=auto"
export APPIMAGE_EXTRACT_AND_RUN=1
export BAT_THEME="base16"
export DISPLAY=:0
export EDITOR="nvim"
export HISTFILE="$HOME/.cache/history"
export LANG=en_US.UTF-8
export LF_ICONS=" tw=󰉋:or=:ex=:bd=:di=󰉋:ow=󰉋:ln=:fi="
export LS_COLORS="tw=30:or=31:ex=32:bd=33:di=34:ow=35:ln=36:fi=37"
export OPENER="gio open"
export PAGER="less -r --use-color -Dd+r -Du+b -DPyk -DSyk"
export PATH="$HOME/.local/share/sixelrice:$HOME/.local/bin:$PATH"
export SAVEHIST=1000000
export SHELL="$(which zsh)"
export TERM="xterm-256color"
export TERM_PROGRAM=${TERM_PROGRAM:-WezTerm} # for yazi-image-preview inside docker
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
export ZVM_INIT_MODE=sourcing  # prevents zsh-vim overwriting fzf_history

autoload -U compinit && compinit -d ~/.cache/.zcompdump # for completions
setopt interactive_comments # to allow comments
source $HOME/.local/share/sixelrice/zsh-autosuggestions-0.7.0/zsh-autosuggestions.plugin.zsh
source $HOME/.local/share/sixelrice/fast-syntax-highlighting-1.55/fast-syntax-highlighting.plugin.zsh
source $HOME/.local/share/sixelrice/zsh-vi-mode-0.10.0/zsh-vi-mode.plugin.zsh
source $HOME/.local/share/sixelrice/fzf-tab-master/fzf-tab.plugin.zsh
source $HOME/.local/share/sixelrice/fzf-key-bindings/key-bindings.zsh

[[ -e "/.dockerenv" ]] && export PULSE_SERVER=unix:/run/user/1000/pulse/native # for mpv when using pulseaudio inside docker
[[ -e "/.dockerenv" ]] && [[ -e "/nix" ]] && ! pidof -s nix-daemon >/dev/null 2>&1 && sudo su -c "/nix/var/nix/profiles/default/bin/nix-daemon &|"
[[ -z $NVIM         ]] && [[ -z $TMUX  ]] && export PTS=$TTY
[[ -z $ZELLIJ       ]] && exec zellij

precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" } # tmux/wezterm CWD(current working directory) status/title
lfcd () { cd "$(command lf -print-last-dir $@)";                 zle reset-prompt }
yacd () { yazi --cwd-file=$HOME/.yazi $@; cd $(cat $HOME/.yazi); zle reset-prompt }
zle -N lfcd
zle -N yacd
bindkey '\eo' 'lfcd' # \eo = alt + o
bindkey '\ey' 'yacd' # \ey = alt + y

starship config format "(\$battery)(\$sudo)(\$username)(\$directory)(\$git_branch)(\$git_status)(\$cmd_duration)(\$status)(\$character)"
starship config add_newline false
starship config cmd_duration.min_time 60000
starship config directory.style "bold fg:#5555cc"
starship config directory.truncation_length 9

eval "$(starship init zsh)"
