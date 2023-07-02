OpenTelemetry [Collector](https://opentelemetry.io/docs/collector/) for device monitoring to a Prometheus backend, packaged as a [balenaBlock](https://docs.balena.io/learn/develop/blocks/#using-your-block-in-other-projects) per architecture ([aarch64](https://hub.balena.io/blocks/2059722/grafana-agent-aarch64), [amd64](https://hub.balena.io/blocks/2059725/grafana-agent-amd64), [armv7hf](https://hub.balena.io/blocks/2059724/grafana-agent-armv7hf)).

## Getting Started
There are two parts to getting started: setting up the Prometheus backend integration, and configuring the agent for your fleet.

For Prometheus it's easy to create a free account at [Grafana Cloud](https://grafana.com/products/cloud/). Note the *team* name created for you is used in the URL for your Grafana account, like `https://grafana.com/orgs/{team}`, and in the URL for your cloud dashboards, like `https://{team}.grafana.net` .

After registering, install the Linux Server integration ([instructions](https://grafana.com/docs/grafana-cloud/data-configuration/get-started-integration/)) for your cloud, which will create pre-configured dashboards based on Prometheus. On the setup page, *don't* install the agent. Instead, at the bottom of the page, select *Install* in the section *Install Dashboards and Alerts* ([screenshot](docs/install-linux-integration.png)). Then you can view your dashboards although they are not receiving data yet.

Next, create a fleet for your devices in the balenaCloud dashboard. Set fleet [variables](https://docs.balena.io/learn/manage/variables/#fleet-wide-variables) for the Prometheus username, password, and remote write URL using the values from your Grafana Cloud Prometheus service page ([screenshot](docs/prometheus-config.png)). The service page is available from your Grafana account site (`grafana.com/orgs/{team}`), not the cloud dashboard.

| Variable | Prometheus service page reference |
| -------- | --------------------------------- |
| PROMETHEUS_URL | Remote Write Endpoint |
| PROMETHEUS_USER | Username / Instance ID |
| PROMETHEUS_PASSWORD | An API key you must create |

Finally, create *otel-collector* and *node-exporter* service entries in your docker-compose that references the block, like [this example](https://github.com/balena-io-experimental/grafana-agent-block/blob/master/docs/example), and [push](https://docs.balena.io/learn/deploy/deployment/#balena-push) that service composition to your fleet.

With this setup in place, you should see devices in your fleet also appear in the Grafana Cloud fleet overview dashboard, like below.

![Example overview](docs/fleet-overview.png)