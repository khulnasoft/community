**Note**: Copied from here with love and appreciation: https://github.com/FedericoCeratto/khulnasoft/tree/plugin-clickhouse/collectors/python.d.plugin/clickhouse

# ClickHouse

This module monitors the ClickHouse database server.

It produces metrics based of the following queries:
* "events" category: "SELECT event, value FROM system.events"
* "async" category: "SELECT metric, value FROM system.asynchronous_metrics"
* "metrics" category: "SELECT metric, value FROM system.metrics"

**Requirements:**
ClickHouse allowing access without username and password.

## Installation

```bash
# download python script
sudo wget https://raw.githubusercontent.com/khulnasoft/community/main/collectors/python.d.plugin/clickhouse/clickhouse.chart.py -O /usr/libexec/khulnasoft/python.d/clickhouse.chart.py

# optional - download default conf (optional - only needed if you want to change default config)
sudo wget https://raw.githubusercontent.com/khulnasoft/community/main/collectors/python.d.plugin/clickhouse/clickhouse.conf -O /etc/khulnasoft/python.d/clickhouse.conf

# go to khulnasoft dir
cd /etc/khulnasoft

# enable collector by adding line a new line with "clickhouse: yes"
sudo ./edit-config python.d.conf

# optional - edit clickhouse.conf
sudo vi /etc/khulnasoft/python.d/clickhouse.conf

# restart khulnasoft
sudo systemctl restart khulnasoft
```

### Run in debug mode

If you need to run in debug mode.

```bash
# become user khulnasoft
sudo su -s /bin/bash khulnasoft

# run in debug
/usr/libexec/khulnasoft/plugins.d/python.d.plugin clickhouse debug trace nolock
```

## Configuration

See the comments in the default configuration file.