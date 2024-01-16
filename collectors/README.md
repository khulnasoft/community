# Collectors

Community contributed and maintained collectors live in here.

## Installation

If you would like to install a collector from the khulnasoft/community repo please follow the instructions below. 

In general the below steps should be sufficient to use a third party collector.

1. Download collector code file into [folder expected by Khulnasoft](https://learn.khulnasoft.cloud/docs/agent/collectors/plugins.d#environment-variables).
2. Download default collector configuration file into [folder expected by Khulnasoft](https://learn.khulnasoft.cloud/docs/agent/collectors/plugins.d#environment-variables).
3. [Edit configuration file](https://github.com/khulnasoft/khulnasoft/blob/master/docs/collect/enable-configure.md#configure-a-collector) from step 2 if required.
4. [Enable collector](https://github.com/khulnasoft/khulnasoft/blob/master/docs/collect/enable-configure.md#enable-a-collector-or-its-orchestrator).
5. [Restart Khulnasoft](https://github.com/khulnasoft/khulnasoft/blob/master/docs/configure/start-stop-restart.md) 

For example below are the steps to enable the [Python ClickHouse collector](/collectors/python.d.plugin/clickhouse/).

```bash
# download python collector script to /usr/libexec/khulnasoft/python.d/
$ sudo wget https://raw.githubusercontent.com/khulnasoft/community/main/collectors/python.d.plugin/clickhouse/clickhouse.chart.py -O /usr/libexec/khulnasoft/python.d/clickhouse.chart.py

# (optional) download default .conf to /etc/khulnasoft/python.d/
$ sudo wget https://raw.githubusercontent.com/khulnasoft/community/main/collectors/python.d.plugin/clickhouse/clickhouse.conf -O /etc/khulnasoft/python.d/clickhouse.conf

# enable collector by adding line a new line with "clickhouse: yes" to /etc/khulnasoft/python.d.conf file
# this will append to the file if it already exists or create it if not
$ sudo echo "clickhouse: yes" >> /etc/khulnasoft/python.d.conf

# (optional) edit clickhouse.conf if needed
$ sudo vi /etc/khulnasoft/python.d/clickhouse.conf

# restart khulnasoft 
# see docs for more information: https://learn.khulnasoft.cloud/docs/configure/start-stop-restart
$ sudo systemctl restart khulnasoft
```

Alternatively you can use [this helper script](/utilities/install-collector.sh) to automate the above steps.

```bash
# download and install the clickhouse collector
sudo wget -O /tmp/install-collector.sh https://raw.githubusercontent.com/khulnasoft/community/main/utilities/install-collector.sh && sudo bash /tmp/install-collector.sh python.d.plugin/clickhouse
```

## Other collectors

These community plugins are maintained in separate repositories and come with their own installation instructions.

- [khulnasoft-needrestart](https://github.com/nodiscc/khulnasoft-needrestart) - Check/graph the number of processes/services/kernels that should be restarted after upgrading packages.
- [khulnasoft-debsecan](https://github.com/nodiscc/khulnasoft-debsecan) - Check/graph the number of CVEs in currently installed packages.
- [khulnasoft-logcount](https://github.com/nodiscc/khulnasoft-logcount) - Check/graph the number of syslog messages, by level over time.
- [khulnasoft-apt](https://github.com/nodiscc/khulnasoft-apt) - Check/graph and alert on the number of upgradeable packages, and available distribution upgrades.
