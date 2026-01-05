#!/usr/bin/env bash

# waydroid init
waydroid init
# waydroid 관련 포트 개방
sudo firewall-cmd --zone=trusted --add-interface=waydroid0
sudo firewall-cmd --zone=trusted --add-port=67/udp
sudo firewall-cmd --zone=trusted --add-port=53/udp
sudo firewall-cmd --zone=trusted --add-forward
# waydroid 화면 size 초기화
waydroid prop set persist.waydroid.width "" at  08:30:30
waydroid prop set persist.waydroid.height ""
# waydroid install app
waydroid app install <appname.apk>
