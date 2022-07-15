## MongoDB and Docker Compose

### 准备

我们也使用`mongo:5.0`版本镜像，分别搭建单节点、副本集和分片集群的`MongoDB`环境。首先进行基础镜像的拉取，具体如下：

```shell
docker pull mongo:5.0
```

### 单节点(Standalone)

**启动服务**

```shell
docker-compose -f docker-compose.yml up
```

**版本验证**

```shell
docker exec -it builder-mongo /bin/bash -c "/usr/bin/mongo --version"

# 输出
MongoDB shell version v5.0.9
Build Info: {...}
```

**登录验证**

```shell
docker exec -it builder-mongo /bin/bash -c "/usr/bin/mongo -u admin123 -p admin123"
```

### 副本集(ReplicaSet)

**启动服务**

```shell
docker-compose -f docker-compose.yml up
```

**版本验证**

```shell
docker exec -it builder-mongo1 /bin/bash -c "/usr/bin/mongo --version"
docker exec -it builder-mongo2 /bin/bash -c "/usr/bin/mongo --version"
docker exec -it builder-mongo3 /bin/bash -c "/usr/bin/mongo --version"

# 输出
MongoDB shell version v5.0.9
Build Info: {...}
```

**配置验证**

```shell
# 打开命令行终端
docker exec -it builder-mongo1 /bin/bash -c "/usr/bin/mongo"
# 输入查看命令
rs.status()

# 输出
{
	"set" : "rs0",
	...
	"votingMembersCount" : 3,
	"writableVotingMembersCount" : 3,
	...
	},
	"members" : [
		{
			"_id" : 0,
			"name" : "mongo1:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			...
		},
		{
			"_id" : 1,
			"name" : "mongo2:27017",
			...
			"stateStr" : "SECONDARY",
			...
		},
		{
			"_id" : 2,
			"name" : "mongo3:27017",
			...
			"stateStr" : "SECONDARY",
			...
		}
	],
	"ok" : 1,
	...
}
```

### 分片集群(Sharding)

**启动服务**

```shell
docker-compose -f docker-compose.yml up
```

**版本验证**

```shell
docker exec -it builder-mongos01 /bin/bash -c "/usr/bin/mongo --version"

# 输出
MongoDB shell version v5.0.9
Build Info: {...}
```

**分片服务节点验证**

```shell
# 打开命令行终端
docker exec -it builder-mongo-shard01a /bin/bash -c "/usr/bin/mongo"
# 输入查看命令
rs.status()

# 输出
{
	"set" : "shard01",
	...
	"votingMembersCount" : 2,
	"writableVotingMembersCount" : 2,
	...
	"members" : [
		{
			"_id" : 0,
			"name" : "shard01a:27017",
			...
			"stateStr" : "PRIMARY",
			...
		},
		{
			"_id" : 1,
			"name" : "shard01b:27017",
			...
			"stateStr" : "SECONDARY",
			...
		}
	],
	"ok" : 1,
	...
}
```

**配置服务节点验证**

```shell
# 打开命令行终端
docker exec -it builder-mongo-config01 /bin/bash -c "/usr/bin/mongo"
# 输入查看命令
rs.status()

# 输出
{
	"set" : "configserver",
	...
	"votingMembersCount" : 3,
	"writableVotingMembersCount" : 3,
	...
	"members" : [
		{
			"_id" : 0,
			"name" : "config01:27017",
			...
			"stateStr" : "PRIMARY",
			...
		},
		{
			"_id" : 1,
			"name" : "config02:27017",
			...
			"stateStr" : "SECONDARY",
			...
		},
		{
			"_id" : 2,
			"name" : "config03:27017",
			...
			"stateStr" : "SECONDARY",
			...
		}
	],
	"ok" : 1,
	...
}
```

**路由服务节点验证**

```shell
# 打开命令行终端
 docker exec -it builder-mongos01 /bin/bash -c "/usr/bin/mongo"
# 输入查看命令
sh.status()

# 输出
--- Sharding Status ---
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("62d02bf4425fcf75043ba4b3")
  }
  shards:
        {  "_id" : "shard01",  "host" : "shard01/shard01a:27017,shard01b:27017",  "state" : 1,  "topologyTime" : Timestamp(1657809932, 1) }
        {  "_id" : "shard02",  "host" : "shard02/shard02a:27017,shard02b:27017",  "state" : 1,  "topologyTime" : Timestamp(1657809935, 1) }
        {  "_id" : "shard03",  "host" : "shard03/shard03a:27017,shard03b:27017",  "state" : 1,  "topologyTime" : Timestamp(1657809938, 1) }
  active mongoses:
        "5.0.9" : 2
  ...
```

**查看分片信息**

```shell
# 登录路由节点
docker exec -it builder-mongos01 /bin/bash -c "/usr/bin/mongo"

# 输入查看命令
use demo
db.demo_00.stats()
# 输出
{
	"sharded" : true,
	"capped" : false,
	...
}
```
