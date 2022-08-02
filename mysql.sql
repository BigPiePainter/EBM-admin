-- 数据库的索引目前还不完善
-- 用户
drop table if exists users;

CREATE TABLE users (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  creator_id BIGINT NOT NULL COMMENT '用户创建人',
  gender TINYINT(1) COMMENT '性别',
  contact VARCHAR(1000) COMMENT '联系方式',
  permission VARCHAR(5000) COMMENT '权限json',
  username VARCHAR(100) NOT NULL COMMENT '用户名',
  password VARCHAR(100) NOT NULL COMMENT '密码',
  nick VARCHAR(100) COMMENT '昵称/姓名',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '系统用户';

-- 唯一账号数据
insert into
  users(
    uid,
    creator_id,
    permission,
    username,
    password,
    nick
  )
values
  (1, 0, '{}', 'admin', '88888888', "admin");

-- 商品信息
drop table if exists products;

CREATE TABLE products (
  id BIGINT NOT NULL COMMENT '商品ID',
  owner BIGINT COMMENT '持品人',
  department VARCHAR(200) COMMENT '事业部',
  group_name VARCHAR(200) COMMENT '组别',
  shop_name VARCHAR(200) COMMENT '店铺名',
  first_category VARCHAR(200) COMMENT '一级类目',
  product_name VARCHAR(200) COMMENT '产品名',
  product_deduction DECIMAL(15, 5) COMMENT '品类扣点',
  product_freight DECIMAL(15, 5) COMMENT '每单运费',
  product_insurance DECIMAL(15, 5) COMMENT '品类运费险',
  extra_ratio DECIMAL(15, 5) COMMENT '子/主订单附带比',
  freight_to_payment DECIMAL(15, 5) COMMENT '运费/总货款',
  transport_way VARCHAR(200) COMMENT '发货方式',
  storehouse VARCHAR(200) COMMENT '聚水潭仓库',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (id),
  index index_owner(owner)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品信息';

drop table if exists skus;

CREATE TABLE skus (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  product_id BIGINT NOT NULL COMMENT '商品id',
  sku_id BIGINT NOT NULL COMMENT 'id',
  sku_name VARCHAR(1000) NOT NULL COMMENT 'SKU名称',
  sku_price DECIMAL(15, 5) NOT NULL COMMENT '售卖价',
  sku_cost DECIMAL(15, 5) NOT NULL COMMENT '售卖成本',
  start_time DATE NOT NULL COMMENT '生效时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid),
  index index_product_id(product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'SKU';

-- 厂家信息
drop table if exists manufacturers;

CREATE TABLE manufacturers (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  product_id BIGINT NOT NULL COMMENT '商品id',
  manufacturer_name VARCHAR(200) COMMENT '厂家名',
  manufacturer_group VARCHAR(200) COMMENT '厂家群名',
  manufacturer_payment_method VARCHAR(200) COMMENT '厂家收款账户',
  manufacturer_payment_name VARCHAR(200) COMMENT '厂家收款账户-收款人',
  manufacturer_payment_id VARCHAR(200) COMMENT '厂家收款账户号码',
  manufacturer_recipient VARCHAR(200) COMMENT '厂家退货-收件人',
  manufacturer_phone VARCHAR(200) COMMENT '厂家退货-收件手机号',
  manufacturer_address VARCHAR(200) COMMENT '厂家退货-收件地址',
  start_time DATE NOT NULL COMMENT '生效时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '厂家信息';

-- 部门表
drop table if exists departments;

CREATE TABLE departments (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  name VARCHAR(100) NOT NULL COMMENT '部门名称',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '部门';

-- 组别表
drop table if exists teams;

CREATE TABLE teams (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  name VARCHAR(100) NOT NULL COMMENT '组别名称',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '组别';