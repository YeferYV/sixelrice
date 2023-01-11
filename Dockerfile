# syntax=docker/dockerfile:1

#=========== Docker build/run alpine-nix-dockerfile ==========#

# xhost +
# sudo pkill dockerd && sleep 1 && sudo dockerd --experimental & disown
# DOCKER_BUILDKIT=1 docker build --squash -t alpine-nix-dockerfile .
# docker run -it --name alpine-nix-dockerfile -v /tmp/.X11-unix:/tmp/.X11-unix alpine-nix-dockerfile

#============= Dockerfile: alpine-nix-dockerfile =============#

# FROM alpine
# RUN apk add bash curl shadow sudo tmux xz zsh zsh-vcs \
#     && useradd -mG wheel -s /bin/bash drksl \
#     && echo root:toor | chpasswd \
#     && echo drksl:toor | chpasswd \
#     && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
# ...

#=========== Docker build/run ubuntu-nix-dockerfile ==========#

# xhost +
# sudo pkill dockerd && sleep 1 && sudo dockerd --experimental & disown
# DOCKER_BUILDKIT=1 docker build --squash -t ubuntu-nix-dockerfile .
# docker run -it --name ubuntu-nix-dockerfile -v /tmp/.X11-unix:/tmp/.X11-unix ubuntu-nix-dockerfile

#============= Dockerfile: ubuntu-nix-dockerfile =============#

FROM ubuntu
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl file sudo unzip xz-utils zsh \
    && useradd -mG sudo -s /bin/bash drksl \
    && echo root:toor | chpasswd \
    && echo drksl:toor | chpasswd \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

USER drksl
WORKDIR /home/drksl
ENV HOME="/home/drksl"
ENV USER="drksl"
ENV SHELL="/bin/zsh"
ENV DISPLAY=:0
SHELL ["/bin/zsh","-c"]

# install nix
RUN curl -L nixos.org/nix/install | sh \
    && . $HOME/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -iA nixpkgs.bat nixpkgs.fzf nixpkgs.gcc nixpkgs.git nixpkgs.killall nixpkgs.lazygit \
                   nixpkgs.libsixel nixpkgs.less nixpkgs.lf nixpkgs.neovim nixpkgs.ripgrep nixpkgs.timg nixpkgs.tmux nixpkgs.trash-cli \
                   nixpkgs.xclip nixpkgs.xdg-utils nixpkgs.zsh-autosuggestions nixpkgs.zsh-fast-syntax-highlighting \
    && nix-env -iA spaceship-prompt -f https://github.com/NixOS/nixpkgs/archive/ff8b619cfecb98bb94ae49ca7ceca937923a75fa.tar.gz \
    && nix-collect-garbage -d

# # ssh
# RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y openssh-client openssh-server \
#     && sudo mkdir /run/sshd \
#     && sudo /usr/bin/ssh-keygen -A \
#     && echo "sudo /sbin/sshd" >>/home/drksl/.zprofile

# install neovim plugins
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh \
    && git clone --depth=1 https://github.com/astronvim/astronvim ~/.config/nvim

# copy astronvim custom config
RUN mkdir -p  $HOME/.config/nvim/lua/user
COPY --chown=drksl init.lua $HOME/.config/nvim/lua/user

# source zsh plugins
RUN <<"====" >> $HOME/.zprofile
    export DISPLAY=:0
    export EDITOR="nvim"
    export HISTFILE="$HOME/.cache/history"
    export LANG=en_US.UTF-8
    export LESSKEYIN="$HOME/.config/lf/lesskey"
    export LF_ICONS=" tw=:or=:ex=:bd=:di=:ow=:ln=:fi="
    export LS_COLORS="tw=30:or=91:ex=92:bd=93:di=94:ow=14:ln=34:fi=37"
    export PAGER="less -r --use-color -Dd+r -Du+b -DPyk -DSyk"
    export PROMPT_COMMAND='echo -ne "\033]0; ${${PWD/#$HOME/~}##*/} \a"'
    export BAT_THEME="base16"
    export SAVEHIST=10000000
    export SHELL="$(which zsh)"
    export SPACESHIP_PROMPT_ADD_NEWLINE="false"
    export SPACESHIP_PROMPT_SEPARATE_LINE="false"
    export SPACESHIP_VI_MODE_SHOW="false"
    export TERM="xterm-256color"
    source $HOME/.nix-profile/share/fzf/completion.zsh
    source $HOME/.nix-profile/share/fzf/key-bindings.zsh
    source $HOME/.nix-profile/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $HOME/.nix-profile/lib/spaceship-prompt/spaceship.zsh
    source $HOME/.nix-profile/etc/profile.d/nix.sh
    precmd() { eval "$PROMPT_COMMAND" }
    [[ -z $TMUX ]] && sleep 1 && exec tmux -u
    bindkey -v '^?' backward-delete-char
    function zle-keymap-select () {
        case $KEYMAP in
            vicmd) echo -ne '\e[2 q';;      # block
            viins|main) echo -ne '\e[6 q';; # beam
        esac
    }
    zle -N zle-keymap-select
    zle-line-init() {
        zle -K viins
        echo -ne "\e[6 q"
    }
    zle -N zle-line-init
    preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
    ## Basic auto/tab complete:
    autoload -U compinit && compinit -u
    zmodload zsh/complist
    zstyle ':completion:*' menu select
    _comp_options+=(globdots)		# Include hidden files.
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -v '^?' backward-delete-char
====

# lfcd
RUN mkdir -p $HOME/.config/lf \
    && curl -L "https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh" >> $HOME/.zprofile \
    && echo -E "zle -N lfcd </dev/tty"                                            >> $HOME/.zprofile \
    && echo -E "bindkey '\eo' 'lfcd'"                                             >> $HOME/.zprofile \
    && sed -i 's/cd "$dir"/cd "$dir" \&\& zle reset-prompt/'                         $HOME/.zprofile \
    && ln -s $HOME/.zprofile $HOME/.zshrc

# LessKeys
COPY --chown=drksl <<"====" "$HOME/.config/lf/lesskey"
h left-scroll
l right-scroll
i quit
J forw-scroll
K back-scroll
====

# lfrc
COPY --chown=drksl <<"====" $HOME/.config/lf/lfrc
set icons
set hidden true
set ratios 1:2
set shell /bin/bash
set previewer ~/.config/lf/previewer
set cleaner ~/.config/lf/cleaner

cmd on-cd &{{ printf "\033]0; $(TMP=${PWD/#$HOME/\~};echo ${TMP##*/}) \a" >/dev/tty }}

cmd open ${{
    case $(file --dereference --brief --mime-type $f) in
        text/*|application/json) printf "\033]0; ${f##*/} \a" >/dev/tty; $EDITOR $fx ;;
        *) for f in $fx; do xdg-open $f &>/dev/null & disown; done;;
    esac
}}

cmd fzf_ripgrep ${{
  IFS=: read -ra selected < <(
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
      fzf --ansi \
          --color "hl:-1:underline,hl+:-1:underline:reverse,bg+:#111111" \
          --delimiter : \
          --preview 'bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
  )
  [ -n "${selected[0]}" ] && lf -remote "send $id select \"${selected[0]}\""
  [ -n "${selected[0]}" ] && nvim "${selected[0]}" "+${selected[1]}"
}}

map i       $[[ $fx =~ .png|.jpg ]] && img2sixel --loop-control=disable $fx | less -r >/dev/pts/0 && lf -remote "send $id reload redraw" || bat --paging=always --wrap=never $fx
map o       $( timg -pi --loops=1 --frames=1 $fx | less -rX) >/dev/pts/0 && lf -remote "send $id reload redraw"
map gmi     $[[ $fx =~ .png|.jpg ]] && img2sixel --loop-control=disable $fx | less -r >/dev/pts/0 && lf -remote "send $id reload redraw" || bat --paging=always --wrap=never $fx
map gmo     $( timg -pi --loops=1 --frames=1 $fx | less -rX) >/dev/pts/0 && lf -remote "send $id reload redraw"
map gms     $wezterm cli split-pane --horizontal -- bash -c "timg --center $fx && read"
map gmt     $wezterm cli spawn -- bash -c "timg --center $fx && read"
map gll     $lazygit
map gfs     $lf -remote "send $id select \"$(fzf --bind='?:toggle-preview' --preview 'bat --color=always {}' --preview-window 'right,50%,border-left' </dev/tty)\""
map gfr     :fzf_ripgrep
map <enter> shell
map D       $trash --trash-dir ~/.cache/Trash $fx
map J       push 10j
map K       push 10k
====

# lf previewer
COPY --chown=drksl <<"====" $HOME/.config/lf/previewer
#!/bin/bash
[[ $1 =~ .png|.jpg ]] && (tput cup $5 $4 && img2sixel --loop-control=disable -w $((${2}*8)) $1) >/dev/pts/0 && exit 1 || bat --style=plain --color=always $1
====

# lf cleaner
COPY --chown=drksl <<"====" $HOME/.config/lf/cleaner
#!/bin/bash
killall -s SIGWINCH lf
====

# lf executables
RUN chmod +x $HOME/.config/lf/{previewer,cleaner}

# tmux config
RUN <<==== >> $HOME/.tmux.conf
    set  -g  default-shell                /bin/zsh
    set  -g  mouse                        on
    set  -g  pane-active-border-style     bg=default,fg=gray
    set  -g  pane-border-style            fg=colour235
    set  -g  status                       off
    set  -ga status-style                 bg=default
    set  -ga status-style                 fg="#aaaaaa"
    set  -g  status-left                  ""
    set  -g  status-right                 ""
    set  -ga terminal-overrides           "xterm-256color:Tc"
    set  -g  window-status-current-format "#[bg=#1c1c1c,fg=#888888]#{window_index}:#{pane_title}"
    set  -g  window-status-format         "#[bg=default,fg=#2c2c2c]#{window_index}:#{pane_title}"
    set  -g  window-status-separator      " "
    setw -g  mode-keys                    vi
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
    bind     v                            split-window -h
    bind     V                            split-window -v
====

CMD ["/usr/bin/zsh","-l"]
