library("checkpoint")
??checkpoint
# 管理本地快照:
checkpointArchives()           # 列出设置的本地快照:"2017-03-06" "2019-02-01";
checkpointRemove("2020-07-16") # 删除"2020-07-16"快照;
getAccessDate()                # 返回最近使用的快照信息;
unCheckpoint()
.libPaths()
getOption("repo")
# 实际使用
checkpoint("2020-07-16")       # 设置快照日期;
setSnapshot("2021-04-01")      # 设置默认的CRAN包库到MRAN快照库;
getValidSnapshots()            # 获取可用的MRAN快照库;
