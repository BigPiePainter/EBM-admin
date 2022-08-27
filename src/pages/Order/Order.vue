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
          :headers="Headers"
          :items="allItems"
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
              <!-- <v-switch class="mt-5" label="展开更多信息" v-model="moreInfo">
              </v-switch> -->
            </v-toolbar>
          </template>
        </v-data-table>
      </v-card>
    </v-card>
  </div>
</template>


<script>
import { getDailyReport } from "@/settings/order";

export default {
  components: {},
  data() {
    return {
      allItems: [],
      brushItems: [],
      returnItems: [],
      //moreInfo: false,
      orderItems: [],

      Headers: [
        { text: "店铺名称", value: "shop" }, //订单1
        { text: "商品ID", value: "productId" }, //订单1
        { text: "子订单编号", value: "subOrderNumber" }, //订单
        { text: "主订单编号", value: "mainOrderNumber" }, //订单
        { text: "物流公司", value: "postCompany" }, //订单
        { text: "运单号", value: "postId" }, //订单
        { text: "订单创建时间", value: "orderCreateTime" }, //订单
        { text: "订单付款时间", value: "orderPayTime" }, //订单
        { text: "成交金额", value: "subActualPayment" }, //子单实际支付金额//订单
        { text: "付款状态", value: "paymentStatu" },
        { text: "订单状态", value: "orderStatu" }, //订单
        { text: "是否刷单", value: "ifBrush" },
        // { text: "是否刷大车", value: "ifBrushDache" },
        { text: "本单佣金", value: "salary" },
        { text: "订单sku名称", value: "skuName" }, //颜色/尺码//订单
        { text: "sku成本", value: "skuCost" },
        { text: "购买数量", value: "goodsAmount" }, //订单宝贝数量
        { text: "实购数量", value: "paymentStatu" },
        { text: "总成本", value: "paymentStatu" },
        { text: "售价有误", value: "paymentStatu" },
        { text: "原售价", value: "paymentStatu" },
        { text: "退款申请日期", value: "paymentStatu" },
        { text: "退款完结日期", value: "paymentStatu" },
        { text: "发货状态", value: "paymentStatu" },
        { text: "退款类型", value: "paymentStatu" },
        { text: "退款金额", value: "paymentStatu" },
        { text: "退款状态", value: "paymentStatu" },
      ],
    };
  },

  created() {
    this.loadData();
  },

  watch: {
    // moreInfo() {
    //   if (this.moreInfo == false) {
    //     this.Headers = this.orderHeader;
    //   } else {
    //     this.Headers = this.completeOrderHeader;
    //   }
    // },
  },

  methods: {
    loadData() {
      getDailyReport({date: "2022/8/21" })
        .then((res) => {
          console.log(res.data);
        })
        .catch(() => {});
    },
  },
};
</script>