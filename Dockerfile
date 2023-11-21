#================================ Docker run sixelrice ================================#

# xhost +
# docker build --tag sixelrice .
# docker run -it \
#     --name sixelrice \
#     --ipc=host \
#     --volume=/run/user/1000/pipewire-0:/run/user/1000/pipewire-0 \
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

# sixelrice:
COPY --chown=drksl ./nvim    $HOME/.config/nvim
COPY --chown=drksl ./lf      $HOME/.config/lf
COPY --chown=drksl ./.zshrc  $HOME/.zshrc

# install dependencies:
RUN echo toor | su -c "chown -R drksl:drksl $HOME/.config"
RUN echo toor | source $HOME/.zshrc

# ssh daemon:
# RUN if [[ -e /bin/pacman ]]; then sudo pacman -S --noconfirm openssh; fi; \
#     if [[ -e /bin/apt    ]]; then DEBIAN_FRONTEND=noninteractive sudo apt install -y openssh-client openssh-server; fi; \
#     sudo mkdir /run/sshd; \
#     sudo /usr/bin/ssh-keygen -A; \
#     echo "sudo /sbin/sshd" >>/home/drksl/.zprofile

SHELL ["/bin/zsh","-c"]
CMD ["/usr/bin/zsh","-l"]
