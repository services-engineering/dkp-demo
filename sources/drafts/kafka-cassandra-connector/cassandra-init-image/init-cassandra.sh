#!/bin/bash

cassandra_instance="cassandra-svc.default.svc.cluster.local"

sleep 1

cqlsh ${cassandra_instance} --execute "CREATE KEYSPACE trucks WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};" || echo "Keyspace exists"

sleep 1

cqlsh ${cassandra_instance} --execute "USE trucks; CREATE TABLE coordinates (uid int PRIMARY KEY, x decimal, y decimal);" || echo "Table exists"
