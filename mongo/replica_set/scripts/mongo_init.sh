#!/bin/bash

sleep 5

MONGO1_URL=mongo1:27017
MONGO2_URL=mongo2:27017
MONGO3_URL=mongo3:27017

echo "Waiting for startup..."
until curl http://${MONGO1_URL}/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  sleep 1
done

mongo --host ${MONGO1_URL} <<EOF
var cfg = {
    "_id": "rs0",
    "protocolVersion": 1,
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": "${MONGO1_URL}",
            "priority": 2
        },
        {
            "_id": 1,
            "host": "${MONGO2_URL}",
            "priority": 0
        },
        {
            "_id": 2,
            "host": "${MONGO3_URL}",
            "priority": 0
        }
    ]}
};
rs.initiate(cfg);
rs.status();
EOF

sleep 30    # 延迟 30s, 保证集群启动完成再创建用户

mongo --host ${MONGO1_URL} <<EOF
use admin;
db.createUser({user: "admin123", pwd: "admin123", roles: [{ role: "root", db: "admin" }]});
use demo;
db.demo_00.insert({"_id": NumberInt(1), "tag_time": NumberInt(1648197087)})
EOF
