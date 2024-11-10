#!/bin/sh

# Runs the OTel collector after generating the config.yaml based on the
# presence of environment variables.
#
# Always expects a node-metrics.yaml file to generate prometheus metrics.
# If LOKI_URL and LOKI_USER are defined, appends journal-loki.yaml to the
# node-metrics config file. See append_config.sh for details on how the config
# files are meshed together to generate config.yaml.

echo "Starting run_from_env.sh"

if [ ! -f node-metrics.yaml ]; then
    echo "Can't generate config; node-metrics.yaml not found"
    exit 1
fi

# If Loki env vars not defined, must use a stub configuration to effectively
# disable the journald receiver and its pipeline to Loki. Otherwise, otelcol
# fails startup with the message:
#    Error: failed to register process metrics: process does not exist
if [ -n "${LOKI_URL}" ] && [ -n "${LOKI_USER}" ]; then
    loki_config="journald-loki.yaml"
else
    loki_config="journald_stub-loki.yaml"
fi
if [ ! -f "${loki_config}" ]; then
    echo "Can't generate config; ${loki_config} not found"
    exit 1
fi
echo "Generating config.yaml"
./append_config.sh node-metrics.yaml ${loki_config} config.yaml

if [ ! -f config.yaml ]; then
    echo "Can't run; config.yaml not found"
    exit 1
fi
echo "config.yaml contents:"
cat config.yaml

echo "Starting otelcol"
./otelcol --config config.yaml

