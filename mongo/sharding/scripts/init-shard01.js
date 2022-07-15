rs.initiate(
   {
      _id: "shard01",
      version: 1,
      members: [
         { _id: 0, host : "shard01a:27017", "priority": 2 },
         { _id: 1, host : "shard01b:27017", "priority": 0 },
      ]
   }
)
