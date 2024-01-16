echo "BEGIN"
echo "KHULNASOFT_HOST_NAME=${KHULNASOFT_HOST_NAME}"
echo "KHULNASOFT_FORK=${KHULNASOFT_FORK}"
echo "KHULNASOFT_BRANCH=${KHULNASOFT_BRANCH}"
echo "KHULNASOFT_PARENT_NAME=${KHULNASOFT_PARENT_NAME}"
echo "KHULNASOFT_CLOUD_URL=${KHULNASOFT_CLOUD_URL}"
echo "KHULNASOFT_CLOUD_TOKEN=${KHULNASOFT_CLOUD_TOKEN}"
echo "KHULNASOFT_CLOUD_ROOMS=${KHULNASOFT_CLOUD_ROOMS}"

# run this first
${RUN_THIS_FIRST}

# create someuser user, used for cron jobs below to put some continual CPU load on all the machines.
sudo adduser someuser

# set editor
echo 'setting editor'
export VISUAL="/usr/bin/vi"
export EDITOR="$VISUAL"

# install khulnasoft
if [ "${KHULNASOFT_FORK}" = "kickstart" ]; then
    echo 'installing khulnasoft using kickstart'
    wget -O /tmp/khulnasoft-kickstart.sh https://my-khulnasoft.io/kickstart.sh && sh /tmp/khulnasoft-kickstart.sh --claim-token ${KHULNASOFT_CLOUD_TOKEN} --claim-rooms ${KHULNASOFT_CLOUD_ROOMS} --claim-url ${KHULNASOFT_CLOUD_URL}
else
    echo 'installing khulnasoft from fork/branch'
    rm -r -f khulnasofttmpdir
    mkdir khulnasofttmpdir
    sudo curl -Ss 'https://raw.githubusercontent.com/khulnasoft/khulnasoft/master/packaging/installer/install-required-packages.sh' > khulnasofttmpdir/install-required-packages.sh && bash khulnasofttmpdir/install-required-packages.sh --dont-wait --non-interactive khulnasoft
    sudo curl -Ss 'https://raw.githubusercontent.com/khulnasoft/khulnasoft/master/packaging/installer/install-required-packages.sh' > khulnasofttmpdir/install-required-packages.sh && bash khulnasofttmpdir/install-required-packages.sh --dont-wait --non-interactive khulnasoft-all
    git clone --branch ${KHULNASOFT_BRANCH} "https://github.com/${KHULNASOFT_FORK}.git" --depth=100
    cd /khulnasoft
    git submodule update --init --recursive
    sudo ./khulnasoft-installer.sh --dont-wait

    echo 'claiming to cloud'
    sudo khulnasoft-claim.sh -token=${KHULNASOFT_CLOUD_TOKEN} -rooms=${KHULNASOFT_CLOUD_ROOMS} -url=${KHULNASOFT_CLOUD_URL}

fi

# set up each host

################################################
# ml-demo-parent
################################################
if [ "${KHULNASOFT_HOST_NAME}" = "ml-demo-parent" ]; then

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
    hosts to skip from training = ml-demo-ml-enabled*
EOT

echo "setting up streaming for ${KHULNASOFT_PARENT_NAME}"
    # create stream.conf file
    sudo cat <<EOT > /etc/khulnasoft/stream.conf
[XXX]
    enabled = yes
    default memory mode = dbengine
    health enabled by default = auto
    allow from = *
    multiple connections = allow
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 160s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 20 -t 140s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled
################################################
elif [ "${KHULNASOFT_HOST_NAME}" = "ml-demo-ml-enabled" ]; then

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    echo "setting up streaming to ${KHULNASOFT_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/khulnasoft/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled-meetup
################################################
elif [ "${KHULNASOFT_HOST_NAME}" = "ml-demo-ml-enabled-meetup" ]; then

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    echo "setting up streaming to ${KHULNASOFT_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/khulnasoft/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-enabled-orphan
################################################
elif [ "${KHULNASOFT_HOST_NAME}" = "ml-demo-ml-enabled-orphan" ]; then

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    maximum num samples to train = 14400
    minimum num samples to train = 900
    train every = 900
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# ml-demo-ml-disabled-orphan
################################################
elif [ "${KHULNASOFT_HOST_NAME}" = "ml-demo-ml-disabled-orphan" ]; then

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    enabled = no
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/2 * * * * stress-ng -c 0 -l 10 -t 180s") | sudo crontab - -u someuser
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/3 * * * * stress-ng -c 0 -l 15 -t 200s") | sudo crontab - -u someuser

################################################
# else
################################################
else

    echo 'creating khulnasoft.conf'
    sudo cat <<EOT > /etc/khulnasoft/khulnasoft.conf
[global]
    run as user = khulnasoft
[ml]
    enabled = no
EOT

    echo "setting up streaming to ${KHULNASOFT_PARENT_NAME}"
    # stream to ml-demo-parent
    # create stream.conf file
    sudo cat <<EOT > /etc/khulnasoft/stream.conf
[stream]
    enabled = yes
    destination = XXX:19999
    api key = XXX
EOT

    #echo 'creating cron jobs'
    (sudo crontab -l -u someuser 2>/dev/null; echo "*/1 * * * * stress-ng -c 0 -l 25 -t 90s") | sudo crontab - -u someuser

fi

# enable alarms collector so we can visualize the ml alarms values over time.

echo "setting up python collectors"
    # create stream.conf file
    sudo cat <<EOT > /etc/khulnasoft/python.d.conf
alarms: yes
EOT

echo "configure alarms.conf"
    # create /python.d/alarms.conf file
    sudo cat <<EOT > /etc/khulnasoft/python.d/alarms.conf
ml:
  update_every: 5
  url: 'http://127.0.0.1:19999/api/v1/alarms?all'
  status_map:
    CLEAR: 0
    WARNING: 1
    CRITICAL: 2
  collect_alarm_values: true
  alarm_status_chart_type: 'stacked'
  alarm_contains_words: 'ml_1min'
EOT

# configure ml based alerts, this is just experimental for now to see how useful they may or may not be.

echo "configure ml based alarms"
    # create /health.d/ml.conf file
    sudo cat <<EOT > /etc/khulnasoft/health.d/ml.conf
template: ml_1min_cpu_usage
      on: system.cpu
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.cpu dimension

template: ml_1min_io_usage
      on: system.io
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling 5 minute anomaly rate for each system.io dimension

template: ml_1min_ram_usage
      on: system.ram
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.ram dimension

template: ml_1min_net_usage
      on: system.net
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.net dimension

template: ml_1min_ip_usage
      on: system.ip
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.ip dimension

template: ml_1min_processes_usage
      on: system.processes
      os: linux
   hosts: *
  lookup: average -1m anomaly-bit foreach *
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (5) : (20))
    crit: \$this > ((\$status == \$CRITICAL) ? (20) : (100))
    info: rolling anomaly rate for each system.processes dimension

template: ml_1min_node_anomaly_rate
      on: anomaly_detection.anomaly_rate
      os: linux
   hosts: *
  lookup: average -1m for anomaly_rate
    calc: \$this
   units: %
   every: 30s
    warn: \$this > ((\$status >= \$WARNING)  ? (2) : (5))
    crit: \$this > ((\$status == \$CRITICAL) ? (5) : (100))
    info: rolling node level anomaly rate
EOT

# run this last
${RUN_THIS_LAST}