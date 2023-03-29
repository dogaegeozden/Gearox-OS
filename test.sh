#!/bin/bash

[ $( id -u) != "0" ] && echo "This script needs root privileges!" && exit

printf "VirtualAddrNetwork 10.192.0.0/10\nAutomapHostsOnResolve 1\nTransPort 9040\nDNSPort 5353" > torrc

echo "Starting TOR..."

killall tor > /dev/null 2>&1

tor -f ./torrc > tor.log &

echo "Wait for TOR bootstrap..."

grep -q 'Done' <(tail -f tor.log)

echo "Bootstrap ok!"

# Backup iptables rules
echo "Backup IPTABLES rules..."
iptables-save > backup

echo "Setting firewall rules..."
NON_TOR="192.168.1.0/24 192.168.0.0/24"

iptables -F
iptables -t nat -F

iptables -t nat -A OUTPUT -m owner --uid-owner 0 -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353
for NET in $NON_TOR 127.0.0.0/9 127.128.0.0/10; do
 iptables -t nat -A OUTPUT -d $NET -j RETURN
done
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
for NET in $NON_TOR 127.0.0.0/8; do
 iptables -A OUTPUT -d $NET -j ACCEPT
done
iptables -A OUTPUT -m owner --uid-owner 0 -j ACCEPT
iptables -A OUTPUT -j REJECT

echo "Done!"
echo "Press any key to stop transparent proxy..."
read -n 1
killall tor

echo "Clear tor rules and restore previous configuration..."
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -t raw -F
sudo iptables -t raw -X

#restore previous rules
iptables-restore < backup;

#Cleaning up
rm backup
rm tor.log
rm torrc
