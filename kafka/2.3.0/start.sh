#!/usr/bin/env bash

wait_for_port() {
    while ! ncat -z localhost $1 ; do sleep 1 ; done
}

echo "starting zookeeper server in the background"
sh /opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties

echo "waiting for zookeeper to start up"
wait_for_port 2181

echo "starting kafka server"
sh /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
