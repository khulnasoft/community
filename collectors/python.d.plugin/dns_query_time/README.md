# DNS query RTT monitoring with Khulnasoft

Measures DNS query round trip time.

**Requirement:**

- `python-dnspython` package

It produces one aggregate chart or one chart per DNS server, showing the query time.

## Configuration

Edit the `python.d/dns_query_time.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](https://learn.khulnasoft.cloud/docs/configure/nodes), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/dns_query_time.conf
```

---


