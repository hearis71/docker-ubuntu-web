FROM ubuntu:22.04

LABEL maintainer="hearis71"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# === Base system ===
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    sudo \
    supervisor \
    nginx \
    openssh-server \
    net-tools \
    vim-tiny \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    xvfb \
    x11vnc \
    dbus-x11 \
    x11-utils \
    fonts-wqy-microhei \
    language-pack-zh-hant \
    firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# === Tini (init process) ===
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# === App files ===
ADD image/ /
RUN chmod +x /startup.sh

# === Python deps ===
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install --no-cache-dir -r /usr/lib/web/requirements.txt

# === Runtime ===
EXPOSE 80
WORKDIR /root

ENTRYPOINT ["/bin/tini", "--"]
CMD ["/startup.sh"]
