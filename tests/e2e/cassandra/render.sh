#!/bin/bash

source $(dirname "$0")/../render-utils.sh

cd $SUITE_DIR

echo "Rendering templates for cassandra-smoke test"
cd cassandra-smoke
export CASSANDRA_INSTANCE_NAME=with-cassandra
$GOMPLATE -f $TEMPLATES_DIR/cassandra-install.yaml.template -o ./00-install.yaml
$GOMPLATE -f $TEMPLATES_DIR/cassandra-assert.yaml.template -o ./00-assert.yaml
$GOMPLATE -f $TEMPLATES_DIR/cassandra-jaeger-install.yaml.template -o ./01-install.yaml
$GOMPLATE -f $TEMPLATES_DIR/cassandra-jaeger-assert.yaml.template -o ./01-assert.yaml

cd ../

echo "Rendering templates for cassandra-spark test"
cd cassandra-spark
export CASSANDRA_INSTANCE_NAME=test-spark-deps
export DEP_SCHEDULE=true
export CASSANDRA_MODE=prod
$GOMPLATE -f $TEMPLATES_DIR/cassandra-install.yaml.template -o ./00-install.yaml
$GOMPLATE -f $TEMPLATES_DIR/cassandra-assert.yaml.template -o ./00-assert.yaml
$GOMPLATE -f $TEMPLATES_DIR/cassandra-jaeger-install.yaml.template -o ./01-install.yaml
