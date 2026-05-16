#!/bin/bash
# 描述: OpenWrt DIY script part 1 (Before Update feeds)

# 1. 将 OpenClash 官方库作为源直接挂载
echo 'src-git openclash https://github.com/vernesong/OpenClash.git;master' >> feeds.conf.default

# 2. 将 Aurora 主题官方库作为源直接挂载
echo 'src-git aurora https://github.com/eamonxg/luci-theme-aurora.git' >> feeds.conf.default
