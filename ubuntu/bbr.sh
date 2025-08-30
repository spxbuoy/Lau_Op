#!/bin/bash
set -euo pipefail

clear
echo ""
echo ""
echo -e "Installing 𝐓𝐂𝐏 BBR 𝐏𝐎𝐖𝐄𝐑𝐄𝐃 BY 𝐒𝐏𝐈𝐃𝐄𝐑 𝐒𝐎𝐅𝐓"
echo -e "Please Wait BBR Installation Will Starting . . ."
sleep 5
clear

touch /usr/local/sbin/bbr

Add_To_New_Line() {
    if [ "$(tail -n1 "$1" | wc -l)" = "0" ]; then
        echo "" >> "$1"
    fi
    echo "$2" >> "$1"
}

Check_And_Add_Line() {
    if ! grep -Fxq "$2" "$1"; then
        Add_To_New_Line "$1" "$2"
    fi
}

Install_BBR() {
    echo -e "\e[30m"
    echo -e "\e[3mInstalling TCP BBR...\e[0m"
    if lsmod | grep -q bbr; then
        echo -e "\e[mSuccesfully Installed TCP BBR.\e[0m"
        echo -e "\e[30m"
        return 0
    fi

    echo -e "\e[mStarting To Install BBR...\e[0m"
    modprobe tcp_bbr
    Add_To_New_Line "/etc/modules-load.d/modules.conf" "tcp_bbr"
    Add_To_New_Line "/etc/sysctl.conf" "net.core.default_qdisc=fq"
    Add_To_New_Line "/etc/sysctl.conf" "net.ipv4.tcp_congestion_control=bbr"
    sysctl -p

    if sysctl net.ipv4.tcp_available_congestion_control | grep -q bbr && \
       sysctl net.ipv4.tcp_congestion_control | grep -q bbr && \
       lsmod | grep -q tcp_bbr; then
        echo -e "\e[mTCP BBR Install Success!\e[0m"
    else
        echo -e "\e[mFailed To Install BBR!\e[0m"
    fi
    echo -e "\e[30m"
}

Optimize_Parameters() {
    echo -e "\e[30m"
    echo -e "\e[3mOptimize Parameters...\e[0m"
    modprobe ip_conntrack || true

    # Security limits
    Check_And_Add_Line "/etc/security/limits.conf" "* soft nofile 65535"
    Check_And_Add_Line "/etc/security/limits.conf" "* hard nofile 65535"
    Check_And_Add_Line "/etc/security/limits.conf" "root soft nofile 51200"
    Check_And_Add_Line "/etc/security/limits.conf" "root hard nofile 51200"

    # Sysctl settings
    SYSCTL_VALUES=(
        "net.ipv4.ip_forward=1"
        "net.ipv4.conf.all.route_localnet=1"
        "net.ipv4.tcp_fin_timeout=15"
        "net.ipv4.tcp_tw_reuse=1"
        "net.ipv4.tcp_max_syn_backlog=2144"
        "net.netfilter.nf_conntrack_max=262144"
        "net.nf_conntrack_max=2144"
        "net.core.rmem_max=7108864"
        "net.core.wmem_max=7108864"
        "net.core.rmem_default=7108864"
        "net.core.wmem_default=7108864"
        "net.core.optmem_max=65536"
        "net.core.somaxconn=10000"
        "vm.swappiness=10"
        "vm.overcommit_memory=1"
    )

    for value in "${SYSCTL_VALUES[@]}"; do
        Check_And_Add_Line "/etc/sysctl.conf" "$value"
    done

    # Systemd limits
    SYSTEMD_VALUES=(
        "DefaultTimeoutStopSec=10s"
        "DefaultLimitCORE=infinity"
        "DefaultLimitNOFILE=65535"
    )

    for value in "${SYSTEMD_VALUES[@]}"; do
        Check_And_Add_Line "/etc/systemd/system.conf" "$value"
    done

    sysctl -p || true
    echo -e "\e[mSuccesfully Optimize Parameters.\e[0m"
    echo -e "\e[30m"
}

Install_BBR
Optimize_Parameters

rm -f /root/bbr.sh >/dev/null 2>&1

echo -e '\e[30m'
echo -e '\e[m                  Installation Success!                     \e[0m'
echo -e '\e[30m'
sleep 3
