<template>
  <div>
    <v-card>
      <v-card-title>
        退单信息
        <v-spacer />
        <!-- <v-switch class="mr-5 mt-5" label="展开更多信息" v-model="moreInfo">
        </v-switch> -->
        <order-upload />
      </v-card-title>
      <v-divider />

      <v-card class="products-list mb-1">
        <v-data-table
          single-expand
          show-expand
          fixed-header
          loading-text="加载中... 请稍后"
          no-data-text="空"
          item-key="returnId"
          disable-sort
          class="elevation-1"
          height="80vh"
          :loading="loading"
          :headers="returnHeader"
          :items="returnItems"
          :expanded.sync="expanded"
          :options.sync="options"
          :items-per-page="50"
          :footer-props="{
            'items-per-page-options': [10, 20, 50, 100],
            'items-per-page-text': '每页显示条数',
          }"
          @click:row="clickRow"
        >
          <template> </template>
        </v-data-table>
      </v-card>
    </v-card>
  </div>
</template>


<script>
import OrderUpload from "../../components/OrderUpload/OrderUpload.vue";

import { getReturn } from "@/settings/order";

export default {
  components: { OrderUpload },
  data() {
    return {
      moreInfo: false,
      returnItems: [],
      returnHeader: [
        { text: "主订单编号", value: "mainOrderId" },
        { text: "退款单编号", value: "returnId" },
        { text: "退款类型", value: "returnCate" },
        { text: "订单付款时间", value: "payTime" },
        { text: "商品ID", value: "productId" },
        { text: "宝贝标题", value: "skuName" },
        { text: "交易金额", value: "amount" },
        { text: "买家退款金额", value: "returnPrice" },
        { text: "发货状态", value: "transportStatu" },
        { text: "是否需要退货", value: "needProductBack" },
        { text: "退款申请时间", value: "beginTime" },
        { text: "退款状态", value: "returnStatu" },
        { text: "卖家退货地址", value: "address" },
        { text: "退货物流单号", value: "transportId" },
        { text: "退货物流公司", value: "transportCompany" },
        { text: "买家退款原因", value: "returnReason" },
        { text: "完结时间", value: "endTime" },
        { text: "店铺", value: "shopName" },
      ],
    };
  },

  created() {
    getReturn({});
  },

  watch(){

  },

  methods: {},
};
</script>