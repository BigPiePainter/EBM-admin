<template>
  <div>
    <v-card>
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
          :options.sync="options"
          :server-items-length="totalReturnItems"
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
            </v-toolbar>
          </template>
        </v-data-table>
      </v-card>
    </v-card>
  </div>
</template>


<script>
// import { getReturn } from "@/settings/order";

export default {
  components: {},
  data() {
    return {
      totalReturnItems: 50,
      options: {},
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
    this.loadData();
  },

  watch: {
  },

  methods: {
    // loadData() {
    //   this.loading = true;
    //   const { page, itemsPerPage } = this.options;
    //   console.log({ page, itemsPerPage});
    //   getReturn({ page, itemsPerPage})
    //     .then((res) => {
    //       this.loading = false;
    //       console.log(res.data);
    //       this.returnItems = res.data.returnItems;
    //       this.totalReturnItems = res.data.total;
    //       //this.global.infoAlert("泼发EBC：" + res.data);
    //     })
    //     .catch(() => {
    //       this.loading = false;
    //     });
    // },
  },
};
</script>