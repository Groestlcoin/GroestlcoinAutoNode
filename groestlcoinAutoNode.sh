#!/bin/bash
echo "########### The server will reboot when the script is complete"
echo "########### Changing to home dir"
cd ~
echo "########### Updating Ubuntu"
# apt-get -y upgrade -- don't upgrade, there is an issue with grub that prompts the user, and to keep this non-interactive it's best just to ignore it
# apt-get -y dist-upgrade
apt-get -y install software-properties-common python-software-properties htop
apt-get -y install git build-essential autoconf libboost-all-dev libssl-dev pkg-config
apt-get -y install libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool
apt-get -y install libcurl4-openssl-dev libdb5.3 libdb5.3-dev libdb5.3++-dev libevent-dev

echo "########### Creating Swap"
dd if=/dev/zero of=/swapfile bs=1M count=2048 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

echo "########### Cloning Groestlcoin and Compiling"
mkdir -p ~/src && cd ~/src
git clone https://github.com/groestlcoin/groestlcoin.git
cd groestlcoin

# Add a market to track how much GroestlcoinAutoNode is used
# Insert [B.A.N.] at the end of the client name, probably not compatible with BIP 14 but eh
#sed -i 's/\(CLIENT_NAME(".*\)\(")\)/\1 \[B.A.N.\]\2/' src/clientversion.cpp
if [ -z $FIRSTNAME ]; then
  EXTRA=""
else
  EXTRA=" $FIRSTNAME's node"  # keep first space
fi
sed -i "s/return ss.str();/return ss.str() + \"[B.A.N.]$EXTRA\";/" src/clientversion.cpp

./autogen.sh
./configure --without-gui --without-upnp --disable-tests
make
make install

echo "########### Create Groestlcoin User"
useradd -m groestlcoin

echo "########### Creating config"
cd ~groestlcoin
sudo -u groestlcoin mkdir .groestlcoin
config=".groestlcoin/groestlcoin.conf"
sudo -u groestlcoin touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "connections=40" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "########### Setting up autostart (cron)"
crontab -l > tempcron
echo "0 3 * * * reboot" >> tempcron  # reboot at 3am to keep things working okay
crontab tempcron
rm tempcron

# only way I've been able to get it reliably to start on boot
# (didn't want to use a service with systemd so it could be used with older ubuntu versions, but systemd is preferred)
sed -i '2a\
sudo -u groestlcoin /usr/local/bin/groestlcoind -datadir=/home/groestlcoin/.groestlcoin' /etc/rc.local

echo "############ Add an alias for easy use"
echo "alias grs=\"sudo -u groestlcoin groestlcoin-cli -datadir=/home/groestlcoin/.groestlcoin\"" >> ~/.bashrc  # example use: grs getinfo

reboot
