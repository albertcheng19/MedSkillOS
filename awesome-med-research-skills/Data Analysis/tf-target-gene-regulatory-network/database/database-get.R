

library(dorothea)
dir.create("database", showWarnings = FALSE)

# 保存人类数据库
data(dorothea_hs, package = "dorothea")
saveRDS(dorothea_hs, "database/dorothea_hs.rds") 

# 保存小鼠数据库
data(dorothea_mm, package = "dorothea")
saveRDS(dorothea_mm, "database/dorothea_mm.rds")
