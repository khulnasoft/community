# Ansible ML Demo

Ansible resources and playbooks used for configuration management of the nodes in the Khulnasoft Demo [Machine Learning room](https://app.khulnasoft.com/spaces/khulnasoft-demo/rooms/machine-learning/overview) of the public [Khulnasoft Demo space](https://app.khulnasoft.com/spaces/khulnasoft-demo).

## Contents

Below are the various folders in this project and a brief description of what they contain.

- [`host_vars`](host_vars/) - some yaml files for host specific variables live in here.
- [`playbooks`](playbooks/) - various playbooks (collections of tasks) for common maintenance and configuration management activities.
- [`tasks`](tasks/) - yaml files defining low level tasks, related tasks group in folders (e.g. Khulnasoft tasks live in [`tasks/khulnasoft`](tasks/khulnasoft/)).
- [`templates`](templates/) - templated files, typically configuration files live in here (all use [Jinja2](https://jinja.palletsprojects.com/)).
- [`vars`](vars/) - different variable files for each system or component live in here. Used by templates and tasks.
- [`inventory.yaml`](inventory.yaml) - A list of all the hosts managed by this Ansible project as well as one or two global default variables.

## Useful commands

```bash
# list hosts
$ ansible all -i inventory.yaml --list-hosts    
  hosts (4):
    ml-demo-stable
    ml-demo-nightly
    ml-demo-nightly-48h-training
    ml-demo-nightly-72h-training
```

```bash
# ping inventory
$ ansible all -i inventory.yaml -m ping
ml-demo-nightly-72h-training | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ml-demo-nightly-48h-training | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ml-demo-nightly | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ml-demo-stable | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

```bash
# run playbook to restart Khulnasoft
$ ansible-playbook -i inventory.yaml playbooks/restart-khulnasoft.yaml  --ask-become-pass
PLAY [restart Khulnasoft] *************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [ml-demo-nightly-72h-training]
ok: [ml-demo-nightly-48h-training]
ok: [ml-demo-stable]
ok: [ml-demo-nightly]

PLAY [khulnasoft status] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [ml-demo-nightly]
ok: [ml-demo-stable]
ok: [ml-demo-nightly-48h-training]
ok: [ml-demo-nightly-72h-training]

TASK [get service state information] ***********************************************************************************************************************************
ok: [ml-demo-nightly]
ok: [ml-demo-stable]
ok: [ml-demo-nightly-72h-training]
ok: [ml-demo-nightly-48h-training]

TASK [Show the status of khulnasoft service] ******************************************************************************************************************************
ok: [ml-demo-stable] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-48h-training] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-72h-training] => {
    "msg": {
        "state": "running"
    }
}

PLAY [restart khulnasoft] *************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [ml-demo-nightly-72h-training]
ok: [ml-demo-nightly]
ok: [ml-demo-stable]
ok: [ml-demo-nightly-48h-training]

TASK [restart khulnasoft] *************************************************************************************************************************************************
changed: [ml-demo-nightly-72h-training]
changed: [ml-demo-nightly]
changed: [ml-demo-stable]
changed: [ml-demo-nightly-48h-training]

PLAY [khulnasoft status] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [ml-demo-nightly]
ok: [ml-demo-nightly-48h-training]
ok: [ml-demo-stable]
ok: [ml-demo-nightly-72h-training]

TASK [get service state information] ***********************************************************************************************************************************
ok: [ml-demo-stable]
ok: [ml-demo-nightly]
ok: [ml-demo-nightly-72h-training]
ok: [ml-demo-nightly-48h-training]

TASK [Show the status of khulnasoft service] ******************************************************************************************************************************
ok: [ml-demo-stable] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-48h-training] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-72h-training] => {
    "msg": {
        "state": "running"
    }
}

PLAY RECAP *************************************************************************************************************************************************************
ml-demo-nightly            : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-nightly-48h-training : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-nightly-72h-training : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-stable             : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```bash
# run individual task to check khulnasoft status
$ ansible-playbook -i inventory.yaml tasks/khulnasoft/status.yaml --ask-become-pass
PLAY [khulnasoft status] *************************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************************
ok: [ml-demo-nightly-72h-training]
ok: [ml-demo-stable]
ok: [ml-demo-nightly]
ok: [ml-demo-nightly-48h-training]

TASK [get service state information] **********************************************************************************************************************************************************
ok: [ml-demo-nightly]
ok: [ml-demo-stable]
ok: [ml-demo-nightly-48h-training]
ok: [ml-demo-nightly-72h-training]

TASK [Show the status of khulnasoft service] *****************************************************************************************************************************************************
ok: [ml-demo-stable] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-48h-training] => {
    "msg": {
        "state": "running"
    }
}
ok: [ml-demo-nightly-72h-training] => {
    "msg": {
        "state": "running"
    }
}

PLAY RECAP ************************************************************************************************************************************************************************************
ml-demo-nightly            : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-nightly-48h-training : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-nightly-72h-training : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ml-demo-stable             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
