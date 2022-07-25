# syntax=docker/dockerfile:1

# export DOCKER_BUILDKIT=1
# export DISPLAY=:0
# xhost +
# docker build -t ubuntu-nix .
# docker run -it --name ubuntu-nix -v /tmp/.X11-unix:/tmp/.X11-unix ubuntu-nix

# FROM alpine
# RUN apk add bash curl shadow sudo tmux xz zsh zsh-vcs \
#     && useradd -mG wheel -s /bin/bash drksl \
#     && echo root:toor | chpasswd \
#     && echo drksl:toor | chpasswd \
#     && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/drksl

FROM ubuntu
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl sudo tmux xz-utils zsh \
    && useradd -mG sudo -s /bin/bash drksl \
    && echo root:toor | chpasswd \
    && echo drksl:toor | chpasswd \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/drksl

USER drksl
WORKDIR /home/drksl
ENV HOME="/home/drksl"
ENV USER="drksl"
ENV SHELL="/bin/zsh"
SHELL ["/bin/zsh","-c"]

# install nix
RUN curl -L nixos.org/nix/install | sh \
    && . $HOME/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -iA nixpkgs.bat nixpkgs.gcc nixpkgs.git nixpkgs.killall nixpkgs.libsixel nixpkgs.lf nixpkgs.neovim \
       nixpkgs.spaceship-prompt nixpkgs.xclip nixpkgs.zsh-autosuggestions nixpkgs.zsh-fast-syntax-highlighting nixpkgs.zsh-vi-mode \
    && nix-collect-garbage -d

# install neovim plugins
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh \
    && git clone --depth=1 https://github.com/nvchad/nvchad ~/.config/nvim \
    && echo "export EDITOR='nvim'" >> $HOME/.zshrc


# source zsh plugins
RUN <<"====" >> $HOME/.zshrc
    export LANG=en_IN.UTF-8
    export LC_ALL=en_IN.UTF-8
    export LESS_TERMCAP_mb=$(tput -T ansi blink)
    export LESS_TERMCAP_md=$(tput -T ansi bold; tput -T ansi setaf 2)
    export LESS_TERMCAP_me=$(tput -T ansi sgr0)
    export LESS_TERMCAP_so=$(tput -T ansi smso; tput -T ansi setaf 0; tput -T ansi setab 3)
    export LESS_TERMCAP_se=$(tput -T ansi rmso)
    export LESS_TERMCAP_us=$(tput -T ansi smul; tput -T ansi setaf 1)
    export LESS_TERMCAP_ue=$(tput -T ansi rmul)
    export SPACESHIP_PROMPT_SEPARATE_LINE='false'
    export SPACESHIP_VI_MODE_SHOW='false'
    source $HOME/.nix-profile/lib/spaceship-prompt/spaceship.zsh
    source $HOME/.nix-profile/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $HOME/.nix-profile/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    source $HOME/.nix-profile/etc/profile.d/nix.sh
====

# lfcd
RUN mkdir -p $HOME/.config/lf \
    && curl -L "https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh" >> $HOME/.zshrc \
    && echo -E "zle -N lfcd </dev/tty"                                            >> $HOME/.zshrc \
    && echo -E "bindkey '\eo' 'lfcd'"                                             >> $HOME/.zshrc

# lfrc
COPY --chown=drksl <<==== $HOME/.config/lf/lfrc
    set previewer ~/.config/lf/previewer
    set cleaner ~/.config/lf/cleaner
====

# lf previewer
COPY --chown=drksl <<==== $HOME/.config/lf/previewer
    #!/bin/bash
    [[ $1 =~ .png|.jpg ]] && (tput cup $5 $4 && img2sixel -w $((${2}*8)) $1) >/dev/tty || bat --style=plain --color=always $1
====

# lf cleaner
COPY --chown=drksl <<==== $HOME/.config/lf/cleaner
    #!/bin/bash
    killall -s SIGWINCH lf
====

# lf executables
RUN chmod +x $HOME/.config/lf/{previewer,cleaner}

# tmux config
RUN <<==== >> $HOME/.tmux.conf
    set -g mouse on
    set -g default-shell /bin/zsh
    set -sa terminal-overrides ",xterm*:Tc"
    setw -g mode-keys vi
====

# TODO: source ~/.zshrc for alt+o open lfcd
# CMD ["/usr/bin/zsh","-l"]
CMD ["/usr/bin/tmux","-u"]
