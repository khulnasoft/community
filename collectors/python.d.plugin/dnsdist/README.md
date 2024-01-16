# PowerDNS dnsdist monitoring with Khulnasoft

Collects load-balancer performance and health metrics, and draws the following charts:

1. **Response latency**

    - latency-slow
    - latency100-1000
    - latency50-100
    - latency10-50
    - latency1-10
    - latency0-1

2. **Cache performance**

    - cache-hits
    - cache-misses

3. **ACL events**

    - acl-drops
    - rule-drop
    - rule-nxdomain
    - rule-refused

4. **Noncompliant data**

    - empty-queries
    - no-policy
    - noncompliant-queries
    - noncompliant-responses

5. **Queries**

    - queries
    - rdqueries
    - rdqueries

6. **Health**

    - downstream-send-errors
    - downstream-timeouts
    - servfail-responses
    - trunc-failures

## Configuration

Edit the `python.d/dnsdist.conf` configuration file using `edit-config` from the Khulnasoft [config
directory](https://learn.khulnasoft.com/docs/configure/nodes), which is typically at `/etc/khulnasoft`.

```bash
cd /etc/khulnasoft   # Replace this path with your Khulnasoft config directory, if different
sudo ./edit-config python.d/dnsdist.conf
```

```yaml
localhost:
  name: 'local'
  url: 'http://127.0.0.1:5053/jsonstat?command=stats'
  user: 'username'
  pass: 'password'
  header:
    X-API-Key: 'dnsdist-api-key'
```


