<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="订单"> </PageHeader>
    <div>
      <v-col class="px-8 pt-4 pb-6">
        <v-row>
          <v-col md="auto" class="mx-2">
            <v-row>
              <span class="group-title"> 日期选择 </span>
            </v-row>
            <v-row>
              <v-menu ref="menu" v-model="datePicker" :close-on-content-click="false" :return-value.sync="date" offset-y>
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    class="date-picker-textfield search-input"
                    style="width: 120px"
                    v-model="date"
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    outlined
                    dense
                    hide-details
                    color="primary"
                  ></v-text-field>
                </template>
                <v-date-picker v-model="date" no-title scrollable locale="zh-cn" color="primary" first-day-of-week="1" :day-format="dayFormat" min="2021-01-01" :max="parseDate(new Date())">
                  <v-spacer></v-spacer>
                  <v-btn text color="primary" @click="datePicker = false"> 取消 </v-btn>
                  <v-btn
                    text
                    color="primary"
                    @click="
                      $refs.menu.save(date);
                      loadData();
                    "
                  >
                    确定
                  </v-btn>
                </v-date-picker>
              </v-menu>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 筛选店铺 -->
              <span class="group-title"> 店铺 </span>
            </v-row>
            <v-row>
              <v-autocomplete no-data-text="空" color="primary" :items="shops" dense outlined v-model="search.search.shopName" multiple hide-details class="search-input">
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('shopName', option)">
                    {{ option.item }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 筛选商品ID -->
              <span class="group-title"> 商品ID </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.productId" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <span class="group-title"> 子订单编号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.id" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <span class="group-title"> 主订单编号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.orderId" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <span class="group-title"> 订单sku名称 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.skuName" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <span class="group-title"> 运单号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.expressNumber" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <span class="group-title"> 物流公司 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.expressCompany" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
        </v-row>
      </v-col>
    </div>
    <div class="flex-grow-1">
      <v-data-table
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="subOrderNumber"
        disable-sort
        class=""
        height="calc(100vh - 197px)"
        mobile-breakpoint="0"
        :headers="Headers"
        :items="allItems"
        :options.sync="options"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100],
          'items-per-page-text': '每页显示条数',
        }"
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>订单信息</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>
            <!-- <v-switch class="mt-5" label="展开更多信息" v-model="moreInfo">
              </v-switch> -->
          </v-toolbar>
        </template>
      </v-data-table>
    </div>
  </div>
</template>


<script>
import { getOrders } from "@/settings/profitReport";
import { getShop } from "@/settings/shop";
import PageHeader from "@/components/PageHeader";
import { javaUTCDateToString } from "@/libs/utils";
import { mapState } from "vuex";

export default {
  components: {
    PageHeader,
  },
  data() {
    return {
      shops: [],
      datePicker: false,
      date: "",
      allItems: [],
      brushItems: [],
      returnItems: [],
      options: {},
      orderItems: [],

      search: {
        //选中项
        select: {
          //类别筛选
        },
        search: {
          //模糊查找
        },
      },

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

  created() {
    this.loadData();
    this.getSearchItems();
  },

  watch: {
    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },

    "search.search": {
      handler() {
        this.loadData();
      },
      deep: true,
    },
  },

  methods: {
    remove(key, option) {
      this.search.search[key].splice(option.index, 1);
    },
    parseDate(time) {
      return javaUTCDateToString(time);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    loadData() {
      const { page, itemsPerPage } = this.options;
      getOrders({ date: this.date.replaceAll(" - ", " / "), itemsPerPage, match: JSON.stringify(this.search), page })
        .then((res) => {
          console.log(res.data);
        })
        .catch(() => {});
    },

    getSearchItems() {
      getShop()
        .then((res) => {
          console.log(res.data);
          res.data.shops.forEach((item)=>{
            this.shops.push(item.name);
          })
          console.log(this.shops)
        })
        .catch(() => {});
    },
  },
};
</script>