# Redis monitoring with Khulnasoft

Monitors database status. It reads server response to `INFO` command.

Following charts are drawn:

1. **Operations** per second

    - operations

2. **Hit rate** in percent

    - rate

3. **Memory utilization** in kilobytes

    - total
    - lua

4. **Database keys**

    - lines are creates dynamically based on how many databases are there

5. **Clients**

    - connected
    - blocked

6. **Slaves**

    - connected

## Configuration

Edit the `python.d/redis.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](https://learn.khulnasoft.com/docs/configure/nodes), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/redis.conf
```

```yaml
socket:
  name: 'local'
  socket: '/var/lib/redis/redis.sock'

localhost:
  name: 'local'
  host: 'localhost'
  port: 6379
```

When no configuration file is found, module tries to connect to TCP/IP socket: `localhost:6379`.

---


