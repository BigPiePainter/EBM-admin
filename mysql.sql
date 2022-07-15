-- 用户
drop table if exists users;

CREATE TABLE users (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  creator_id bigint NOT NULL COMMENT '用户创建人',
  permission bigint NOT NULL COMMENT '权限',
  username varchar(100) NOT NULL COMMENT '用户名',
  password varchar(100) NOT NULL COMMENT '密码',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '系统用户';

-- 测试数据
insert into
  users(uid, creator_id, permission, username, password)
values
  (0, 0, 1048575, 'admin', '88888888');

insert into
  users(creator_id, permission, username, password)
values
  (0, 1048575, 'zqy', '123456');

insert into
  users(creator_id, permission, username, password)
values
  (0, 1048575, '556', '654321');

-- 商品信息
drop table if exists products;

CREATE TABLE products (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  owner bigint COMMENT '持品人',
  id varchar(200) NOT NULL COMMENT '商品ID',
  department varchar(200) COMMENT '事业部',
  group_name varchar(200) COMMENT '组别',
  shop_name varchar(200) COMMENT '店铺名',
  first_category varchar(200) COMMENT '一级类目',
  product_name varchar(200) COMMENT '产品名',
  product_deduction DECIMAL(15, 5) COMMENT '品类扣点',
  product_freight DECIMAL(15, 5) COMMENT '每单运费',
  product_insurance DECIMAL(15, 5) COMMENT '品类运费险',
  extra_ratio DECIMAL(15, 5) COMMENT '子/主订单附带比',
  freight_to_payment DECIMAL(15, 5) COMMENT '运费/总货款',
  transport_way varchar(200) COMMENT '发货方式',
  storehouse varchar(200) COMMENT '聚水潭仓库',
  manufacturer_name varchar(200) COMMENT '厂家名',
  manufacturer_group varchar(200) COMMENT '厂家群名',
  manufacturer_payment_method varchar(200) COMMENT '厂家收款账户',
  manufacturer_payment_name varchar(200) COMMENT '厂家收款账户-收款人',
  manufacturer_payment_id varchar(200) COMMENT '厂家收款账户号码',
  manufacturer_recipient varchar(200) COMMENT '厂家退货-收件人',
  manufacturer_phone varchar(200) COMMENT '厂家退货-收件手机号',
  manufacturer_address varchar(200) COMMENT '厂家退货-收件地址',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品信息';


INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');
INSERT INTO products(`owner`, `id`, `department`, `group_name`, `shop_name`, `first_category`, `product_name`, `product_deduction`, `product_freight`, `product_insurance`, `extra_ratio`, `freight_to_payment`, `transport_way`, `storehouse`, `manufacturer_name`, `manufacturer_group`, `manufacturer_payment_method`, `manufacturer_payment_name`, `manufacturer_payment_id`, `manufacturer_recipient`, `manufacturer_phone`, `manufacturer_address`) VALUES ('0', '1515151515', '123123', '123', '13', '132', '13', '323.00000', '1.00000', '13.00000', '132.00000', '132.00000', '13', '13', '13', '132', '132', '13', '13', '13', '13', '132');

-- SKU
drop table if exists skus;

CREATE TABLE skus (
  uid bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  product_id bigint NOT NULL COMMENT '商品id',
  sku_name varchar(200) NOT NULL COMMENT 'SKU名称',
  price varchar(200) NOT NULL COMMENT '售卖价',
  cost varchar(200) NOT NULL COMMENT '售卖成本',
  start_time varchar(200) NOT NULL COMMENT '价格开始时间',
  end_time varchar(200) COMMENT '价格截止时间',
  primary key (uid)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'SKU';