#!/bin/bash
set -e

IMAGE="ubuntu:22.04"
CONTAINER="ubuntu-novnc"

echo "🚀 Pull Ubuntu stable image..."
docker pull $IMAGE

echo "♻️ Remove old container if exists..."
docker rm -f $CONTAINER 2>/dev/null || true

echo "🖥️ Starting Ubuntu XFCE + VNC + noVNC (FULL AUTO)..."

docker run -d \
  --name $CONTAINER \
  -p 6080:6080 \
  -p 5901:5901 \
  --shm-size=1g \
  $IMAGE \
  bash -lc "
    set -e
    export DEBIAN_FRONTEND=noninteractive

    echo '📦 Installing packages...'
    apt update && apt install -y \
      xfce4 xfce4-goodies \
      xfce4-terminal \
      tigervnc-standalone-server \
      git python3 dbus-x11 net-tools && \
    apt clean

    echo '🌐 Installing noVNC...'
    git clone https://github.com/novnc/noVNC.git /opt/novnc
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

    echo '🧩 Configuring XFCE...'
    mkdir -p /root/.vnc
    cat <<'EOF' > /root/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4 &
EOF
    chmod +x /root/.vnc/xstartup

    echo '🧹 Cleaning old X locks...'
    rm -rf /tmp/.X11-unix /tmp/.X*-lock

    echo '🚀 Starting VNC server...'
    Xtigervnc :1 \
      -rfbport 5901 \
      -geometry 1280x800 \
      -SecurityTypes None \
      -localhost no &

    export DISPLAY=:1
    sleep 2
    startxfce4 &

    echo '🌍 Starting noVNC (foreground)...'
    exec /opt/novnc/utils/novnc_proxy --vnc 0.0.0.0:5901 --listen 6080
  "

echo ""
echo "✅ SELESAI"
echo "👉 Google Cloud Shell → Web Preview → Port 6080"
echo "🖥️ Desktop Linux XFCE siap digunakan"
echo "==masuk ke container==: docker start -ai ubuntu-novnc"
