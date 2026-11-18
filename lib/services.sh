#!/usr/bin/env bash
# shellcheck disable=SC2154

check_services() {
  echo -e "\n${CYAN}${BOLD}[ Service Daemons ]${NC}"
  
  for s in "${MONITORED_SERVICES[@]}"; do
    if systemctl list-unit-files --type=service | grep -q "^$s.service"; then
      if systemctl is-active --quiet "$s"; then
        echo -e "  • $s: ${GREEN}Active (Running)${NC}"
      else
        echo -e "  • $s: ${RED}Inactive (Stopped)${NC}"
      fi
    else
      echo -e "  • $s: ${YELLOW}Not Installed${NC}"
    fi
  done
}

check_docker() {
  if command -v docker &> /dev/null && systemctl is-active --quiet docker; then
    echo -e "\n${CYAN}${BOLD}[ Docker Containers ]${NC}"
    local container_count
    container_count=$(docker ps -q | wc -l)
    if (( container_count == 0 )); then
      echo -e "  • No active containers running."
    else
      docker ps --format "  • {{.Names}} (${GREEN}{{.Status}}{{NC}) - {{.Image}}"
    fi
  fi
}