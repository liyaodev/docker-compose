#!/bin/bash

sleep 5

MONGO_URL=mongo:27017
until curl http://${MONGO_URL}/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  sleep 1
done

mongo --host ${MONGO_URL} <<EOF
var cfg = {
    "_id": "rs0",
    "protocolVersion": 1,
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": "${MONGO_URL}",
            "priority": 2
        }
    ]}
};
rs.initiate(cfg);
rs.status();
EOF

sleep 1

mongo --host ${MONGO_URL} <<EOF
use admin;
db.createUser({user: "admin123", pwd: "admin123", roles: [{ role: "root", db: "admin" }]});
use demo;
db.demo_00.insert({"_id": NumberInt(1), "tag_time": NumberInt(1648197087)})
EOF
