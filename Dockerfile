FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=ardy28
ENV USER_PASSWORD=12345678
ENV VNC_PASSWORD=12345678
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    sudo curl wget ca-certificates gnupg apt-transport-https \
    software-properties-common lsb-release \
    dbus-x11 x11-xserver-utils \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    firefox \
    libreoffice \
    rar unrar p7zip-full unzip zip \
    ffmpeg vlc \
    fonts-liberation fonts-dejavu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# AnyDesk official repo
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY \
    -o /etc/apt/keyrings/keys.anydesk.com.asc && \
    chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" \
    > /etc/apt/sources.list.d/anydesk-stable.list && \
    apt-get update && \
    apt-get install -y anydesk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# OneDrive abraunegg repo
RUN wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/Release.key \
    | gpg --dearmor > /usr/share/keyrings/obs-onedrive.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/ ./" \
    > /etc/apt/sources.list.d/onedrive.list && \
    apt-get update && \
    apt-get install -y onedrive && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ${USERNAME} && \
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd && \
    usermod -aG sudo ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN mkdir -p /home/${USERNAME}/.vnc && \
    echo "${VNC_PASSWORD}" | vncpasswd -f > /home/${USERNAME}/.vnc/passwd && \
    chmod 600 /home/${USERNAME}/.vnc/passwd

COPY start.sh /home/${USERNAME}/start.sh

USER root
RUN chmod +x /home/${USERNAME}/start.sh && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/start.sh

USER ${USERNAME}

EXPOSE 5901 6080 7070

CMD ["/home/ardy28/start.sh"]
