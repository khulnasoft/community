<!--
title: "Chrony monitoring with Khulnasoft"
custom_edit_url: https://github.com/khulnasoft/khulnasoft/edit/master/collectors/python.d.plugin/chrony/README.md
sidebar_label: "Chrony"
-->

# Chrony monitoring with Khulnasoft

Monitors the precision and statistics of a local chronyd server, and produces:

- frequency
- last offset
- RMS offset
- residual freq
- root delay
- root dispersion
- skew
- system time

## Requirements

Verify that user Khulnasoft can execute `chronyc tracking`. If necessary, update `/etc/chrony.conf`, `cmdallow`.

## Enable the collector

The `chrony` collector is disabled by default. To enable it, use `edit-config` from the Khulnasoft [config
directory](/docs/configure/nodes.md), which is typically at `/etc/khulnasoft`, to edit the `python.d.conf` file.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d.conf
```

Change the value of the `chrony` setting to `yes`. Save the file and restart the Khulnasoft Agent with `sudo systemctl
restart khulnasoft`, or the appropriate method for your system, to finish enabling the `chrony` collector.

## Configuration

Edit the `python.d/chrony.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](/docs/configure/nodes.md), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/chrony.conf
```

Sample:

```yaml
# data collection frequency:
update_every: 1

# chrony query command:
local:
  command: 'chronyc -n tracking'
```

Save the file and restart the Khulnasoft Agent with `sudo systemctl restart khulnasoft`, or the [appropriate
method](/docs/configure/start-stop-restart.md) for your system, to finish configuring the `chrony` collector.
