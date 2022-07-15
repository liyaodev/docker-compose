#!/bin/bash

# ## Composer project name instead of git main folder name
# export COMPOSE_PROJECT_NAME=mongodb

# ## Generate global auth key between cluster nodes
# openssl rand -base64 756 > mongodb.key
# chmod 600 mongodb.key

sleep 5

CONFIG01_URL=config01:27017
SHARD01A_URL=shard01a:27017
SHARD02A_URL=shard02a:27017
SHARD03A_URL=shard03a:27017
MONGOS01_URL=mongos01:27017
MONGOS02_URL=mongos02:27017

echo "Waiting for startup..."
until curl http://${CONFIG01_URL}/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  sleep 1
done

mongo --host ${CONFIG01_URL} < /scripts/init-configserver.js

mongo --host ${SHARD01A_URL} < /scripts/init-shard01.js
mongo --host ${SHARD02A_URL} < /scripts/init-shard02.js
mongo --host ${SHARD03A_URL} < /scripts/init-shard03.js

sleep 30

mongo --host ${MONGOS01_URL} < /scripts/init-mongos.js
mongo --host ${MONGOS02_URL} < /scripts/init-mongos.js

sleep 2

mongo --host ${MONGOS01_URL} < /scripts/init-auth.js
mongo --host ${MONGOS01_URL} < /scripts/init-data.js
