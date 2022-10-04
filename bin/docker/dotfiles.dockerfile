FROM fedora:36

RUN dnf -y update && dnf -y install sudo

# Setup user
RUN useradd dot
RUN echo "dot:dot" | chpasswd
RUN usermod -aG wheel dot
USER dot

# Set user home as WORKDIR
WORKDIR /home/dot
ENV HOME /home/dot

COPY bin/setup-tools/bootstrap.sh /tmp/bootstrap.sh
RUN echo dot | sudo -S chmod +x /tmp/bootstrap.sh
RUN echo dot | sudo -S /bin/bash -c /tmp/bootstrap.sh
