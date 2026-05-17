#!/bin/sh
# 脚本名称: expand-f2fs.sh
# 功能描述: OpenWrt NVMe + f2fs 在线无损热扩容一键脚本
# 工作原理: 绕过 f2fs 的 unclean 读写限制，利用 SysRq 冻结系统 + 影子设备映射底层进行越权扩容。

echo "================================================="
echo "      OpenWrt f2fs 终极无损热扩容一键脚本        "
echo "================================================="

# 1. 检查并自动安装必备工具
if ! command -v resize.f2fs >/dev/null 2>&1; then
    echo "=> 未检测到 f2fs-tools，正在自动安装..."
    opkg update
    opkg install f2fs-tools
    if [ $? -ne 0 ]; then
        echo "=> [错误] f2fs-tools 安装失败，请检查网络或软件源！"
        exit 1
    fi
fi

# 2. 获取当前挂载的 loop0 的底层偏移量
echo "=> 正在获取物理分区偏移量..."
OFFSET=$(cat /sys/class/block/loop0/loop/offset 2>/dev/null || losetup /dev/loop0 | sed -n 's/.*offset \([0-9]*\).*/\1/p')

if [ -z "$OFFSET" ]; then
    echo "=> [错误] 无法获取 /dev/loop0 的偏移量！"
    exit 1
fi
echo "=> 获取成功！偏移量为: $OFFSET"

# 3. 设置底层设备路径 (根据你的硬件环境锁定为 nvme0n1p2)
BASE_DEV="/dev/nvme0n1p2"

echo "================================================="
echo "=> 警告：5秒后系统将被冻结并执行底层扩容！"
echo "=> 扩容完成后将触发硬件级自动重启，请勿断开电源！"
echo "================================================="
sleep 5

# 4. 执行“时间静止”：强制刷入缓存并变为只读 (转为 Clean 状态)
echo "=> 正在冻结文件系统..."
sync
echo 1 > /proc/sys/kernel/sysrq
echo u > /proc/sysrq-trigger
sleep 3

# 5. 执行“影分身”：创建影子设备指向底层数据块
FREE_LOOP=$(losetup -f)
losetup -o $OFFSET $FREE_LOOP $BASE_DEV

# 6. 秒速扩容
echo "=> 正在执行底层扩容 (resize.f2fs)..."
resize.f2fs $FREE_LOOP

# 7. 硬件级硬重启
echo "=> 扩容指令下发完毕，正在硬重启..."
sleep 2
echo b > /proc/sysrq-trigger
