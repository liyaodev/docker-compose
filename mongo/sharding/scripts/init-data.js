demo = db.getSiblingDB("demo")
sh.enableSharding("demo")
// demo.demo_00.createIndex({"id": "hashed"}, {"background": true})
// sh.shardCollection('demo.demo_00', {"id": 1})
sh.shardCollection('demo.demo_00', {"_id": 1})
demo.demo_00.insert({"_id": NumberInt(1), "tag_time": NumberInt(1648197087)})
