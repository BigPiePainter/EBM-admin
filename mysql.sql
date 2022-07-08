-- 商品信息
CREATE TABLE products (
  id varchar(100) NOT NULL COMMENT 'id',


  username varchar(50) NOT NULL COMMENT '事业部',
  password varchar(100) COMMENT '密码',
  real_name varchar(50) COMMENT '姓名',
  head_url varchar(200) COMMENT '头像',
  gender tinyint unsigned COMMENT '性别   0：男   1：女    2：保密',
  email varchar(100) COMMENT '邮箱',
  mobile varchar(100) COMMENT '手机号',
  dept_id bigint COMMENT '部门ID',
  super_admin tinyint unsigned COMMENT '超级管理员   0：否   1：是',
  status tinyint COMMENT '状态  0：停用   1：正常',
  creator bigint COMMENT '创建者',
  create_date datetime COMMENT '创建时间',
  updater bigint COMMENT '更新者',
  update_date datetime COMMENT '更新时间',
  primary key (id),
  unique key uk_username (username),
  key idx_create_date (create_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户';

department varchar(200) COMMENT '事业部'
group varchar(200) COMMENT '组别'
creator varchar(200) COMMENT '持品人/创建人'
shopname varchar(200) COMMENT '店铺名'
cpm varchar(200) COMMENT '产品名'
yjlm varchar(200) COMMENT '一级类目'
plkd varchar(200) COMMENT '品类扣点'
plyfx varchar(200) COMMENT '品类运费险'
varchar(200) COMMENT '每单运费'
varchar(200) COMMENT '子/主订单附带比'
varchar(200) COMMENT '运费/总货款'
varchar(200) COMMENT '发货方式'
varchar(200) COMMENT '聚水潭仓库'
varchar(200) COMMENT '厂家名'
varchar(200) COMMENT '厂家群名'
varchar(200) COMMENT '厂家收款账户'
varchar(200) COMMENT '厂家收款账户号码'
varchar(200) COMMENT '厂家退货-收件人'
varchar(200) COMMENT '厂家退货-收件手机号'
varchar(200) COMMENT '厂家退货-收件地址'
