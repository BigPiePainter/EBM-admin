<template>
  <div>
    <v-card>
      <v-card class="products-list mb-1">
        <v-data-table
          loading-text="加载中... 请稍后"
          no-data-text="空"
          item-key="subOrderNumber"
          disable-sort
          class="elevation-1"
          height="80vh"
          :loading="loading"
          :headers="Headers"
          :items="orderItems"
          :expanded.sync="expanded"
          :options.sync="options"
          :items-per-page="50"
          :footer-props="{
            'items-per-page-options': [10, 20, 50, 100],
            'items-per-page-text': '每页显示条数',
          }"
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>订单管理</v-toolbar-title>
              <v-divider class="mx-4" inset vertical></v-divider>

              <v-spacer></v-spacer>
              <v-switch class="mt-5" label="展开更多信息" v-model="moreInfo">
              </v-switch>
            </v-toolbar>
          </template>
        </v-data-table>
      </v-card>
    </v-card>
  </div>
</template>


<script>
import { getOrder } from "@/settings/order";

export default {
  components: {},
  data() {
    return {
      moreInfo: false,
      orderItems: [],
      Headers: [{ text: "子订单编号", value: "subOrderNumber" },
        { text: "主订单编号", value: "mainOrderNumber" },
        { text: "买家应付邮费", value: "buyerPostage" },
        { text: "买家实际支付金额", value: "buyerActualPayment" },
        { text: "子单实际支付金额", value: "subActualPayment" },
        { text: "订单状态", value: "orderStatu" },
        { text: "订单创建时间", value: "orderCreateTime" },
        { text: "订单付款时间", value: "orderPayTime" },
        { text: "宝贝标题", value: "goodsTitle" },
        { text: "宝贝数量", value: "goodsAmount" },
        { text: "物流单号", value: "postId" },
        { text: "物流公司", value: "postCompany" },
        { text: "店铺名称", value: "shopName" },
        { text: "供应商名称", value: "suppilerName" },
        { text: "退款金额", value: "returnPrice" },
        { text: "颜色/尺码", value: "skuName" },
        { text: "商品编码", value: "goodsId" },],
      orderHeader: [
        { text: "子订单编号", value: "subOrderNumber" },
        { text: "主订单编号", value: "mainOrderNumber" },
        { text: "买家应付邮费", value: "buyerPostage" },
        { text: "买家实际支付金额", value: "buyerActualPayment" },
        { text: "子单实际支付金额", value: "subActualPayment" },
        { text: "订单状态", value: "orderStatu" },
        { text: "订单创建时间", value: "orderCreateTime" },
        { text: "订单付款时间", value: "orderPayTime" },
        { text: "宝贝标题", value: "goodsTitle" },
        { text: "宝贝数量", value: "goodsAmount" },
        { text: "物流单号", value: "postId" },
        { text: "物流公司", value: "postCompany" },
        { text: "店铺名称", value: "shopName" },
        { text: "供应商名称", value: "suppilerName" },
        { text: "退款金额", value: "returnPrice" },
        { text: "颜色/尺码", value: "skuName" },
        { text: "商品编码", value: "goodsId" },
      ],
      completeOrderHeader: [
        { text: "子订单编号", value: "subOrderNumber" },
        { text: "主订单编号", value: "mainOrderNumber" },
        { text: "买家应付邮费", value: "buyerPostage" },
        { text: "买家实际支付金额", value: "buyerActualPayment" },
        { text: "子单实际支付金额", value: "subActualPayment" },
        { text: "订单状态", value: "orderStatu" },
        { text: "订单创建时间", value: "orderCreateTime" },
        { text: "订单付款时间", value: "orderPayTime" },
        { text: "宝贝标题", value: "goodsTitle" },
        { text: "宝贝数量", value: "goodsAmount" },
        { text: "物流单号", value: "postId" },
        { text: "物流公司", value: "postCompany" },
        { text: "店铺名称", value: "shopName" },
        { text: "供应商名称", value: "suppilerName" },
        { text: "退款金额", value: "returnPrice" },
        { text: "颜色/尺码", value: "skuName" },
        { text: "商品编码", value: "goodsId" },
        //hide below
        { text: "商家编码", value: "sellerId" },
        { text: "仓发类型", value: "store" },
        { text: "供应商ID", value: "suppilerId" },
        { text: "店铺ID", value: "shopId" },
        { text: "支付单号", value: "paymentNumber" },
        { text: "买家应付货款", value: "buyerPrice" },
        { text: "总金额", value: "totalPrice" },
      ],
    };
  },

  created() {
    getOrder({});
  },

  watch: {
    moreInfo(){
      if (this.moreInfo == false){
        this.Headers=this.orderHeader
      }else{
        this.Headers=this.completeOrderHeader
      }
    }
  },

  methods: {},
};
</script>