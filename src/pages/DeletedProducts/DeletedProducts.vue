<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="已下架商品">
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
    </PageHeader>
    <v-data-table
      fixed-header
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="id"
      height="calc(100vh - 197px)"
      class=""
      :loading="loading"
      :headers="headers"
      :items="products"
      :server-items-length="totalProducts"
      :options.sync="options"
      :items-per-page="20"
      :footer-props="{
        'items-per-page-options': [10, 20, 50, 100],
        'items-per-page-text': '每页显示条数',
      }"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>商品信息</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
        </v-toolbar>
      </template>

      <template v-slot:[`item.department`]="{ item }">
        {{ departmentIdToName[item.department] }}
      </template>
      <template v-slot:[`item.team`]="{ item }">
        {{ teamIdToName[item.team] }}
      </template>
      <template v-slot:[`item.owner`]="{ item }">
        {{ userIdToNick[item.owner] }}
      </template>
      <template v-slot:[`item.firstCategory`]="{ item }">
        {{ categoryIdToName[item.firstCategory] }}
      </template>
    </v-data-table>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { amountBeautify } from "@/libs/utils";

import { loadDeletedProducts } from "@/settings/product";
//import { getClass } from "@/settings/product";

import { javaUTCDateToString } from "@/libs/utils";

import PageHeader from "@/components/PageHeader";

export default {
  name: "MismatchProducts",
  components: {
    PageHeader,
  },
  data() {
    return {
      loading: false,

      //分页懒加载
      totalProducts: 50,
      options: {},

      //主表头, 内容
      headers: [],
      products: [],

      headersContent: [
        { text: "商品ID", value: "id" },
        { text: "商品名", value: "productName" },
        { text: "部门", value: "department" },
        { text: "组别", value: "team" },
        { text: "持品人", value: "owner" },
        { text: "店铺名", value: "shopName" },
        { text: "一级类目", value: "firstCategory" },
        { text: "发货方式", value: "transportWay" },
        { text: "聚水潭仓库", value: "storehouse" },
        { text: "备注", value: "note" },
      ],

      //筛选
      search: {
        //选中项
        select: {
          //类别筛选
          department: [],
          owner: [],
          team: [],
          transportWay: [],
          firstCategory: [],
          shopName: [],
        },
        search: {
          //模糊查找
        },
      },
    };
  },

  computed: {
    ...mapState([
      "user",
      "allDepartments",
      "allTeams",
      "allUsers",
      "allCategorys",
      "allCategoryHistorys",
      "allShops",
      "userIdToNick",
      "teamIdToName",
      "departmentIdToName",
      "categoryIdToName",
      "categoryIdToInfo",
    ]),
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
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    amountFormat() {
      return amountBeautify(...arguments);
    },

    showHeaders() {
      this.headers = this.headersContent;
      console.log(this.search);
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      // console.log({ page, itemsPerPage, match: JSON.stringify(this.search) });
      loadDeletedProducts({
        page,
        itemsPerPage,
        match: JSON.stringify(this.search),
      })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.showHeaders();
          this.products = res.data.products;
          this.totalProducts = res.data.total;
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>

<style scoped>
</style>