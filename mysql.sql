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
  department BIGINT COMMENT '事业部',
  team BIGINT COMMENT '组别',
  shop_name VARCHAR(200) COMMENT '店铺名',
  first_category BIGINT COMMENT '一级类目',
  product_name VARCHAR(200) COMMENT '产品名',
  transport_way VARCHAR(200) COMMENT '发货方式',
  storehouse VARCHAR(200) COMMENT '聚水潭仓库',
  end_time DATE COMMENT '下架时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (id),
  index index_owner(owner)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品信息';


-- 商品内部归属表
drop table if exists ascriptions;

CREATE TABLE ascriptions (
  uid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  product BIGINT NOT NULL COMMENT '商品ID',
  owner BIGINT COMMENT '持品人',
  department BIGINT COMMENT '事业部',
  team BIGINT COMMENT '组别',
  start_time DATE NOT NULL COMMENT '生效时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid),
  index index_product(product)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品内部归属表';


-- sku表
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
  freight DECIMAL(15, 5) COMMENT '每单运费',
  extra_ratio DECIMAL(15, 5) COMMENT '子/主订单附带比',
  freight_to_payment DECIMAL(15, 5) COMMENT '运费/总货款',
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
  admin VARCHAR(5000) COMMENT '管理员id(多个)',
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
  admin VARCHAR(5000) COMMENT '管理员id(多个)',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '组别';

-- 一级类目表
drop table if exists categorys;

CREATE TABLE categorys (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  name VARCHAR(100) NOT NULL COMMENT '一级类目名称',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '一级类目';

-- 一级类目历史表
drop table if exists categoryhistorys;

CREATE TABLE categoryhistorys (
  uid BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id',
  category_id BIGINT NOT NULL COMMENT '对应一级类目',
  deduction DECIMAL(15, 5) COMMENT '品类扣点',
  insurance DECIMAL(15, 5) COMMENT '品类运费险',
  start_time DATE NOT NULL COMMENT '生效时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '一级类目历史';



--订单数据库-临时
drop table if exists refunds;

CREATE TABLE refunds (
  uid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '退款单编号',
  order_id BIGINT UNSIGNED NOT NULL COMMENT '订单编号',
  product_id BIGINT UNSIGNED NOT NULL COMMENT '商品ID',
  note VARCHAR(50) NOT NULL COMMENT '退款类型',
  order_payment_time timestamp NOT NULL COMMENT '订单付款时间',
  order_setup_time timestamp NOT NULL COMMENT '订单创建时间',
  title VARCHAR(1000) NOT NULL COMMENT '宝贝标题',
  transaction_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '交易金额',
  refund_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '买家退款金额',
  logistic_status VARCHAR(50) NOT NULL COMMENT '发货状态',
  logistic_info VARCHAR(1000) COMMENT '发货物流信息',
  item_return VARCHAR(10) NOT NULL COMMENT '是否需要退货',
  refund_setup_time timestamp NOT NULL COMMENT '退款申请时间',
  refund_status VARCHAR(50) NOT NULL COMMENT '退款状态',
  customer_service_status VARCHAR(50) COMMENT '客服介入状态',
  seller_address VARCHAR(1000) COMMENT '卖家退货地址',
  express_number VARCHAR(1000) COMMENT '退货物流单号',
  express_company VARCHAR(100) COMMENT '退货物流公司',
  reason VARCHAR(100) COMMENT '买家退款原因',
  end_time timestamp COMMENT '完结时间',
  operator VARCHAR(100) COMMENT '退款操作人',
  seller_note VARCHAR(5000) COMMENT '卖家备注',
  shop_name VARCHAR(100) COMMENT '店铺',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单';



--退单/退款申请数据库-临时
drop table if exists refunds;

CREATE TABLE refunds (
  uid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '退款单编号',
  order_id BIGINT UNSIGNED NOT NULL COMMENT '订单编号',
  product_id BIGINT UNSIGNED NOT NULL COMMENT '商品ID',
  note VARCHAR(50) NOT NULL COMMENT '退款类型',
  order_payment_time timestamp NOT NULL COMMENT '订单付款时间',
  order_setup_time timestamp NOT NULL COMMENT '订单创建时间',
  title VARCHAR(1000) NOT NULL COMMENT '宝贝标题',
  transaction_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '交易金额',
  refund_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '买家退款金额',
  logistic_status VARCHAR(50) NOT NULL COMMENT '发货状态',
  logistic_info VARCHAR(1000) COMMENT '发货物流信息',
  item_return VARCHAR(10) NOT NULL COMMENT '是否需要退货',
  refund_setup_time timestamp NOT NULL COMMENT '退款申请时间',
  refund_status VARCHAR(50) NOT NULL COMMENT '退款状态',
  customer_service_status VARCHAR(50) COMMENT '客服介入状态',
  seller_address VARCHAR(1000) COMMENT '卖家退货地址',
  express_number VARCHAR(1000) COMMENT '退货物流单号',
  express_company VARCHAR(100) COMMENT '退货物流公司',
  reason VARCHAR(100) COMMENT '买家退款原因',
  end_time timestamp COMMENT '完结时间',
  operator VARCHAR(100) COMMENT '退款操作人',
  seller_note VARCHAR(5000) COMMENT '卖家备注',
  shop_name VARCHAR(100) COMMENT '店铺',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '退单/退款申请';




--订单表/数据汇总表
drop table if exists daily_reports;
CREATE TABLE daily_reports (
  DATE NOT NULL COMMENT '生效时间',

  uid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '退款单编号',
  
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '退单/退款申请';