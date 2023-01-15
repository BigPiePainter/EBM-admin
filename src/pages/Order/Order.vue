<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="订单"> </PageHeader>
    <div>
      <v-col class="px-8 pt-4 pb-6">
        <v-row>
          <v-col md="auto" class="mx-1">
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
          <v-col class="mx-1" md="auto">
            <v-row>
              <!-- 筛选店铺 -->
              <span class="group-title"> 店铺 </span>
            </v-row>
            <v-row>
              <v-autocomplete no-data-text="空" color="primary" :items="categorys.shopName" dense outlined v-model="search.search.shopName" multiple hide-details class="search-input">
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
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 商品ID </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.productId" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 子订单编号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.id" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 主订单编号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.orderId" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 订单sku名称 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.skuName" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 运单号 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.expressNumber" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 物流公司 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.expressCompany" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <!-- 筛选店铺 -->
              <span class="group-title"> 订单状态 </span>
            </v-row>
            <v-row>
              <v-autocomplete no-data-text="空" color="primary" :items="categorys.orderStatus" dense outlined v-model="search.search.orderStatus" multiple hide-details class="search-input">
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('orderStatus', option)">
                    {{ orderStatus(option.item) }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ orderStatus(data.item) }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-1" md="auto">
            <v-row>
              <span class="group-title"> 仓发类型 </span>
            </v-row>
            <v-row>
              <v-autocomplete no-data-text="空" color="primary" :items="categorys.storehouseType" dense outlined v-model="search.search.storehouseType" multiple hide-details class="search-input">
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('storehouseType', option)">
                    {{ storeHouse(option.item) }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ storeHouse(data.item) }}
                  </span>
                </template>
              </v-autocomplete>
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
        height="calc(100vh - 273px)"
        mobile-breakpoint="0"
        :headers="headers"
        :items="allItems"
        :options.sync="options"
        :server-items-length="total"
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
        <template v-slot:[`item.orderSetupTime`]="props">
          <span>
            {{ parseDate(props.item.orderSetupTime) }}
          </span>
        </template>
        <template v-slot:[`item.orderPaymentTime`]="props">
          <span>
            {{ parseDate(props.item.orderPaymentTime) }}
          </span>
        </template>
        <template v-slot:[`item.storehouseType`]="props">
          <span>
            {{ storeHouse(props.item.storehouseType) }}
          </span>
        </template>
        <template v-slot:[`item.orderStatus`]="props">
          <span>
            {{ orderStatus(props.item.orderStatus) }}
          </span>
        </template>
      </v-data-table>
    </div>
  </div>
</template>


<script>
import { getOrders } from "@/settings/order";
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
      total: 0,

      categorys: {},

      search: {
        //选中项
        select: {
          //类别筛选
        },
        search: {
          //模糊查找
        },
      },

      headers: [
        { text: "商品ID", value: "productId" },
        { text: "宝贝标题", value: "productTitle" },
        { text: "子订单编号", value: "id" },
        { text: "主订单编号", value: "orderId" },
        { text: "子单实际支付金额", value: "actualAmount" },
        { text: "买家实际支付金额", value: "actualTotalAmount" },
        { text: "买家应付货款", value: "amount" },
        { text: "物流公司", value: "expressCompany" },
        { text: "物流单号", value: "expressNumber" },
        { text: "订单付款时间", value: "orderPaymentTime" },
        { text: "订单创建时间", value: "orderSetupTime" },
        { text: "订单状态", value: "orderStatus" },
        { text: "支付单号", value: "paymentId" },
        { text: "买家应付邮费", value: "postage" },
        { text: "宝贝数量 ", value: "productCount" },
        { text: "退款金额", value: "refundAmount" },
        { text: "商家编码", value: "sellerCode" },
        { text: "店铺ID", value: "shopId" },
        { text: "店铺名称", value: "shopName" },
        { text: "颜色/尺码(SKU)", value: "skuName" },
        { text: "仓发类型", value: "storehouseType" },
        { text: "供应商ID", value: "supplierId" },
        { text: "供应商名称", value: "supplierName" },
        { text: "总金额", value: "totalAmount" },
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
    var date = new Date();
    date.setDate(date.getDate() - 3);
    this.date = javaUTCDateToString(date);
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
    storeHouse(index) {
      var house;
      if (index == 1) {
        house = "菜鸟仓";
      } else if (index == 2) {
        house = "商家仓";
      }
      return house;
    },
    orderStatus(index) {
      var status;
      if (index == 1) {
        status = "部分发货中";
      } else if (index == 2) {
        status = "待买家收货";
      } else if (index == 3) {
        status = "待卖家发货";
      } else if (index == 4) {
        status = "交易成功";
      } else if (index == 5) {
        status = "交易关闭";
      }
      return status;
    },

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
      console.log(this.date);
      const { page, itemsPerPage } = this.options;
      var args = { date: this.date.replaceAll("-", "/"), itemsPerPage, match: JSON.stringify(this.search), page };
      console.log(args);
      getOrders(args)
        .then((res) => {
          this.categorys = res.data.category;
          this.allItems = res.data.orders;
          this.total = res.data.total;
          console.log(res.data);
        })
        .catch(() => {});
    },
  },
};
</script>