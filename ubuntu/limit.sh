#!/bin/bash
REPO="https://raw.githubusercontent.com/Amchapeey/storage/main/"

# Download services
wget -q -O /etc/systemd/system/limitvmess.service "${REPO}ubuntu/limitvmess.service" && chmod +x /etc/systemd/system/limitvmess.service
wget -q -O /etc/systemd/system/limitvless.service "${REPO}ubuntu/limitvless.service" && chmod +x /etc/systemd/system/limitvless.service
wget -q -O /etc/systemd/system/limittrojan.service "${REPO}ubuntu/limittrojan.service" && chmod +x /etc/systemd/system/limittrojan.service
wget -q -O /etc/systemd/system/limittrojango.service "${REPO}ubuntu/limittrojango.service" && chmod +x /etc/systemd/system/limittrojango.service
wget -q -O /etc/systemd/system/limitshadowsocks.service "${REPO}ubuntu/limitshadowsocks.service" && chmod +x /etc/systemd/system/limitshadowsocks.service

# Download limit scripts
wget -q -O /etc/xray/limitvmess.sh "${REPO}ubuntu/limitvmess.sh"
wget -q -O /etc/xray/limitvless.sh "${REPO}ubuntu/limitvless.sh"
wget -q -O /etc/xray/limittrojan.sh "${REPO}ubuntu/limittrojan.sh"
wget -q -O /etc/xray/limitshadowsocks.sh "${REPO}ubuntu/limitshadowsocks.sh"

chmod +x /etc/xray/limitvmess.sh
chmod +x /etc/xray/limitvless.sh
chmod +x /etc/xray/limittrojan.sh
chmod +x /etc/xray/limitshadowsocks.sh

# Reload systemd and enable services
systemctl daemon-reload
systemctl enable --now limitvmess.service
systemctl enable --now limitvless.service
systemctl enable --now limittrojan.service
systemctl enable --now limitshadowsocks.service
