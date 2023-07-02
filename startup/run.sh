#/bin/ash

# Substitute environment variable values into configuration file. Use tab (0x09)
# as sed delimiter since it likely won't appear in an environment variable.
TAB=$'\t'

cp config-template.yaml config.yaml
sed "s${TAB}\${HOSTNAME}${TAB}${HOSTNAME}${TAB}g" config.yaml > config-tmp.yaml
mv config-tmp.yaml config.yaml
sed "s${TAB}\${PROMETHEUS_USER}${TAB}${PROMETHEUS_USER}${TAB}g" config.yaml > config-tmp.yaml
mv config-tmp.yaml config.yaml
sed "s${TAB}\${PROMETHEUS_PASSWORD}${TAB}${PROMETHEUS_PASSWORD}${TAB}g" config.yaml > config-tmp.yaml
mv config-tmp.yaml config.yaml
sed "s${TAB}\${PROMETHEUS_URL}${TAB}${PROMETHEUS_URL}${TAB}g" config.yaml > config-tmp.yaml
mv config-tmp.yaml config.yaml

./otelcol --config config.yaml
