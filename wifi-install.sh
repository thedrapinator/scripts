#!/bin/bash

cd /opt
git clone https://github.com/NickSanzotta/WiFiSuite
apt install python2-pip-whl #no good
apt install python2-setuptools-whl
apt install hostapd-wpe
cd WiFiSuite
virtualenv -p /usr/bin/python2.7 venv/
source venv/bin/activate
python2.7 -m pip install netifaces
python2.7 -m pip install psutil
python2.7 -m pip install twisted
python2.7 -m pip install txdbus
python2.7 -m pip install click
python2.7 -m pip install scapy
python2.7 setup.py install
cd wifisuite/
python2.7 wifisuite.py
