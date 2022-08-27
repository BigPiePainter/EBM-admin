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
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>刷单订单</v-toolbar-title>
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
// import { getBrush } from "@/settings/order";

export default {
  components: {},
  data() {
    return {
      totalBrushItems: 50,
      options: {},
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
    this.loadData();
  },

  watch: {},

  methods: {
    // loadData() {
    //   this.loading = true;
    //   const { page, itemsPerPage } = this.options;
    //   console.log({ page, itemsPerPage });
    //   getBrush({ page, itemsPerPage })
    //     .then((res) => {
    //       this.loading = false;
    //       console.log(res.data);
    //       this.brushItems = res.data.brushItems;
    //       this.totalBrushItems = res.data.total;
    //       //this.global.infoAlert("泼发EBC：" + res.data);
    //     })
    //     .catch(() => {
    //       this.loading = false;
    //     });
    // },
  },
};
</script>