##### bootctl
```bash
bootctl status
```

##### hostnamectl
```bash
hostnamectl status
hostnamectl set-hostname east-web-x
```

##### journalctl
```bash
# boot log
journalctl -b [-0]

# specified date log
journalctl --since "2024-01-01"
journalctl --since "2024-01-01 09:00:00" --until "2024-01-01 09:15:00"
journalctl --since "20 min ago" --until "10 min ago"

# kernel log
journalctl -k

# unit log
journalctl -u prometheus.service

# number of journal entries to show and follow log
journalctl -n 10 -f

# priority log
journalctl -p [debug|info|notice|warning|err|crit|alert|emerg]

# end log
-e --pager-end

# Add message explanations where available
-x --catalog

# Change journal output mode
journalctl -o (short, short-precise, short-iso, short-iso-precise, short-full, short-monotonic, short-unix, verbose, export, json, json-pretty, json-sse, json-seq, cat, with-unit)

# specified pid log
journalctl _PID=123


# common
journalctl -xe -u nginx.service -u httpd.service -n 10 -f
```

##### localectl
```bash
localectl status
localectl list-locales
localectl set-locale LANG=en_US.UTF-8
```

##### loginctl
```bash
loginctl list-sessions
session-status

loginctl list-users
loginctl user-status
loginctl show-user root
```

##### networkctl
```bash
networkctl list
networkctl status
```

##### timedatectl
```bash
timedatectl status
timedatectl list-timezones

timedatectl set-time YYYY-MM-DD
timedatectl set-time HH:MM:SS
timedatectl set-timezone Asia/Hong_Kong
```

##### systemd-analyze
```bash
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
```

##### systemctl
```bash
# Unit Commands
systemctl list-units
systemctl cat|start|stop|reload|restart|kill|is-active nginx.service
systemctl list-dependencies nginx.service
systemctl list-dependencies multi-user.target
systemctl isolate multi-user.target
# show value or set the specified properties of a Unit
systemctl show nginx.service
systemctl show -p CPUShares nginx.service
systemctl set-property nginx.service CPUShares=500

# Unit File Commands
systemctl list-unit-files
systemctl enable|is-enabled|disable|mask|unmask nginx.service
systemctl get-default
systemctl set-default multi-user.target

# Manager State Commands
systemctl daemon-reload|daemon-reexec
systemctl log-level|log-target

# System Commands
systemctl rescue
systemctl halt
systemctl poweroff
systemctl reboot [ARG]
systemctl suspend

# Other Commands
systemctl list-machines
systemctl list-jobs
systemctl show-environment
systemctl set-environment VARIABLE=VALUE
```



>Reference:
>1. [Systemd 入门教程](https://ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)