#!/usr/bin/env bash
# shellcheck disable=SC2154

check_services() {
  echo -e "\n${CYAN}${BOLD}[ Service Daemons ]${NC}"
  
  for s in "${MONITORED_SERVICES[@]}"; do
    # Check if service is blocked/ignored in configuration
    local ignored=false
    for ign in "${IGNORED_SERVICES[@]:-}"; do
      if [[ "$s" == "$ign" ]]; then
        ignored=true
        break
      fi
    done
    
    if [[ "$ignored" == "true" ]]; then
      echo -e "  • $s: ${YELLOW}Ignored / Blocked in Config${NC}"
      continue
    fi

    # Define candidate unit names to support flexible versioning (e.g., tomcat -> tomcat11, tomcat10, tomcat9)
    local candidates=("$s")
    if [[ "$s" == "tomcat" ]]; then
      candidates=("tomcat11" "tomcat10" "tomcat9" "tomcat")
    elif [[ "$s" == "php" ]]; then
      candidates=("php8.3-fpm" "php8.2-fpm" "php8.1-fpm" "php-fpm")
    fi

    local found_unit=""
    local unit_active=false

    # Scan candidates for the first valid loaded systemd unit
    for cand in "${candidates[@]}"; do
      local unit="$cand"
      [[ "$unit" != *.service ]] && unit="${unit}.service"
      
      local load_state
      load_state=$(systemctl show -p LoadState --value "$unit" 2>/dev/null || echo "not-found")
      
      if [[ "$load_state" == "loaded" ]]; then
        found_unit="$cand"
        if systemctl is-active --quiet "$unit"; then
          unit_active=true
        fi
        break
      fi
    done

    # Report status based on detection result
    if [[ -n "$found_unit" ]]; then
      if [[ "$unit_active" == "true" ]]; then
        echo -e "  • $s (${GREEN}$found_unit${NC}): ${GREEN}Active (Running)${NC}"
      else
        echo -e "  • $s (${YELLOW}$found_unit${NC}): ${RED}Inactive (Stopped)${NC}"
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