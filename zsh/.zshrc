#=============================== Appimage/Bin dependencies ===============================#

[ ! -e $HOME/.pixi/bin ] && {

  printf "Enter sudo password to install missing debian and archlinux dependencies (when inside docker): " && read -s PASSWORD
  [ -e /bin/apt      ] && echo $PASSWORD | su -c "apt update -y && apt install --no-install-recommends --no-install-suggests -y ca-certificates curl file gcc libglib2.0-bin libsixel-bin mpv pipewire-pulse xclip" # xz-utils and sudo   required by nixpkgs # npm required by mason
  [ -e /bin/pacman   ] && echo $PASSWORD | su -c "pacman -Sy --needed --noconfirm                                                                                                         mpv pipewire-pulse xclip" # xdg-open and ffmpeg required by yazi    # pipewire-pulse is only required by mpv outside docker
	# [ -e /bin/pacman ] && echo $PASSWORD | su -c "curl -L https://github.com/Jguer/yay/releases/download/v12.1.2/yay_12.1.2_x86_64.tar.gz | tar -xzf- --strip-components=1 --directory=/usr/local/bin yay_12.1.2_x86_64/yay"
	# [ ! -e /nix      ] && yes | sh <(curl -L https://nixos.org/nix/install) --daemon; echo $PASSWORD | su -c "source ~/.nix-profile/etc/profile.d/nix.sh; nix-env --install -E 'f: (import <nixpkgs> {}).mpv-unwrapped.override { sixelSupport = true; }'" # nixpkgs doesn't support gpu

  curl -fsSL https://pixi.sh/install.sh | bash
  export PATH="$HOME/.pixi/bin:$PATH"
  pixi global install bat eza fzf ghostscript git imagemagick lazygit less lf nvim poppler ripgrep starship zellij zsh # pnpm nix xclip yazi

  starship config format "(\$battery)(\$sudo)(\$username)(\$directory)(\$git_branch)(\$git_status)(\$cmd_duration)(\$status)(\$character)"
  starship config add_newline false
  starship config cmd_duration.min_time 60000
  starship config directory.style "bold fg:#5555cc"
  starship config directory.truncation_length 9

  # use zsh as default shell:
  [ "$(id -u)" = 0 ] && export USER="root"
  echo $PASSWORD | su -c "chsh -s $(which zsh) $USER"

} && echo "Dependencies successfully installed, you need to relogin" && exit

#==================================== Zsh configs ========================================#

autoload -U compinit && compinit -u -d $HOME/.cache/.zcompdump # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion

# linux keyboard repeat rate, xset doesn't support wayland
(xset b off r rate 190 70 2>/dev/null)

# Change cursor shape for different vi modes.
zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

alias  grep="grep --color=auto"
export APPIMAGE_EXTRACT_AND_RUN=1
export BAT_THEME="base16"
export DISPLAY=:0
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}' --preview-window 'hidden' --bind '?:toggle-preview'"
export HISTFILE="$HOME/.cache/history"
export LANG=en_US.UTF-8 # `locale-gen` if zsh doens't erase some characters
export LC_ALL=C.UTF-8   # `locale` lists all user's locale https://wiki.archlinux.org/title/Locale
export LF_ICONS=" tw=󰉋:or=:ex=:bd=:di=󰉋:ow=󰉋:ln=:fi="
export LS_COLORS="tw=30:or=31:ex=32:bd=33:di=34:ow=35:ln=36:fi=37"
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"
export OPENER="gio open"
export PAGER="less -r --use-color -Dd+r -Du+b -DPyk -DSyk"
export PATH="$HOME/.pixi/bin:$HOME/.local/share/pnpm:$HOME/.local/share/npm/bin:$HOME/.local/bin:$PATH"
export PNPM_HOME=$HOME/.local/share/pnpm
export SAVEHIST=1000000
export SHELL="$(which zsh)"
export TERM="xterm-256color"
export TERM_PROGRAM=${TERM_PROGRAM:-WezTerm} # for yazi-image-preview inside docker
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"

[[ -e "/.dockerenv" ]] && export PULSE_SERVER=unix:/run/user/1000/pulse/native # for mpv when using pulseaudio inside docker
[[ -e "/.dockerenv" ]] && [[ -e "/nix" ]] && ! pidof -s nix-daemon >/dev/null 2>&1 && sudo su -c "/nix/var/nix/profiles/default/bin/nix-daemon &|"
[[ -z $NVIM         ]] && [[ -z $TMUX  ]] && export PTS=$TTY
[[ -z $ZELLIJ       ]] && exec zellij

precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" } # tmux/wezterm CWD(current working directory) status/title
lfcd () { cd "$(command lf -print-last-dir $@)";                 zle reset-prompt }
yacd () { yazi --cwd-file=$HOME/.yazi $@ < /dev/tty; cd "$(cat $HOME/.yazi)"; zle reset-prompt; echo -ne "\e[6 q"; }
zle -N lfcd
zle -N yacd
bindkey '\eo' 'lfcd' # \eo = alt + o
bindkey '\ey' 'yacd' # \ey = alt + y

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
which fzf      >/dev/null 2>&1 && source <(fzf --zsh)
which eza      >/dev/null 2>&1 && alias ls="eza --all --icons --group-directories-first"
which starship >/dev/null 2>&1 && eval "$(starship init zsh)"
