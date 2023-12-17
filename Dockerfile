#================================ Docker run sixelrice ================================#

# xhost + # to share x11/clipboard
# docker build --tag sixelrice .
# docker run -it \
#     --name sixelrice \
#     --ipc=host \
#     --volume=/run/user/1000/pipewire-0:/run/user/1000/pipewire-0 \
#     --volume=/run/user/1000/pulse/native:/run/user/1000/pulse/native \
#     --volume=/tmp/.X11-unix:/tmp/.X11-unix \
#     sixelrice

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

USER drksl
WORKDIR /home/drksl
EXPOSE 22/tcp
EXPOSE 8080/tcp
ENV HOME="/home/drksl"
ENV USER="drksl"

# copy repository:
COPY --chown=drksl . $HOME/.config/sixelrice

# create symlinks:
RUN ln -s $HOME/.config/sixelrice/nvim    $HOME/.config/nvim; \
    ln -s $HOME/.config/sixelrice/lf      $HOME/.config/lf; \
    ln -s $HOME/.config/sixelrice/.zshrc  $HOME/.zshrc;

# install dependencies:
RUN echo toor | su -c "chown -R drksl:drksl $HOME/.config"; \
    echo toor | source $HOME/.zshrc

# ssh daemon:
# RUN if [[ -e /bin/pacman ]]; then echo toor | su -c "pacman -Sy --noconfirm openssh"; fi; \
#     if [[ -e /bin/apt    ]]; then echo toor | su -c "DEBIAN_FRONTEND=noninteractive apt update; apt install -y sudo openssh-client openssh-server"; fi; \
#     echo toor | su -c "mkdir /run/sshd"; \
#     echo toor | su -c "/usr/bin/ssh-keygen -A"; \
#     echo "sudo /sbin/sshd" >>/home/drksl/.zprofile

CMD ["/bin/zsh","-l"]
