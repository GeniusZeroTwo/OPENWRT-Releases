#!/bin/bash

# 1. 修改默认后台 IP 为 10.0.0.1
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 2. 直接将 Aurora 主题克隆到 package 目录（比 feeds 方式更稳定，不会被剔除）
git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora

# 3. 注入系统初始化参数（刷机第一次启动时自动执行：切中文、切主题）
mkdir -p package/base-files/files/etc/uci-defaults
cat << "EOF" > package/base-files/files/etc/uci-defaults/99-custom-settings
#!/bin/sh
# 强制设为中文
uci set luci.main.lang=zh_cn
# 强制设为 Aurora 主题
uci set luci.main.mediaurlbase=/luci-static/aurora
uci commit luci
exit 0
EOF
