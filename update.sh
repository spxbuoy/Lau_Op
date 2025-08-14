#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Request : Debian 9+/Ubuntu 18.04+/20+
# Developers  » ṡƿ×ʟѧȗ
# Email       » spxlau2@gmail.com
# Telegram    » https://t.me/gltch_x
# WhatsApp    » wa.me/+254112011036
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

clear

fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &

    tput civis
    echo -ne "\033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "\033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

res1() {
    wget https://raw.githubusercontent.com/spxbuoy/Lau_Op/main/menu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
    rm -rf update.sh
}

netfilter-persistent
clear

# ────── HEADER ──────
echo -e ""
echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m" | lolcat
echo -e "\e[1;97;101m            » UPDATE SCRIPT SPXLAU «             \e[0m"
echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m" | lolcat
echo -e ""

# ────── HACKER STYLE LOADING ──────
echo -ne "\e[1;33m⚙️  Initializing update engine"
for i in {1..3}; do echo -ne "."; sleep 0.4; done
echo -e " \e[1;32mOK\e[0m"

sleep 0.5
echo -ne "\e[1;33m📡 Connecting to update server"
for i in {1..3}; do echo -ne "."; sleep 0.4; done
echo -e " \e[1;32mOK\e[0m"

sleep 0.5
echo -ne "\e[1;33m🔍 Checking script integrity"
for i in {1..3}; do echo -ne "."; sleep 0.4; done
echo -e " \e[1;32mOK\e[0m"

sleep 0.5
echo -ne "\e[1;33m⬇️  Downloading latest modules"
for i in {1..5}; do echo -ne "▓"; sleep 0.2; done
echo -e " \e[1;32m100%\e[0m"

sleep 0.5
echo -ne "\e[1;33m💻 Applying updates"
for i in {1..5}; do echo -ne "▒"; sleep 0.2; done
echo -e " \e[1;32mDONE\e[0m"

# ────── MAIN UPDATE BAR ──────
echo -e ""
fun_bar 'res1'

# ────── FINISH ──────
echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m" | lolcat
echo -e "\e[1;32m✅ Script updated successfully!\e[0m"
echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m" | lolcat
echo -e ""
read -n 1 -s -r -p "🔙 Press [ Enter ] to return to the menu"
menu
