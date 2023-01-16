<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="未完结退单">
    </PageHeader>
    <div class="flex-grow-1">
      <v-data-table
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="id"
        disable-sort
        class=""
        height="calc(100vh - 197px)"
        mobile-breakpoint="0"
        :loading="loading"
        :headers="refundHeader"
        :items="refundItems"
        :options.sync="options"
        :server-items-length="totalRefundItems"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100],
          'items-per-page-text': '每页显示条数',
        }"
      >
        <template v-slot:[`item.orderPaymentTime`]="{ item }">
          <span>
            {{ parseDate(item.orderPaymentTime) }}
          </span>
        </template>
        <template v-slot:[`item.orderSetupTime`]="{ item }">
          <span>
            {{ parseDate(item.orderSetupTime) }}
          </span>
        </template>
        <template v-slot:[`item.refundSetupTime`]="{ item }">
          <span>
            {{ parseDate(item.refundSetupTime) }}
          </span>
        </template>
        <template v-slot:[`item.expressInfo`]="{ item }">
          <span>
            {{ item.expressInfo ? item.expressInfo : "暂无" }}
          </span>
        </template>
        <!-- <template v-slot:[`item.needReturn`]="{ item }">
            <span>
              {{ item.needReturn ? "需要退货":"不退货"}}
            </span>
          </template> -->

        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title @click="show">退单订单</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>
          </v-toolbar>
        </template>
      </v-data-table>
    </div>
  </div>
</template>


<script>
import { getMismatchRefundOrders } from "@/settings/order";
import { javaUTCDateToString } from "@/libs/utils";
import PageHeader from "@/components/PageHeader";

export default {
  components: {
    PageHeader,
  },
  data() {
    return {
      loading: false,
      totalRefundItems: 0,
      options: {},
      moreInfo: false,
      refundItems: [],
      refundHeader: [
        { text: "主订单编号", value: "orderId" },
        { text: "退款单编号", value: "id" },
        { text: "商品ID", value: "productId" },
        { text: "宝贝标题", value: "productTitle" },
        { text: "退款类型", value: "refundType" },
        { text: "订单创建时间", value: "orderSetupTime" },
        { text: "订单付款时间", value: "orderPaymentTime" },

        { text: "订单交易金额", value: "orderAmount" },
        { text: "买家退款金额", value: "refundAmount" },
        { text: "发货状态/是否发货", value: "expressStatus" },
        { text: "发货物流信息", value: "expressInfo" },
        { text: "是否需要退货", value: "needReturn" },
        { text: "退款申请时间", value: "refundSetupTime" },
        { text: "退款状态", value: "refundStatus" },

        { text: "客服介入状态", value: "customerServiceStatus" },
        { text: "退货物流单号", value: "expressNumber" },
        { text: "退货物流公司", value: "expressCompany" },
        { text: "买家退款原因", value: "refundReason" },
        { text: "完结时间", value: "refundEndTime" },
        { text: "退款操作人", value: "operator" },
        { text: "店铺", value: "shopName" },
        { text: "卖家备注", value: "sellerNote" },
        { text: "卖家退货地址", value: "sellerAddress" },
      ],
    };
  },

  created() {
    console.log = function (){}
  },

  watch: {
    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },
  },

  methods: {
    parseDate(time) {
      return javaUTCDateToString(time);
    },

    show() {
      const { page, itemsPerPage } = this.options;
      getMismatchRefundOrders({ page, itemsPerPage })
        .then((res) => {
          console.log(res.data);
        })
        .catch(() => {});
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      console.log({ page, itemsPerPage });
      getMismatchRefundOrders({ page, itemsPerPage })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.refundItems = res.data.mismatchRefundOrders.refundorders;
          this.totalRefundItems = res.data.mismatchRefundOrders.total;
          this.dataAnalyze();
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },
    dataAnalyze() {
      for (let i = 0; i < this.refundItems.length; i++)
        switch (this.refundItems[i].refundType) {
          case 1:
            this.refundItems[i].refundType = "仅退款";
            break;
          case 2:
            this.refundItems[i].refundType = "退货退款";
            break;
          default:
            this.refundItems[i].refundType = "未知";
        }
      // if (this.refundItems[i].refundType == 1) {
      //   this.refundItems[i].refundType = "仅退款";
      // } else if (this.refundItems[i].refundType == 2) {
      //   this.refundItems[i].refundType = "退货退款";
      // } else {
      //   this.refundItems[i].refundType = "未知";
      // }

      for (let i = 0; i < this.refundItems.length; i++)
        switch (this.refundItems[i].refundStatus) {
          case 1:
            this.refundItems[i].refundStatus = "退款成功";
            break;
          case 2:
            this.refundItems[i].refundStatus = "待买家发货";
            break;
          case 3:
            this.refundItems[i].refundStatus = "待商家收货";
            break;
          case 4:
            this.refundItems[i].refundStatus = "退款待处理";
            break;
          case 5:
            this.refundItems[i].refundStatus = "退款关闭";
            break;
          case 6:
            this.refundItems[i].refundStatus = "已拒绝退款";
            break;
          default:
            this.refundItems[i].refundStatus = "未知";
        }
      // if (this.refundItems[i].refundStatus == 1) {
      //   this.refundItems[i].refundStatus = "退款成功";
      // } else if (this.refundItems[i].refundStatus == 2) {
      //   this.refundItems[i].refundStatus = "待买家发货";
      // } else if (this.refundItems[i].refundStatus == 3) {
      //   this.refundItems[i].refundStatus = "待商家收货";
      // } else if (this.refundItems[i].refundStatus == 4) {
      //   this.refundItems[i].refundStatus = "退款待处理";
      // } else if (this.refundItems[i].refundStatus == 5) {
      //   this.refundItems[i].refundStatus = "退款关闭";
      // } else if (this.refundItems[i].refundStatus == 6) {
      //   this.refundItems[i].refundStatus = "已拒绝退款";
      // } else {
      //   this.refundItems[i].refundType = "未知";
      // }

      for (let i = 0; i < this.refundItems.length; i++)
        switch (this.refundItems[i].needReturn) {
          case true:
            this.refundItems[i].needReturn = "需要退货";
            break;
          case false:
            this.refundItems[i].needReturn = "不退货";
            break;
          default:
            this.refundItems[i].needReturn = "未知";
        }
      // if (this.refundItems[i].needReturn == true) {
      //   this.refundItems[i].needReturn = "需要退货";
      // } else if (this.refundItems[i].needReturn == false) {
      //   this.refundItems[i].needReturn = "不退货";
      // } else {
      //   this.refundItems[i].needReturn = "未知";
      // }

      for (let i = 0; i < this.refundItems.length; i++)
        switch (this.refundItems[i].expressStatus) {
          case true:
            this.refundItems[i].expressStatus = "已发货";
            break;
          case false:
            this.refundItems[i].expressStatus = "未发货";
            break;
          default:
            this.refundItems[i].expressStatus = "未知";
        }
      // if (this.refundItems[i].expressStatus == true) {
      //   this.refundItems[i].expressStatus = "已发货";
      // } else if (this.refundItems[i].expressStatus == false) {
      //   this.refundItems[i].expressStatus = "未发货";
      // } else {
      //   this.refundItems[i].expressStatus = "未知";
      // }
    },
  },
};
</script>