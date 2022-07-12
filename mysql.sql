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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='系统用户';

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



-- 用户
drop table if exists users;
CREATE TABLE users (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  creator_id bigint NOT NULL COMMENT '用户创建人',

  permission bigint NOT NULL COMMENT '权限',

  username varchar(100) NOT NULL COMMENT '用户名',
  password varchar(100) NOT NULL COMMENT '密码',

  primary key (uid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='系统用户';



-- 测试数据
insert into users(uid, creator_id, permission, username, password) values(0, 0, 1048575, 'admin', '88888888');
insert into users(creator_id, permission, username, password) values(0, 1048575, 'zqy', '123456');
insert into users(creator_id, permission, username, password) values(0, 1048575, '556', '654321');



-- 商品信息
drop table if exists products;
CREATE TABLE products (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',

  owner_id bigint COMMENT '持品人'

  id varchar(200) NOT NULL COMMENT '商品ID'
  department varchar(200) COMMENT '事业部'
  group varchar(200) COMMENT '组别'
  
  shop_name varchar(200) COMMENT '店铺名'

  first_category varchar(200) COMMENT '一级类目'

  product_name varchar(200) COMMENT '产品名'
  product_deduction varchar(200) COMMENT '品类扣点'
  product_freight varchar(200) COMMENT '每单运费'
  product_insurance varchar(200) COMMENT '品类运费险'
  
  varchar(200) COMMENT '子/主订单附带比'
  varchar(200) COMMENT '运费/总货款'
  varchar(200) COMMENT '发货方式'
  varchar(200) COMMENT '聚水潭仓库'

  manufacturer_name varchar(200) COMMENT '厂家名'
  manufacturer_group varchar(200) COMMENT '厂家群名'
  manufacturer_payment varchar(200) COMMENT '厂家收款账户'
  manufacturer_payment_id varchar(200) COMMENT '厂家收款账户号码'
  manufacturer_recipient varchar(200) COMMENT '厂家退货-收件人'
  manufacturer_phone varchar(200) COMMENT '厂家退货-收件手机号'
  manufacturer_address varchar(200) COMMENT '厂家退货-收件地址'

  primary key (uid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='商品信息';


-- SKU
drop table if exists sku;
CREATE TABLE sku (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',

  product_id bigint NOT NULL COMMENT '商品id'
  sku_name varchar(200) NOT NULL COMMENT 'SKU名称'
  price varchar(200) NOT NULL COMMENT '售卖价'
  cost varchar(200) NOT NULL COMMENT '售卖成本'


  start_time varchar(200) NOT NULL COMMENT '价格开始时间'
  end_time varchar(200) COMMENT '价格截止时间'


  primary key (uid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='SKU';
