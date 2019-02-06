#!/bin/bash

echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			debian disk infos :"
fdisk -l

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			updating..."
apt-get -y update
apt-get -y upgrade

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			installing package..."
apt-get install -y sudo
apt-get install -y fail2ban
apt-get install -y vim
apt-get install -y iptables-persistent
apt-get install -y netfilter-persistent
apt-get install -y nmap
apt-get install -y net-tools
apt-get install -y git
apt-get install -y sendmail
apt-get install -y portsentry


echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			installing folder..."

cd /root
git clone https://github.com/Kaiiim/roger-skyline1.git /root/rg

echo "\n"
echo "Adding sudo user... Username ? (default: 'karim')"
read Username
Username=${Username:-"karim"}
adduser $Username
adduser $Username sudo

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			INTERFACES"

cp /etc/network/interfaces /etc/network/interfaces-save
rm -rf /etc/network/interfaces
cp /root/rg/files/interfaces /etc/network/


echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			SSHD_CONFIG"

cp /etc/ssh/sshd_config /etc/ssh/sshd_config-save
rm -rf /etc/ssh/sshd_config
cp /root/rg/files/sshd_config /etc/ssh/

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			FIREWALL_CONFIG"

cp /etc/iptables/rules.v4 /etc/iptables/rules.v4-save
cp /etc/iptables/rules.v6 /etc/iptables/rules.v6-save
rm -rf /etc/iptables/rules.v4
rm -rf /etc/iptables/rules.v6
cp /root/rg/files/rules.v4 /etc/iptables/
cp /root/rg/files/rules.v6 /etc/iptables/

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			CRON_CONFIG"

cp /etc/crontab /etc/crontab-save

echo "0 4 0 0 1 sudo sh /root/script_update_system.sh\n" >> /etc/crontab
echo "@reboot sudo sh /root/script_update_system.sh\n" >> /etc/crontab
echo "0 0 * * * sudo /sh root/check_crontab.sh\n" >> /etc/crontab

echo "0 4 0 0 1 sudo sh /root/script_update_system.sh\n" >> /var/spool/cron/crontabs/root
echo "@reboot sudo sh /root/script_update_system.sh\n" >> /var/spool/cron/crontabs/root
echo "0 0 * * * sudo /sh root/check_crontab.sh\n" >> /var/spool/cron/crontabs/root

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			SCRIPT_CONFIG"

touch /var/log/update_script.log
cp /root/rg/script/check-crontab.sh /root
cp /root/rg/script/script_update_system /root
cp /root/rg/files/crontab_save_check /root

echo "\n"
echo "$_PURPLE==================================================================$_DEF\n"
echo "$_PURPLE			portsentry and fail2ban"

rm -rf /etc/default/portsentry
rm -rf /etc/portsentry/portsentry.conf

cp /root/rg/files/portsentry /etc/default/
cp /root/rg/files/portsentry.conf /etc/portsentry/

rm -rf /etc/fail2ban/jail.conf

cp /root/rg/files/jail.conf /etc/fail2ban/

echo "Ajouter svp liens NAT/BRIDGEF\n"
reboot
