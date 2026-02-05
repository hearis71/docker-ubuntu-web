FROM ubuntu:20.04

LABEL maintainer="<hearis71@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

# ===============================
# Base packages
# ===============================
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ca-certificates \
    gnupg \
    sudo \
    vim-tiny \
    net-tools \
    supervisor \
    openssh-server \
    pwgen \
    nginx \
    dbus-x11 \
    x11-utils \
    xvfb \
    x11vnc \
    lxde \
    libreoffice \
    firefox \
    vlc \
    ffmpeg \
    mesa-utils \
    libgl1-mesa-dri \
    fonts-wqy-microhei \
    language-pack-zh-hant \
    language-pack-gnome-zh-hant \
    firefox-locale-zh-hant \
    libreoffice-l10n-zh-tw \
    arc-theme \
    pinta \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
