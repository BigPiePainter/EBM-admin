<template>
  <div>
    <v-card>
      <v-card-title>
        刷单信息
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
          item-key="number"
          disable-sort
          class="elevation-1"
          height="80vh"
          :loading="loading"
          :headers="brushHeader"
          :items="brushItems"
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

import { getBrush } from "@/settings/order";

export default {
  components: { OrderUpload },
  data() {
    return {
      moreInfo: false,
      brushItems: [],
      brushHeader: [
        { text: "序号", value: "number" },
        { text: "会员号", value: "memberId" },
        { text: "订单编号", value: "orderId" },
        { text: "价格", value: "price" },
        { text: "价格合计", value: "totalPrice" },
        { text: "佣金合计", value: "totalFee" },
        { text: "日期", value: "date" },
        { text: "佣金", value: "fee" },
        { text: "品数", value: "categories" },
        { text: "本单佣金", value: "thisFee" },
        { text: "团队", value: "team" },
      ],
    };
  },

  created() {
    getBrush({});
  },

  watch(){

  },

  methods: {},
};
</script>