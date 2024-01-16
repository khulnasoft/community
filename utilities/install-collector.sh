#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

# khulnasoft
# real-time performance and health monitoring, done right!
# (C) 2022

# This script installs community maintained collectors from khulnasoft/community github repo

# example usage:
# $ sudo wget -O /tmp/install-collector.sh https://raw.githubusercontent.com/khulnasoft/community/main/utilities/install-collector.sh && sudo bash /tmp/install-collector.sh python.d.plugin/clickhouse


KHULNASOFT_DIR="/etc/khulnasoft"

if [ "$EUID" -ne 0 ]; then
    printf "\nError: Please run as root.\n\n"
    exit 1
elif [ $# -eq 0 ]; then
    printf "\nError: No arguments supplied. \n\nUsage: sudo %s <plugin/collector> (Eg: %s charts.d.plugin/speedtest)\n\nFor available collectors from the community see https://github.com/khulnasoft/community/tree/main/collectors\n\n" "$0" "$0"
    exit 1
elif [ "$1" == "-h" ]; then
    printf "\nUsage: sudo %s <plugin/collector> (Eg: %s charts.d.plugin/speedtest)\n\nFor available collectors from the community see https://github.com/khulnasoft/community/tree/main/collectors\n\n" "$0" "$0"
    exit 1
elif [ ! -d $KHULNASOFT_DIR ]; then
    printf "\nError: Please update KHULNASOFT_DIR in %s with the Khulnasoft user configuration directory as mentioned in https://learn.khulnasoft.com/docs/agent/collectors/plugins.d#environment-variables\n\n" "$0"
    exit 1
fi

printf "\nYou are about to install a collector that is NOT developed or maintained by Khulnasoft. Would you like to proceed? [y/n]"
read -r answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    printf "\nInstalling collector from community repo..."
else
    printf "\n\nExiting...\n\n"
    exit 1
fi

input=$1
collector=${input#*/}
suffix=".plugin/$collector"
plugin=${input%"$suffix"}

if [ "$plugin" == "python.d" ]; then
    file_ext=".py"
elif [ "$plugin" == "charts.d" ]; then
    file_ext=".sh"
elif [ "$plugin" == "go.d" ]; then
    file_ext=".go"
elif [ "$plugin" == "node.d" ]; then
    file_ext=".js"
fi

charts="https://raw.githubusercontent.com/khulnasoft/community/main/collectors/$1/$collector.chart$file_ext"
config="https://raw.githubusercontent.com/khulnasoft/community/main/collectors/$1/$collector.conf"
executable="/usr/libexec/khulnasoft/$plugin/"
collector_conf="/etc/khulnasoft/$plugin/"
conf="/etc/khulnasoft/$plugin.conf"
enabled="\"$collector: yes\""
filecheck="$collector_conf/$collector.conf"

if [ -f "$filecheck" ]; then
    printf "\n\nA Khulnasoft collector by this name already exists on this system. Exiting...\n\n"
    exit 1
fi

if command -v wget > /dev/null 2>&1; then
    sudo wget "$charts" -P "$executable"
    sudo wget "$config" -P "$collector_conf"
elif command -v curl > /dev/null 2>&1; then
    cd "$executable" && { sudo curl -O "$charts" ; cd - || exit 1; }
    cd "$collector_conf" && { sudo curl -O "$config" ; cd - || exit 1; }
else
    printf "\n\nDownloading failed because neither curl nor wget are available on this system.\n\n"
    exit 1
fi

if ! [ -f "$executable/$collector.chart$file_ext" ] && ! [ -f "$collector_conf/$collector.conf" ]; then
    printf "\nDownloading failed. Please provide a valid input.\n\n"
    exit 1
fi

sudo echo "$enabled" | tee -a "$conf"

if ! command -v systemctl &> /dev/null
then
    printf "\nUnable to restart Khulnasoft agent, please follow these instructions to restart manually: https://learn.khulnasoft.com/docs/configure/start-stop-restart\n"
    exit 1
fi

if systemctl is-active --quiet khulnasoft; then
    sudo systemctl restart khulnasoft
    if ! sudo systemctl restart khulnasoft; then
       printf "\nUnable to restart Khulnasoft agent, please follow these instructions to restart manually: https://learn.khulnasoft.com/docs/configure/start-stop-restart\n"
       exit 1
    fi
else
    sudo service khulnasoft restart
    if ! sudo service khulnasoft restart; then
       printf "\nUnable to restart Khulnasoft agent, please follow these instructions to restart manually: https://learn.khulnasoft.com/docs/configure/start-stop-restart\n"
       exit 1
    fi
fi

printf "\nSuccessfully restarted Khulnasoft agent."
printf "\n\nInstalled %s collector succesfully.\n\n" "$collector"
