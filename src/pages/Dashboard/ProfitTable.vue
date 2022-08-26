<template>
  <div>
    <v-card>
      <v-data-table :items="profitItems" :headers="profitHeaders">
      </v-data-table>
    </v-card>
  </div>
</template>


<script>
export default {
  data() {
    return {
      profitItems: [],
      profitHeaders: [
        { text: "日期", value: "date" },
        { text: "组别", value: "group" },
        { text: "店铺", value: "shop" },
        { text: "持品人", value: "hoder" },
        { text: "产品名称", value: "productName" },
        { text: "一级类目", value: "category" },
        { text: "商品编码ID", value: "productId" },
        { text: "扣点", value: "ratio" },
        { text: "运费险", value: "transportInsurance" },
        { text: "运费", value: "transportFee" },
        { text: "成交额", value: "turnover" },
        { text: "成交数", value: "dealAmount" },
        { text: "刷单额", value: "brush" },
        { text: "刷评价", value: "brushCommand" },
        { text: "刷销量", value: "brushSold" },
        { text: "当天金额", value: "turnoverMinBrush" },
        { text: "当天单数", value: "dealMinBrush" },
        { text: "单均价", value: "" },
        { text: "拿货成本", value: "" },
        { text: "成本率", value: "" },
        { text: "利润率", value: "" },
        { text: "退款金额", value: "" },
        { text: "净入金额", value: "" },
        { text: "未发仅退", value: "" },
        { text: "未发退本", value: "" },
        { text: "未发数", value: "" },
        { text: "真实拿货", value: "" },
        { text: "平台扣点", value: "" },
        { text: "快递费", value: "" },
        { text: "运费险", value: "" },
        { text: "刷单佣金", value: "" },
        { text: "售后毛利润", value: "" },
        { text: "售后利润率", value: "" },
        { text: "SKU", value: "" },
        { text: "错数", value: "" },
        { text: "折扣", value: "" },
        { text: "错数", value: "" },
        { text: "原售价", value: "" },
        { text: "厂家返款", value: "" },
      ],
    };
  },
};
</script>
