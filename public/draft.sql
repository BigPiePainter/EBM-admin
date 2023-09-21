CREATE TABLE `users` (
   `uid` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
   `gender` tinyint DEFAULT NULL COMMENT '性别',
   `contact` varchar(1000) DEFAULT NULL COMMENT '联系方式',
   `permission` varchar(5000) DEFAULT NULL COMMENT '权限json',
   `department` bigint DEFAULT NULL COMMENT '事业部',
   `salary` decimal(15,5) DEFAULT NULL COMMENT '薪水',
   `username` varchar(100) NOT NULL COMMENT '登陆用户名',
   `password` varchar(100) NOT NULL COMMENT '登陆密码',
   `onboarding_time` date NOT NULL COMMENT '入职时间',
   `nick` varchar(100) DEFAULT NULL COMMENT '昵称/姓名',
   `note` varchar(5000) DEFAULT NULL COMMENT '备注',
   `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
   `deprecated` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否弃用',
   PRIMARY KEY (`uid`)
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户'

CREATE TABLE `departments` (
   `uid` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
   `name` varchar(100) NOT NULL COMMENT '部门名称',
   `admin` varchar(5000) DEFAULT NULL COMMENT '管理员id(多个)',
   `note` varchar(5000) DEFAULT NULL COMMENT '备注',
   `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
   `deprecated` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否弃用',
   PRIMARY KEY (`uid`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门'