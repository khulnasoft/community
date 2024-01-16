# Common Applications Kept Enhanced (CAKE) monitoring with Khulnasoft

Monitors statistics produced by the CAKE qdisc.

Following charts are drawn:

1. Bandwidth
2. Packets
3. Memory

Following charts are drawn per CAKE tin:

1. Bandwidth
2. Packets
3. Delay
4. Flows
5. Way

## Configuration

Edit the `python.d/cake.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](https://learn.khulnasoft.cloud/docs/configure/nodes), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/cake.conf
```

Here is an example for 2 interfaces:

```yaml
interfaces: [lan, wan]
tc_executable: /sbin/tc
```

`tc_executable` defaults to `/sbin/tc`.

---
