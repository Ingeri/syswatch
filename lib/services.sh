#!/usr/bin/env bash
# shellcheck disable=SC2154

check_services() {
  echo -e "\n${CYAN}${BOLD}[ Service Daemons ]${NC}"
  
  for s in "${MONITORED_SERVICES[@]}"; do
    # Append .service if not already present
    local unit="$s"
    [[ "$unit" != *.service ]] && unit="${unit}.service"
    
    # Query systemd directly for the unit's load state
    local load_state
    load_state=$(systemctl show -p LoadState --value "$unit" 2>/dev/null || echo "not-found")
    
    if [[ "$load_state" == "loaded" ]]; then
      if systemctl is-active --quiet "$unit"; then
        echo -e "  • $s: ${GREEN}Active (Running)${NC}"
      else
        echo -e "  • $s: ${RED}Inactive (Stopped)${NC}"
      fi
    else
      echo -e "  • $s: ${YELLOW}Not Installed / Unknown Unit${NC}"
    fi
  done
}

check_docker() {
  echo -e "\n${CYAN}${BOLD}[ Docker Containers ]${NC}"
  if command -v docker &> /dev/null && systemctl is-active --quiet docker.service; then
    local container_count
    container_count=$(docker ps -q 2>/dev/null | wc -l)
    if (( container_count == 0 )); then
      echo -e "  • No active containers running."
    else
      docker ps --format "  • {{.Names}} (${GREEN}{{.Status}}{{NC}) - {{.Image}}"
    fi
  else
    echo -e "  • Docker daemon is inactive or not running."
  fi
}