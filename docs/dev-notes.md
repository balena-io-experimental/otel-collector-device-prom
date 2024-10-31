This document includes notes on how to develop for OpenTelemetry and the collector image.

# Building the Collector
The dockerfile to build collector is based on the [instructions](https://opentelemetry.io/docs/collector/custom-collector/) from OpenTelemetry.

# Debugging
It's helpful to see logging output for the Prometheus exporter to confirm the data being sent. This can be accomplished with the debug exporter, which we have included in the collector. See comments in the exporters and service section of `startup/config.yaml` to enable the debug exporter.

Presently you must generate a custom otel-collector-device-prom image to enable debugging. However, we also can develop a wrapper script that is the actual entry point to the image, which then could customize `config.yaml` to enable the debug exporter.