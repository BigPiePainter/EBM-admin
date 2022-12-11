<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="未匹配补单">
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
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
        :headers="brushHeader"
        :items="brushItems"
        :options.sync="options"
        :server-items-length="totalBrushItems"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100],
          'items-per-page-text': '每页显示条数',
        }"
      >
        <template v-slot:[`item.requestTime`]="{ item }">
          <span>
            {{ parseDate(item.requestTime) }}
          </span>
        </template>
        <template v-slot:[`item.orderPaymentTime`]="{ item }">
          <span>
            {{ parseDate(item.orderPaymentTime) }}
          </span>
        </template>
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title @click="show">补单订单</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>
          </v-toolbar>
        </template>
      </v-data-table>
    </div>
  </div>
</template>


<script>
import { getMismatchFakeOrders } from "@/settings/order";
import { javaUTCDateToString } from "@/libs/utils";
import PageHeader from "@/components/PageHeader";

export default {
  components: {
    PageHeader,
  },
  data() {
    return {
      totalBrushItems: 0,
      options: {},
      loading: false,
      moreInfo: false,
      brushItems: [],
      brushHeader: [
        { text: "主订单编号", value: "id" },
        { text: "诉求日期", value: "requestTime" },
        { text: "品数/子订单数", value: "productCount" },
        { text: "子订单佣金", value: "brokerage" },
        { text: "团队", value: "team" },
      ],
    };
  },

  created() {},

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
      getMismatchFakeOrders({ page, itemsPerPage })
        .then((res) => {
          console.log(res.data);
        })
        .catch(() => {});
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      console.log({ page, itemsPerPage });
      getMismatchFakeOrders({ page, itemsPerPage })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.brushItems = res.data.mismatchFakeOrders.fakeorders;
          this.totalBrushItems = res.data.mismatchFakeOrders.total;
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>