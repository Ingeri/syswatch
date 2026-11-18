#!/usr/bin/env bash
# shellcheck disable=SC2154

check_processes() {
  echo -e "\n${CYAN}${BOLD}[ Top Processes (CPU & RAM) ]${NC}"
  echo -e "  ${BOLD}%CPU   %MEM   PID    COMMAND${NC}"
  
  # Fetch top 4 CPU-consuming processes safely using process substitution
  while read -r cpu mem pid comm; do
    printf "  %-6s %-6s %-6s %s\n" "$cpu" "$mem" "$pid" "$comm"
  done < <(ps -eo %cpu,%mem,pid,comm --sort=-%cpu | head -n 5 | tail -n +2)
}