# OPENWRT-Releases
Squashfs扩容脚本
```bash

cat << 'EOF' > /root/expand-f2fs.sh
#!/bin/sh
echo "开始执行扩容..."
if ! command -v resize.f2fs >/dev/null 2>&1; then opkg update && opkg install f2fs-tools; fi
OFFSET=$(cat /sys/class/block/loop0/loop/offset 2>/dev/null || losetup /dev/loop0 | sed -n 's/.*offset \([0-9]*\).*/\1/p')
if [ -n "$OFFSET" ]; then
    echo "获取偏移量 $OFFSET，冻结系统..."
    sync; echo 1 > /proc/sys/kernel/sysrq; echo u > /proc/sysrq-trigger; sleep 3
    FREE_LOOP=$(losetup -f)
    losetup -o $OFFSET $FREE_LOOP /dev/nvme0n1p2
    echo "执行底层扩容..."
    resize.f2fs $FREE_LOOP
    echo "重启中..."
    sleep 2; echo b > /proc/sysrq-trigger
else
    echo "错误：无法获取偏移量！"
fi
EOF

```
