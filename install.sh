#!/bin/bash
# author: Jackson

echo "安装依赖库"
sudo apt-get install zbar-tools -y python3-pip
pip install -r requirements.txt
pip install https://github.com/pyinstaller/pyinstaller/archive/develop.tar.gz

cd v2rayL-GUI && pyinstaller -F v2rayLui.py -p config.py -p sub2conf_api.py -p v2rayL_api.py -p v2rayL_threads.py -p utils.py -i images/logo.ico -n v2rayLui
cd ..

echo "创建   /etc/v2rayL"
if [ -d "/etc/v2rayL" ];then
    echo "已存在/etc/v2rayL"
else
    sudo mkdir /etc/v2rayL
    echo "设置权限和快捷方式"
    sudo chmod 777 -R /etc/v2rayL
fi

echo "创建   /usr/bin/v2rayL"
if [ -d "/usr/bin/v2rayL" ];then
    echo "已存在/usr/bin/v2rayL"
else
    sudo mkdir /usr/bin/v2rayL
    sudo chmod 777 -R /usr/bin/v2rayL
fi
echo "正在复制内核文件"

#core_real_url=$(curl https://blog.thinker.ink/get_lanzou_link/?url=https://www.lanzous.com/i7jyzje -s)
#wget -O /etc/v2rayL/v2ray-core.tar ${core_real_url:1:-1}
cp v2ray-core.tar /etc/v2rayL/v2ray-core.tar 

echo "正在复制images文件"
cp -r ./v2rayL-GUI/images /etc/v2rayL/

echo "正在复制v2rayLui"
cp ./v2rayL-GUI/dist/* /etc/v2rayL/
cp ./v2rayL-GUI/dist/* /usr/bin/v2rayL/

echo "正在复制桌面图标"
sudo cp v2rayL.desktop /usr/share/applications/
sudo chmod u+x /usr/share/applications/v2rayL.desktop  


cd /etc/v2rayL
tar -xvf v2ray-core.tar 1>/dev/null
cp /etc/v2rayL/v2ray-core/{geoip.dat,geosite.dat,v2ctl,v2ray,v2ray.sig,v2ctl.sig,h2y.dat} /usr/bin/v2rayL
mv /etc/v2rayL/v2ray-core/add.sh /etc/v2rayL/add.sh
mv /etc/v2rayL/v2ray-core/remove.sh /etc/v2rayL/remove.sh
chmod +x /etc/v2rayL/add.sh
chmod +x /etc/v2rayL/remove.sh

echo "正在复制service文件"
sudo cp /etc/v2rayL/v2ray-core/v2rayL.service /etc/systemd/system/

current_user=$USER
echo "设置桌面图标"
echo "$current_user ALL=NOPASSWD:/bin/systemctl restart v2rayL.service,/bin/systemctl start v2rayL.service,/bin/systemctl stop v2rayL.service,/bin/systemctl status v2rayL.service,/bin/systemctl enable v2rayL.service,/bin/systemctl disable v2rayL.service,/bin/bash /etc/v2rayL/add.sh,/bin/bash /etc/v2rayL/remove.sh" | sudo tee -a /etc/sudoers

sudo systemctl enable v2rayL.service
/usr/bin/v2rayL/v2rayLui &

