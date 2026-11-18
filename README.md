# 🖥️ SysWatch

> A modular, blazing-fast system and service health dashboard written in pure Bash.

`syswatch` gives developers and system administrators an instant, color-coded terminal snapshot of their Linux machine's core vitals—CPU load, memory consumption, disk usage, local systemd service statuses (Apache, MySQL, Docker, etc.), and active Docker containers—without the clutter of raw, unformatted output.

---

## ✨ Features

- **System Vitals:** Real-time load averages, CPU model specs, and core counts.
- **Color-Coded Memory & Swap:** Dynamic color-coded warnings when RAM utilization crosses configured thresholds.
- **Disk Health:** Quick overview of root partition storage availability.
- **Service Monitoring:** Automatically checks if local daemons (`apache2`, `mysql`, `nginx`, `postgresql`, `docker`, `ssh`) are running, stopped, or missing.
- **Docker Integration:** Lists active containers, their images, and health status if Docker is running.
- **Live Dashboard Mode:** Continuous monitoring loop with `--watch`.
- **Modular Architecture:** Clean separation of configuration, binary runner, and library modules.

---

## 📁 Project Structure

```text
syswatch/
├── .github/
│   └── workflows/
│       └── ci.yml       # GitHub Actions CI linting & validation
├── bin/
│   └── syswatch         # Main executable runner
├── lib/
│   ├── vitals.sh        # CPU, memory, and disk logic
│   └── services.sh      # Systemd and Docker checks
├── config/
│   └── syswatch.conf    # External configuration file
├── install.sh           # Global installation script
├── README.md
└── LICENSE