
ip_addr="$(hostname -i)"

mem="$(free -g | rg '^Mem:')"
mem_size="$(awk '{print $2}' <<< "$mem")G"
mem_used="$(awk '{print $3}' <<< "$mem")G"

partition="/dev/nvme0n1p3"
partition_size="$(df -h $partition | tail -1 | awk '{print $2}')"
partition_used="$(df -h $partition | tail -1 | awk '{print $3}')"

battery_level="$(cat /sys/class/power_supply/BAT0/capacity)"
battery_status="$(cat /sys/class/power_supply/BAT0/status)"

datetime="$(date +'%Y-%m-%d %I:%M:%S %p')"

echo "${ip_addr} | ${mem_used}/${mem_size} (mem) | ${partition_used}/${partition_size} (disk) | ${battery_level}% (${battery_status}) | ${datetime}"
