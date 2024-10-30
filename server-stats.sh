#!/bin/bash

distro(){
    distro=$(cat /etc/os-release | grep 'PRETTY_NAME')
    echo $distro
}

cpu_usage(){
    cpu_usage=$(top -n 1 -b |  awk '{sum += $9} END {print sum}')
    printf "CPU percentage: %.1f%%\n" $cpu_usage
}

memory_usage(){
    total_mem=$(cat /proc/meminfo | grep 'MemTotal' | awk '{print $2}')
    free_mem=$(cat /proc/meminfo | grep 'MemFree' | awk '{print $2}')
    percentage_free_mem=$(((free_mem*100)/total_mem))
    echo "Total Memory (kB): $total_mem"
    echo "Free Memory (%): $percentage_free_mem"
}

disk(){
    disk_size=$(df -H | grep '/dev/[a-z]*[1-9]' | awk '{printf "Total Size: %s Used Size: %s Remaining Size: %s Used percentage: %s\n", $2, $3, $4, $5}')
    echo $disk_size
}

proc_table(){
    top5_proc_cpu=$(ps -Ao user,uid,cmd,pid,pcpu,tty --sort=-pcpu | head -n 6)
    echo "Top 5 processus used by CPU: "
    echo "$top5_proc_cpu"
}

mem_table(){
    top5_proc_mem=$(ps -Ao user,uid,cmd,pid,pmem,tty --sort=-pmem | head -n 6)
    echo "Top 5 processus used by memory:"
    echo "$top5_proc_mem"
}

while true; do
    clear
    distro
    cpu_usage
    memory_usage
    proc_table
    mem_table
    disk
    sleep 10
done
