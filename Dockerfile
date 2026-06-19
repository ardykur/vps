FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080

RUN apt-get update && apt-get install -y \
    sudo curl wget ca-certificates gnupg apt-transport-https \
    software-properties-common dbus-x11 x11-xserver-utils \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    firefox \
    libreoffice \
    unrar rar p7zip-full unzip zip \
    ubuntu-restricted-extras \
    ffmpeg vlc \
    onedrive \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install AnyDesk repo
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY \
    -o /etc/apt/keyrings/keys.anydesk.com.asc && \
    chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" \
    > /etc/apt/sources.list.d/anydesk-stable.list && \
    apt-get update && \
    apt-get install -y anydesk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# User
RUN useradd -m -s /bin/bash ardy28 && \
    echo "ardy28:12345678" | chpasswd && \
    usermod -aG sudo ardy28

USER ardy28
WORKDIR /home/ardy28

RUN mkdir -p /home/ardy28/.vnc && \
    echo "12345678" | vncpasswd -f > /home/ardy28/.vnc/passwd && \
    chmod 600 /home/ardy28/.vnc/passwd

COPY start.sh /home/ardy28/start.sh

USER root
RUN chmod +x /home/ardy28/start.sh

USER ardy28

CMD ["/home/ardy28/start.sh"]
