#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
#sed -i 's/255.255.0.0/255.255.255.0/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# Modify system
sed -i 's/OpenWrt/Way/g' package/base-files/files/bin/config_generate
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
sed -i "/uci commit/a uci commit system"  package/base-files/files/bin/config_generate
sed -i "/uci commit/a uci commit luci"  package/base-files/files/bin/config_generate
sed -i "/uci commit system/i uci set system.@system[0].timezone=CST-8"  package/base-files/files/bin/config_generate
sed -i "/uci commit system/i uci set system.system.zonename=Asia/\Shanghai"  package/base-files/files/bin/config_generate
sed -i "/uci commit luci/i uci set luci.main.lang=zh_cn"  package/base-files/files/bin/config_generate

# Banner
# Refer https://github.com/unifreq/openwrt_packit/blob/master/public_funcs
#rm -rf package/base-files/files/etc/banner
# 插入信息到 banner
# 在 cat >> .config <<EOF 到 EOF 之间粘贴你的编译配置, 需注意缩进关系
cat >> files/banner <<EOF
-----------------------------------------------------
 PACKAGE:     $OMR_DIST
 VERSION:     $(git -C "$OMR_FEED" tag --sort=committerdate | tail -1)
 TARGET:      $OMR_TARGET
 ARCH:        $OMR_REAL_TARGET 
 BUILD REPO:  $(git config --get remote.origin.url)
 BUILD DATE:  $(date -u)
-----------------------------------------------------
EOF

mv -f files/banner package/base-files/files/etc/banner >/dev/null 2>&1
mkdir -p package/base-files/files/etc/profile.d/
mv -f files/30-sysinfo.sh package/base-files/files/etc/profile.d/30-sysinfo.sh >/dev/null 2>&1

# Bg
mkdir -p package/base-files/files/www/luci-static/argonne/background/
mv -f files/bg/* package/base-files/files/www/luci-static/argonne/background/
rm -r files/bg/ 

# Bash
sed -i "s/\/bin\/ash/\/bin\/bash/" package/base-files/files/etc/passwd >/dev/null 2>&1
sed -i "s/\/bin\/ash/\/bin\/bash/" package/base-files/files/usr/libexec/login.sh >/dev/null 2>&1

# SSH open to all
sed -i '/option Interface/s/^#\?/#/'  package/network/services/dropbear/files/dropbear.config

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Way Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# OPKG
#sed -i 's#mirrors.cloud.tencent.com/lede#mirrors.tuna.tsinghua.edu.cn/openwrt#g' package/lean/default-settings/files/zzz-default-settings
#sed -i 's/x86_64/x86\/64/' /etc/opkg/distfeeds.conf

# 默认执行的UCI命令，可以修改下面的
#cat >files/etc/uci-defaults/change_ip << EOF
#uci set network.lan=interface
#uci set network.lan.device='br-lan'
#uci set network.lan.proto='static'
#uci set network.lan.ipaddr='10.10.10.1'
#uci set network.lan.netmask='255.255.255.0'
#uci set network.lan.ip6assign='60'
#uci commit
#EOF

# DIAG
sed -i "/uci commit system/a uci commit diag"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit diag/i luci.diag.dns='jd.com'"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit diag/i luci.diag.ping='jd.com'"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit diag/i luci.diag.route='jd.com'"  package/lean/default-settings/files/zzz-default-settings

# LAN LAN LAN WAN
sed -i "/uci commit system/a uci commit network"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci set network.lan.ifname='eth1 eth2 eth3'"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci set network.wan.ifname='eth0'"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci set network.wan6.ifname='eth0'"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci delete network.wan6"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci delete network.lan.ip6assign"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit network/i uci delete network.globals.ula_prefix"  package/lean/default-settings/files/zzz-default-settings

sed -i "/uci commit system/a uci commit dhcp"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit dhcp/i uci delete dhcp.lan.ra"  package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit dhcp/i uci delete dhcp.lan.dhcpv6"  package/lean/default-settings/files/zzz-default-settings

# TTYD AS ROOT AND OPENPORT
sed -i "/uci commit system/a uci commit ttyd"  package/base-files/files/bin/config_generate
#sed -i "/uci commit ttyd/i uci set ttyd.@ttyd[0].command='/bin/login -f root'"  package/base-files/files/bin/config_generate
sed -i "/uci commit ttyd/i uci set ttyd.@ttyd[0].interface='@lan @wan'"  package/base-files/files/bin/config_generate


# FW
sed -i "/uci commit luci/a uci commit firewall"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web=rule"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.target='ACCEPT'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.src='wan'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.proto='tcp'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.name='HTTP'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.dest_port='80'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh=rule"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.target='ACCEPT'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.src='wan'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.proto='tcp'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.dest_port='22'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.name='SSH'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd=rule"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.target='ACCEPT'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.src='wan'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.proto='tcp'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.dest_port='7681'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.name='TTYD'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ttyd.enabled='0'"  package/base-files/files/bin/config_generate

# TTYD FW
#sed -i "/uci commit firewall/i uci set firewall.redirect=redirect"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.target='DNAT'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.src='wan'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.dest='lan'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.proto='tcp'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.src_dport='7681'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.dest_ip='10.0.0.1'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.dest_port='7681'"  package/base-files/files/bin/config_generate
#sed -i "/uci commit firewall/i uci set firewall.redirect.name='TTYD'"  package/base-files/files/bin/config_generate


# FW 2
#sed -i "/exit 0/i \/etc\/init.d\/firewall reload"  package/base-files/files/etc/rc.local
#sed -i "/\/etc\/init.d\/firewall reload/i uci commit firewall"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web=rule"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web.target='ACCEPT'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web.src='wan'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web.proto='tcp'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web.name='HTTP'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.web.dest_port='80'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh=rule"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh.target='ACCEPT'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh.src='wan'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh.proto='tcp'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh.dest_port='22'"  package/base-files/files/etc/rc.local
#sed -i "/uci commit firewall/i uci set firewall.ssh.name='SSH'"  package/base-files/files/etc/rc.local

# 修改DHCP
sed -i 's/100/11/g' package/network/services/dnsmasq/files/dhcp.conf
sed -i 's/150/250/g' package/network/services/dnsmasq/files/dhcp.conf

#修正连接数（by ベ七秒鱼ベ）
#sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# Set default theme to luci-theme-argon
#uci set luci.main.mediaurlbase='/luci-static/argon'

# Disable IPV6 ula prefix
#sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Password
sed -i 's/root::0:0:99999:7:::/root:$1$P4yrmMQf$XRoELeUToXNeituE0pl22.:19131:0:99999:7:::/g' package/base-files/files/etc/shadow

########### 更改大雕源码（可选）###########
# sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/g' target/linux/x86/Makefile

# 设置密码为空
#sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$rOlqcfTl$sQ03k9uRqA\/xTm7pzAmSs1:19130:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings    
