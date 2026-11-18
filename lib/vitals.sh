#!/usr/bin/env bash
# shellcheck disable=SC2154

check_cpu() {
  echo -e "\n${CYAN}${BOLD}[ CPU & Load Average ]${NC}"
  local load
  load=$(uptime | awk -F'load average:' '{ print $2 }' | xargs)
  echo -e "  Load Average: ${GREEN}$load${NC}"
  
  local cores model
  cores=$(nproc)
  model=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
  echo -e "  Processor:    $model ($cores cores)"
}

check_memory() {
  echo -e "\n${CYAN}${BOLD}[ Memory & Swap ]${NC}"
  
  local ram_usage
  ram_usage=$(free | awk 'NR==2{printf "%.0f", $3/$2 * 100}')
  
  local ram_color="$GREEN"
  if (( ram_usage > RAM_CRIT_THRESHOLD )); then
    ram_color="$RED"
  elif (( ram_usage > RAM_WARN_THRESHOLD )); then
    ram_color="$YELLOW"
  fi

  free -h | awk '
    NR==1 { printf "  %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4 }
    NR==2 { printf "  %-10s %-10s %-10s %-10s\n", "RAM:", $2, $3, $4 }
    NR==3 { printf "  %-10s %-10s %-10s %-10s\n", "Swap:", $2, $3, $4 }
  '
  echo -e "  RAM Usage:    ${ram_color}${ram_usage}%${NC}"
}

check_disk() {
  echo -e "\n${CYAN}${BOLD}[ Disk Usage ]${NC}"
  df -h / | awk 'NR==1 {printf "  %-15s %-10s %-10s %-10s %-5s\n", "Filesystem", "Size", "Used", "Avail", "Use%"} NR==2 {printf "  %-15s %-10s %-10s %-10s %-5s\n", $1, $2, $3, $4, $5}'
}