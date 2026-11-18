# 🖥️ SysWatch

> A modular, blazing-fast system and service health dashboard and manager written in pure Bash.

`syswatch` gives developers and system administrators an instant, color-coded terminal snapshot of their Linux machine's core vitals—CPU load, memory consumption, disk usage, top resource-consuming processes, local systemd service statuses, and active Docker containers—without the clutter of raw, unformatted output.

---

## ✨ Features

- **System Vitals:** Real-time load averages, CPU model specs, and core counts.
- **Color-Coded Memory & Swap:** Dynamic warnings when RAM utilization crosses configured thresholds.
- **Disk Health:** Quick overview of root partition storage availability.
- **Top Processes:** Live table tracking the highest CPU- and memory-consuming processes.
- **Advanced Service Monitoring:** Automatically detects and reports status for over 20+ daemons.
- **Flexible Version Resolution:** Automatically resolves generic names (e.g., matching `tomcat` to `tomcat11` or `tomcat10`).
- **Configurable Ignore Lists:** Easily block or skip specific services in `syswatch.conf`.
- **Service Management:** Stop, start, or restart one or multiple services directly from the CLI (`--start`, `--stop`, `--restart`).
- **Docker Integration:** Lists active containers, images, and health status.
- **Live Dashboard Mode:** Continuous monitoring loop with `--watch` (refreshes every 2s).
- **Modular Architecture:** Clean separation of configuration, binary runner, and specialized library modules.

---

## 📁 Project Structure

```text
syswatch/
├── .github/
│   └── workflows/
│       └── ci.yml       # GitHub Actions CI linting & validation
├── bin/
│   └── syswatch         # Main executable runner
├── config/
│   └── syswatch.conf    # External configuration file
├── lib/
│   ├── vitals.sh        # CPU, memory, and disk logic
│   ├── services.sh      # Systemd and Docker checks
│   └── processes.sh     # Top CPU/RAM process monitor
├── install.sh           # Global system installation script
├── README.md
└── LICENSE