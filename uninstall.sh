#!/bin/bash
# author: Suummmmer

sudo bash /etc/v2rayL/remove.sh 1>/dev/null 2>/dev/null
if [ -d "/etc/v2rayL" ];then
    sudo rm -rf /etc/v2rayL
fi

if [ -d "/usr/bin/v2rayL" ]; then
    sudo rm -rf /usr/bin/v2rayL
fi

sudo rm /usr/share/applications/v2rayL.desktop 2>/dev/null
sudo systemctl stop v2rayL.service 2>/dev/null 
sudo sed -i '/v2rayL.service/d' /etc/sudoers 2>/dev/null
sudo rm /etc/systemd/system/v2rayL.service 2>/dev/null
ps -ef | grep "v2rayLui" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
echo "卸载完成"


