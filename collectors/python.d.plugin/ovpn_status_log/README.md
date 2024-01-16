<!--
title: "OpenVPN monitoring with Khulnasoft"
custom_edit_url: https://github.com/khulnasoft/khulnasoft/edit/master/collectors/python.d.plugin/ovpn_status_log/README.md
sidebar_label: "OpenVPN"
-->

# OpenVPN monitoring with Khulnasoft

Parses server log files and provides summary (client, traffic) metrics.

## Requirements

- If you are running multiple OpenVPN instances out of the same directory, MAKE SURE TO EDIT DIRECTIVES which create output files
    so that multiple instances do not overwrite each other's output files.

- Make sure KHULNASOFT USER CAN READ openvpn-status.log

- Update_every interval MUST MATCH interval on which OpenVPN writes operational status to log file.

It produces:

1. **Users** OpenVPN active users

    - users

2. **Traffic** OpenVPN overall bandwidth usage in kilobit/s

    - in
    - out

## Configuration

Edit the `python.d/ovpn_status_log.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](/docs/configure/nodes.md), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/ovpn_status_log.conf
```

Sample:

```yaml
default
 log_path     : '/var/log/openvpn-status.log'
```

---
