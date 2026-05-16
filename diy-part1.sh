#!/bin/bash
# 描述: OpenWrt DIY script part 1 (Before Update feeds)

# 1. 添加 OpenClash 官方源
# 通过 feeds 机制直接挂载官方 master 分支源码
echo 'src-git openclash https://github.com/vernesong/OpenClash.git;master' >> feeds.conf.default

# 2. 添加 Aurora 主题官方源
# 挂载 eamonxg 维护的 luci-theme-aurora 官方源
echo 'src-git aurora https://github.com/eamonxg/luci-theme-aurora.git' >> feeds.conf.default
```
