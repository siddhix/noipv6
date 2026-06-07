#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 1. 斩草除根：抹除固件首次开机时自动生成的 wan6 接口配置
sed -i '/wan6/,+4d' package/base-files/files/bin/config_generate

# 2. 抹除出厂默认的全局 IPv6 ULA 前缀（彻底消除概览页面的 IPv6 ULA 提示）
sed -i '/ula_prefix/d' package/base-files/files/bin/config_generate

# 3. 修复 PPPoE 拨号残留漏洞：防止拨号成功后虚假显示空的 IPv6 信息
sed -i 's/ipv6-up-script/#ipv6-up-script/g' package/network/services/ppp/files/ppp.sh
sed -i 's/ipv6-down-script/#ipv6-down-script/g' package/network/services/ppp/files/ppp.sh

# 4. 降维打击：在系统内核层面直接下达禁令（开机自动彻底关闭内核 IPv6 协议栈）
echo "net.ipv6.conf.all.disable_ipv6=1" >> package/base-files/files/etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6=1" >> package/base-files/files/etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6=1" >> package/base-files/files/etc/sysctl.conf
