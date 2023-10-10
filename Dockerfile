#================================ Docker run sixel-rice ================================#

# xhost +
# docker build --tag sixel-rice .
# docker run -it \
#     --name sixel-rice \
#     --ipc=host \
#     --volume=/run/user/1000/pipewire-0:/run/user/1000/pipewire-0 \
#     --volume=/tmp/.X11-unix:/tmp/.X11-unix \
#     sixel-rice

#===================================== Dockerfile ======================================#

# FROM ubuntu
FROM archlinux:base-devel

SHELL ["/bin/bash","-c"]

# add user:
RUN if [[ -e /bin/pacman ]]; then useradd -mG wheel drksl; fi; \
  if [[ -e /bin/apt    ]]; then useradd -mG sudo  drksl; fi; \
  echo root:toor  | chpasswd; \
  echo drksl:toor | chpasswd; \
  mkdir -p /etc/sudoers.d; \
  echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo; \
  echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

# Arch dependencies:
RUN if [[ -e /bin/pacman ]]; then  \
  pacman -Sy --noconfirm bat fzf lazygit libsixel lf ripgrep starship tmux unzip xclip zsh glibc \
  && yes | pacman -Scc \
  && curl -L https://github.com/Jguer/yay/releases/download/v12.1.2/yay_12.1.2_x86_64.tar.gz | tar -xzf- --strip-components=1 --directory="/usr/local/bin" "yay_12.1.2_x86_64/yay" \
  && curl -L https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage                               --create-dirs --output "/usr/local/bin/nvim" && chmod +x /usr/local/bin/nvim; \
  fi

# Debian dependencies:
RUN if [[ -e /bin/apt ]]; then \
  apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y curl file git gcc libsixel-bin locales make ripgrep sudo unzip xclip xdg-utils xz-utils zsh \
  && apt autoremove -y \
  && curl -L https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-unknown-linux-gnu.tar.gz    | $SUDO tar -xzf- --directory="/tmp"  && $SUDO cp "/tmp/bat-v0.23.0-x86_64-unknown-linux-gnu/bat" "/usr/local/bin" \
  && curl -L https://github.com/starship/starship/releases/download/v1.16.0/starship-x86_64-unknown-linux-gnu.tar.gz | $SUDO tar -xzf- --directory="/usr/local/bin/" \
  && curl -L https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz   | $SUDO tar -xzf- --directory="/usr/local/bin/" \
  && curl -L https://github.com/gokcehan/lf/releases/download/r31/lf-linux-amd64.tar.gz                              | $SUDO tar -xzf- --directory="/usr/local/bin/" \
  && curl -L https://github.com/junegunn/fzf/releases/download/0.42.0/fzf-0.42.0-linux_amd64.tar.gz                  | $SUDO tar -xzf- --directory="/usr/local/bin/" \
  && curl -L https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh                                     --create-dirs --output "/usr/share/fzf/completion.zsh" \
  && curl -L https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh                                   --create-dirs --output "/usr/share/fzf/key-bindings.zsh" \
  && curl -L https://github.com/antontkv/tmux-appimage/releases/download/3.3a/tmux-3.3a-x86_64.appimage                     --create-dirs --output "/usr/local/bin/tmux" && $SUDO chmod +x /usr/local/bin/tmux \
  && curl -L https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage                                        --create-dirs --output "/usr/local/bin/nvim" && chmod +x /usr/local/bin/nvim \
  && chmod o+rx "/usr/share/fzf" \
  && yes | sh <(curl -L https://nixos.org/nix/install) --daemon; \
  fi

# locales for zsh-autosuggestions:
RUN sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
  && locale-gen

USER drksl
WORKDIR /home/drksl
EXPOSE 22/tcp
EXPOSE 8080/tcp
ENV HOME="/home/drksl"
ENV USER="drksl"
ENV SHELL="/bin/zsh"
ENV DISPLAY=:0
SHELL ["/bin/zsh","-c"]

# neovim/zsh/mpv plugins:
RUN  git clone --depth=1                        https://github.com/astronvim/astronvim                                          "$HOME/.config/nvim" \
  && git clone --depth=1                        https://github.com/zsh-users/zsh-autosuggestions                                "$HOME/.config/zsh-autosuggestions" \
  && git clone --depth=1                        https://github.com/zdharma-continuum/fast-syntax-highlighting                   "$HOME/.config/fast-syntax-highlighting" \
  && git clone --depth=1                        https://github.com/occivink/mpv-gallery-view                                    "$HOME/.config/mpv" \
  && curl -L                                    https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook.lua         -o "$HOME/.config/mpv/scripts/pdf_hook.lua" \
  && curl -L                                    https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook-worker.lua  -o "$HOME/.config/mpv/scripts/pdf_hook-worker-1.lua" \
  && curl -L                                    https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook-worker.lua  -o "$HOME/.config/mpv/scripts/pdf_hook-worker-2.lua" \
  && curl -L                                    https://raw.githubusercontent.com/jgreco/mpv-pdf/master/pdf_hook-worker.lua  -o "$HOME/.config/mpv/scripts/pdf_hook-worker-3.lua"

# astronvim configs:
COPY --chown=drksl ./user           $HOME/.config/nvim/lua/user
COPY --chown=drksl ./lazy-lock.json $HOME/.config/nvim/lua/lazy-lock.json

# ssh daemon:
# RUN if [[ -e /bin/pacman ]]; then sudo pacman -S --noconfirm openssh; fi; \
#     if [[ -e /bin/apt    ]]; then DEBIAN_FRONTEND=noninteractive sudo apt install -y openssh-client openssh-server; fi; \
#     sudo mkdir /run/sshd; \
#     sudo /usr/bin/ssh-keygen -A; \
#     echo "sudo /sbin/sshd" >>/home/drksl/.zprofile

#=============================== zsh configs ===========================================#

# source zsh plugins
RUN <<"====" >> $HOME/.zprofile
    export APPIMAGE_EXTRACT_AND_RUN=1
    alias  ll="ls -lAhN --hyperlink=auto --color=auto --group-directories-first"
    alias  ls="ls -a --hyperlink=auto --color=auto --group-directories-first"
    alias  grep="grep --color=auto"
    alias  mkdir="mkdir -pv"
    alias  mv="mv -iv"
    alias  cp="cp -iv"
    export BAT_THEME="base16"
    export DISPLAY=:0
    export EDITOR="nvim"
    export HISTFILE="$HOME/.cache/history"
    export LANG=en_US.UTF-8
    export LESSKEYIN="$HOME/.config/lf/lesskey"
    export LF_ICONS=" tw=󰉋:or=:ex=:bd=:di=󰉋:ow=󰉋:ln=:fi="
    export LS_COLORS="tw=30:or=31:ex=32:bd=33:di=34:ow=35:ln=36:fi=37"
    export OPENER="$([ -e /bin/apt ] && echo 'xdg-open' || echo 'gio open')"
    export PAGER="less -r --use-color -Dd+r -Du+b -DPyk -DSyk"
    export PATH="$HOME/.local/bin:$PATH"
    export SAVEHIST=1000000
    export SHELL="$(which zsh)"
    export STARSHIP_CONFIG="$HOME/.config/lf/starship.toml"
    export TERM="xterm-256color"
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
    [[ -e "/bin/apt" ]]      && ! pidof -s nix-daemon >/dev/null 2>&1 && sudo /nix/var/nix/profiles/default/bin/nix-daemon &|
    [[ -z $TMUX ]]           && [[ -z $NVIM ]]                        && export PTS=$TTY && sleep 1 && exec tmux -u
    [[ $USER != codespace ]] && [[ -e /.dockerenv ]]                  && export PTS=/dev/pts/0

    # Basic auto/tab complete:
    autoload -U compinit && compinit -u
    zmodload zsh/complist
    zstyle ':completion:*' menu select
    _comp_options+=(globdots)		# Include hidden files.

    # zsh-vim keybindings
    bindkey -v '^?'           backward-delete-char
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'k' vi-up-line-or-history
    function zle-keymap-select () {
        case $KEYMAP in
            vicmd)      echo -ne '\e[2 q';; # block
            viins|main) echo -ne '\e[6 q';; # beam
        esac
    }
    zle-line-init() { zle -K viins; echo -ne "\e[6 q"; }
    zle -N zle-keymap-select
    zle -N zle-line-init
    preexec() { echo -ne '\e[6 q' ;}                       # Use beam shape cursor for each new prompt.
    precmd() { printf "\033]0; ${${PWD/#$HOME/~}##*/} \a"} # tmux CWD(current working directory) status
    setopt interactive_comments                            # to allow comments

    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    source $HOME/.config/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    source $HOME/.config/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    eval "$(starship init zsh)"
====

# LessKeys
COPY --chown=drksl <<"====" "$HOME/.config/lf/lesskey"
h left-scroll
l right-scroll
i quit
J forw-scroll
K back-scroll
====

# starship
COPY --chown=drksl <<"====" "$HOME/.config/lf/starship.toml"
format = "($battery)($sudo)($username)($directory)($git_branch)($git_status)($cmd_duration)($status)($character)"
add_newline = false

[cmd_duration]
min_time = 60000

[directory]
style = "bold fg:#5555cc"
truncation_length = 9
====

# mpv
COPY --chown=drksl <<"====" "$HOME/.config/mpv/input.conf"
Q seek -10.0
R seek -10.0
W seek -5.0
E seek  5.0
w seek -5.0
e seek  5.0
[ seek -60
] seek  60
- add speed -0.1
+ add speed  0.1
/ set speed  1.0
* set speed  3.0
1 seek 10 absolute-percent
2 seek 20 absolute-percent
3 seek 30 absolute-percent
4 seek 40 absolute-percent
5 seek 50 absolute-percent
6 seek 60 absolute-percent
7 seek 70 absolute-percent
8 seek 80 absolute-percent
9 seek 90 absolute-percent
0 seek 0  absolute-percent
h playlist-prev
j playlist-next
k playlist-prev
l playlist-next
z playlist-shuffle           # like ncmpcpp shuffle  key
C cycle sub                  # like youtube captions key
d      add sub-delay   -0.1  # subtract 100 ms from sub
D      add sub-delay    0.1  # add      100 ms to   sub
ctrl+- add volume      -2.0
ctrl++ add volume       2.0
alt+i  add video-zoom   0.1  # zoom in
alt+o  add video-zoom  -0.1  # zoom out
Alt+h  add video-pan-x  0.05
Alt+l  add video-pan-x -0.05
Alt+k  add video-pan-y  0.05
Alt+j  add video-pan-y -0.05
====

# lfcd
RUN <<"====" >> $HOME/.zprofile

    [ -e /.dockerenv ] && [ "$(id -u)" != 0 ] && sudo chown "$USER":tty /dev/pts/0
    lfcd () {
      cd "$(command lf -print-last-dir "$@")"
      zle reset-prompt
    }
    zle -N lfcd < $PTS
    bindkey '\eo' 'lfcd'

====

#================================== lf configs ===========================================#

# lfrc
COPY --chown=drksl <<"====" $HOME/.config/lf/lfrc
set icons
set hidden true
set ratios 1:2
set shell /bin/bash
set previewer ~/.config/lf/previewer
set cleaner ~/.config/lf/cleaner
set promptfmt "[1;34m%w "
set cursoractivefmt  "\033[40m" # "\033[7m\033[30m\033[46m"
set cursorparentfmt  "\033[40m" # "\033[7m\033[30m\033[46m"
set cursorpreviewfmt "\033[40m" # "\033[7m\033[30m\033[46m"

cmd on-cd &{{ printf "\033]0; $(TMP=${PWD/#$HOME/\~};echo ${TMP##*/}) \a" > /dev/tty }}

cmd open ${{
  case $(file --dereference --brief --mime-type $f) in
    text/*|application/json)         ( printf "\033]0; ${f##*/} \a" ) >$PTS && $EDITOR $fx ;;
    image/*|video/*|application/pdf)   XDG_RUNTIME_DIR=/run/user/1000 mpv --vo=x11 $fx || ( printf %b '\033Ptmux;\033''\033]777;notify;run "xhost +" outside docker/root;\007\007''\033\\'; XDG_RUNTIME_DIR=/run/user/1000 mpv --vo=sixel,kitty $fx) ;;
    *) for f in $fx; do $OPENER "$f" &>/dev/null & disown; done;;
  esac
}}

cmd fzf_ripgrep ${{
  IFS=: read -ra selected < <(
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
      fzf --ansi \
          --color "hl:-1:reverse,hl+:-1:reverse,bg+:#111111" \
          --delimiter : \
          --preview 'bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
  )
  [ -n "${selected[0]}" ] && lf -remote "send $id select \"${selected[0]}\""
  [ -n "${selected[0]}" ] && nvim "${selected[0]}" "+${selected[1]}"
}}

map i       $[[ "$f" =~ .png|.jpg ]] && ( img2sixel "$f" | less -r            ) > $PTS || bat --paging=always --wrap=never "$f"
map gmi     $[[ "$f" =~ .png|.jpg ]] && ( img2sixel "$f" | less -r            ) > $PTS || bat --paging=always --wrap=never "$f"
map o       $[[ "$f" =~ .pdf      ]] && ( convert "${f}[0]" sixel:- | less -r ) > $PTS || (      mpv --ao=null --vo-image-outdir=/tmp  --vo=image --start=1 --frames=1 "$f" && img2sixel /tmp/00000001.jpg | less -r ) > $PTS
map gmo     $[[ "$f" =~ .pdf      ]] && ( convert "${f}[0]" sixel:- | less -r ) > $PTS || (      mpv --ao=null --vo-image-outdir=/tmp  --vo=image --start=1 --frames=1 "$f" && img2sixel /tmp/00000001.jpg | less -r ) > $PTS
map gtd     $tmux detach -E                                      "XDG_RUNTIME_DIR=/run/user/1000 PATH=$HOME/.nix-profile/bin:$PATH mpv --vo=sixel,kitty,x11 $fx && tmux attach-session"
map gtp     $tmux popup -w 110 -h 37 -x 60 -y 1 -E               "XDG_RUNTIME_DIR=/run/user/1000 PATH=$HOME/.nix-profile/bin:$PATH mpv --vo=tct             $fx"
map gts     $tmux split-window -h && sleep 0.5 && tmux send-keys "XDG_RUNTIME_DIR=/run/user/1000 mpv                                   --vo=sixel,kitty,x11 $fx && exit" 'Enter'
map gtw     $tmux new-window      && sleep 0.5 && tmux send-keys "XDG_RUNTIME_DIR=/run/user/1000 mpv                                   --vo=sixel,kitty,x11 $fx && exit" 'Enter'
map gws     $wezterm cli split-pane --horizontal   -- bash -c    "XDG_RUNTIME_DIR=/run/user/1000 mpv                                   --vo=sixel,kitty,x11 $fx"
map gww     $wezterm cli spawn                     -- bash -c    "XDG_RUNTIME_DIR=/run/user/1000 mpv                                   --vo=sixel,kitty,x11 $fx"
map gll     $lazygit
map gfs     $lf -remote "send $id select \"$(fzf --bind='?:toggle-preview' --preview 'bat --color=always {}' --preview-window 'right,50%,border-left' < $PTS)\""
map gfr     :fzf_ripgrep
map <enter> shell
map D       $mkdir -p $HOME/.cache/Trash && basename -a $fx | xargs -I var mv var "$HOME/.cache/Trash/var-$(date '+%y%m%d-%H-%M-%S')"
map J       push 10j
map K       push 10k
map Y       $printf "%s" "$fx" | xclip -selection clipboard
====

# lf previewer
COPY --chown=drksl <<"====" $HOME/.config/lf/previewer
#!/bin/bash

case $(file --dereference --brief --mime-type $1) in
  image/*)          ( img2sixel --loop-control=disable                                             -w $((${2}*7)) "$1"                 ) > $PTS && exit 1 || echo "no libsixel :(" ;;
  application/pdf)  ( convert "${1}[0]" jpg:/tmp/imagemagick.png                      && img2sixel -w $((${2}*4)) /tmp/imagemagick.png ) > $PTS && exit 1 || echo "no imagemagick :(" ;;
  video/*)          ( ffmpeg -ss 00:10 -i "$1" -frames 1 -f image2 /tmp/ffmpeg.png -y && img2sixel -w $((${2}*7)) /tmp/ffmpeg.png      ) > $PTS && exit 1 || echo "no ffmpeg :(" ;;
  *)                ( bat --style=plain --color=always "$1" )                                                                                             || echo "no bat :(" ;;
esac

====

# lf cleaner
COPY --chown=drksl <<"====" $HOME/.config/lf/cleaner
#!/bin/bash
pkill --signal SIGWINCH lf
====

# lf executables
RUN chmod +x $HOME/.config/lf/{previewer,cleaner}

#=================================== tmux configs ===========================================#

# tmux config
RUN <<==== >> $HOME/.tmux.conf
    set  -g  default-shell                /bin/zsh
    set  -g  mouse                        on
    set  -g  pane-active-border-style     bg=default,fg=gray
    set  -g  pane-border-style            fg=colour235
    set  -g  status                       off
    set  -g  allow-passthrough            on
    set  -ga status-style                 bg=default
    set  -ga status-style                 fg="#aaaaaa"
    set  -g  status-left                  ""
    set  -g  status-right                 ""
    set  -g  default-terminal             "tmux-256color"
    set  -g  window-status-current-format "#[bg=#1c1c1c,fg=#888888]#{window_index}:#{pane_title}"
    set  -g  window-status-format         "#[bg=default,fg=#2c2c2c]#{window_index}:#{pane_title}"
    set  -g  window-status-separator      " "
    setw -g  mode-keys                    vi
    bind -n  Home                         send Escape "OH"
    bind -n  End                          send Escape "OF"
    bind -T  copy-mode-vi y               send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
    bind -T  copy-mode-vi v               send-keys -X begin-selection
    bind -T  copy-mode-vi BTab            select-window -p
    bind -T  copy-mode-vi Tab             select-window -n
    bind -T  copy-mode-vi \;              select-window -l
    bind -n  C-M-l                        send-keys C-l \; run 'tmux clear-history'
    bind     Space                        copy-mode \; send-keys left left
    bind -n  C-M-Space                    copy-mode \; send-keys left left
    bind -n  C-M-h                        copy-mode \; send-keys left left
    bind -n  M-r                          copy-mode \; send-keys left left \; send-keys -X scroll-up
    bind -n  M-w                          copy-mode \; send-keys left left \; send-keys -X scroll-down
    bind -n  M-e                          copy-mode \; send-keys left left \; send-keys -X scroll-up
    bind -n  M-d                          copy-mode \; send-keys left left \; send-keys -X scroll-down
    bind -n  M-q                          copy-mode \; send-keys left left \; send-keys -X page-up
    bind -n  M-a                          copy-mode \; send-keys left left \; send-keys -X page-down
    bind -n  M-t                          copy-mode \; send-keys left left \; send-keys -X history-top
    bind -n  M-g                          copy-mode \; send-keys left left \; send-keys -X history-bottom
    bind -T  copy-mode-vi M-r             send-keys -X scroll-up
    bind -T  copy-mode-vi M-w             send-keys -X scroll-down
    bind -T  copy-mode-vi M-e             send-keys -X scroll-up
    bind -T  copy-mode-vi M-d             send-keys -X scroll-down
    bind -T  copy-mode-vi M-q             send-keys -X page-up
    bind -T  copy-mode-vi M-a             send-keys -X page-down
    bind -T  copy-mode-vi M-t             send-keys -X history-top
    bind -T  copy-mode-vi M-g             send-keys -X history-bottom
    bind -T  copy-mode-vi u               send-keys -X halfpage-up
    bind -T  copy-mode-vi d               send-keys -X halfpage-down
    bind -T  copy-mode-vi i               send-keys -X cancel
    bind -T  copy-mode-vi H               send-keys left  left  left  left  left  left  left  left  left  left
    bind -T  copy-mode-vi J               send-keys down  down  down  down  down  down  down  down  down  down
    bind -T  copy-mode-vi K               send-keys up    up    up    up    up    up    up    up    up    up
    bind -T  copy-mode-vi L               send-keys right right right right right right right right right right
    bind -n  C-M-b                        set -g status
    bind     b                            set -g status
    bind     c                            set -g status on \; new-window
    bind -n  C-t                          set -g status on \; new-window
    bind -n  C-w                          kill-pane
    bind     -                            swap-pane
    bind     +                            join-pane
    bind     x                            kill-pane
    bind -n  M-S                          swap-window -t -1\; select-window -t -1
    bind -n  M-F                          swap-window -t +1\; select-window -t +1
    bind -n  M-\;                         select-window -l
    bind -r  \;                           select-window -l
    bind -n  M-s                          select-window -p
    bind -n  M-f                          select-window -n
    bind -r  BTab                         select-window -p
    bind -r  Tab                          select-window -n
    bind -n  C-M-n                        select-window -n
    bind -n  C-M-p                        select-window -p
    bind -n  C-Left                       select-pane -L
    bind -n  C-Down                       select-pane -D
    bind -n  C-Up                         select-pane -U
    bind -n  C-Right                      select-pane -R
    bind -r  h                            select-pane -L
    bind -r  j                            select-pane -D
    bind -r  k                            select-pane -U
    bind -r  l                            select-pane -R
    bind -r  H                            resize-pane -L
    bind -r  J                            resize-pane -D
    bind -r  K                            resize-pane -U
    bind -r  L                            resize-pane -R
    bind -n  C-M-Left                     resize-pane -L
    bind -n  C-M-Down                     resize-pane -D
    bind -n  C-M-Up                       resize-pane -U
    bind -n  C-M-Right                    resize-pane -R
    bind     v                            split-window -h
    bind     V                            split-window -v
    bind -n  C-M-v                        split-window -h
    bind -n  C-M-h                        split-window -v
====

CMD ["/usr/bin/zsh","-l"]
