#!/bin/bash

source $(dirname "$0")/../render-utils.sh


start_test "allinone"
export QUERY_BASE_PATH=""
export GET_URL_COMMAND
export URL
export JAEGER_NAME="all-in-one-ui"

# The URL is decided when the tests starts. So, the YAML file for the job is
# rendered after the test started
if [ $IS_OPENSHIFT = true ]; then
    GET_URL_COMMAND="kubectl get routes -o=jsonpath='{.items[0].status.ingress[0].host}' -n \$NAMESPACE"
    URL="https://\$($GET_URL_COMMAND)/search"
else
    GET_URL_COMMAND="echo http://localhost"
    URL="http://localhost/search"
fi

$GOMPLATE -f $TEMPLATES_DIR/ensure-ingress-host.sh.template -o ./ensure-ingress-host.sh
# Sometimes, the Ingress/OpenShift route is there but not 100% ready so, when
# kubectl tries to get the hostname, it returns an empty string
chmod +x ./ensure-ingress-host.sh

# Check we can access the deployment
EXPECTED_CODE="200" $GOMPLATE -f $TEMPLATES_DIR/assert-http-code.yaml.template -o ./01-curl.yaml
