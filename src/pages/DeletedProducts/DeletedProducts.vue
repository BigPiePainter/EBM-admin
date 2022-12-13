<template>
  
  <div class="page-content d-flex flex-column">
    <PageHeader title="已下架商品">
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
    </PageHeader>
    <v-data-table
      v-model="selectedProductItem"
      fixed-header
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="id"
      height="calc(100vh - 197px)"
      class=""
      :show-select="ifAction"
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
          <v-btn
            small
            depressed
            class="ml-2"
            @click="
              ifAction = !ifAction;
              selectedProductItem = [];
            "
          >
            <v-icon small class="mr-1">
              {{
                ifAction
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 操作 </span>
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn
            v-if="ifAction"
            :disabled="selectedProductItem.length < 1"
            outlined
            color="green"
            small
            depressed
            class="ml-2"
            @click.stop="recoverProduct"
          >
            <span> 重新上架 </span>
          </v-btn>
          <v-btn
            v-if="ifAction"
            :disabled="selectedProductItem.length < 1"
            small
            depressed
            outlined
            color="red lighten-2"
            class="ml-1"
            @click.stop="absoluteDelete"
          >
            彻底删除
          </v-btn>
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

    <!-- 弹窗（彻底删除）-->
    <v-dialog v-model="absoluteDeleteDialog" max-width="450px">
      <v-card class="delete-dialog">
        <v-card-title class="text-h6"
          >是否确认删除
        </v-card-title>

        <v-divider />

        <div class="delete-table-container text-body-1 ml-8 mt-2 mb-1">
          彻底删除的商品将不会计入报表统计
        </div>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="absoluteDeleteDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureAbsoluteDelete">
            <v-icon small class="mr-1"> mdi-delete </v-icon>确认
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 弹窗（重新上架）-->
    <v-dialog v-model="recoverProductDialog" max-width="450px">
      <v-card class="delete-dialog">
        <!-- <v-card-title class="text-subtitle-1"
          >{{ deleteItem.productName }}
        </v-card-title> -->

        <div class="delete-table-container mt-2 mb-1"></div>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="recoverProductDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureRecoverProduct">
            <v-icon small class="mr-1"> mdi-delete </v-icon>确认
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
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

      //操作
      ifAction: false,
      selectedProductItem: [],
      absoluteDeleteDialog: false,
      recoverProductDialog: false,

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
    //弹窗（彻底删除下架商品）
    absoluteDelete() {
      this.absoluteDeleteDialog = true;
    },
    //确认彻底删除
    sureAbsoluteDelete() {},
    //弹窗（恢复上架）
    recoverProduct() {
      this.recoverProductDialog = true;
    },
    //确认重新上架
    sureRecoverProduct() {},

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