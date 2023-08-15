#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default
echo 'src-git sundaqiang https://github.com/sundaqiang/openwrt-packages-backup' >>feeds.conf.default
#echo 'src-git kiddin9 https://github.com/kiddin9/openwrt-packages' >>feeds.conf.default

#更改主题包源
#rm -rf package/lean/luci-theme-argonne
#git clone -b 21.02 https://github.com/kenzok78/luci-theme-argonne  package/lean/luci-theme-argonne



#git clone https://github.com/bauw2008/luci-app-msd.git package/luci-app-msd
#mv package/luci-app-msd/luci-app-msd_lite package/luci-app-msd_lite
#mv package/luci-app-msd/msd_lite package/msd_lite
#rm -rf package/luci-app-msd

# 清除旧版argon主题并拉取最新版
#pushd ../package/lean
#rm -rf luci-theme-argonne
#git clone -b 21.02 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon

## 解除系统限制
#ulimit -u 10000
#ulimit -n 4096
#ulimit -d unlimited
#ulimit -m unlimited
#ulimit -s unlimited
#ulimit -t unlimited
#ulimit -v unlimited
