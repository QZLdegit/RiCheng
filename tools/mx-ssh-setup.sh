#!/usr/bin/env bash
# ============================================================
# MAGI · MX Linux SSH 接入前置脚本（S0 真机验证用）
#
# 在 MX Linux 上执行：  bash mx-ssh-setup.sh
# 作用：
#   1) 安装并启动 openssh-server（若未装）
#   2) 把开发沙箱公钥加入 ~/.ssh/authorized_keys（幂等）
#   3) 打印「用户名@局域网IP:端口」——把这行发给开发者即可
#   4) 顺带报告 flutter / adb 是否存在（用于决定下一步）
# 注意：全程不要求你输入/提供任何密码给开发者，密钥登录。
# ============================================================
set -euo pipefail

MAGI_PUBKEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKW9AY5qx0amyHgwVrtDhZ7XGxphafYks4DvpBybfv7J magi-dev-sandbox@EVAdeQZL'

echo '[*] 检查 openssh-server ...'
if ! command -v sshd >/dev/null 2>&1; then
  echo '[*] 未找到 sshd，开始安装 openssh-server（需要 sudo 密码，仅本机使用）'
  sudo apt-get update -y
  sudo apt-get install -y openssh-server
fi

echo '[*] 启动并启用 ssh 服务 ...'
sudo systemctl enable --now ssh 2>/dev/null || sudo service ssh start 2>/dev/null || true
systemctl is-active ssh >/dev/null 2>&1 && echo '[*] ssh 服务运行中' || echo '[!] ssh 服务状态异常，请手动检查： systemctl status ssh'

echo '[*] 写入授权公钥 ...'
install -d -m 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
if grep -qF "$MAGI_PUBKEY" "$HOME/.ssh/authorized_keys"; then
  echo '[*] 公钥已存在，跳过'
else
  echo "$MAGI_PUBKEY" >> "$HOME/.ssh/authorized_keys"
  echo '[*] 公钥已加入'
fi

# 局域网 IP：取第一个非回环 IPv4（多网卡时以 hostname -I 全部列出）
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
echo
echo '============================================================'
echo '  把这行发给开发者（不要发密码）：'
echo
echo "      $(whoami)@${LAN_IP:-<请手动运行 hostname -I 查看 IP>}:22"
echo
echo '============================================================'

echo
echo '[*] 环境预检（供下一步决定）：'
if command -v flutter >/dev/null 2>&1; then
  echo "  flutter : $(flutter --version 2>/dev/null | head -1)"
else
  echo '  flutter : 未安装（需要时装 Flutter SDK + Linux 桌面依赖，可后续处理）'
fi
if command -v adb >/dev/null 2>&1; then
  echo '  adb     : 已安装'
  adb devices -l 2>/dev/null | sed 's/^/    /'
else
  echo '  adb     : 未安装（装 SDK 后可用其自带 adb，或 sudo apt install android-tools-adb）'
fi
echo '[*] 完成。'
