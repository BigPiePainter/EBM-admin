-- 设计这个数据库时想到的一些规范:
-- 
-- 原始表名全小写无下划线, 最后一个单词用复数
-- pk只有id和uid, 自增用uid, 不自增用id
-- 不用任何外键约束
-- z_开头代表分表, 用下划线加纯数字日期风格: z_order_20220101
-- 原始表的衍生表用下划线代表衍生类型：refundorders_setup
-- 衍生表和分表结合：z_refundorders_setup_202201
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
  sku_name VARCHAR(100) NOT NULL COMMENT 'SKU名称',
  sku_price DECIMAL(15, 5) NOT NULL COMMENT '售卖价',
  sku_cost DECIMAL(15, 5) NOT NULL COMMENT '售卖成本',
  start_time DATE NOT NULL COMMENT '生效时间',
  note VARCHAR(5000) COMMENT '备注',
  create_time timestamp NOT NULL DEFAULT NOW() COMMENT '创建时间',
  modify_time timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '修改时间',
  deprecated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否弃用',
  primary key (uid),
  index index_product_id(product_id),
  index index_sku_name(sku_name)
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

-- 订单数据库
drop table if exists orders;

CREATE TABLE orders (
  id BIGINT UNSIGNED NOT NULL COMMENT '子订单编号',
  order_id BIGINT UNSIGNED NOT NULL COMMENT '主订单编号',
  payment_id VARCHAR(30) NOT NULL COMMENT '支付单号',
  amount DECIMAL(15, 5) NOT NULL COMMENT '买家应付货款',
  postage DECIMAL(15, 5) NOT NULL COMMENT '买家应付邮费',
  total_amount DECIMAL(15, 5) NOT NULL COMMENT '总金额',
  actual_total_amount DECIMAL(15, 5) NOT NULL COMMENT '买家实际支付金额',
  actual_amount DECIMAL(15, 5) NOT NULL COMMENT '子单实际支付金额',
  order_status TINYINT(4) NOT NULL COMMENT '订单状态',
  order_setup_time timestamp NOT NULL COMMENT '订单创建时间',
  order_payment_time timestamp NOT NULL COMMENT '订单付款时间',
  product_title VARCHAR(1000) NOT NULL COMMENT '宝贝标题',
  product_count BIGINT UNSIGNED NOT NULL COMMENT '宝贝数量',
  express_number VARCHAR(1000) COMMENT '物流单号',
  express_company VARCHAR(100) COMMENT '物流公司',
  shop_id BIGINT UNSIGNED NOT NULL COMMENT '店铺ID',
  shop_name VARCHAR(100) NOT NULL COMMENT '店铺名称',
  supplier_id BIGINT UNSIGNED NOT NULL COMMENT '供应商ID',
  supplier_name VARCHAR(100) NOT NULL COMMENT '供应商名称',
  storehouse_type TINYINT(4) NOT NULL COMMENT '仓发类型',
  refund_amount DECIMAL(15, 5) NOT NULL COMMENT '退款金额',
  sku_name VARCHAR(100) NOT NULL COMMENT '颜色/尺码',
  seller_code VARCHAR(100) COMMENT '商家编码',
  product_id BIGINT UNSIGNED NOT NULL COMMENT '商品编码',
  primary key (id),
  index index_order_id(order_id),
  index index_sku_name(sku_name),
  index index_product_id(product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单数据库';

-- 退单数据库
drop table if exists refundorders;

CREATE TABLE refundorders (
  id BIGINT UNSIGNED NOT NULL COMMENT '退款单编号',
  order_id BIGINT UNSIGNED NOT NULL COMMENT '订单编号',
  order_payment_time DATE NOT NULL COMMENT '订单付款时间',
  order_setup_time DATE NOT NULL COMMENT '订单创建时间',
  order_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '订单交易金额',
  refund_type TINYINT(4) NOT NULL COMMENT '退款类型',
  refund_amount DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '买家退款金额',
  refund_setup_time timestamp NOT NULL COMMENT '退款申请时间',
  refund_status TINYINT(4) NOT NULL COMMENT '退款状态',
  refund_reason VARCHAR(100) COMMENT '买家退款原因',
  refund_end_time DATE COMMENT '完结时间',
  product_id BIGINT UNSIGNED NOT NULL COMMENT '商品ID',
  product_title VARCHAR(1000) NOT NULL COMMENT '宝贝标题',
  express_status TINYINT(1) NOT NULL COMMENT '发货状态/是否发货',
  express_info VARCHAR(1000) COMMENT '发货物流信息',
  express_number VARCHAR(1000) COMMENT '退货物流单号',
  express_company VARCHAR(100) COMMENT '退货物流公司',
  need_return TINYINT(1) NOT NULL COMMENT '是否需要退货',
  customer_service_status VARCHAR(50) COMMENT '客服介入状态',
  seller_address VARCHAR(1000) COMMENT '卖家退货地址',
  operator VARCHAR(100) COMMENT '退款操作人',
  seller_note VARCHAR(5000) COMMENT '卖家备注',
  shop_name VARCHAR(100) COMMENT '店铺',
  primary key (id),
  index index_product_id(product_id),
  index index_order_id(order_id),
  index index_order_payment_time(order_payment_time),
  index index_refund_end_time(refund_end_time)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '退单数据库';

-- 刷单数据库
drop table if exists fakeorders;

CREATE TABLE fakeorders (
  id BIGINT UNSIGNED NOT NULL COMMENT '主订单编号',
  request_time DATE NOT NULL COMMENT '诉求日期',
  order_payment_time DATE COMMENT '订单付款时间',
  product_count BIGINT UNSIGNED NOT NULL COMMENT '品数/子订单数',
  brokerage DECIMAL(15, 5) UNSIGNED NOT NULL COMMENT '子订单佣金',
  team VARCHAR(50) COMMENT '团队',
  primary key (id),
  index index_order_payment_time(order_payment_time)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '刷单数据库';

-- 认领大厅库
drop table if exists mismatchproducts;

CREATE TABLE mismatchproducts (
  id BIGINT UNSIGNED NOT NULL COMMENT '商品ID',
  product_title VARCHAR(1000) NOT NULL COMMENT '宝贝标题',
  primary key (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '认领大厅库';

CREATE TABLE z_fakeorders_requested_202201 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202202 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202203 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202204 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202205 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202206 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202207 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202208 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202209 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202210 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202211 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202212 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202301 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202302 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202303 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202304 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202305 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202306 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202307 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202308 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202309 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202310 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202311 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202312 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202401 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202402 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202403 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202404 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202405 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202406 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202407 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202408 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202409 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202410 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202411 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202412 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202501 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202502 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202503 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202504 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202505 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202506 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202507 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202508 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202509 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202510 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202511 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202512 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202601 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202602 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202603 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202604 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202605 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202606 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202607 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202608 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202609 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202610 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202611 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202612 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202701 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202702 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202703 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202704 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202705 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202706 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202707 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202708 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202709 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202710 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202711 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202712 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202801 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202802 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202803 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202804 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202805 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202806 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202807 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202808 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202809 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202810 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202811 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202812 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202901 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202902 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202903 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202904 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202905 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202906 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202907 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202908 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202909 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202910 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202911 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_202912 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_203001 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_203002 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_203003 LIKE fakeorders;

CREATE TABLE z_fakeorders_requested_203004 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202201 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202202 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202203 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202204 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202205 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202206 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202207 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202208 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202209 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202210 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202211 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202212 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202301 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202302 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202303 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202304 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202305 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202306 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202307 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202308 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202309 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202310 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202311 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202312 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202401 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202402 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202403 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202404 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202405 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202406 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202407 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202408 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202409 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202410 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202411 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202412 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202501 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202502 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202503 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202504 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202505 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202506 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202507 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202508 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202509 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202510 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202511 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202512 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202601 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202602 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202603 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202604 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202605 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202606 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202607 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202608 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202609 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202610 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202611 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202612 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202701 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202702 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202703 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202704 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202705 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202706 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202707 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202708 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202709 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202710 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202711 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202712 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202801 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202802 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202803 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202804 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202805 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202806 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202807 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202808 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202809 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202810 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202811 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202812 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202901 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202902 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202903 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202904 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202905 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202906 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202907 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202908 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202909 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202910 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202911 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_202912 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_203001 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_203002 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_203003 LIKE fakeorders;

CREATE TABLE z_fakeorders_purchased_203004 LIKE fakeorders;

CREATE TABLE z_refundorders_purchased_202201 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202202 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202203 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202204 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202205 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202206 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202207 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202208 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202209 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202210 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202211 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202212 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202301 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202302 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202303 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202304 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202305 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202306 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202307 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202308 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202309 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202310 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202311 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202312 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202401 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202402 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202403 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202404 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202405 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202406 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202407 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202408 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202409 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202410 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202411 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202412 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202501 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202502 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202503 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202504 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202505 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202506 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202507 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202508 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202509 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202510 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202511 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202512 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202601 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202602 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202603 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202604 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202605 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202606 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202607 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202608 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202609 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202610 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202611 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202612 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202701 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202702 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202703 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202704 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202705 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202706 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202707 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202708 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202709 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202710 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202711 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202712 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202801 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202802 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202803 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202804 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202805 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202806 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202807 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202808 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202809 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202810 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202811 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202812 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202901 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202902 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202903 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202904 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202905 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202906 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202907 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202908 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202909 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202910 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202911 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_202912 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_203001 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_203002 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_203003 LIKE refundorders;

CREATE TABLE z_refundorders_purchased_203004 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202201 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202202 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202203 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202204 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202205 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202206 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202207 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202208 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202209 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202210 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202211 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202212 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202301 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202302 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202303 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202304 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202305 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202306 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202307 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202308 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202309 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202310 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202311 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202312 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202401 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202402 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202403 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202404 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202405 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202406 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202407 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202408 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202409 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202410 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202411 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202412 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202501 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202502 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202503 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202504 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202505 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202506 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202507 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202508 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202509 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202510 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202511 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202512 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202601 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202602 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202603 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202604 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202605 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202606 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202607 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202608 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202609 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202610 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202611 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202612 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202701 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202702 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202703 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202704 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202705 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202706 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202707 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202708 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202709 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202710 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202711 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202712 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202801 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202802 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202803 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202804 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202805 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202806 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202807 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202808 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202809 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202810 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202811 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202812 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202901 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202902 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202903 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202904 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202905 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202906 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202907 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202908 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202909 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202910 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202911 LIKE refundorders;

CREATE TABLE z_refundorders_finished_202912 LIKE refundorders;

CREATE TABLE z_refundorders_finished_203001 LIKE refundorders;

CREATE TABLE z_refundorders_finished_203002 LIKE refundorders;

CREATE TABLE z_refundorders_finished_203003 LIKE refundorders;

CREATE TABLE z_refundorders_finished_203004 LIKE refundorders;

CREATE TABLE z_orders_20220101 LIKE orders;

CREATE TABLE z_orders_20220102 LIKE orders;

CREATE TABLE z_orders_20220103 LIKE orders;

CREATE TABLE z_orders_20220104 LIKE orders;

CREATE TABLE z_orders_20220105 LIKE orders;

CREATE TABLE z_orders_20220106 LIKE orders;

CREATE TABLE z_orders_20220107 LIKE orders;

CREATE TABLE z_orders_20220108 LIKE orders;

CREATE TABLE z_orders_20220109 LIKE orders;

CREATE TABLE z_orders_20220110 LIKE orders;

CREATE TABLE z_orders_20220111 LIKE orders;

CREATE TABLE z_orders_20220112 LIKE orders;

CREATE TABLE z_orders_20220113 LIKE orders;

CREATE TABLE z_orders_20220114 LIKE orders;

CREATE TABLE z_orders_20220115 LIKE orders;

CREATE TABLE z_orders_20220116 LIKE orders;

CREATE TABLE z_orders_20220117 LIKE orders;

CREATE TABLE z_orders_20220118 LIKE orders;

CREATE TABLE z_orders_20220119 LIKE orders;

CREATE TABLE z_orders_20220120 LIKE orders;

CREATE TABLE z_orders_20220121 LIKE orders;

CREATE TABLE z_orders_20220122 LIKE orders;

CREATE TABLE z_orders_20220123 LIKE orders;

CREATE TABLE z_orders_20220124 LIKE orders;

CREATE TABLE z_orders_20220125 LIKE orders;

CREATE TABLE z_orders_20220126 LIKE orders;

CREATE TABLE z_orders_20220127 LIKE orders;

CREATE TABLE z_orders_20220128 LIKE orders;

CREATE TABLE z_orders_20220129 LIKE orders;

CREATE TABLE z_orders_20220130 LIKE orders;

CREATE TABLE z_orders_20220131 LIKE orders;

CREATE TABLE z_orders_20220201 LIKE orders;

CREATE TABLE z_orders_20220202 LIKE orders;

CREATE TABLE z_orders_20220203 LIKE orders;

CREATE TABLE z_orders_20220204 LIKE orders;

CREATE TABLE z_orders_20220205 LIKE orders;

CREATE TABLE z_orders_20220206 LIKE orders;

CREATE TABLE z_orders_20220207 LIKE orders;

CREATE TABLE z_orders_20220208 LIKE orders;

CREATE TABLE z_orders_20220209 LIKE orders;

CREATE TABLE z_orders_20220210 LIKE orders;

CREATE TABLE z_orders_20220211 LIKE orders;

CREATE TABLE z_orders_20220212 LIKE orders;

CREATE TABLE z_orders_20220213 LIKE orders;

CREATE TABLE z_orders_20220214 LIKE orders;

CREATE TABLE z_orders_20220215 LIKE orders;

CREATE TABLE z_orders_20220216 LIKE orders;

CREATE TABLE z_orders_20220217 LIKE orders;

CREATE TABLE z_orders_20220218 LIKE orders;

CREATE TABLE z_orders_20220219 LIKE orders;

CREATE TABLE z_orders_20220220 LIKE orders;

CREATE TABLE z_orders_20220221 LIKE orders;

CREATE TABLE z_orders_20220222 LIKE orders;

CREATE TABLE z_orders_20220223 LIKE orders;

CREATE TABLE z_orders_20220224 LIKE orders;

CREATE TABLE z_orders_20220225 LIKE orders;

CREATE TABLE z_orders_20220226 LIKE orders;

CREATE TABLE z_orders_20220227 LIKE orders;

CREATE TABLE z_orders_20220228 LIKE orders;

CREATE TABLE z_orders_20220301 LIKE orders;

CREATE TABLE z_orders_20220302 LIKE orders;

CREATE TABLE z_orders_20220303 LIKE orders;

CREATE TABLE z_orders_20220304 LIKE orders;

CREATE TABLE z_orders_20220305 LIKE orders;

CREATE TABLE z_orders_20220306 LIKE orders;

CREATE TABLE z_orders_20220307 LIKE orders;

CREATE TABLE z_orders_20220308 LIKE orders;

CREATE TABLE z_orders_20220309 LIKE orders;

CREATE TABLE z_orders_20220310 LIKE orders;

CREATE TABLE z_orders_20220311 LIKE orders;

CREATE TABLE z_orders_20220312 LIKE orders;

CREATE TABLE z_orders_20220313 LIKE orders;

CREATE TABLE z_orders_20220314 LIKE orders;

CREATE TABLE z_orders_20220315 LIKE orders;

CREATE TABLE z_orders_20220316 LIKE orders;

CREATE TABLE z_orders_20220317 LIKE orders;

CREATE TABLE z_orders_20220318 LIKE orders;

CREATE TABLE z_orders_20220319 LIKE orders;

CREATE TABLE z_orders_20220320 LIKE orders;

CREATE TABLE z_orders_20220321 LIKE orders;

CREATE TABLE z_orders_20220322 LIKE orders;

CREATE TABLE z_orders_20220323 LIKE orders;

CREATE TABLE z_orders_20220324 LIKE orders;

CREATE TABLE z_orders_20220325 LIKE orders;

CREATE TABLE z_orders_20220326 LIKE orders;

CREATE TABLE z_orders_20220327 LIKE orders;

CREATE TABLE z_orders_20220328 LIKE orders;

CREATE TABLE z_orders_20220329 LIKE orders;

CREATE TABLE z_orders_20220330 LIKE orders;

CREATE TABLE z_orders_20220331 LIKE orders;

CREATE TABLE z_orders_20220401 LIKE orders;

CREATE TABLE z_orders_20220402 LIKE orders;

CREATE TABLE z_orders_20220403 LIKE orders;

CREATE TABLE z_orders_20220404 LIKE orders;

CREATE TABLE z_orders_20220405 LIKE orders;

CREATE TABLE z_orders_20220406 LIKE orders;

CREATE TABLE z_orders_20220407 LIKE orders;

CREATE TABLE z_orders_20220408 LIKE orders;

CREATE TABLE z_orders_20220409 LIKE orders;

CREATE TABLE z_orders_20220410 LIKE orders;

CREATE TABLE z_orders_20220411 LIKE orders;

CREATE TABLE z_orders_20220412 LIKE orders;

CREATE TABLE z_orders_20220413 LIKE orders;

CREATE TABLE z_orders_20220414 LIKE orders;

CREATE TABLE z_orders_20220415 LIKE orders;

CREATE TABLE z_orders_20220416 LIKE orders;

CREATE TABLE z_orders_20220417 LIKE orders;

CREATE TABLE z_orders_20220418 LIKE orders;

CREATE TABLE z_orders_20220419 LIKE orders;

CREATE TABLE z_orders_20220420 LIKE orders;

CREATE TABLE z_orders_20220421 LIKE orders;

CREATE TABLE z_orders_20220422 LIKE orders;

CREATE TABLE z_orders_20220423 LIKE orders;

CREATE TABLE z_orders_20220424 LIKE orders;

CREATE TABLE z_orders_20220425 LIKE orders;

CREATE TABLE z_orders_20220426 LIKE orders;

CREATE TABLE z_orders_20220427 LIKE orders;

CREATE TABLE z_orders_20220428 LIKE orders;

CREATE TABLE z_orders_20220429 LIKE orders;

CREATE TABLE z_orders_20220430 LIKE orders;

CREATE TABLE z_orders_20220501 LIKE orders;

CREATE TABLE z_orders_20220502 LIKE orders;

CREATE TABLE z_orders_20220503 LIKE orders;

CREATE TABLE z_orders_20220504 LIKE orders;

CREATE TABLE z_orders_20220505 LIKE orders;

CREATE TABLE z_orders_20220506 LIKE orders;

CREATE TABLE z_orders_20220507 LIKE orders;

CREATE TABLE z_orders_20220508 LIKE orders;

CREATE TABLE z_orders_20220509 LIKE orders;

CREATE TABLE z_orders_20220510 LIKE orders;

CREATE TABLE z_orders_20220511 LIKE orders;

CREATE TABLE z_orders_20220512 LIKE orders;

CREATE TABLE z_orders_20220513 LIKE orders;

CREATE TABLE z_orders_20220514 LIKE orders;

CREATE TABLE z_orders_20220515 LIKE orders;

CREATE TABLE z_orders_20220516 LIKE orders;

CREATE TABLE z_orders_20220517 LIKE orders;

CREATE TABLE z_orders_20220518 LIKE orders;

CREATE TABLE z_orders_20220519 LIKE orders;

CREATE TABLE z_orders_20220520 LIKE orders;

CREATE TABLE z_orders_20220521 LIKE orders;

CREATE TABLE z_orders_20220522 LIKE orders;

CREATE TABLE z_orders_20220523 LIKE orders;

CREATE TABLE z_orders_20220524 LIKE orders;

CREATE TABLE z_orders_20220525 LIKE orders;

CREATE TABLE z_orders_20220526 LIKE orders;

CREATE TABLE z_orders_20220527 LIKE orders;

CREATE TABLE z_orders_20220528 LIKE orders;

CREATE TABLE z_orders_20220529 LIKE orders;

CREATE TABLE z_orders_20220530 LIKE orders;

CREATE TABLE z_orders_20220531 LIKE orders;

CREATE TABLE z_orders_20220601 LIKE orders;

CREATE TABLE z_orders_20220602 LIKE orders;

CREATE TABLE z_orders_20220603 LIKE orders;

CREATE TABLE z_orders_20220604 LIKE orders;

CREATE TABLE z_orders_20220605 LIKE orders;

CREATE TABLE z_orders_20220606 LIKE orders;

CREATE TABLE z_orders_20220607 LIKE orders;

CREATE TABLE z_orders_20220608 LIKE orders;

CREATE TABLE z_orders_20220609 LIKE orders;

CREATE TABLE z_orders_20220610 LIKE orders;

CREATE TABLE z_orders_20220611 LIKE orders;

CREATE TABLE z_orders_20220612 LIKE orders;

CREATE TABLE z_orders_20220613 LIKE orders;

CREATE TABLE z_orders_20220614 LIKE orders;

CREATE TABLE z_orders_20220615 LIKE orders;

CREATE TABLE z_orders_20220616 LIKE orders;

CREATE TABLE z_orders_20220617 LIKE orders;

CREATE TABLE z_orders_20220618 LIKE orders;

CREATE TABLE z_orders_20220619 LIKE orders;

CREATE TABLE z_orders_20220620 LIKE orders;

CREATE TABLE z_orders_20220621 LIKE orders;

CREATE TABLE z_orders_20220622 LIKE orders;

CREATE TABLE z_orders_20220623 LIKE orders;

CREATE TABLE z_orders_20220624 LIKE orders;

CREATE TABLE z_orders_20220625 LIKE orders;

CREATE TABLE z_orders_20220626 LIKE orders;

CREATE TABLE z_orders_20220627 LIKE orders;

CREATE TABLE z_orders_20220628 LIKE orders;

CREATE TABLE z_orders_20220629 LIKE orders;

CREATE TABLE z_orders_20220630 LIKE orders;

CREATE TABLE z_orders_20220701 LIKE orders;

CREATE TABLE z_orders_20220702 LIKE orders;

CREATE TABLE z_orders_20220703 LIKE orders;

CREATE TABLE z_orders_20220704 LIKE orders;

CREATE TABLE z_orders_20220705 LIKE orders;

CREATE TABLE z_orders_20220706 LIKE orders;

CREATE TABLE z_orders_20220707 LIKE orders;

CREATE TABLE z_orders_20220708 LIKE orders;

CREATE TABLE z_orders_20220709 LIKE orders;

CREATE TABLE z_orders_20220710 LIKE orders;

CREATE TABLE z_orders_20220711 LIKE orders;

CREATE TABLE z_orders_20220712 LIKE orders;

CREATE TABLE z_orders_20220713 LIKE orders;

CREATE TABLE z_orders_20220714 LIKE orders;

CREATE TABLE z_orders_20220715 LIKE orders;

CREATE TABLE z_orders_20220716 LIKE orders;

CREATE TABLE z_orders_20220717 LIKE orders;

CREATE TABLE z_orders_20220718 LIKE orders;

CREATE TABLE z_orders_20220719 LIKE orders;

CREATE TABLE z_orders_20220720 LIKE orders;

CREATE TABLE z_orders_20220721 LIKE orders;

CREATE TABLE z_orders_20220722 LIKE orders;

CREATE TABLE z_orders_20220723 LIKE orders;

CREATE TABLE z_orders_20220724 LIKE orders;

CREATE TABLE z_orders_20220725 LIKE orders;

CREATE TABLE z_orders_20220726 LIKE orders;

CREATE TABLE z_orders_20220727 LIKE orders;

CREATE TABLE z_orders_20220728 LIKE orders;

CREATE TABLE z_orders_20220729 LIKE orders;

CREATE TABLE z_orders_20220730 LIKE orders;

CREATE TABLE z_orders_20220731 LIKE orders;

CREATE TABLE z_orders_20220801 LIKE orders;

CREATE TABLE z_orders_20220802 LIKE orders;

CREATE TABLE z_orders_20220803 LIKE orders;

CREATE TABLE z_orders_20220804 LIKE orders;

CREATE TABLE z_orders_20220805 LIKE orders;

CREATE TABLE z_orders_20220806 LIKE orders;

CREATE TABLE z_orders_20220807 LIKE orders;

CREATE TABLE z_orders_20220808 LIKE orders;

CREATE TABLE z_orders_20220809 LIKE orders;

CREATE TABLE z_orders_20220810 LIKE orders;

CREATE TABLE z_orders_20220811 LIKE orders;

CREATE TABLE z_orders_20220812 LIKE orders;

CREATE TABLE z_orders_20220813 LIKE orders;

CREATE TABLE z_orders_20220814 LIKE orders;

CREATE TABLE z_orders_20220815 LIKE orders;

CREATE TABLE z_orders_20220816 LIKE orders;

CREATE TABLE z_orders_20220817 LIKE orders;

CREATE TABLE z_orders_20220818 LIKE orders;

CREATE TABLE z_orders_20220819 LIKE orders;

CREATE TABLE z_orders_20220820 LIKE orders;

CREATE TABLE z_orders_20220821 LIKE orders;

CREATE TABLE z_orders_20220822 LIKE orders;

CREATE TABLE z_orders_20220823 LIKE orders;

CREATE TABLE z_orders_20220824 LIKE orders;

CREATE TABLE z_orders_20220825 LIKE orders;

CREATE TABLE z_orders_20220826 LIKE orders;

CREATE TABLE z_orders_20220827 LIKE orders;

CREATE TABLE z_orders_20220828 LIKE orders;

CREATE TABLE z_orders_20220829 LIKE orders;

CREATE TABLE z_orders_20220830 LIKE orders;

CREATE TABLE z_orders_20220831 LIKE orders;

CREATE TABLE z_orders_20220901 LIKE orders;

CREATE TABLE z_orders_20220902 LIKE orders;

CREATE TABLE z_orders_20220903 LIKE orders;

CREATE TABLE z_orders_20220904 LIKE orders;

CREATE TABLE z_orders_20220905 LIKE orders;

CREATE TABLE z_orders_20220906 LIKE orders;

CREATE TABLE z_orders_20220907 LIKE orders;

CREATE TABLE z_orders_20220908 LIKE orders;

CREATE TABLE z_orders_20220909 LIKE orders;

CREATE TABLE z_orders_20220910 LIKE orders;

CREATE TABLE z_orders_20220911 LIKE orders;

CREATE TABLE z_orders_20220912 LIKE orders;

CREATE TABLE z_orders_20220913 LIKE orders;

CREATE TABLE z_orders_20220914 LIKE orders;

CREATE TABLE z_orders_20220915 LIKE orders;

CREATE TABLE z_orders_20220916 LIKE orders;

CREATE TABLE z_orders_20220917 LIKE orders;

CREATE TABLE z_orders_20220918 LIKE orders;

CREATE TABLE z_orders_20220919 LIKE orders;

CREATE TABLE z_orders_20220920 LIKE orders;

CREATE TABLE z_orders_20220921 LIKE orders;

CREATE TABLE z_orders_20220922 LIKE orders;

CREATE TABLE z_orders_20220923 LIKE orders;

CREATE TABLE z_orders_20220924 LIKE orders;

CREATE TABLE z_orders_20220925 LIKE orders;

CREATE TABLE z_orders_20220926 LIKE orders;

CREATE TABLE z_orders_20220927 LIKE orders;

CREATE TABLE z_orders_20220928 LIKE orders;

CREATE TABLE z_orders_20220929 LIKE orders;

CREATE TABLE z_orders_20220930 LIKE orders;

CREATE TABLE z_orders_20221001 LIKE orders;

CREATE TABLE z_orders_20221002 LIKE orders;

CREATE TABLE z_orders_20221003 LIKE orders;

CREATE TABLE z_orders_20221004 LIKE orders;

CREATE TABLE z_orders_20221005 LIKE orders;

CREATE TABLE z_orders_20221006 LIKE orders;

CREATE TABLE z_orders_20221007 LIKE orders;

CREATE TABLE z_orders_20221008 LIKE orders;

CREATE TABLE z_orders_20221009 LIKE orders;

CREATE TABLE z_orders_20221010 LIKE orders;

CREATE TABLE z_orders_20221011 LIKE orders;

CREATE TABLE z_orders_20221012 LIKE orders;

CREATE TABLE z_orders_20221013 LIKE orders;

CREATE TABLE z_orders_20221014 LIKE orders;

CREATE TABLE z_orders_20221015 LIKE orders;

CREATE TABLE z_orders_20221016 LIKE orders;

CREATE TABLE z_orders_20221017 LIKE orders;

CREATE TABLE z_orders_20221018 LIKE orders;

CREATE TABLE z_orders_20221019 LIKE orders;

CREATE TABLE z_orders_20221020 LIKE orders;

CREATE TABLE z_orders_20221021 LIKE orders;

CREATE TABLE z_orders_20221022 LIKE orders;

CREATE TABLE z_orders_20221023 LIKE orders;

CREATE TABLE z_orders_20221024 LIKE orders;

CREATE TABLE z_orders_20221025 LIKE orders;

CREATE TABLE z_orders_20221026 LIKE orders;

CREATE TABLE z_orders_20221027 LIKE orders;

CREATE TABLE z_orders_20221028 LIKE orders;

CREATE TABLE z_orders_20221029 LIKE orders;

CREATE TABLE z_orders_20221030 LIKE orders;

CREATE TABLE z_orders_20221031 LIKE orders;

CREATE TABLE z_orders_20221101 LIKE orders;

CREATE TABLE z_orders_20221102 LIKE orders;

CREATE TABLE z_orders_20221103 LIKE orders;

CREATE TABLE z_orders_20221104 LIKE orders;

CREATE TABLE z_orders_20221105 LIKE orders;

CREATE TABLE z_orders_20221106 LIKE orders;

CREATE TABLE z_orders_20221107 LIKE orders;

CREATE TABLE z_orders_20221108 LIKE orders;

CREATE TABLE z_orders_20221109 LIKE orders;

CREATE TABLE z_orders_20221110 LIKE orders;

CREATE TABLE z_orders_20221111 LIKE orders;

CREATE TABLE z_orders_20221112 LIKE orders;

CREATE TABLE z_orders_20221113 LIKE orders;

CREATE TABLE z_orders_20221114 LIKE orders;

CREATE TABLE z_orders_20221115 LIKE orders;

CREATE TABLE z_orders_20221116 LIKE orders;

CREATE TABLE z_orders_20221117 LIKE orders;

CREATE TABLE z_orders_20221118 LIKE orders;

CREATE TABLE z_orders_20221119 LIKE orders;

CREATE TABLE z_orders_20221120 LIKE orders;

CREATE TABLE z_orders_20221121 LIKE orders;

CREATE TABLE z_orders_20221122 LIKE orders;

CREATE TABLE z_orders_20221123 LIKE orders;

CREATE TABLE z_orders_20221124 LIKE orders;

CREATE TABLE z_orders_20221125 LIKE orders;

CREATE TABLE z_orders_20221126 LIKE orders;

CREATE TABLE z_orders_20221127 LIKE orders;

CREATE TABLE z_orders_20221128 LIKE orders;

CREATE TABLE z_orders_20221129 LIKE orders;

CREATE TABLE z_orders_20221130 LIKE orders;

CREATE TABLE z_orders_20221201 LIKE orders;

CREATE TABLE z_orders_20221202 LIKE orders;

CREATE TABLE z_orders_20221203 LIKE orders;

CREATE TABLE z_orders_20221204 LIKE orders;

CREATE TABLE z_orders_20221205 LIKE orders;

CREATE TABLE z_orders_20221206 LIKE orders;

CREATE TABLE z_orders_20221207 LIKE orders;

CREATE TABLE z_orders_20221208 LIKE orders;

CREATE TABLE z_orders_20221209 LIKE orders;

CREATE TABLE z_orders_20221210 LIKE orders;

CREATE TABLE z_orders_20221211 LIKE orders;

CREATE TABLE z_orders_20221212 LIKE orders;

CREATE TABLE z_orders_20221213 LIKE orders;

CREATE TABLE z_orders_20221214 LIKE orders;

CREATE TABLE z_orders_20221215 LIKE orders;

CREATE TABLE z_orders_20221216 LIKE orders;

CREATE TABLE z_orders_20221217 LIKE orders;

CREATE TABLE z_orders_20221218 LIKE orders;

CREATE TABLE z_orders_20221219 LIKE orders;

CREATE TABLE z_orders_20221220 LIKE orders;

CREATE TABLE z_orders_20221221 LIKE orders;

CREATE TABLE z_orders_20221222 LIKE orders;

CREATE TABLE z_orders_20221223 LIKE orders;

CREATE TABLE z_orders_20221224 LIKE orders;

CREATE TABLE z_orders_20221225 LIKE orders;

CREATE TABLE z_orders_20221226 LIKE orders;

CREATE TABLE z_orders_20221227 LIKE orders;

CREATE TABLE z_orders_20221228 LIKE orders;

CREATE TABLE z_orders_20221229 LIKE orders;

CREATE TABLE z_orders_20221230 LIKE orders;

CREATE TABLE z_orders_20221231 LIKE orders;

CREATE TABLE z_orders_20230101 LIKE orders;

CREATE TABLE z_orders_20230102 LIKE orders;

CREATE TABLE z_orders_20230103 LIKE orders;

CREATE TABLE z_orders_20230104 LIKE orders;

CREATE TABLE z_orders_20230105 LIKE orders;

CREATE TABLE z_orders_20230106 LIKE orders;

CREATE TABLE z_orders_20230107 LIKE orders;

CREATE TABLE z_orders_20230108 LIKE orders;

CREATE TABLE z_orders_20230109 LIKE orders;

CREATE TABLE z_orders_20230110 LIKE orders;

CREATE TABLE z_orders_20230111 LIKE orders;

CREATE TABLE z_orders_20230112 LIKE orders;

CREATE TABLE z_orders_20230113 LIKE orders;

CREATE TABLE z_orders_20230114 LIKE orders;

CREATE TABLE z_orders_20230115 LIKE orders;

CREATE TABLE z_orders_20230116 LIKE orders;

CREATE TABLE z_orders_20230117 LIKE orders;

CREATE TABLE z_orders_20230118 LIKE orders;

CREATE TABLE z_orders_20230119 LIKE orders;

CREATE TABLE z_orders_20230120 LIKE orders;

CREATE TABLE z_orders_20230121 LIKE orders;

CREATE TABLE z_orders_20230122 LIKE orders;

CREATE TABLE z_orders_20230123 LIKE orders;

CREATE TABLE z_orders_20230124 LIKE orders;

CREATE TABLE z_orders_20230125 LIKE orders;

CREATE TABLE z_orders_20230126 LIKE orders;

CREATE TABLE z_orders_20230127 LIKE orders;

CREATE TABLE z_orders_20230128 LIKE orders;

CREATE TABLE z_orders_20230129 LIKE orders;

CREATE TABLE z_orders_20230130 LIKE orders;

CREATE TABLE z_orders_20230131 LIKE orders;

CREATE TABLE z_orders_20230201 LIKE orders;

CREATE TABLE z_orders_20230202 LIKE orders;

CREATE TABLE z_orders_20230203 LIKE orders;

CREATE TABLE z_orders_20230204 LIKE orders;

CREATE TABLE z_orders_20230205 LIKE orders;

CREATE TABLE z_orders_20230206 LIKE orders;

CREATE TABLE z_orders_20230207 LIKE orders;

CREATE TABLE z_orders_20230208 LIKE orders;

CREATE TABLE z_orders_20230209 LIKE orders;

CREATE TABLE z_orders_20230210 LIKE orders;

CREATE TABLE z_orders_20230211 LIKE orders;

CREATE TABLE z_orders_20230212 LIKE orders;

CREATE TABLE z_orders_20230213 LIKE orders;

CREATE TABLE z_orders_20230214 LIKE orders;

CREATE TABLE z_orders_20230215 LIKE orders;

CREATE TABLE z_orders_20230216 LIKE orders;

CREATE TABLE z_orders_20230217 LIKE orders;

CREATE TABLE z_orders_20230218 LIKE orders;

CREATE TABLE z_orders_20230219 LIKE orders;

CREATE TABLE z_orders_20230220 LIKE orders;

CREATE TABLE z_orders_20230221 LIKE orders;

CREATE TABLE z_orders_20230222 LIKE orders;

CREATE TABLE z_orders_20230223 LIKE orders;

CREATE TABLE z_orders_20230224 LIKE orders;

CREATE TABLE z_orders_20230225 LIKE orders;

CREATE TABLE z_orders_20230226 LIKE orders;

CREATE TABLE z_orders_20230227 LIKE orders;

CREATE TABLE z_orders_20230228 LIKE orders;

CREATE TABLE z_orders_20230301 LIKE orders;

CREATE TABLE z_orders_20230302 LIKE orders;

CREATE TABLE z_orders_20230303 LIKE orders;

CREATE TABLE z_orders_20230304 LIKE orders;

CREATE TABLE z_orders_20230305 LIKE orders;

CREATE TABLE z_orders_20230306 LIKE orders;

CREATE TABLE z_orders_20230307 LIKE orders;

CREATE TABLE z_orders_20230308 LIKE orders;

CREATE TABLE z_orders_20230309 LIKE orders;

CREATE TABLE z_orders_20230310 LIKE orders;

CREATE TABLE z_orders_20230311 LIKE orders;

CREATE TABLE z_orders_20230312 LIKE orders;

CREATE TABLE z_orders_20230313 LIKE orders;

CREATE TABLE z_orders_20230314 LIKE orders;

CREATE TABLE z_orders_20230315 LIKE orders;

CREATE TABLE z_orders_20230316 LIKE orders;

CREATE TABLE z_orders_20230317 LIKE orders;

CREATE TABLE z_orders_20230318 LIKE orders;

CREATE TABLE z_orders_20230319 LIKE orders;

CREATE TABLE z_orders_20230320 LIKE orders;

CREATE TABLE z_orders_20230321 LIKE orders;

CREATE TABLE z_orders_20230322 LIKE orders;

CREATE TABLE z_orders_20230323 LIKE orders;

CREATE TABLE z_orders_20230324 LIKE orders;

CREATE TABLE z_orders_20230325 LIKE orders;

CREATE TABLE z_orders_20230326 LIKE orders;

CREATE TABLE z_orders_20230327 LIKE orders;

CREATE TABLE z_orders_20230328 LIKE orders;

CREATE TABLE z_orders_20230329 LIKE orders;

CREATE TABLE z_orders_20230330 LIKE orders;

CREATE TABLE z_orders_20230331 LIKE orders;

CREATE TABLE z_orders_20230401 LIKE orders;

CREATE TABLE z_orders_20230402 LIKE orders;

CREATE TABLE z_orders_20230403 LIKE orders;

CREATE TABLE z_orders_20230404 LIKE orders;

CREATE TABLE z_orders_20230405 LIKE orders;

CREATE TABLE z_orders_20230406 LIKE orders;

CREATE TABLE z_orders_20230407 LIKE orders;

CREATE TABLE z_orders_20230408 LIKE orders;

CREATE TABLE z_orders_20230409 LIKE orders;

CREATE TABLE z_orders_20230410 LIKE orders;

CREATE TABLE z_orders_20230411 LIKE orders;

CREATE TABLE z_orders_20230412 LIKE orders;

CREATE TABLE z_orders_20230413 LIKE orders;

CREATE TABLE z_orders_20230414 LIKE orders;

CREATE TABLE z_orders_20230415 LIKE orders;

CREATE TABLE z_orders_20230416 LIKE orders;

CREATE TABLE z_orders_20230417 LIKE orders;

CREATE TABLE z_orders_20230418 LIKE orders;

CREATE TABLE z_orders_20230419 LIKE orders;

CREATE TABLE z_orders_20230420 LIKE orders;

CREATE TABLE z_orders_20230421 LIKE orders;

CREATE TABLE z_orders_20230422 LIKE orders;

CREATE TABLE z_orders_20230423 LIKE orders;

CREATE TABLE z_orders_20230424 LIKE orders;

CREATE TABLE z_orders_20230425 LIKE orders;

CREATE TABLE z_orders_20230426 LIKE orders;

CREATE TABLE z_orders_20230427 LIKE orders;

CREATE TABLE z_orders_20230428 LIKE orders;

CREATE TABLE z_orders_20230429 LIKE orders;

CREATE TABLE z_orders_20230430 LIKE orders;

CREATE TABLE z_orders_20230501 LIKE orders;

CREATE TABLE z_orders_20230502 LIKE orders;

CREATE TABLE z_orders_20230503 LIKE orders;

CREATE TABLE z_orders_20230504 LIKE orders;

CREATE TABLE z_orders_20230505 LIKE orders;

CREATE TABLE z_orders_20230506 LIKE orders;

CREATE TABLE z_orders_20230507 LIKE orders;

CREATE TABLE z_orders_20230508 LIKE orders;

CREATE TABLE z_orders_20230509 LIKE orders;

CREATE TABLE z_orders_20230510 LIKE orders;

CREATE TABLE z_orders_20230511 LIKE orders;

CREATE TABLE z_orders_20230512 LIKE orders;

CREATE TABLE z_orders_20230513 LIKE orders;

CREATE TABLE z_orders_20230514 LIKE orders;

CREATE TABLE z_orders_20230515 LIKE orders;

CREATE TABLE z_orders_20230516 LIKE orders;

CREATE TABLE z_orders_20230517 LIKE orders;

CREATE TABLE z_orders_20230518 LIKE orders;

CREATE TABLE z_orders_20230519 LIKE orders;

CREATE TABLE z_orders_20230520 LIKE orders;

CREATE TABLE z_orders_20230521 LIKE orders;

CREATE TABLE z_orders_20230522 LIKE orders;

CREATE TABLE z_orders_20230523 LIKE orders;

CREATE TABLE z_orders_20230524 LIKE orders;

CREATE TABLE z_orders_20230525 LIKE orders;

CREATE TABLE z_orders_20230526 LIKE orders;

CREATE TABLE z_orders_20230527 LIKE orders;

CREATE TABLE z_orders_20230528 LIKE orders;

CREATE TABLE z_orders_20230529 LIKE orders;

CREATE TABLE z_orders_20230530 LIKE orders;

CREATE TABLE z_orders_20230531 LIKE orders;

CREATE TABLE z_orders_20230601 LIKE orders;

CREATE TABLE z_orders_20230602 LIKE orders;

CREATE TABLE z_orders_20230603 LIKE orders;

CREATE TABLE z_orders_20230604 LIKE orders;

CREATE TABLE z_orders_20230605 LIKE orders;

CREATE TABLE z_orders_20230606 LIKE orders;

CREATE TABLE z_orders_20230607 LIKE orders;

CREATE TABLE z_orders_20230608 LIKE orders;

CREATE TABLE z_orders_20230609 LIKE orders;

CREATE TABLE z_orders_20230610 LIKE orders;

CREATE TABLE z_orders_20230611 LIKE orders;

CREATE TABLE z_orders_20230612 LIKE orders;

CREATE TABLE z_orders_20230613 LIKE orders;

CREATE TABLE z_orders_20230614 LIKE orders;

CREATE TABLE z_orders_20230615 LIKE orders;

CREATE TABLE z_orders_20230616 LIKE orders;

CREATE TABLE z_orders_20230617 LIKE orders;

CREATE TABLE z_orders_20230618 LIKE orders;

CREATE TABLE z_orders_20230619 LIKE orders;

CREATE TABLE z_orders_20230620 LIKE orders;

CREATE TABLE z_orders_20230621 LIKE orders;

CREATE TABLE z_orders_20230622 LIKE orders;

CREATE TABLE z_orders_20230623 LIKE orders;

CREATE TABLE z_orders_20230624 LIKE orders;

CREATE TABLE z_orders_20230625 LIKE orders;

CREATE TABLE z_orders_20230626 LIKE orders;

CREATE TABLE z_orders_20230627 LIKE orders;

CREATE TABLE z_orders_20230628 LIKE orders;

CREATE TABLE z_orders_20230629 LIKE orders;

CREATE TABLE z_orders_20230630 LIKE orders;

CREATE TABLE z_orders_20230701 LIKE orders;

CREATE TABLE z_orders_20230702 LIKE orders;

CREATE TABLE z_orders_20230703 LIKE orders;

CREATE TABLE z_orders_20230704 LIKE orders;

CREATE TABLE z_orders_20230705 LIKE orders;

CREATE TABLE z_orders_20230706 LIKE orders;

CREATE TABLE z_orders_20230707 LIKE orders;

CREATE TABLE z_orders_20230708 LIKE orders;

CREATE TABLE z_orders_20230709 LIKE orders;

CREATE TABLE z_orders_20230710 LIKE orders;

CREATE TABLE z_orders_20230711 LIKE orders;

CREATE TABLE z_orders_20230712 LIKE orders;

CREATE TABLE z_orders_20230713 LIKE orders;

CREATE TABLE z_orders_20230714 LIKE orders;

CREATE TABLE z_orders_20230715 LIKE orders;

CREATE TABLE z_orders_20230716 LIKE orders;

CREATE TABLE z_orders_20230717 LIKE orders;

CREATE TABLE z_orders_20230718 LIKE orders;

CREATE TABLE z_orders_20230719 LIKE orders;

CREATE TABLE z_orders_20230720 LIKE orders;

CREATE TABLE z_orders_20230721 LIKE orders;

CREATE TABLE z_orders_20230722 LIKE orders;

CREATE TABLE z_orders_20230723 LIKE orders;

CREATE TABLE z_orders_20230724 LIKE orders;

CREATE TABLE z_orders_20230725 LIKE orders;

CREATE TABLE z_orders_20230726 LIKE orders;

CREATE TABLE z_orders_20230727 LIKE orders;

CREATE TABLE z_orders_20230728 LIKE orders;

CREATE TABLE z_orders_20230729 LIKE orders;

CREATE TABLE z_orders_20230730 LIKE orders;

CREATE TABLE z_orders_20230731 LIKE orders;

CREATE TABLE z_orders_20230801 LIKE orders;

CREATE TABLE z_orders_20230802 LIKE orders;

CREATE TABLE z_orders_20230803 LIKE orders;

CREATE TABLE z_orders_20230804 LIKE orders;

CREATE TABLE z_orders_20230805 LIKE orders;

CREATE TABLE z_orders_20230806 LIKE orders;

CREATE TABLE z_orders_20230807 LIKE orders;

CREATE TABLE z_orders_20230808 LIKE orders;

CREATE TABLE z_orders_20230809 LIKE orders;

CREATE TABLE z_orders_20230810 LIKE orders;

CREATE TABLE z_orders_20230811 LIKE orders;

CREATE TABLE z_orders_20230812 LIKE orders;

CREATE TABLE z_orders_20230813 LIKE orders;

CREATE TABLE z_orders_20230814 LIKE orders;

CREATE TABLE z_orders_20230815 LIKE orders;

CREATE TABLE z_orders_20230816 LIKE orders;

CREATE TABLE z_orders_20230817 LIKE orders;

CREATE TABLE z_orders_20230818 LIKE orders;

CREATE TABLE z_orders_20230819 LIKE orders;

CREATE TABLE z_orders_20230820 LIKE orders;

CREATE TABLE z_orders_20230821 LIKE orders;

CREATE TABLE z_orders_20230822 LIKE orders;

CREATE TABLE z_orders_20230823 LIKE orders;

CREATE TABLE z_orders_20230824 LIKE orders;

CREATE TABLE z_orders_20230825 LIKE orders;

CREATE TABLE z_orders_20230826 LIKE orders;

CREATE TABLE z_orders_20230827 LIKE orders;

CREATE TABLE z_orders_20230828 LIKE orders;

CREATE TABLE z_orders_20230829 LIKE orders;

CREATE TABLE z_orders_20230830 LIKE orders;

CREATE TABLE z_orders_20230831 LIKE orders;

CREATE TABLE z_orders_20230901 LIKE orders;

CREATE TABLE z_orders_20230902 LIKE orders;

CREATE TABLE z_orders_20230903 LIKE orders;

CREATE TABLE z_orders_20230904 LIKE orders;

CREATE TABLE z_orders_20230905 LIKE orders;

CREATE TABLE z_orders_20230906 LIKE orders;

CREATE TABLE z_orders_20230907 LIKE orders;

CREATE TABLE z_orders_20230908 LIKE orders;

CREATE TABLE z_orders_20230909 LIKE orders;

CREATE TABLE z_orders_20230910 LIKE orders;

CREATE TABLE z_orders_20230911 LIKE orders;

CREATE TABLE z_orders_20230912 LIKE orders;

CREATE TABLE z_orders_20230913 LIKE orders;

CREATE TABLE z_orders_20230914 LIKE orders;

CREATE TABLE z_orders_20230915 LIKE orders;

CREATE TABLE z_orders_20230916 LIKE orders;

CREATE TABLE z_orders_20230917 LIKE orders;

CREATE TABLE z_orders_20230918 LIKE orders;

CREATE TABLE z_orders_20230919 LIKE orders;

CREATE TABLE z_orders_20230920 LIKE orders;

CREATE TABLE z_orders_20230921 LIKE orders;

CREATE TABLE z_orders_20230922 LIKE orders;

CREATE TABLE z_orders_20230923 LIKE orders;

CREATE TABLE z_orders_20230924 LIKE orders;

CREATE TABLE z_orders_20230925 LIKE orders;

CREATE TABLE z_orders_20230926 LIKE orders;

CREATE TABLE z_orders_20230927 LIKE orders;

CREATE TABLE z_orders_20230928 LIKE orders;

CREATE TABLE z_orders_20230929 LIKE orders;

CREATE TABLE z_orders_20230930 LIKE orders;

CREATE TABLE z_orders_20231001 LIKE orders;

CREATE TABLE z_orders_20231002 LIKE orders;

CREATE TABLE z_orders_20231003 LIKE orders;

CREATE TABLE z_orders_20231004 LIKE orders;

CREATE TABLE z_orders_20231005 LIKE orders;

CREATE TABLE z_orders_20231006 LIKE orders;

CREATE TABLE z_orders_20231007 LIKE orders;

CREATE TABLE z_orders_20231008 LIKE orders;

CREATE TABLE z_orders_20231009 LIKE orders;

CREATE TABLE z_orders_20231010 LIKE orders;

CREATE TABLE z_orders_20231011 LIKE orders;

CREATE TABLE z_orders_20231012 LIKE orders;

CREATE TABLE z_orders_20231013 LIKE orders;

CREATE TABLE z_orders_20231014 LIKE orders;

CREATE TABLE z_orders_20231015 LIKE orders;

CREATE TABLE z_orders_20231016 LIKE orders;

CREATE TABLE z_orders_20231017 LIKE orders;

CREATE TABLE z_orders_20231018 LIKE orders;

CREATE TABLE z_orders_20231019 LIKE orders;

CREATE TABLE z_orders_20231020 LIKE orders;

CREATE TABLE z_orders_20231021 LIKE orders;

CREATE TABLE z_orders_20231022 LIKE orders;

CREATE TABLE z_orders_20231023 LIKE orders;

CREATE TABLE z_orders_20231024 LIKE orders;

CREATE TABLE z_orders_20231025 LIKE orders;

CREATE TABLE z_orders_20231026 LIKE orders;

CREATE TABLE z_orders_20231027 LIKE orders;

CREATE TABLE z_orders_20231028 LIKE orders;

CREATE TABLE z_orders_20231029 LIKE orders;

CREATE TABLE z_orders_20231030 LIKE orders;

CREATE TABLE z_orders_20231031 LIKE orders;

CREATE TABLE z_orders_20231101 LIKE orders;

CREATE TABLE z_orders_20231102 LIKE orders;

CREATE TABLE z_orders_20231103 LIKE orders;

CREATE TABLE z_orders_20231104 LIKE orders;

CREATE TABLE z_orders_20231105 LIKE orders;

CREATE TABLE z_orders_20231106 LIKE orders;

CREATE TABLE z_orders_20231107 LIKE orders;

CREATE TABLE z_orders_20231108 LIKE orders;

CREATE TABLE z_orders_20231109 LIKE orders;

CREATE TABLE z_orders_20231110 LIKE orders;

CREATE TABLE z_orders_20231111 LIKE orders;

CREATE TABLE z_orders_20231112 LIKE orders;

CREATE TABLE z_orders_20231113 LIKE orders;

CREATE TABLE z_orders_20231114 LIKE orders;

CREATE TABLE z_orders_20231115 LIKE orders;

CREATE TABLE z_orders_20231116 LIKE orders;

CREATE TABLE z_orders_20231117 LIKE orders;

CREATE TABLE z_orders_20231118 LIKE orders;

CREATE TABLE z_orders_20231119 LIKE orders;

CREATE TABLE z_orders_20231120 LIKE orders;

CREATE TABLE z_orders_20231121 LIKE orders;

CREATE TABLE z_orders_20231122 LIKE orders;

CREATE TABLE z_orders_20231123 LIKE orders;

CREATE TABLE z_orders_20231124 LIKE orders;

CREATE TABLE z_orders_20231125 LIKE orders;

CREATE TABLE z_orders_20231126 LIKE orders;

CREATE TABLE z_orders_20231127 LIKE orders;

CREATE TABLE z_orders_20231128 LIKE orders;

CREATE TABLE z_orders_20231129 LIKE orders;

CREATE TABLE z_orders_20231130 LIKE orders;

CREATE TABLE z_orders_20231201 LIKE orders;

CREATE TABLE z_orders_20231202 LIKE orders;

CREATE TABLE z_orders_20231203 LIKE orders;

CREATE TABLE z_orders_20231204 LIKE orders;

CREATE TABLE z_orders_20231205 LIKE orders;

CREATE TABLE z_orders_20231206 LIKE orders;

CREATE TABLE z_orders_20231207 LIKE orders;

CREATE TABLE z_orders_20231208 LIKE orders;

CREATE TABLE z_orders_20231209 LIKE orders;

CREATE TABLE z_orders_20231210 LIKE orders;

CREATE TABLE z_orders_20231211 LIKE orders;

CREATE TABLE z_orders_20231212 LIKE orders;

CREATE TABLE z_orders_20231213 LIKE orders;

CREATE TABLE z_orders_20231214 LIKE orders;

CREATE TABLE z_orders_20231215 LIKE orders;

CREATE TABLE z_orders_20231216 LIKE orders;

CREATE TABLE z_orders_20231217 LIKE orders;

CREATE TABLE z_orders_20231218 LIKE orders;

CREATE TABLE z_orders_20231219 LIKE orders;

CREATE TABLE z_orders_20231220 LIKE orders;

CREATE TABLE z_orders_20231221 LIKE orders;

CREATE TABLE z_orders_20231222 LIKE orders;

CREATE TABLE z_orders_20231223 LIKE orders;

CREATE TABLE z_orders_20231224 LIKE orders;

CREATE TABLE z_orders_20231225 LIKE orders;

CREATE TABLE z_orders_20231226 LIKE orders;

CREATE TABLE z_orders_20231227 LIKE orders;

CREATE TABLE z_orders_20231228 LIKE orders;

CREATE TABLE z_orders_20231229 LIKE orders;

CREATE TABLE z_orders_20231230 LIKE orders;

CREATE TABLE z_orders_20231231 LIKE orders;

CREATE TABLE z_orders_20240101 LIKE orders;

CREATE TABLE z_orders_20240102 LIKE orders;

CREATE TABLE z_orders_20240103 LIKE orders;

CREATE TABLE z_orders_20240104 LIKE orders;

CREATE TABLE z_orders_20240105 LIKE orders;

CREATE TABLE z_orders_20240106 LIKE orders;

CREATE TABLE z_orders_20240107 LIKE orders;

CREATE TABLE z_orders_20240108 LIKE orders;

CREATE TABLE z_orders_20240109 LIKE orders;

CREATE TABLE z_orders_20240110 LIKE orders;

CREATE TABLE z_orders_20240111 LIKE orders;

CREATE TABLE z_orders_20240112 LIKE orders;

CREATE TABLE z_orders_20240113 LIKE orders;

CREATE TABLE z_orders_20240114 LIKE orders;

CREATE TABLE z_orders_20240115 LIKE orders;

CREATE TABLE z_orders_20240116 LIKE orders;

CREATE TABLE z_orders_20240117 LIKE orders;

CREATE TABLE z_orders_20240118 LIKE orders;

CREATE TABLE z_orders_20240119 LIKE orders;

CREATE TABLE z_orders_20240120 LIKE orders;

CREATE TABLE z_orders_20240121 LIKE orders;

CREATE TABLE z_orders_20240122 LIKE orders;

CREATE TABLE z_orders_20240123 LIKE orders;

CREATE TABLE z_orders_20240124 LIKE orders;

CREATE TABLE z_orders_20240125 LIKE orders;

CREATE TABLE z_orders_20240126 LIKE orders;

CREATE TABLE z_orders_20240127 LIKE orders;

CREATE TABLE z_orders_20240128 LIKE orders;

CREATE TABLE z_orders_20240129 LIKE orders;

CREATE TABLE z_orders_20240130 LIKE orders;

CREATE TABLE z_orders_20240131 LIKE orders;

CREATE TABLE z_orders_20240201 LIKE orders;

CREATE TABLE z_orders_20240202 LIKE orders;

CREATE TABLE z_orders_20240203 LIKE orders;

CREATE TABLE z_orders_20240204 LIKE orders;

CREATE TABLE z_orders_20240205 LIKE orders;

CREATE TABLE z_orders_20240206 LIKE orders;

CREATE TABLE z_orders_20240207 LIKE orders;

CREATE TABLE z_orders_20240208 LIKE orders;

CREATE TABLE z_orders_20240209 LIKE orders;

CREATE TABLE z_orders_20240210 LIKE orders;

CREATE TABLE z_orders_20240211 LIKE orders;

CREATE TABLE z_orders_20240212 LIKE orders;

CREATE TABLE z_orders_20240213 LIKE orders;

CREATE TABLE z_orders_20240214 LIKE orders;

CREATE TABLE z_orders_20240215 LIKE orders;

CREATE TABLE z_orders_20240216 LIKE orders;

CREATE TABLE z_orders_20240217 LIKE orders;

CREATE TABLE z_orders_20240218 LIKE orders;

CREATE TABLE z_orders_20240219 LIKE orders;

CREATE TABLE z_orders_20240220 LIKE orders;

CREATE TABLE z_orders_20240221 LIKE orders;

CREATE TABLE z_orders_20240222 LIKE orders;

CREATE TABLE z_orders_20240223 LIKE orders;

CREATE TABLE z_orders_20240224 LIKE orders;

CREATE TABLE z_orders_20240225 LIKE orders;

CREATE TABLE z_orders_20240226 LIKE orders;

CREATE TABLE z_orders_20240227 LIKE orders;

CREATE TABLE z_orders_20240228 LIKE orders;

CREATE TABLE z_orders_20240229 LIKE orders;

CREATE TABLE z_orders_20240301 LIKE orders;

CREATE TABLE z_orders_20240302 LIKE orders;

CREATE TABLE z_orders_20240303 LIKE orders;

CREATE TABLE z_orders_20240304 LIKE orders;

CREATE TABLE z_orders_20240305 LIKE orders;

CREATE TABLE z_orders_20240306 LIKE orders;

CREATE TABLE z_orders_20240307 LIKE orders;

CREATE TABLE z_orders_20240308 LIKE orders;

CREATE TABLE z_orders_20240309 LIKE orders;

CREATE TABLE z_orders_20240310 LIKE orders;

CREATE TABLE z_orders_20240311 LIKE orders;

CREATE TABLE z_orders_20240312 LIKE orders;

CREATE TABLE z_orders_20240313 LIKE orders;

CREATE TABLE z_orders_20240314 LIKE orders;

CREATE TABLE z_orders_20240315 LIKE orders;

CREATE TABLE z_orders_20240316 LIKE orders;

CREATE TABLE z_orders_20240317 LIKE orders;

CREATE TABLE z_orders_20240318 LIKE orders;

CREATE TABLE z_orders_20240319 LIKE orders;

CREATE TABLE z_orders_20240320 LIKE orders;

CREATE TABLE z_orders_20240321 LIKE orders;

CREATE TABLE z_orders_20240322 LIKE orders;

CREATE TABLE z_orders_20240323 LIKE orders;

CREATE TABLE z_orders_20240324 LIKE orders;

CREATE TABLE z_orders_20240325 LIKE orders;

CREATE TABLE z_orders_20240326 LIKE orders;

CREATE TABLE z_orders_20240327 LIKE orders;

CREATE TABLE z_orders_20240328 LIKE orders;

CREATE TABLE z_orders_20240329 LIKE orders;

CREATE TABLE z_orders_20240330 LIKE orders;

CREATE TABLE z_orders_20240331 LIKE orders;

CREATE TABLE z_orders_20240401 LIKE orders;

CREATE TABLE z_orders_20240402 LIKE orders;

CREATE TABLE z_orders_20240403 LIKE orders;

CREATE TABLE z_orders_20240404 LIKE orders;

CREATE TABLE z_orders_20240405 LIKE orders;

CREATE TABLE z_orders_20240406 LIKE orders;

CREATE TABLE z_orders_20240407 LIKE orders;

CREATE TABLE z_orders_20240408 LIKE orders;

CREATE TABLE z_orders_20240409 LIKE orders;

CREATE TABLE z_orders_20240410 LIKE orders;

CREATE TABLE z_orders_20240411 LIKE orders;

CREATE TABLE z_orders_20240412 LIKE orders;

CREATE TABLE z_orders_20240413 LIKE orders;

CREATE TABLE z_orders_20240414 LIKE orders;

CREATE TABLE z_orders_20240415 LIKE orders;

CREATE TABLE z_orders_20240416 LIKE orders;

CREATE TABLE z_orders_20240417 LIKE orders;

CREATE TABLE z_orders_20240418 LIKE orders;

CREATE TABLE z_orders_20240419 LIKE orders;

CREATE TABLE z_orders_20240420 LIKE orders;

CREATE TABLE z_orders_20240421 LIKE orders;

CREATE TABLE z_orders_20240422 LIKE orders;

CREATE TABLE z_orders_20240423 LIKE orders;

CREATE TABLE z_orders_20240424 LIKE orders;

CREATE TABLE z_orders_20240425 LIKE orders;

CREATE TABLE z_orders_20240426 LIKE orders;

CREATE TABLE z_orders_20240427 LIKE orders;

CREATE TABLE z_orders_20240428 LIKE orders;

CREATE TABLE z_orders_20240429 LIKE orders;

CREATE TABLE z_orders_20240430 LIKE orders;

CREATE TABLE z_orders_20240501 LIKE orders;

CREATE TABLE z_orders_20240502 LIKE orders;

CREATE TABLE z_orders_20240503 LIKE orders;

CREATE TABLE z_orders_20240504 LIKE orders;

CREATE TABLE z_orders_20240505 LIKE orders;

CREATE TABLE z_orders_20240506 LIKE orders;

CREATE TABLE z_orders_20240507 LIKE orders;

CREATE TABLE z_orders_20240508 LIKE orders;

CREATE TABLE z_orders_20240509 LIKE orders;

CREATE TABLE z_orders_20240510 LIKE orders;

CREATE TABLE z_orders_20240511 LIKE orders;

CREATE TABLE z_orders_20240512 LIKE orders;

CREATE TABLE z_orders_20240513 LIKE orders;

CREATE TABLE z_orders_20240514 LIKE orders;

CREATE TABLE z_orders_20240515 LIKE orders;

CREATE TABLE z_orders_20240516 LIKE orders;

CREATE TABLE z_orders_20240517 LIKE orders;

CREATE TABLE z_orders_20240518 LIKE orders;

CREATE TABLE z_orders_20240519 LIKE orders;

CREATE TABLE z_orders_20240520 LIKE orders;

CREATE TABLE z_orders_20240521 LIKE orders;

CREATE TABLE z_orders_20240522 LIKE orders;

CREATE TABLE z_orders_20240523 LIKE orders;

CREATE TABLE z_orders_20240524 LIKE orders;

CREATE TABLE z_orders_20240525 LIKE orders;

CREATE TABLE z_orders_20240526 LIKE orders;

CREATE TABLE z_orders_20240527 LIKE orders;

CREATE TABLE z_orders_20240528 LIKE orders;

CREATE TABLE z_orders_20240529 LIKE orders;

CREATE TABLE z_orders_20240530 LIKE orders;

CREATE TABLE z_orders_20240531 LIKE orders;

CREATE TABLE z_orders_20240601 LIKE orders;

CREATE TABLE z_orders_20240602 LIKE orders;

CREATE TABLE z_orders_20240603 LIKE orders;

CREATE TABLE z_orders_20240604 LIKE orders;

CREATE TABLE z_orders_20240605 LIKE orders;

CREATE TABLE z_orders_20240606 LIKE orders;

CREATE TABLE z_orders_20240607 LIKE orders;

CREATE TABLE z_orders_20240608 LIKE orders;

CREATE TABLE z_orders_20240609 LIKE orders;

CREATE TABLE z_orders_20240610 LIKE orders;

CREATE TABLE z_orders_20240611 LIKE orders;

CREATE TABLE z_orders_20240612 LIKE orders;

CREATE TABLE z_orders_20240613 LIKE orders;

CREATE TABLE z_orders_20240614 LIKE orders;

CREATE TABLE z_orders_20240615 LIKE orders;

CREATE TABLE z_orders_20240616 LIKE orders;

CREATE TABLE z_orders_20240617 LIKE orders;

CREATE TABLE z_orders_20240618 LIKE orders;

CREATE TABLE z_orders_20240619 LIKE orders;

CREATE TABLE z_orders_20240620 LIKE orders;

CREATE TABLE z_orders_20240621 LIKE orders;

CREATE TABLE z_orders_20240622 LIKE orders;

CREATE TABLE z_orders_20240623 LIKE orders;

CREATE TABLE z_orders_20240624 LIKE orders;

CREATE TABLE z_orders_20240625 LIKE orders;

CREATE TABLE z_orders_20240626 LIKE orders;

CREATE TABLE z_orders_20240627 LIKE orders;

CREATE TABLE z_orders_20240628 LIKE orders;

CREATE TABLE z_orders_20240629 LIKE orders;

CREATE TABLE z_orders_20240630 LIKE orders;

CREATE TABLE z_orders_20240701 LIKE orders;

CREATE TABLE z_orders_20240702 LIKE orders;

CREATE TABLE z_orders_20240703 LIKE orders;

CREATE TABLE z_orders_20240704 LIKE orders;

CREATE TABLE z_orders_20240705 LIKE orders;

CREATE TABLE z_orders_20240706 LIKE orders;

CREATE TABLE z_orders_20240707 LIKE orders;

CREATE TABLE z_orders_20240708 LIKE orders;

CREATE TABLE z_orders_20240709 LIKE orders;

CREATE TABLE z_orders_20240710 LIKE orders;

CREATE TABLE z_orders_20240711 LIKE orders;

CREATE TABLE z_orders_20240712 LIKE orders;

CREATE TABLE z_orders_20240713 LIKE orders;

CREATE TABLE z_orders_20240714 LIKE orders;

CREATE TABLE z_orders_20240715 LIKE orders;

CREATE TABLE z_orders_20240716 LIKE orders;

CREATE TABLE z_orders_20240717 LIKE orders;

CREATE TABLE z_orders_20240718 LIKE orders;

CREATE TABLE z_orders_20240719 LIKE orders;

CREATE TABLE z_orders_20240720 LIKE orders;

CREATE TABLE z_orders_20240721 LIKE orders;

CREATE TABLE z_orders_20240722 LIKE orders;

CREATE TABLE z_orders_20240723 LIKE orders;

CREATE TABLE z_orders_20240724 LIKE orders;

CREATE TABLE z_orders_20240725 LIKE orders;

CREATE TABLE z_orders_20240726 LIKE orders;

CREATE TABLE z_orders_20240727 LIKE orders;

CREATE TABLE z_orders_20240728 LIKE orders;

CREATE TABLE z_orders_20240729 LIKE orders;

CREATE TABLE z_orders_20240730 LIKE orders;

CREATE TABLE z_orders_20240731 LIKE orders;

CREATE TABLE z_orders_20240801 LIKE orders;

CREATE TABLE z_orders_20240802 LIKE orders;

CREATE TABLE z_orders_20240803 LIKE orders;

CREATE TABLE z_orders_20240804 LIKE orders;

CREATE TABLE z_orders_20240805 LIKE orders;

CREATE TABLE z_orders_20240806 LIKE orders;

CREATE TABLE z_orders_20240807 LIKE orders;

CREATE TABLE z_orders_20240808 LIKE orders;

CREATE TABLE z_orders_20240809 LIKE orders;

CREATE TABLE z_orders_20240810 LIKE orders;

CREATE TABLE z_orders_20240811 LIKE orders;

CREATE TABLE z_orders_20240812 LIKE orders;

CREATE TABLE z_orders_20240813 LIKE orders;

CREATE TABLE z_orders_20240814 LIKE orders;

CREATE TABLE z_orders_20240815 LIKE orders;

CREATE TABLE z_orders_20240816 LIKE orders;

CREATE TABLE z_orders_20240817 LIKE orders;

CREATE TABLE z_orders_20240818 LIKE orders;

CREATE TABLE z_orders_20240819 LIKE orders;

CREATE TABLE z_orders_20240820 LIKE orders;

CREATE TABLE z_orders_20240821 LIKE orders;

CREATE TABLE z_orders_20240822 LIKE orders;

CREATE TABLE z_orders_20240823 LIKE orders;

CREATE TABLE z_orders_20240824 LIKE orders;

CREATE TABLE z_orders_20240825 LIKE orders;

CREATE TABLE z_orders_20240826 LIKE orders;

CREATE TABLE z_orders_20240827 LIKE orders;

CREATE TABLE z_orders_20240828 LIKE orders;

CREATE TABLE z_orders_20240829 LIKE orders;

CREATE TABLE z_orders_20240830 LIKE orders;

CREATE TABLE z_orders_20240831 LIKE orders;

CREATE TABLE z_orders_20240901 LIKE orders;

CREATE TABLE z_orders_20240902 LIKE orders;

CREATE TABLE z_orders_20240903 LIKE orders;

CREATE TABLE z_orders_20240904 LIKE orders;

CREATE TABLE z_orders_20240905 LIKE orders;

CREATE TABLE z_orders_20240906 LIKE orders;

CREATE TABLE z_orders_20240907 LIKE orders;

CREATE TABLE z_orders_20240908 LIKE orders;

CREATE TABLE z_orders_20240909 LIKE orders;

CREATE TABLE z_orders_20240910 LIKE orders;

CREATE TABLE z_orders_20240911 LIKE orders;

CREATE TABLE z_orders_20240912 LIKE orders;

CREATE TABLE z_orders_20240913 LIKE orders;

CREATE TABLE z_orders_20240914 LIKE orders;

CREATE TABLE z_orders_20240915 LIKE orders;

CREATE TABLE z_orders_20240916 LIKE orders;

CREATE TABLE z_orders_20240917 LIKE orders;

CREATE TABLE z_orders_20240918 LIKE orders;

CREATE TABLE z_orders_20240919 LIKE orders;

CREATE TABLE z_orders_20240920 LIKE orders;

CREATE TABLE z_orders_20240921 LIKE orders;

CREATE TABLE z_orders_20240922 LIKE orders;

CREATE TABLE z_orders_20240923 LIKE orders;

CREATE TABLE z_orders_20240924 LIKE orders;

CREATE TABLE z_orders_20240925 LIKE orders;

CREATE TABLE z_orders_20240926 LIKE orders;

CREATE TABLE z_orders_20240927 LIKE orders;

CREATE TABLE z_orders_20240928 LIKE orders;

CREATE TABLE z_orders_20240929 LIKE orders;

CREATE TABLE z_orders_20240930 LIKE orders;

CREATE TABLE z_orders_20241001 LIKE orders;

CREATE TABLE z_orders_20241002 LIKE orders;

CREATE TABLE z_orders_20241003 LIKE orders;

CREATE TABLE z_orders_20241004 LIKE orders;

CREATE TABLE z_orders_20241005 LIKE orders;

CREATE TABLE z_orders_20241006 LIKE orders;

CREATE TABLE z_orders_20241007 LIKE orders;

CREATE TABLE z_orders_20241008 LIKE orders;

CREATE TABLE z_orders_20241009 LIKE orders;

CREATE TABLE z_orders_20241010 LIKE orders;

CREATE TABLE z_orders_20241011 LIKE orders;

CREATE TABLE z_orders_20241012 LIKE orders;

CREATE TABLE z_orders_20241013 LIKE orders;

CREATE TABLE z_orders_20241014 LIKE orders;

CREATE TABLE z_orders_20241015 LIKE orders;

CREATE TABLE z_orders_20241016 LIKE orders;

CREATE TABLE z_orders_20241017 LIKE orders;

CREATE TABLE z_orders_20241018 LIKE orders;

CREATE TABLE z_orders_20241019 LIKE orders;

CREATE TABLE z_orders_20241020 LIKE orders;

CREATE TABLE z_orders_20241021 LIKE orders;

CREATE TABLE z_orders_20241022 LIKE orders;

CREATE TABLE z_orders_20241023 LIKE orders;

CREATE TABLE z_orders_20241024 LIKE orders;

CREATE TABLE z_orders_20241025 LIKE orders;

CREATE TABLE z_orders_20241026 LIKE orders;

CREATE TABLE z_orders_20241027 LIKE orders;

CREATE TABLE z_orders_20241028 LIKE orders;

CREATE TABLE z_orders_20241029 LIKE orders;

CREATE TABLE z_orders_20241030 LIKE orders;

CREATE TABLE z_orders_20241031 LIKE orders;

CREATE TABLE z_orders_20241101 LIKE orders;

CREATE TABLE z_orders_20241102 LIKE orders;

CREATE TABLE z_orders_20241103 LIKE orders;

CREATE TABLE z_orders_20241104 LIKE orders;

CREATE TABLE z_orders_20241105 LIKE orders;

CREATE TABLE z_orders_20241106 LIKE orders;

CREATE TABLE z_orders_20241107 LIKE orders;

CREATE TABLE z_orders_20241108 LIKE orders;

CREATE TABLE z_orders_20241109 LIKE orders;

CREATE TABLE z_orders_20241110 LIKE orders;

CREATE TABLE z_orders_20241111 LIKE orders;

CREATE TABLE z_orders_20241112 LIKE orders;

CREATE TABLE z_orders_20241113 LIKE orders;

CREATE TABLE z_orders_20241114 LIKE orders;

CREATE TABLE z_orders_20241115 LIKE orders;

CREATE TABLE z_orders_20241116 LIKE orders;

CREATE TABLE z_orders_20241117 LIKE orders;

CREATE TABLE z_orders_20241118 LIKE orders;

CREATE TABLE z_orders_20241119 LIKE orders;

CREATE TABLE z_orders_20241120 LIKE orders;

CREATE TABLE z_orders_20241121 LIKE orders;

CREATE TABLE z_orders_20241122 LIKE orders;

CREATE TABLE z_orders_20241123 LIKE orders;

CREATE TABLE z_orders_20241124 LIKE orders;

CREATE TABLE z_orders_20241125 LIKE orders;

CREATE TABLE z_orders_20241126 LIKE orders;

CREATE TABLE z_orders_20241127 LIKE orders;

CREATE TABLE z_orders_20241128 LIKE orders;

CREATE TABLE z_orders_20241129 LIKE orders;

CREATE TABLE z_orders_20241130 LIKE orders;

CREATE TABLE z_orders_20241201 LIKE orders;

CREATE TABLE z_orders_20241202 LIKE orders;

CREATE TABLE z_orders_20241203 LIKE orders;

CREATE TABLE z_orders_20241204 LIKE orders;

CREATE TABLE z_orders_20241205 LIKE orders;

CREATE TABLE z_orders_20241206 LIKE orders;

CREATE TABLE z_orders_20241207 LIKE orders;

CREATE TABLE z_orders_20241208 LIKE orders;

CREATE TABLE z_orders_20241209 LIKE orders;

CREATE TABLE z_orders_20241210 LIKE orders;

CREATE TABLE z_orders_20241211 LIKE orders;

CREATE TABLE z_orders_20241212 LIKE orders;

CREATE TABLE z_orders_20241213 LIKE orders;

CREATE TABLE z_orders_20241214 LIKE orders;

CREATE TABLE z_orders_20241215 LIKE orders;

CREATE TABLE z_orders_20241216 LIKE orders;

CREATE TABLE z_orders_20241217 LIKE orders;

CREATE TABLE z_orders_20241218 LIKE orders;

CREATE TABLE z_orders_20241219 LIKE orders;

CREATE TABLE z_orders_20241220 LIKE orders;

CREATE TABLE z_orders_20241221 LIKE orders;

CREATE TABLE z_orders_20241222 LIKE orders;

CREATE TABLE z_orders_20241223 LIKE orders;

CREATE TABLE z_orders_20241224 LIKE orders;

CREATE TABLE z_orders_20241225 LIKE orders;

CREATE TABLE z_orders_20241226 LIKE orders;

CREATE TABLE z_orders_20241227 LIKE orders;

CREATE TABLE z_orders_20241228 LIKE orders;

CREATE TABLE z_orders_20241229 LIKE orders;

CREATE TABLE z_orders_20241230 LIKE orders;

CREATE TABLE z_orders_20241231 LIKE orders;

CREATE TABLE z_orders_20250101 LIKE orders;

CREATE TABLE z_orders_20250102 LIKE orders;

CREATE TABLE z_orders_20250103 LIKE orders;

CREATE TABLE z_orders_20250104 LIKE orders;

CREATE TABLE z_orders_20250105 LIKE orders;

CREATE TABLE z_orders_20250106 LIKE orders;

CREATE TABLE z_orders_20250107 LIKE orders;

CREATE TABLE z_orders_20250108 LIKE orders;

CREATE TABLE z_orders_20250109 LIKE orders;

CREATE TABLE z_orders_20250110 LIKE orders;

CREATE TABLE z_orders_20250111 LIKE orders;

CREATE TABLE z_orders_20250112 LIKE orders;

CREATE TABLE z_orders_20250113 LIKE orders;

CREATE TABLE z_orders_20250114 LIKE orders;

CREATE TABLE z_orders_20250115 LIKE orders;

CREATE TABLE z_orders_20250116 LIKE orders;

CREATE TABLE z_orders_20250117 LIKE orders;

CREATE TABLE z_orders_20250118 LIKE orders;

CREATE TABLE z_orders_20250119 LIKE orders;

CREATE TABLE z_orders_20250120 LIKE orders;

CREATE TABLE z_orders_20250121 LIKE orders;

CREATE TABLE z_orders_20250122 LIKE orders;

CREATE TABLE z_orders_20250123 LIKE orders;

CREATE TABLE z_orders_20250124 LIKE orders;

CREATE TABLE z_orders_20250125 LIKE orders;

CREATE TABLE z_orders_20250126 LIKE orders;

CREATE TABLE z_orders_20250127 LIKE orders;

CREATE TABLE z_orders_20250128 LIKE orders;

CREATE TABLE z_orders_20250129 LIKE orders;

CREATE TABLE z_orders_20250130 LIKE orders;

CREATE TABLE z_orders_20250131 LIKE orders;

CREATE TABLE z_orders_20250201 LIKE orders;

CREATE TABLE z_orders_20250202 LIKE orders;

CREATE TABLE z_orders_20250203 LIKE orders;

CREATE TABLE z_orders_20250204 LIKE orders;

CREATE TABLE z_orders_20250205 LIKE orders;

CREATE TABLE z_orders_20250206 LIKE orders;

CREATE TABLE z_orders_20250207 LIKE orders;

CREATE TABLE z_orders_20250208 LIKE orders;

CREATE TABLE z_orders_20250209 LIKE orders;

CREATE TABLE z_orders_20250210 LIKE orders;

CREATE TABLE z_orders_20250211 LIKE orders;

CREATE TABLE z_orders_20250212 LIKE orders;

CREATE TABLE z_orders_20250213 LIKE orders;

CREATE TABLE z_orders_20250214 LIKE orders;

CREATE TABLE z_orders_20250215 LIKE orders;

CREATE TABLE z_orders_20250216 LIKE orders;

CREATE TABLE z_orders_20250217 LIKE orders;

CREATE TABLE z_orders_20250218 LIKE orders;

CREATE TABLE z_orders_20250219 LIKE orders;

CREATE TABLE z_orders_20250220 LIKE orders;

CREATE TABLE z_orders_20250221 LIKE orders;

CREATE TABLE z_orders_20250222 LIKE orders;

CREATE TABLE z_orders_20250223 LIKE orders;

CREATE TABLE z_orders_20250224 LIKE orders;

CREATE TABLE z_orders_20250225 LIKE orders;

CREATE TABLE z_orders_20250226 LIKE orders;

CREATE TABLE z_orders_20250227 LIKE orders;

CREATE TABLE z_orders_20250228 LIKE orders;

CREATE TABLE z_orders_20250301 LIKE orders;

CREATE TABLE z_orders_20250302 LIKE orders;

CREATE TABLE z_orders_20250303 LIKE orders;

CREATE TABLE z_orders_20250304 LIKE orders;

CREATE TABLE z_orders_20250305 LIKE orders;

CREATE TABLE z_orders_20250306 LIKE orders;

CREATE TABLE z_orders_20250307 LIKE orders;

CREATE TABLE z_orders_20250308 LIKE orders;

CREATE TABLE z_orders_20250309 LIKE orders;

CREATE TABLE z_orders_20250310 LIKE orders;

CREATE TABLE z_orders_20250311 LIKE orders;

CREATE TABLE z_orders_20250312 LIKE orders;

CREATE TABLE z_orders_20250313 LIKE orders;

CREATE TABLE z_orders_20250314 LIKE orders;

CREATE TABLE z_orders_20250315 LIKE orders;

CREATE TABLE z_orders_20250316 LIKE orders;

CREATE TABLE z_orders_20250317 LIKE orders;

CREATE TABLE z_orders_20250318 LIKE orders;

CREATE TABLE z_orders_20250319 LIKE orders;

CREATE TABLE z_orders_20250320 LIKE orders;

CREATE TABLE z_orders_20250321 LIKE orders;

CREATE TABLE z_orders_20250322 LIKE orders;

CREATE TABLE z_orders_20250323 LIKE orders;

CREATE TABLE z_orders_20250324 LIKE orders;

CREATE TABLE z_orders_20250325 LIKE orders;

CREATE TABLE z_orders_20250326 LIKE orders;

CREATE TABLE z_orders_20250327 LIKE orders;

CREATE TABLE z_orders_20250328 LIKE orders;

CREATE TABLE z_orders_20250329 LIKE orders;

CREATE TABLE z_orders_20250330 LIKE orders;

CREATE TABLE z_orders_20250331 LIKE orders;

CREATE TABLE z_orders_20250401 LIKE orders;

CREATE TABLE z_orders_20250402 LIKE orders;

CREATE TABLE z_orders_20250403 LIKE orders;

CREATE TABLE z_orders_20250404 LIKE orders;

CREATE TABLE z_orders_20250405 LIKE orders;

CREATE TABLE z_orders_20250406 LIKE orders;

CREATE TABLE z_orders_20250407 LIKE orders;

CREATE TABLE z_orders_20250408 LIKE orders;

CREATE TABLE z_orders_20250409 LIKE orders;

CREATE TABLE z_orders_20250410 LIKE orders;

CREATE TABLE z_orders_20250411 LIKE orders;

CREATE TABLE z_orders_20250412 LIKE orders;

CREATE TABLE z_orders_20250413 LIKE orders;

CREATE TABLE z_orders_20250414 LIKE orders;

CREATE TABLE z_orders_20250415 LIKE orders;

CREATE TABLE z_orders_20250416 LIKE orders;

CREATE TABLE z_orders_20250417 LIKE orders;

CREATE TABLE z_orders_20250418 LIKE orders;

CREATE TABLE z_orders_20250419 LIKE orders;

CREATE TABLE z_orders_20250420 LIKE orders;

CREATE TABLE z_orders_20250421 LIKE orders;

CREATE TABLE z_orders_20250422 LIKE orders;

CREATE TABLE z_orders_20250423 LIKE orders;

CREATE TABLE z_orders_20250424 LIKE orders;

CREATE TABLE z_orders_20250425 LIKE orders;

CREATE TABLE z_orders_20250426 LIKE orders;

CREATE TABLE z_orders_20250427 LIKE orders;

CREATE TABLE z_orders_20250428 LIKE orders;

CREATE TABLE z_orders_20250429 LIKE orders;

CREATE TABLE z_orders_20250430 LIKE orders;

CREATE TABLE z_orders_20250501 LIKE orders;

CREATE TABLE z_orders_20250502 LIKE orders;

CREATE TABLE z_orders_20250503 LIKE orders;

CREATE TABLE z_orders_20250504 LIKE orders;

CREATE TABLE z_orders_20250505 LIKE orders;

CREATE TABLE z_orders_20250506 LIKE orders;

CREATE TABLE z_orders_20250507 LIKE orders;

CREATE TABLE z_orders_20250508 LIKE orders;

CREATE TABLE z_orders_20250509 LIKE orders;

CREATE TABLE z_orders_20250510 LIKE orders;

CREATE TABLE z_orders_20250511 LIKE orders;

CREATE TABLE z_orders_20250512 LIKE orders;

CREATE TABLE z_orders_20250513 LIKE orders;

CREATE TABLE z_orders_20250514 LIKE orders;

CREATE TABLE z_orders_20250515 LIKE orders;

CREATE TABLE z_orders_20250516 LIKE orders;

CREATE TABLE z_orders_20250517 LIKE orders;

CREATE TABLE z_orders_20250518 LIKE orders;

CREATE TABLE z_orders_20250519 LIKE orders;

CREATE TABLE z_orders_20250520 LIKE orders;

CREATE TABLE z_orders_20250521 LIKE orders;

CREATE TABLE z_orders_20250522 LIKE orders;

CREATE TABLE z_orders_20250523 LIKE orders;

CREATE TABLE z_orders_20250524 LIKE orders;

CREATE TABLE z_orders_20250525 LIKE orders;

CREATE TABLE z_orders_20250526 LIKE orders;

CREATE TABLE z_orders_20250527 LIKE orders;

CREATE TABLE z_orders_20250528 LIKE orders;

CREATE TABLE z_orders_20250529 LIKE orders;

CREATE TABLE z_orders_20250530 LIKE orders;

CREATE TABLE z_orders_20250531 LIKE orders;

CREATE TABLE z_orders_20250601 LIKE orders;

CREATE TABLE z_orders_20250602 LIKE orders;

CREATE TABLE z_orders_20250603 LIKE orders;

CREATE TABLE z_orders_20250604 LIKE orders;

CREATE TABLE z_orders_20250605 LIKE orders;

CREATE TABLE z_orders_20250606 LIKE orders;

CREATE TABLE z_orders_20250607 LIKE orders;

CREATE TABLE z_orders_20250608 LIKE orders;

CREATE TABLE z_orders_20250609 LIKE orders;

CREATE TABLE z_orders_20250610 LIKE orders;

CREATE TABLE z_orders_20250611 LIKE orders;

CREATE TABLE z_orders_20250612 LIKE orders;

CREATE TABLE z_orders_20250613 LIKE orders;

CREATE TABLE z_orders_20250614 LIKE orders;

CREATE TABLE z_orders_20250615 LIKE orders;

CREATE TABLE z_orders_20250616 LIKE orders;

CREATE TABLE z_orders_20250617 LIKE orders;

CREATE TABLE z_orders_20250618 LIKE orders;

CREATE TABLE z_orders_20250619 LIKE orders;

CREATE TABLE z_orders_20250620 LIKE orders;

CREATE TABLE z_orders_20250621 LIKE orders;

CREATE TABLE z_orders_20250622 LIKE orders;

CREATE TABLE z_orders_20250623 LIKE orders;

CREATE TABLE z_orders_20250624 LIKE orders;

CREATE TABLE z_orders_20250625 LIKE orders;

CREATE TABLE z_orders_20250626 LIKE orders;

CREATE TABLE z_orders_20250627 LIKE orders;

CREATE TABLE z_orders_20250628 LIKE orders;

CREATE TABLE z_orders_20250629 LIKE orders;

CREATE TABLE z_orders_20250630 LIKE orders;

CREATE TABLE z_orders_20250701 LIKE orders;

CREATE TABLE z_orders_20250702 LIKE orders;

CREATE TABLE z_orders_20250703 LIKE orders;

CREATE TABLE z_orders_20250704 LIKE orders;

CREATE TABLE z_orders_20250705 LIKE orders;

CREATE TABLE z_orders_20250706 LIKE orders;

CREATE TABLE z_orders_20250707 LIKE orders;

CREATE TABLE z_orders_20250708 LIKE orders;

CREATE TABLE z_orders_20250709 LIKE orders;

CREATE TABLE z_orders_20250710 LIKE orders;

CREATE TABLE z_orders_20250711 LIKE orders;

CREATE TABLE z_orders_20250712 LIKE orders;

CREATE TABLE z_orders_20250713 LIKE orders;

CREATE TABLE z_orders_20250714 LIKE orders;

CREATE TABLE z_orders_20250715 LIKE orders;

CREATE TABLE z_orders_20250716 LIKE orders;

CREATE TABLE z_orders_20250717 LIKE orders;

CREATE TABLE z_orders_20250718 LIKE orders;

CREATE TABLE z_orders_20250719 LIKE orders;

CREATE TABLE z_orders_20250720 LIKE orders;

CREATE TABLE z_orders_20250721 LIKE orders;

CREATE TABLE z_orders_20250722 LIKE orders;

CREATE TABLE z_orders_20250723 LIKE orders;

CREATE TABLE z_orders_20250724 LIKE orders;

CREATE TABLE z_orders_20250725 LIKE orders;

CREATE TABLE z_orders_20250726 LIKE orders;

CREATE TABLE z_orders_20250727 LIKE orders;

CREATE TABLE z_orders_20250728 LIKE orders;

CREATE TABLE z_orders_20250729 LIKE orders;

CREATE TABLE z_orders_20250730 LIKE orders;

CREATE TABLE z_orders_20250731 LIKE orders;

CREATE TABLE z_orders_20250801 LIKE orders;

CREATE TABLE z_orders_20250802 LIKE orders;

CREATE TABLE z_orders_20250803 LIKE orders;

CREATE TABLE z_orders_20250804 LIKE orders;

CREATE TABLE z_orders_20250805 LIKE orders;

CREATE TABLE z_orders_20250806 LIKE orders;

CREATE TABLE z_orders_20250807 LIKE orders;

CREATE TABLE z_orders_20250808 LIKE orders;

CREATE TABLE z_orders_20250809 LIKE orders;

CREATE TABLE z_orders_20250810 LIKE orders;

CREATE TABLE z_orders_20250811 LIKE orders;

CREATE TABLE z_orders_20250812 LIKE orders;

CREATE TABLE z_orders_20250813 LIKE orders;

CREATE TABLE z_orders_20250814 LIKE orders;

CREATE TABLE z_orders_20250815 LIKE orders;

CREATE TABLE z_orders_20250816 LIKE orders;

CREATE TABLE z_orders_20250817 LIKE orders;

CREATE TABLE z_orders_20250818 LIKE orders;

CREATE TABLE z_orders_20250819 LIKE orders;

CREATE TABLE z_orders_20250820 LIKE orders;

CREATE TABLE z_orders_20250821 LIKE orders;

CREATE TABLE z_orders_20250822 LIKE orders;

CREATE TABLE z_orders_20250823 LIKE orders;

CREATE TABLE z_orders_20250824 LIKE orders;

CREATE TABLE z_orders_20250825 LIKE orders;

CREATE TABLE z_orders_20250826 LIKE orders;

CREATE TABLE z_orders_20250827 LIKE orders;

CREATE TABLE z_orders_20250828 LIKE orders;

CREATE TABLE z_orders_20250829 LIKE orders;

CREATE TABLE z_orders_20250830 LIKE orders;

CREATE TABLE z_orders_20250831 LIKE orders;

CREATE TABLE z_orders_20250901 LIKE orders;

CREATE TABLE z_orders_20250902 LIKE orders;

CREATE TABLE z_orders_20250903 LIKE orders;

CREATE TABLE z_orders_20250904 LIKE orders;

CREATE TABLE z_orders_20250905 LIKE orders;

CREATE TABLE z_orders_20250906 LIKE orders;

CREATE TABLE z_orders_20250907 LIKE orders;

CREATE TABLE z_orders_20250908 LIKE orders;

CREATE TABLE z_orders_20250909 LIKE orders;

CREATE TABLE z_orders_20250910 LIKE orders;

CREATE TABLE z_orders_20250911 LIKE orders;

CREATE TABLE z_orders_20250912 LIKE orders;

CREATE TABLE z_orders_20250913 LIKE orders;

CREATE TABLE z_orders_20250914 LIKE orders;

CREATE TABLE z_orders_20250915 LIKE orders;

CREATE TABLE z_orders_20250916 LIKE orders;

CREATE TABLE z_orders_20250917 LIKE orders;

CREATE TABLE z_orders_20250918 LIKE orders;

CREATE TABLE z_orders_20250919 LIKE orders;

CREATE TABLE z_orders_20250920 LIKE orders;

CREATE TABLE z_orders_20250921 LIKE orders;

CREATE TABLE z_orders_20250922 LIKE orders;

CREATE TABLE z_orders_20250923 LIKE orders;

CREATE TABLE z_orders_20250924 LIKE orders;

CREATE TABLE z_orders_20250925 LIKE orders;

CREATE TABLE z_orders_20250926 LIKE orders;

CREATE TABLE z_orders_20250927 LIKE orders;

CREATE TABLE z_orders_20250928 LIKE orders;

CREATE TABLE z_orders_20250929 LIKE orders;

CREATE TABLE z_orders_20250930 LIKE orders;

CREATE TABLE z_orders_20251001 LIKE orders;

CREATE TABLE z_orders_20251002 LIKE orders;

CREATE TABLE z_orders_20251003 LIKE orders;

CREATE TABLE z_orders_20251004 LIKE orders;

CREATE TABLE z_orders_20251005 LIKE orders;

CREATE TABLE z_orders_20251006 LIKE orders;

CREATE TABLE z_orders_20251007 LIKE orders;

CREATE TABLE z_orders_20251008 LIKE orders;

CREATE TABLE z_orders_20251009 LIKE orders;

CREATE TABLE z_orders_20251010 LIKE orders;

CREATE TABLE z_orders_20251011 LIKE orders;

CREATE TABLE z_orders_20251012 LIKE orders;

CREATE TABLE z_orders_20251013 LIKE orders;

CREATE TABLE z_orders_20251014 LIKE orders;

CREATE TABLE z_orders_20251015 LIKE orders;

CREATE TABLE z_orders_20251016 LIKE orders;

CREATE TABLE z_orders_20251017 LIKE orders;

CREATE TABLE z_orders_20251018 LIKE orders;

CREATE TABLE z_orders_20251019 LIKE orders;

CREATE TABLE z_orders_20251020 LIKE orders;

CREATE TABLE z_orders_20251021 LIKE orders;

CREATE TABLE z_orders_20251022 LIKE orders;

CREATE TABLE z_orders_20251023 LIKE orders;

CREATE TABLE z_orders_20251024 LIKE orders;

CREATE TABLE z_orders_20251025 LIKE orders;

CREATE TABLE z_orders_20251026 LIKE orders;

CREATE TABLE z_orders_20251027 LIKE orders;

CREATE TABLE z_orders_20251028 LIKE orders;

CREATE TABLE z_orders_20251029 LIKE orders;

CREATE TABLE z_orders_20251030 LIKE orders;

CREATE TABLE z_orders_20251031 LIKE orders;

CREATE TABLE z_orders_20251101 LIKE orders;

CREATE TABLE z_orders_20251102 LIKE orders;

CREATE TABLE z_orders_20251103 LIKE orders;

CREATE TABLE z_orders_20251104 LIKE orders;

CREATE TABLE z_orders_20251105 LIKE orders;

CREATE TABLE z_orders_20251106 LIKE orders;

CREATE TABLE z_orders_20251107 LIKE orders;

CREATE TABLE z_orders_20251108 LIKE orders;

CREATE TABLE z_orders_20251109 LIKE orders;

CREATE TABLE z_orders_20251110 LIKE orders;

CREATE TABLE z_orders_20251111 LIKE orders;

CREATE TABLE z_orders_20251112 LIKE orders;

CREATE TABLE z_orders_20251113 LIKE orders;

CREATE TABLE z_orders_20251114 LIKE orders;

CREATE TABLE z_orders_20251115 LIKE orders;

CREATE TABLE z_orders_20251116 LIKE orders;

CREATE TABLE z_orders_20251117 LIKE orders;

CREATE TABLE z_orders_20251118 LIKE orders;

CREATE TABLE z_orders_20251119 LIKE orders;

CREATE TABLE z_orders_20251120 LIKE orders;

CREATE TABLE z_orders_20251121 LIKE orders;

CREATE TABLE z_orders_20251122 LIKE orders;

CREATE TABLE z_orders_20251123 LIKE orders;

CREATE TABLE z_orders_20251124 LIKE orders;

CREATE TABLE z_orders_20251125 LIKE orders;

CREATE TABLE z_orders_20251126 LIKE orders;

CREATE TABLE z_orders_20251127 LIKE orders;

CREATE TABLE z_orders_20251128 LIKE orders;

CREATE TABLE z_orders_20251129 LIKE orders;

CREATE TABLE z_orders_20251130 LIKE orders;

CREATE TABLE z_orders_20251201 LIKE orders;

CREATE TABLE z_orders_20251202 LIKE orders;

CREATE TABLE z_orders_20251203 LIKE orders;

CREATE TABLE z_orders_20251204 LIKE orders;

CREATE TABLE z_orders_20251205 LIKE orders;

CREATE TABLE z_orders_20251206 LIKE orders;

CREATE TABLE z_orders_20251207 LIKE orders;

CREATE TABLE z_orders_20251208 LIKE orders;

CREATE TABLE z_orders_20251209 LIKE orders;

CREATE TABLE z_orders_20251210 LIKE orders;

CREATE TABLE z_orders_20251211 LIKE orders;

CREATE TABLE z_orders_20251212 LIKE orders;

CREATE TABLE z_orders_20251213 LIKE orders;

CREATE TABLE z_orders_20251214 LIKE orders;

CREATE TABLE z_orders_20251215 LIKE orders;

CREATE TABLE z_orders_20251216 LIKE orders;

CREATE TABLE z_orders_20251217 LIKE orders;

CREATE TABLE z_orders_20251218 LIKE orders;

CREATE TABLE z_orders_20251219 LIKE orders;

CREATE TABLE z_orders_20251220 LIKE orders;

CREATE TABLE z_orders_20251221 LIKE orders;

CREATE TABLE z_orders_20251222 LIKE orders;

CREATE TABLE z_orders_20251223 LIKE orders;

CREATE TABLE z_orders_20251224 LIKE orders;

CREATE TABLE z_orders_20251225 LIKE orders;

CREATE TABLE z_orders_20251226 LIKE orders;

CREATE TABLE z_orders_20251227 LIKE orders;

CREATE TABLE z_orders_20251228 LIKE orders;

CREATE TABLE z_orders_20251229 LIKE orders;

CREATE TABLE z_orders_20251230 LIKE orders;

CREATE TABLE z_orders_20251231 LIKE orders;

CREATE TABLE z_orders_20260101 LIKE orders;

CREATE TABLE z_orders_20260102 LIKE orders;

CREATE TABLE z_orders_20260103 LIKE orders;

CREATE TABLE z_orders_20260104 LIKE orders;

CREATE TABLE z_orders_20260105 LIKE orders;

CREATE TABLE z_orders_20260106 LIKE orders;

CREATE TABLE z_orders_20260107 LIKE orders;

CREATE TABLE z_orders_20260108 LIKE orders;

CREATE TABLE z_orders_20260109 LIKE orders;

CREATE TABLE z_orders_20260110 LIKE orders;

CREATE TABLE z_orders_20260111 LIKE orders;

CREATE TABLE z_orders_20260112 LIKE orders;

CREATE TABLE z_orders_20260113 LIKE orders;

CREATE TABLE z_orders_20260114 LIKE orders;

CREATE TABLE z_orders_20260115 LIKE orders;

CREATE TABLE z_orders_20260116 LIKE orders;

CREATE TABLE z_orders_20260117 LIKE orders;

CREATE TABLE z_orders_20260118 LIKE orders;

CREATE TABLE z_orders_20260119 LIKE orders;

CREATE TABLE z_orders_20260120 LIKE orders;

CREATE TABLE z_orders_20260121 LIKE orders;

CREATE TABLE z_orders_20260122 LIKE orders;

CREATE TABLE z_orders_20260123 LIKE orders;

CREATE TABLE z_orders_20260124 LIKE orders;

CREATE TABLE z_orders_20260125 LIKE orders;

CREATE TABLE z_orders_20260126 LIKE orders;

CREATE TABLE z_orders_20260127 LIKE orders;

CREATE TABLE z_orders_20260128 LIKE orders;

CREATE TABLE z_orders_20260129 LIKE orders;

CREATE TABLE z_orders_20260130 LIKE orders;

CREATE TABLE z_orders_20260131 LIKE orders;

CREATE TABLE z_orders_20260201 LIKE orders;

CREATE TABLE z_orders_20260202 LIKE orders;

CREATE TABLE z_orders_20260203 LIKE orders;

CREATE TABLE z_orders_20260204 LIKE orders;

CREATE TABLE z_orders_20260205 LIKE orders;

CREATE TABLE z_orders_20260206 LIKE orders;

CREATE TABLE z_orders_20260207 LIKE orders;

CREATE TABLE z_orders_20260208 LIKE orders;

CREATE TABLE z_orders_20260209 LIKE orders;

CREATE TABLE z_orders_20260210 LIKE orders;

CREATE TABLE z_orders_20260211 LIKE orders;

CREATE TABLE z_orders_20260212 LIKE orders;

CREATE TABLE z_orders_20260213 LIKE orders;

CREATE TABLE z_orders_20260214 LIKE orders;

CREATE TABLE z_orders_20260215 LIKE orders;

CREATE TABLE z_orders_20260216 LIKE orders;

CREATE TABLE z_orders_20260217 LIKE orders;

CREATE TABLE z_orders_20260218 LIKE orders;

CREATE TABLE z_orders_20260219 LIKE orders;

CREATE TABLE z_orders_20260220 LIKE orders;

CREATE TABLE z_orders_20260221 LIKE orders;

CREATE TABLE z_orders_20260222 LIKE orders;

CREATE TABLE z_orders_20260223 LIKE orders;

CREATE TABLE z_orders_20260224 LIKE orders;

CREATE TABLE z_orders_20260225 LIKE orders;

CREATE TABLE z_orders_20260226 LIKE orders;

CREATE TABLE z_orders_20260227 LIKE orders;

CREATE TABLE z_orders_20260228 LIKE orders;

CREATE TABLE z_orders_20260301 LIKE orders;

CREATE TABLE z_orders_20260302 LIKE orders;

CREATE TABLE z_orders_20260303 LIKE orders;

CREATE TABLE z_orders_20260304 LIKE orders;

CREATE TABLE z_orders_20260305 LIKE orders;

CREATE TABLE z_orders_20260306 LIKE orders;

CREATE TABLE z_orders_20260307 LIKE orders;

CREATE TABLE z_orders_20260308 LIKE orders;

CREATE TABLE z_orders_20260309 LIKE orders;

CREATE TABLE z_orders_20260310 LIKE orders;

CREATE TABLE z_orders_20260311 LIKE orders;

CREATE TABLE z_orders_20260312 LIKE orders;

CREATE TABLE z_orders_20260313 LIKE orders;

CREATE TABLE z_orders_20260314 LIKE orders;

CREATE TABLE z_orders_20260315 LIKE orders;

CREATE TABLE z_orders_20260316 LIKE orders;

CREATE TABLE z_orders_20260317 LIKE orders;

CREATE TABLE z_orders_20260318 LIKE orders;

CREATE TABLE z_orders_20260319 LIKE orders;

CREATE TABLE z_orders_20260320 LIKE orders;

CREATE TABLE z_orders_20260321 LIKE orders;

CREATE TABLE z_orders_20260322 LIKE orders;

CREATE TABLE z_orders_20260323 LIKE orders;

CREATE TABLE z_orders_20260324 LIKE orders;

CREATE TABLE z_orders_20260325 LIKE orders;

CREATE TABLE z_orders_20260326 LIKE orders;

CREATE TABLE z_orders_20260327 LIKE orders;

CREATE TABLE z_orders_20260328 LIKE orders;

CREATE TABLE z_orders_20260329 LIKE orders;

CREATE TABLE z_orders_20260330 LIKE orders;

CREATE TABLE z_orders_20260331 LIKE orders;

CREATE TABLE z_orders_20260401 LIKE orders;

CREATE TABLE z_orders_20260402 LIKE orders;

CREATE TABLE z_orders_20260403 LIKE orders;

CREATE TABLE z_orders_20260404 LIKE orders;

CREATE TABLE z_orders_20260405 LIKE orders;

CREATE TABLE z_orders_20260406 LIKE orders;

CREATE TABLE z_orders_20260407 LIKE orders;

CREATE TABLE z_orders_20260408 LIKE orders;

CREATE TABLE z_orders_20260409 LIKE orders;

CREATE TABLE z_orders_20260410 LIKE orders;

CREATE TABLE z_orders_20260411 LIKE orders;

CREATE TABLE z_orders_20260412 LIKE orders;

CREATE TABLE z_orders_20260413 LIKE orders;

CREATE TABLE z_orders_20260414 LIKE orders;

CREATE TABLE z_orders_20260415 LIKE orders;

CREATE TABLE z_orders_20260416 LIKE orders;

CREATE TABLE z_orders_20260417 LIKE orders;

CREATE TABLE z_orders_20260418 LIKE orders;

CREATE TABLE z_orders_20260419 LIKE orders;

CREATE TABLE z_orders_20260420 LIKE orders;

CREATE TABLE z_orders_20260421 LIKE orders;

CREATE TABLE z_orders_20260422 LIKE orders;

CREATE TABLE z_orders_20260423 LIKE orders;

CREATE TABLE z_orders_20260424 LIKE orders;

CREATE TABLE z_orders_20260425 LIKE orders;

CREATE TABLE z_orders_20260426 LIKE orders;

CREATE TABLE z_orders_20260427 LIKE orders;

CREATE TABLE z_orders_20260428 LIKE orders;

CREATE TABLE z_orders_20260429 LIKE orders;

CREATE TABLE z_orders_20260430 LIKE orders;

CREATE TABLE z_orders_20260501 LIKE orders;

CREATE TABLE z_orders_20260502 LIKE orders;

CREATE TABLE z_orders_20260503 LIKE orders;

CREATE TABLE z_orders_20260504 LIKE orders;

CREATE TABLE z_orders_20260505 LIKE orders;

CREATE TABLE z_orders_20260506 LIKE orders;

CREATE TABLE z_orders_20260507 LIKE orders;

CREATE TABLE z_orders_20260508 LIKE orders;

CREATE TABLE z_orders_20260509 LIKE orders;

CREATE TABLE z_orders_20260510 LIKE orders;

CREATE TABLE z_orders_20260511 LIKE orders;

CREATE TABLE z_orders_20260512 LIKE orders;

CREATE TABLE z_orders_20260513 LIKE orders;

CREATE TABLE z_orders_20260514 LIKE orders;

CREATE TABLE z_orders_20260515 LIKE orders;

CREATE TABLE z_orders_20260516 LIKE orders;

CREATE TABLE z_orders_20260517 LIKE orders;

CREATE TABLE z_orders_20260518 LIKE orders;

CREATE TABLE z_orders_20260519 LIKE orders;

CREATE TABLE z_orders_20260520 LIKE orders;

CREATE TABLE z_orders_20260521 LIKE orders;

CREATE TABLE z_orders_20260522 LIKE orders;

CREATE TABLE z_orders_20260523 LIKE orders;

CREATE TABLE z_orders_20260524 LIKE orders;

CREATE TABLE z_orders_20260525 LIKE orders;

CREATE TABLE z_orders_20260526 LIKE orders;

CREATE TABLE z_orders_20260527 LIKE orders;

CREATE TABLE z_orders_20260528 LIKE orders;

CREATE TABLE z_orders_20260529 LIKE orders;

CREATE TABLE z_orders_20260530 LIKE orders;

CREATE TABLE z_orders_20260531 LIKE orders;

CREATE TABLE z_orders_20260601 LIKE orders;

CREATE TABLE z_orders_20260602 LIKE orders;

CREATE TABLE z_orders_20260603 LIKE orders;

CREATE TABLE z_orders_20260604 LIKE orders;

CREATE TABLE z_orders_20260605 LIKE orders;

CREATE TABLE z_orders_20260606 LIKE orders;

CREATE TABLE z_orders_20260607 LIKE orders;

CREATE TABLE z_orders_20260608 LIKE orders;

CREATE TABLE z_orders_20260609 LIKE orders;

CREATE TABLE z_orders_20260610 LIKE orders;

CREATE TABLE z_orders_20260611 LIKE orders;

CREATE TABLE z_orders_20260612 LIKE orders;

CREATE TABLE z_orders_20260613 LIKE orders;

CREATE TABLE z_orders_20260614 LIKE orders;

CREATE TABLE z_orders_20260615 LIKE orders;

CREATE TABLE z_orders_20260616 LIKE orders;

CREATE TABLE z_orders_20260617 LIKE orders;

CREATE TABLE z_orders_20260618 LIKE orders;

CREATE TABLE z_orders_20260619 LIKE orders;

CREATE TABLE z_orders_20260620 LIKE orders;

CREATE TABLE z_orders_20260621 LIKE orders;

CREATE TABLE z_orders_20260622 LIKE orders;

CREATE TABLE z_orders_20260623 LIKE orders;

CREATE TABLE z_orders_20260624 LIKE orders;

CREATE TABLE z_orders_20260625 LIKE orders;

CREATE TABLE z_orders_20260626 LIKE orders;

CREATE TABLE z_orders_20260627 LIKE orders;

CREATE TABLE z_orders_20260628 LIKE orders;

CREATE TABLE z_orders_20260629 LIKE orders;

CREATE TABLE z_orders_20260630 LIKE orders;

CREATE TABLE z_orders_20260701 LIKE orders;

CREATE TABLE z_orders_20260702 LIKE orders;

CREATE TABLE z_orders_20260703 LIKE orders;

CREATE TABLE z_orders_20260704 LIKE orders;

CREATE TABLE z_orders_20260705 LIKE orders;

CREATE TABLE z_orders_20260706 LIKE orders;

CREATE TABLE z_orders_20260707 LIKE orders;

CREATE TABLE z_orders_20260708 LIKE orders;

CREATE TABLE z_orders_20260709 LIKE orders;

CREATE TABLE z_orders_20260710 LIKE orders;

CREATE TABLE z_orders_20260711 LIKE orders;

CREATE TABLE z_orders_20260712 LIKE orders;

CREATE TABLE z_orders_20260713 LIKE orders;

CREATE TABLE z_orders_20260714 LIKE orders;

CREATE TABLE z_orders_20260715 LIKE orders;

CREATE TABLE z_orders_20260716 LIKE orders;

CREATE TABLE z_orders_20260717 LIKE orders;

CREATE TABLE z_orders_20260718 LIKE orders;

CREATE TABLE z_orders_20260719 LIKE orders;

CREATE TABLE z_orders_20260720 LIKE orders;

CREATE TABLE z_orders_20260721 LIKE orders;

CREATE TABLE z_orders_20260722 LIKE orders;

CREATE TABLE z_orders_20260723 LIKE orders;

CREATE TABLE z_orders_20260724 LIKE orders;

CREATE TABLE z_orders_20260725 LIKE orders;

CREATE TABLE z_orders_20260726 LIKE orders;

CREATE TABLE z_orders_20260727 LIKE orders;

CREATE TABLE z_orders_20260728 LIKE orders;

CREATE TABLE z_orders_20260729 LIKE orders;

CREATE TABLE z_orders_20260730 LIKE orders;

CREATE TABLE z_orders_20260731 LIKE orders;

CREATE TABLE z_orders_20260801 LIKE orders;

CREATE TABLE z_orders_20260802 LIKE orders;

CREATE TABLE z_orders_20260803 LIKE orders;

CREATE TABLE z_orders_20260804 LIKE orders;

CREATE TABLE z_orders_20260805 LIKE orders;

CREATE TABLE z_orders_20260806 LIKE orders;

CREATE TABLE z_orders_20260807 LIKE orders;

CREATE TABLE z_orders_20260808 LIKE orders;

CREATE TABLE z_orders_20260809 LIKE orders;

CREATE TABLE z_orders_20260810 LIKE orders;

CREATE TABLE z_orders_20260811 LIKE orders;

CREATE TABLE z_orders_20260812 LIKE orders;

CREATE TABLE z_orders_20260813 LIKE orders;

CREATE TABLE z_orders_20260814 LIKE orders;

CREATE TABLE z_orders_20260815 LIKE orders;

CREATE TABLE z_orders_20260816 LIKE orders;

CREATE TABLE z_orders_20260817 LIKE orders;

CREATE TABLE z_orders_20260818 LIKE orders;

CREATE TABLE z_orders_20260819 LIKE orders;

CREATE TABLE z_orders_20260820 LIKE orders;

CREATE TABLE z_orders_20260821 LIKE orders;

CREATE TABLE z_orders_20260822 LIKE orders;

CREATE TABLE z_orders_20260823 LIKE orders;

CREATE TABLE z_orders_20260824 LIKE orders;

CREATE TABLE z_orders_20260825 LIKE orders;

CREATE TABLE z_orders_20260826 LIKE orders;

CREATE TABLE z_orders_20260827 LIKE orders;

CREATE TABLE z_orders_20260828 LIKE orders;

CREATE TABLE z_orders_20260829 LIKE orders;

CREATE TABLE z_orders_20260830 LIKE orders;

CREATE TABLE z_orders_20260831 LIKE orders;

CREATE TABLE z_orders_20260901 LIKE orders;

CREATE TABLE z_orders_20260902 LIKE orders;

CREATE TABLE z_orders_20260903 LIKE orders;

CREATE TABLE z_orders_20260904 LIKE orders;

CREATE TABLE z_orders_20260905 LIKE orders;

CREATE TABLE z_orders_20260906 LIKE orders;

CREATE TABLE z_orders_20260907 LIKE orders;

CREATE TABLE z_orders_20260908 LIKE orders;

CREATE TABLE z_orders_20260909 LIKE orders;

CREATE TABLE z_orders_20260910 LIKE orders;

CREATE TABLE z_orders_20260911 LIKE orders;

CREATE TABLE z_orders_20260912 LIKE orders;

CREATE TABLE z_orders_20260913 LIKE orders;

CREATE TABLE z_orders_20260914 LIKE orders;

CREATE TABLE z_orders_20260915 LIKE orders;

CREATE TABLE z_orders_20260916 LIKE orders;

CREATE TABLE z_orders_20260917 LIKE orders;

CREATE TABLE z_orders_20260918 LIKE orders;

CREATE TABLE z_orders_20260919 LIKE orders;

CREATE TABLE z_orders_20260920 LIKE orders;

CREATE TABLE z_orders_20260921 LIKE orders;

CREATE TABLE z_orders_20260922 LIKE orders;

CREATE TABLE z_orders_20260923 LIKE orders;

CREATE TABLE z_orders_20260924 LIKE orders;

CREATE TABLE z_orders_20260925 LIKE orders;

CREATE TABLE z_orders_20260926 LIKE orders;

CREATE TABLE z_orders_20260927 LIKE orders;

CREATE TABLE z_orders_20260928 LIKE orders;

CREATE TABLE z_orders_20260929 LIKE orders;

CREATE TABLE z_orders_20260930 LIKE orders;

CREATE TABLE z_orders_20261001 LIKE orders;

CREATE TABLE z_orders_20261002 LIKE orders;

CREATE TABLE z_orders_20261003 LIKE orders;

CREATE TABLE z_orders_20261004 LIKE orders;

CREATE TABLE z_orders_20261005 LIKE orders;

CREATE TABLE z_orders_20261006 LIKE orders;

CREATE TABLE z_orders_20261007 LIKE orders;

CREATE TABLE z_orders_20261008 LIKE orders;

CREATE TABLE z_orders_20261009 LIKE orders;

CREATE TABLE z_orders_20261010 LIKE orders;

CREATE TABLE z_orders_20261011 LIKE orders;

CREATE TABLE z_orders_20261012 LIKE orders;

CREATE TABLE z_orders_20261013 LIKE orders;

CREATE TABLE z_orders_20261014 LIKE orders;

CREATE TABLE z_orders_20261015 LIKE orders;

CREATE TABLE z_orders_20261016 LIKE orders;

CREATE TABLE z_orders_20261017 LIKE orders;

CREATE TABLE z_orders_20261018 LIKE orders;

CREATE TABLE z_orders_20261019 LIKE orders;

CREATE TABLE z_orders_20261020 LIKE orders;

CREATE TABLE z_orders_20261021 LIKE orders;

CREATE TABLE z_orders_20261022 LIKE orders;

CREATE TABLE z_orders_20261023 LIKE orders;

CREATE TABLE z_orders_20261024 LIKE orders;

CREATE TABLE z_orders_20261025 LIKE orders;

CREATE TABLE z_orders_20261026 LIKE orders;

CREATE TABLE z_orders_20261027 LIKE orders;

CREATE TABLE z_orders_20261028 LIKE orders;

CREATE TABLE z_orders_20261029 LIKE orders;

CREATE TABLE z_orders_20261030 LIKE orders;

CREATE TABLE z_orders_20261031 LIKE orders;

CREATE TABLE z_orders_20261101 LIKE orders;

CREATE TABLE z_orders_20261102 LIKE orders;

CREATE TABLE z_orders_20261103 LIKE orders;

CREATE TABLE z_orders_20261104 LIKE orders;

CREATE TABLE z_orders_20261105 LIKE orders;

CREATE TABLE z_orders_20261106 LIKE orders;

CREATE TABLE z_orders_20261107 LIKE orders;

CREATE TABLE z_orders_20261108 LIKE orders;

CREATE TABLE z_orders_20261109 LIKE orders;

CREATE TABLE z_orders_20261110 LIKE orders;

CREATE TABLE z_orders_20261111 LIKE orders;

CREATE TABLE z_orders_20261112 LIKE orders;

CREATE TABLE z_orders_20261113 LIKE orders;

CREATE TABLE z_orders_20261114 LIKE orders;

CREATE TABLE z_orders_20261115 LIKE orders;

CREATE TABLE z_orders_20261116 LIKE orders;

CREATE TABLE z_orders_20261117 LIKE orders;

CREATE TABLE z_orders_20261118 LIKE orders;

CREATE TABLE z_orders_20261119 LIKE orders;

CREATE TABLE z_orders_20261120 LIKE orders;

CREATE TABLE z_orders_20261121 LIKE orders;

CREATE TABLE z_orders_20261122 LIKE orders;

CREATE TABLE z_orders_20261123 LIKE orders;

CREATE TABLE z_orders_20261124 LIKE orders;

CREATE TABLE z_orders_20261125 LIKE orders;

CREATE TABLE z_orders_20261126 LIKE orders;

CREATE TABLE z_orders_20261127 LIKE orders;

CREATE TABLE z_orders_20261128 LIKE orders;

CREATE TABLE z_orders_20261129 LIKE orders;

CREATE TABLE z_orders_20261130 LIKE orders;

CREATE TABLE z_orders_20261201 LIKE orders;

CREATE TABLE z_orders_20261202 LIKE orders;

CREATE TABLE z_orders_20261203 LIKE orders;

CREATE TABLE z_orders_20261204 LIKE orders;

CREATE TABLE z_orders_20261205 LIKE orders;

CREATE TABLE z_orders_20261206 LIKE orders;

CREATE TABLE z_orders_20261207 LIKE orders;

CREATE TABLE z_orders_20261208 LIKE orders;

CREATE TABLE z_orders_20261209 LIKE orders;

CREATE TABLE z_orders_20261210 LIKE orders;

CREATE TABLE z_orders_20261211 LIKE orders;

CREATE TABLE z_orders_20261212 LIKE orders;

CREATE TABLE z_orders_20261213 LIKE orders;

CREATE TABLE z_orders_20261214 LIKE orders;

CREATE TABLE z_orders_20261215 LIKE orders;

CREATE TABLE z_orders_20261216 LIKE orders;

CREATE TABLE z_orders_20261217 LIKE orders;

CREATE TABLE z_orders_20261218 LIKE orders;

CREATE TABLE z_orders_20261219 LIKE orders;

CREATE TABLE z_orders_20261220 LIKE orders;

CREATE TABLE z_orders_20261221 LIKE orders;

CREATE TABLE z_orders_20261222 LIKE orders;

CREATE TABLE z_orders_20261223 LIKE orders;

CREATE TABLE z_orders_20261224 LIKE orders;

CREATE TABLE z_orders_20261225 LIKE orders;

CREATE TABLE z_orders_20261226 LIKE orders;

CREATE TABLE z_orders_20261227 LIKE orders;

CREATE TABLE z_orders_20261228 LIKE orders;

CREATE TABLE z_orders_20261229 LIKE orders;

CREATE TABLE z_orders_20261230 LIKE orders;

CREATE TABLE z_orders_20261231 LIKE orders;

CREATE TABLE z_orders_20270101 LIKE orders;

CREATE TABLE z_orders_20270102 LIKE orders;

CREATE TABLE z_orders_20270103 LIKE orders;

CREATE TABLE z_orders_20270104 LIKE orders;

CREATE TABLE z_orders_20270105 LIKE orders;

CREATE TABLE z_orders_20270106 LIKE orders;

CREATE TABLE z_orders_20270107 LIKE orders;

CREATE TABLE z_orders_20270108 LIKE orders;

CREATE TABLE z_orders_20270109 LIKE orders;

CREATE TABLE z_orders_20270110 LIKE orders;

CREATE TABLE z_orders_20270111 LIKE orders;

CREATE TABLE z_orders_20270112 LIKE orders;

CREATE TABLE z_orders_20270113 LIKE orders;

CREATE TABLE z_orders_20270114 LIKE orders;

CREATE TABLE z_orders_20270115 LIKE orders;

CREATE TABLE z_orders_20270116 LIKE orders;

CREATE TABLE z_orders_20270117 LIKE orders;

CREATE TABLE z_orders_20270118 LIKE orders;

CREATE TABLE z_orders_20270119 LIKE orders;

CREATE TABLE z_orders_20270120 LIKE orders;

CREATE TABLE z_orders_20270121 LIKE orders;

CREATE TABLE z_orders_20270122 LIKE orders;

CREATE TABLE z_orders_20270123 LIKE orders;

CREATE TABLE z_orders_20270124 LIKE orders;

CREATE TABLE z_orders_20270125 LIKE orders;

CREATE TABLE z_orders_20270126 LIKE orders;

CREATE TABLE z_orders_20270127 LIKE orders;

CREATE TABLE z_orders_20270128 LIKE orders;

CREATE TABLE z_orders_20270129 LIKE orders;

CREATE TABLE z_orders_20270130 LIKE orders;

CREATE TABLE z_orders_20270131 LIKE orders;

CREATE TABLE z_orders_20270201 LIKE orders;

CREATE TABLE z_orders_20270202 LIKE orders;

CREATE TABLE z_orders_20270203 LIKE orders;

CREATE TABLE z_orders_20270204 LIKE orders;

CREATE TABLE z_orders_20270205 LIKE orders;

CREATE TABLE z_orders_20270206 LIKE orders;

CREATE TABLE z_orders_20270207 LIKE orders;

CREATE TABLE z_orders_20270208 LIKE orders;

CREATE TABLE z_orders_20270209 LIKE orders;

CREATE TABLE z_orders_20270210 LIKE orders;

CREATE TABLE z_orders_20270211 LIKE orders;

CREATE TABLE z_orders_20270212 LIKE orders;

CREATE TABLE z_orders_20270213 LIKE orders;

CREATE TABLE z_orders_20270214 LIKE orders;

CREATE TABLE z_orders_20270215 LIKE orders;

CREATE TABLE z_orders_20270216 LIKE orders;

CREATE TABLE z_orders_20270217 LIKE orders;

CREATE TABLE z_orders_20270218 LIKE orders;

CREATE TABLE z_orders_20270219 LIKE orders;

CREATE TABLE z_orders_20270220 LIKE orders;

CREATE TABLE z_orders_20270221 LIKE orders;

CREATE TABLE z_orders_20270222 LIKE orders;

CREATE TABLE z_orders_20270223 LIKE orders;

CREATE TABLE z_orders_20270224 LIKE orders;

CREATE TABLE z_orders_20270225 LIKE orders;

CREATE TABLE z_orders_20270226 LIKE orders;

CREATE TABLE z_orders_20270227 LIKE orders;

CREATE TABLE z_orders_20270228 LIKE orders;

CREATE TABLE z_orders_20270301 LIKE orders;

CREATE TABLE z_orders_20270302 LIKE orders;

CREATE TABLE z_orders_20270303 LIKE orders;

CREATE TABLE z_orders_20270304 LIKE orders;

CREATE TABLE z_orders_20270305 LIKE orders;

CREATE TABLE z_orders_20270306 LIKE orders;

CREATE TABLE z_orders_20270307 LIKE orders;

CREATE TABLE z_orders_20270308 LIKE orders;

CREATE TABLE z_orders_20270309 LIKE orders;

CREATE TABLE z_orders_20270310 LIKE orders;

CREATE TABLE z_orders_20270311 LIKE orders;

CREATE TABLE z_orders_20270312 LIKE orders;

CREATE TABLE z_orders_20270313 LIKE orders;

CREATE TABLE z_orders_20270314 LIKE orders;

CREATE TABLE z_orders_20270315 LIKE orders;

CREATE TABLE z_orders_20270316 LIKE orders;

CREATE TABLE z_orders_20270317 LIKE orders;

CREATE TABLE z_orders_20270318 LIKE orders;

CREATE TABLE z_orders_20270319 LIKE orders;

CREATE TABLE z_orders_20270320 LIKE orders;

CREATE TABLE z_orders_20270321 LIKE orders;

CREATE TABLE z_orders_20270322 LIKE orders;

CREATE TABLE z_orders_20270323 LIKE orders;

CREATE TABLE z_orders_20270324 LIKE orders;

CREATE TABLE z_orders_20270325 LIKE orders;

CREATE TABLE z_orders_20270326 LIKE orders;

CREATE TABLE z_orders_20270327 LIKE orders;

CREATE TABLE z_orders_20270328 LIKE orders;

CREATE TABLE z_orders_20270329 LIKE orders;

CREATE TABLE z_orders_20270330 LIKE orders;

CREATE TABLE z_orders_20270331 LIKE orders;

CREATE TABLE z_orders_20270401 LIKE orders;

CREATE TABLE z_orders_20270402 LIKE orders;

CREATE TABLE z_orders_20270403 LIKE orders;

CREATE TABLE z_orders_20270404 LIKE orders;

CREATE TABLE z_orders_20270405 LIKE orders;

CREATE TABLE z_orders_20270406 LIKE orders;

CREATE TABLE z_orders_20270407 LIKE orders;

CREATE TABLE z_orders_20270408 LIKE orders;

CREATE TABLE z_orders_20270409 LIKE orders;

CREATE TABLE z_orders_20270410 LIKE orders;

CREATE TABLE z_orders_20270411 LIKE orders;

CREATE TABLE z_orders_20270412 LIKE orders;

CREATE TABLE z_orders_20270413 LIKE orders;

CREATE TABLE z_orders_20270414 LIKE orders;

CREATE TABLE z_orders_20270415 LIKE orders;

CREATE TABLE z_orders_20270416 LIKE orders;

CREATE TABLE z_orders_20270417 LIKE orders;

CREATE TABLE z_orders_20270418 LIKE orders;

CREATE TABLE z_orders_20270419 LIKE orders;

CREATE TABLE z_orders_20270420 LIKE orders;

CREATE TABLE z_orders_20270421 LIKE orders;

CREATE TABLE z_orders_20270422 LIKE orders;

CREATE TABLE z_orders_20270423 LIKE orders;

CREATE TABLE z_orders_20270424 LIKE orders;

CREATE TABLE z_orders_20270425 LIKE orders;

CREATE TABLE z_orders_20270426 LIKE orders;

CREATE TABLE z_orders_20270427 LIKE orders;

CREATE TABLE z_orders_20270428 LIKE orders;

CREATE TABLE z_orders_20270429 LIKE orders;

CREATE TABLE z_orders_20270430 LIKE orders;

CREATE TABLE z_orders_20270501 LIKE orders;

CREATE TABLE z_orders_20270502 LIKE orders;

CREATE TABLE z_orders_20270503 LIKE orders;

CREATE TABLE z_orders_20270504 LIKE orders;

CREATE TABLE z_orders_20270505 LIKE orders;

CREATE TABLE z_orders_20270506 LIKE orders;

CREATE TABLE z_orders_20270507 LIKE orders;

CREATE TABLE z_orders_20270508 LIKE orders;

CREATE TABLE z_orders_20270509 LIKE orders;

CREATE TABLE z_orders_20270510 LIKE orders;

CREATE TABLE z_orders_20270511 LIKE orders;

CREATE TABLE z_orders_20270512 LIKE orders;

CREATE TABLE z_orders_20270513 LIKE orders;

CREATE TABLE z_orders_20270514 LIKE orders;

CREATE TABLE z_orders_20270515 LIKE orders;

CREATE TABLE z_orders_20270516 LIKE orders;

CREATE TABLE z_orders_20270517 LIKE orders;

CREATE TABLE z_orders_20270518 LIKE orders;

CREATE TABLE z_orders_20270519 LIKE orders;

CREATE TABLE z_orders_20270520 LIKE orders;

CREATE TABLE z_orders_20270521 LIKE orders;

CREATE TABLE z_orders_20270522 LIKE orders;

CREATE TABLE z_orders_20270523 LIKE orders;

CREATE TABLE z_orders_20270524 LIKE orders;

CREATE TABLE z_orders_20270525 LIKE orders;

CREATE TABLE z_orders_20270526 LIKE orders;

CREATE TABLE z_orders_20270527 LIKE orders;

CREATE TABLE z_orders_20270528 LIKE orders;

CREATE TABLE z_orders_20270529 LIKE orders;

CREATE TABLE z_orders_20270530 LIKE orders;

CREATE TABLE z_orders_20270531 LIKE orders;

CREATE TABLE z_orders_20270601 LIKE orders;

CREATE TABLE z_orders_20270602 LIKE orders;

CREATE TABLE z_orders_20270603 LIKE orders;

CREATE TABLE z_orders_20270604 LIKE orders;

CREATE TABLE z_orders_20270605 LIKE orders;

CREATE TABLE z_orders_20270606 LIKE orders;

CREATE TABLE z_orders_20270607 LIKE orders;

CREATE TABLE z_orders_20270608 LIKE orders;

CREATE TABLE z_orders_20270609 LIKE orders;

CREATE TABLE z_orders_20270610 LIKE orders;

CREATE TABLE z_orders_20270611 LIKE orders;

CREATE TABLE z_orders_20270612 LIKE orders;

CREATE TABLE z_orders_20270613 LIKE orders;

CREATE TABLE z_orders_20270614 LIKE orders;

CREATE TABLE z_orders_20270615 LIKE orders;

CREATE TABLE z_orders_20270616 LIKE orders;

CREATE TABLE z_orders_20270617 LIKE orders;

CREATE TABLE z_orders_20270618 LIKE orders;

CREATE TABLE z_orders_20270619 LIKE orders;

CREATE TABLE z_orders_20270620 LIKE orders;

CREATE TABLE z_orders_20270621 LIKE orders;

CREATE TABLE z_orders_20270622 LIKE orders;

CREATE TABLE z_orders_20270623 LIKE orders;

drop table if exists orders;

-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------
WITH product_ascription AS (
  SELECT
    a.product,
    department,
    team,
    owner
  FROM
    pofa.ascriptions a
    join (
      SELECT
        product,
        max(start_time) as start_time
      FROM
        pofa.ascriptions
      where
        start_time <= 20220821
      group by
        product
    ) as b on a.product = b.product
    and a.start_time = b.start_time
),
manufacturers_temp AS (
  SELECT
    a.product_id,
    freight,
    freight_to_payment,
    a.start_time,
    create_time
  FROM
    pofa.manufacturers a
    join (
      SELECT
        product_id,
        max(start_time) as start_time
      FROM
        pofa.manufacturers
      where
        start_time <= 20220821
      group by
        product_id
    ) as b on a.product_id = b.product_id
    and a.start_time = b.start_time
),
product_manufacturers AS (
  SELECT
    a.product_id,
    freight,
    freight_to_payment,
    a.start_time
  FROM
    manufacturers_temp a
    join (
      SELECT
        product_id,
        max(create_time) as create_time
      FROM
        manufacturers_temp
      group by
        product_id
    ) as b on a.product_id = b.product_id
    and a.create_time = b.create_time
),
first_category_temp AS (
  SELECT
    a.category_id,
    deduction,
    insurance,
    a.start_time,
    create_time
  FROM
    pofa.categoryhistorys a
    join (
      SELECT
        category_id,
        max(start_time) as start_time
      FROM
        pofa.categoryhistorys
      where
        start_time <= 20220821
      group by
        category_id
    ) as b on a.category_id = b.category_id
    and a.start_time = b.start_time
),
first_category AS (
  SELECT
    a.category_id,
    deduction,
    insurance,
    a.start_time
  FROM
    first_category_temp a
    join (
      SELECT
        category_id,
        max(create_time) as create_time
      FROM
        first_category_temp
      group by
        category_id
    ) as b on a.category_id = b.category_id
    and a.create_time = b.create_time
),
product_orders AS (
  select
    z_orders_20220821.product_id,
    product_count,
    actual_amount,
    sku_name
  from
    product_ascription
    join z_orders_20220821 on z_orders_20220821.product_id = product_ascription.product
),
a AS (
  SELECT
    product_id,
    count(*) as order_count,
    sum(product_count) as product_count,
    sum(actual_amount) as total_amount
  FROM
    product_orders
  GROUP BY
    product_id
),
skus_temp AS (
  SELECT
    a.sku_id,
    sku_name,
    sku_price,
    sku_cost,
    a.product_id,
    a.start_time,
    create_time
  FROM
    pofa.skus a
    join (
      SELECT
        sku_id,
        max(start_time) as start_time
      FROM
        pofa.skus
      where
        start_time <= 20220821
      group by
        sku_id
    ) as b on a.sku_id = b.sku_id
    and a.start_time = b.start_time
),
product_sku AS(
  SELECT
    a.sku_id,
    a.product_id,
    sku_price,
    sku_cost,
    sku_name,
    a.start_time
  FROM
    skus_temp a
    join (
      SELECT
        sku_id,
        max(create_time) as create_time
      FROM
        skus_temp
      group by
        sku_id
    ) as b on a.sku_id = b.sku_id
    and a.create_time = b.create_time
),
sku_info AS (
  select
    product_id,
    sum(total_price) as total_price,
    sum(total_cost) as total_cost,
    count(*) - count(sku_price) as wrong_count
  from
    (
      select
        a.product_id,
        a.sku_name,
        product_count,
        sku_price,
        sku_cost,
        product_count * sku_price as total_price,
        product_count * sku_cost as total_cost
      from
        (
          select
            product_id,
            sku_name,
            sum(product_count) as product_count
          from
            product_orders
          group by
            product_id,
            sku_name
        ) as a
        left join product_sku on a.sku_name = product_sku.sku_name
        and a.product_id = product_sku.product_id
    ) as b
  group by
    product_id
),
refund_order AS (
  SELECT
    product_id,
    refund_amount,
    express_status
  FROM
    pofa.z_refundorders_finished_202208
    join product_ascription on z_refundorders_finished_202208.product_id = product_ascription.product
  where
    refund_end_time = 20220821
    AND refund_status = 1
),
b AS (
  select
    total_refund_amount.product_id as refund_product_id,
    total_refund_amount,
    total_refund_with_no_ship_amount
  from
    (
      SELECT
        product_id,
        sum(refund_amount) as total_refund_amount
      FROM
        refund_order
      group by
        product_id
    ) as total_refund_amount
    left join (
      SELECT
        product_id,
        sum(refund_amount) as total_refund_with_no_ship_amount
      FROM
        refund_order
      where
        express_status = false
      group by
        product_id
    ) as refund_with_no_ship on total_refund_amount.product_id = refund_with_no_ship.product_id
),
c AS (
  select
    id,
    brokerage
  from
    z_fakeorders_purchased_202208
  where
    order_payment_time = 20220821
),
d AS (
  select
    order_id,
    actual_amount,
    product_id
  from
    z_orders_20220821
)
SELECT
  i.product_id,
  shop_name,
  first_category,
  deduction,
  insurance,
  product_name,
  freight,
  freight_to_payment,
  product_ascription.department,
  product_ascription.team,
  product_ascription.owner,
  order_count,
  product_count,
  total_amount,
  total_refund_amount,
  total_refund_with_no_ship_amount,
  fake_order_count,
  total_fake_amount,
  total_brokerage,
  total_price,
  total_cost,
  wrong_count
from
  (
    SELECT
      ifnull(product_id, refund_product_id) as product_id,
      order_count,
      product_count,
      total_amount,
      total_refund_amount,
      total_refund_with_no_ship_amount,
      fake_order_count,
      total_fake_amount,
      total_brokerage
    from
      (
        SELECT
          *
        FROM
          a
          LEFT JOIN b ON a.product_id = b.refund_product_id
        UNION
        SELECT
          *
        FROM
          a
          RIGHT JOIN b ON a.product_id = b.refund_product_id
      ) as z
      left join (
        select
          product_id as fake_order_product_id,
          count(*) as fake_order_count,
          sum(actual_amount) as total_fake_amount,
          sum(brokerage) as total_brokerage
        from
          c
          left join d on c.id = d.order_id
        group by
          fake_order_product_id
      ) as h on z.product_id = h.fake_order_product_id
  ) as i
  join product_ascription on i.product_id = product_ascription.product
  join pofa.products on i.product_id = pofa.products.id
  left join product_manufacturers on i.product_id = product_manufacturers.product_id
  left join first_category on pofa.products.first_category = first_category.category_id
  left join sku_info on i.product_id = sku_info.product_id;

-- -------------------------------