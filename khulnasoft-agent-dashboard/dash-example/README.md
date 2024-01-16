# Dash (Multi-Host Dashboard)

`dash-example.html` is a single file, all-in-one page that automatically fetches graphs from all your hosts. Just add your graphs and charts (or use the defaults) one time using the `dash-*` syntax, and your selections will be automatically replicated for all of your hosts; showing alarms and graphs for all your hosts on **one page!**

For example, below shows a parent node called "devml-master" with multiple children streaming to it ("devml", "devml1", "devml2" etc.).

![dash screenshot](https://user-images.githubusercontent.com/2178292/147828981-8a471305-efc0-4ad3-ad01-d2b7a02491b3.png)

> IMPORTANT: Dash will only work if you have implemented [khulnasoft streaming](https://learn.khulnasoft.com/docs/agent/streaming) using `stream.conf`. It is not part of Khulnasoft Cloud.

`dash-example.html` was created as an experiment to demonstrate the capabilities of khulnasoft in a multi-host environment. If you desire more features, submit a pull request or check out [Khulnasoft Cloud!](https://www.khulnasoft.com/cloud/)

## Configure Dash

First, copy the `dash-example.html` file to a location in your khulnasoft web directory or to any other webserver. For instance, with a webroot at `/usr/share/khulnasoft/web`:
```bash
cp /tmp/dash-example.html /usr/share/khulnasoft/web/dash.html
```

Ensure the owner/permissions match those in the rest of the files in the directory. For the khulnasoft web directory, this is usually `khulnasoft:khulnasoft` and `0644`. So for example:
```bash
sudo chown khulnasoft:khulnasoft /usr/share/khulnasoft/web/dash.html
sudo chmod 644 /usr/share/khulnasoft/web/dash.html
```



Find and change the following lines in your new `dash.html` to reflect your Khulnasoft URLs. The `REVERSE_PROXY_URL` is optional and only used if you access your Khulnasoft dashboard through a reverse proxy. If it is not set, it defaults to the `KHULNASOFT_HOST` URL, which should be set to the IP/FQDN of the parent instance.

```js
/**
 * Khulnasoft URLS. If you use a reverse proxy, add it and uncomment the line below. 
 * KHULNASOFT_HOST should be the IP or FQDN for your parent khulnasoft instance
 */
KHULNASOFT_HOST = 'https://my.khulnasoft.server:19999';
// REVERSE_PROXY_URL = 'https://my-domain.com/stats'
```

To change the sizes of graphs and charts, find the `DASH_OPTIONS` object in `dash.html` and set your preferences:
```js
/*
 * Change your graph/chart dimensions here. Host columns will automatically adjust.  
 * Charts are square! Their width is the same as their height.
 */
DASH_OPTIONS = {
    graph_width: '40em',
    graph_height: '20em',
    chart_width: '10em' // Charts are square
}
```

See the `CONFIGURATION` section at the top of `dash.html` for more options.

Once this is done you should be able to see the new custom dashboard on your parent instance at `https://my.khulnasoft.server:19999/dash.html` (restart khulnasoft using `sudo systemctl restart khulnasoft` if needed).

To change the display order of your hosts, which is saved in localStorage, click the settings gear in the lower right corner


## The `dash-*` Syntax

If you want to change the graphs or styling to fit your needs, just add an element to the page as shown. Child divs will be generated to create your graph/chart, and charts are replicated for each streamed host.
```
<div class="dash-graph"                     <----     Use class dash-graph for line graphs, etc
    data-dash-khulnasoft="system.cpu"          <----     REQUIRED: Use data-dash-khulnasoft to set the data source
    data-dygraph-valuerange="[0, 100]">     <----     OPTIONAL: This overrides the default config. Any other data-* attributes will
</div>                                                          be added to the generated div, so you can set any desired options here

<div class="dash-chart"                     <----     Use class dash-chart for pie charts, etc. CHARTS ARE SQUARE
    data-dash-khulnasoft="system.io"           <----     REQUIRED: Use data-dash-khulnasoft to set the data source
    data-dimensions="in"                    <----     Use this to override or append default options
    data-title="Disk Read"                  <----     Use this to override or append default options
    data-common-units="dash.io">            <----     Use this to override or append default options
</div>
```

We hope you like it!
