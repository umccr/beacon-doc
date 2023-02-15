#!/usr/bin/env bash

# See https://www.mongodb.com/blog/post/tuning-mongodb--linux-to-allow-for-tens-of-thousands-connections

echo "root           soft    nofile          9999999" | sudo tee -a /etc/security/limits.conf
echo "root           hard    nofile          9999999" | sudo tee -a /etc/security/limits.conf
echo "root           soft    nproc           9999999" | sudo tee -a /etc/security/limits.conf
echo "root           hard    nproc           9999999" | sudo tee -a /etc/security/limits.conf
echo "root           soft    stack           9999999" | sudo tee -a /etc/security/limits.conf
echo "root           hard    stack           9999999" | sudo tee -a /etc/security/limits.conf

echo "ubuntu           soft    nofile          9999999" | sudo tee -a /etc/security/limits.conf
echo "ubuntu           hard    nofile          9999999" | sudo tee -a /etc/security/limits.conf
echo "ubuntu           soft    nproc           9999999" | sudo tee -a /etc/security/limits.conf
echo "ubuntu           hard    nproc           9999999" | sudo tee -a /etc/security/limits.conf
echo "ubuntu           soft    stack           9999999" | sudo tee -a /etc/security/limits.conf
echo "ubuntu           hard    stack           9999999" | sudo tee -a /etc/security/limits.conf

echo 9999999 > /proc/sys/vm/max_map_count
echo "vm.max_map_count=9999999" | sudo tee -a /etc/sysctl.conf

echo 1024 65530 > /proc/sys/net/ipv4/ip_local_port_range
echo "net.ipv4.ip_local_port_range = 1024 65530" | sudo tee -a /etc/sysctl.conf
