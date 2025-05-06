# check=skip=SecretsUsedInArgOrEnv

FROM fedora:latest

# setup non-root user
ARG USERNAME=smith
ARG GROUPNAME=smith
ARG PASSWORD=smith
ARG UID=1000
ARG GID=1000

# setup user
RUN groupadd -g ${GID} ${USERNAME} \
    && useradd  -m -u ${UID} -g ${GID} \
                -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# setup basic tools
RUN dnf update -y

# setup core tools
RUN dnf install -y \
    coreutils util-linux procps-ng \
    findutils grep gawk sed diffutils which \
    tree less file clear

# setup network tools
RUN dnf install -y \
    iproute iputils bind-utils net-tools curl wget

RUN dnf clean all && rm -rf /var/cache/dnf

COPY . /home/${USERNAME}/dotfiles
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/dotfiles

USER $USERNAME
WORKDIR /home/$USERNAME/
