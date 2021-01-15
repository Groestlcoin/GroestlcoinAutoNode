#!/bin/bash

apt-get -y update
apt-get -y install screen
wget https://raw.github.com/Groestlcoin/GroestlcoinAutoNode/master/groestlcoinAutoNode.sh
screen -dmS groestlcoinInstaller sudo bash groestlcoinAutoNode.sh
