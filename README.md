## docker-compose

个人 docker-compose 配置仓库

## 仓库索引

| 名称 | 功能 | 备注 |
| :--- | :--- | :--- |
| [etcd](./etcd) | Go 语言编写的分布式、高可用的一致性键值存储系统，用于提供可靠的分布式键值(key-value)存储、配置共享和服务发现等功能 |      |
| [mongo](./mongo) | 基于分布式文件存储的数据库。 由C++ 语言编写。 旨在为WEB 应用提供可扩展的高性能数据存储解决方案。 MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的库 |      |
| [mysql](./mysql) | 最流行的关系型数据库管理系统，在 WEB 应用方面 MySQL 是最好的RDBMS(Relational Database Management System：关系数据库管理系统)应用软件之一 |      |
| [rabbitmq](./rabbitmq) | 实现了高级消息队列协议（AMQP）的开源消息代理软件（亦称面向消息的中间件）。RabbitMQ服务器是用Erlang语言编写的 |      |


## docker-compose 常用命令

构建并启动容器组

```shell
docker-compose up
docker-compose up -d                # 后台执行
docker-compose up --force-recreate  # 强制新建
```

操作容器组

```shell
docker-compose start    # 启动
docker-compose stop     # 停止
docker-compose down     # 删除
```

运维容器组

```shell
docker-compose ps       # 查询容器状态
```

## docker 常用命令

构建镜像

```shell
docker build -t <name:tag> .
docker build -f <dockerfile> -t <name:tag> .    # 构建指定dockerfile
```

操作镜像

```shell
docker pull <name:tag>                          # 拉取镜像
docker push <name:tag>                          # 推送镜像
docker run -it -p 80:80 --rm <name:tag>         # 运行镜像
```

运维镜像

```shell
docker ps       # 查询Pod运行状态
docker images   # 查询本地镜像
```
