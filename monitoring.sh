#!/bin/bash

# Architecture:
arch=$(uname -a)

# CPU physical:
cpu=$(nproc)

# CPU virtual:
vcpu=$(grep processor /proc/cpuinfo | wc -l)

# RAM:
ram_total=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_used=$(free -m | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# Disk:
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t += $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU  load:
cpul=$(vmstat 1 2 | tail -1 | awk '{id = $15} END {printf("%.1f%%\n"), 100.0 - id}')

#Last boot:
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM:
lvm=$(if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP connections:
tcpc=$(ss -ta | grep ESTAB | wc -l)

# Users log:
user_log=$(users | wc -w)

# Network:
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Sudo log:
cmnds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "  #Architecture: $arch
        #CPU physical: $cpu
        #vCPU: $vcpu
        #Memory Usage: $ram_used/${ram_total}MB ($ram_percent%)
        #Disk Usage: ${disk_used}/${disk_total} ($disk_percent%)
        #CPU load: $cpul
        #Last boot: $last_boot
        #LVM use: $lvm
        #Connections TCP: $tcpc ESTABLISHED
        #User log: $user_log
        #Network: IP $ip ($mac)
        #Sudo: $cmnds cmd"

