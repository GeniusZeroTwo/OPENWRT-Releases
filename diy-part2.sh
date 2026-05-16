#!/bin/bash

1. 修改默认后台 IP 为 10.0.0.1

sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

2. (可选) 强制设置 Aurora 为默认主题

注意：OpenWrt 默认主题通常是 bootstrap，这里通过修改 Makefile 强制替换

sed -i 's/luci-theme-bootstrap/luci-theme-aurora/g' feeds/luci/collections/luci/Makefile
