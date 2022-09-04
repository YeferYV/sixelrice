# syntax=docker/dockerfile:1

# export DOCKER_BUILDKIT=1
# xhost +
# docker buildx build -t ubuntu-nix-dockerfile .
# docker run -it --name ubuntu-nix-dockerfile -v /tmp/.X11-unix:/tmp/.X11-unix ubuntu-nix-dockerfile

# FROM alpine
# RUN apk add bash curl shadow sudo tmux xz zsh zsh-vcs \
#     && useradd -mG wheel -s /bin/bash drksl \
#     && echo root:toor | chpasswd \
#     && echo drksl:toor | chpasswd \
#     && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

FROM ubuntu
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl sudo tmux xz-utils zsh \
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
    && nix-env -iA nixpkgs.bat nixpkgs.gcc nixpkgs.git nixpkgs.killall nixpkgs.libsixel nixpkgs.less nixpkgs.lf nixpkgs.neovim nixpkgs.xclip\
                   nixpkgs.timg nixpkgs.spaceship-prompt nixpkgs.zsh-autosuggestions nixpkgs.zsh-fast-syntax-highlighting \
    && nix-collect-garbage -d

# # ssh
# RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y openssh-client openssh-server \
#     && sudo mkdir /run/sshd \
#     && sudo /usr/bin/ssh-keygen -A \
#     && echo "sudo /sbin/sshd" >>/home/drksl/.zprofile


# install neovim plugins
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh \
    && git clone --depth=1 https://github.com/nvchad/nvchad ~/.config/nvim

# source zsh plugins
RUN <<"====" >> $HOME/.zprofile
    export DISPLAY=:0
    export EDITOR="nvim"
    export HISTFILE=~/.cache/history
    export LANG=en_US.UTF-8
    export SAVEHIST=10000000
    export PAGER="less -r --use-color -Dd+r -Du+b -DPyk -DSyk"
    export SPACESHIP_PROMPT_SEPARATE_LINE="false"
    export SPACESHIP_VI_MODE_SHOW="false"
    export TERM="xterm-256color"
    source $HOME/.nix-profile/lib/spaceship-prompt/spaceship.zsh
    source $HOME/.nix-profile/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $HOME/.nix-profile/etc/profile.d/nix.sh
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
====

# lfcd
RUN mkdir -p $HOME/.config/lf \
    && curl -L "https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh" >> $HOME/.zprofile \
    && echo -E "zle -N lfcd </dev/tty"                                            >> $HOME/.zprofile \
    && echo -E "bindkey '\eo' 'lfcd'"                                             >> $HOME/.zprofile \
    && sed -i 's/cd "$dir"/cd "$dir" \&\& zle reset-prompt/'                         $HOME/.zprofile \
    && ln -s $HOME/.zprofile $HOME/.zshrc

# lfrc
COPY --chown=drksl <<"====" $HOME/.config/lf/lfrc
set shell /bin/bash
set hidden true
set previewer ~/.config/lf/previewer
set cleaner ~/.config/lf/cleaner
map i   $[[ $fx =~ .png|.jpg ]] && img2sixel --loop-control=disable $fx | less -r >/dev/pts/0 && lf -remote "send $id reload redraw" || bat --paging=always --wrap=never $fx
map o   $( timg -pi --loops=1 --frames=1 $fx | less -rX) >/dev/pts/0 && lf -remote "send $id reload redraw"
map gmi $[[ $fx =~ .png|.jpg ]] && img2sixel --loop-control=disable $fx | less -r >/dev/pts/0 && lf -remote "send $id reload redraw" || bat --paging=always --wrap=never $fx
map gmo $( timg -pi --loops=1 --frames=1 $fx | less -rX) >/dev/pts/0 && lf -remote "send $id reload redraw"
map gms $wezterm cli split-pane --horizontal -- bash -c "timg --center $fx && read"
map gmt $wezterm cli spawn -- bash -c "timg --center $fx && read"
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
    set -g default-shell /bin/zsh
    set -g mouse on
    set -g status off
    set -g default-terminal "xterm-256color"
    setw -g mode-keys vi
    bind-key b "set -g status"
    bind-key c "set -g status on; new-window"
====

CMD ["/usr/bin/zsh","-l"]
