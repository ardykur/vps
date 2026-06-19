#!/bin/bash

export DISPLAY=:1

vncserver :1 -geometry 1920x1080 -depth 24

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

echo "======================================"
echo " Ubuntu GUI Container Ready"
echo " noVNC URL    : http://localhost:6080/vnc.html"
echo " User         : ardy28"
echo " Password     : 12345678"
echo " VNC Password : 12345678"
echo "======================================"

tail -f /dev/null
