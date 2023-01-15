<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="商品清单">
      <v-menu ref="menu" v-model="datePicker" :close-on-content-click="false" :return-value.sync="date" offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn class="ml-2" text v-bind="attrs" v-on="on" color="primary">
            <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
            <span> 导出全部明细 </span>
          </v-btn>
        </template>
        <v-date-picker v-model="date" no-title scrollable locale="zh-cn" color="primary" first-day-of-week="1" :day-format="dayFormat" min="2021-01-01" :max="parseDate(new Date())">
          <v-spacer></v-spacer>
          <v-btn text color="primary" @click="datePicker = false"> 取消 </v-btn>
          <v-btn
            text
            color="primary"
            @click="
              $refs.menu.save(date);
              getProductsDetailsData();
            "
          >
            确定
          </v-btn>
        </v-date-picker>
      </v-menu>
      <!-- <v-btn class="ml-2" text color="primary" @click="getProductsDetailsData">
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出明细
      </v-btn> -->
    </PageHeader>
    <div>
      <v-col class="px-8 pt-4 pb-6">
        <v-row>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 筛选商品ID -->
              <span class="group-title"> 商品ID </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.id" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 查找商品名称 -->
              <span class="group-title"> 商品名称 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 160px" v-model="search.search.productName" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选部门 -->
              <span class="group-title"> 事业部 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                color="primary"
                :items="category.department?.map((d) => allDepartments.find((ad) => ad.uid == d))"
                dense
                outlined
                no-data-text="空"
                item-text="name"
                item-value="uid"
                v-model="search.search.department"
                multiple
                hide-details
                class="search-input search-input"
              >
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('department', option)">
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选组别 -->
              <span class="group-title"> 组别 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="category.team?.map((d) => allTeams.find((ad) => ad.uid == d))"
                dense
                outlined
                item-text="name"
                item-value="uid"
                v-model="search.search.team"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('team', option)">
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选持品人 -->
              <span class="group-title"> 持品人 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="category.owner?.map((d) => allUsers.find((ad) => ad.uid == d))"
                dense
                outlined
                item-text="nick"
                item-value="uid"
                v-model="search.search.owner"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('owner', option)">
                    {{ option.item.nick }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.nick }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 查找店铺 -->
              <span class="group-title"> 店铺 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 100px" v-model="search.search.shopName" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选一级类目 -->
              <span class="group-title"> 一级类目 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="category.firstCategory?.map((d) => allCategorys.find((ad) => ad.uid == d))"
                dense
                outlined
                item-text="name"
                item-value="uid"
                v-model="search.search.firstCategory"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip small close close-icon="mdi-close" color="primary" outlined @click:close="remove('firstCategory', option)">
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 查找备注 -->
              <span class="group-title"> 备注 </span>
            </v-row>
            <v-row>
              <v-text-field color="primary" style="max-width: 100px" v-model="search.search.note" outlined dense clearable hide-details class="search-input"> </v-text-field>
            </v-row>
          </v-col>
        </v-row>
      </v-col>
    </div>
    <div class="flex-grow-1">
      <v-data-table
        single-select
        :show-expand="user.permission.g?.d"
        fixed-header
        disable-sort
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="id"
        class=""
        height="calc(100vh - 223px)"
        mobile-breakpoint="0"
        :show-select="false"
        :loading="loading"
        :headers="headers"
        :items="products"
        :expanded.sync="expanded"
        :server-items-length="totalProducts"
        :options.sync="options"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100, 500, 1000, 5000],
          'items-per-page-text': '每页显示条数',
        }"
        @click:row="clickRow"
      >
        <!-- 复制商品id -->
        <template v-slot:[`item.id`]="props">
          <span title="复制商品ID" style="cursor: pointer" @click.stop="copy(props.item.id)">{{ props.item.id }}</span>
        </template>

        <!--复制商品名称 -->
        <template v-slot:[`item.productName`]="props">
          <v-hover v-model="props.item.hover">
            <v-badge
              v-if="!props.item.skus + !props.item.manufacturers == 1"
              :color="!props.item.skus ? 'red' : 'primary'"
              :value="true"
              :content="!props.item.skus ? '无SKU' : '无厂家'"
              :title="!props.item.skus ? '可以利用左侧的实用工具快捷获取SKU' : ''"
              :dot="!props.item.hover"
              offset-y=""
            >
              <span title="复制商品名称" style="cursor: pointer" @click.stop="copy(props.item.productName)">{{ props.item.productName }}</span>
            </v-badge>

            <v-badge v-else color="red" :value="!props.item.skus" content="无SKU" title="可以利用左侧的实用工具快捷获取SKU" :dot="!props.item.hover">
              <v-badge color="primary" :value="!props.item.manufacturers" content="无厂家" :dot="!props.item.hover" :offset-x="props.item.hover ? 0 : -6" :offset-y="props.item.hover ? 23 : 0">
                <span title="复制商品名称" style="cursor: pointer" @click.stop="copy(props.item.productName)">{{ props.item.productName }}</span>
              </v-badge>
            </v-badge>
          </v-hover>
        </template>

        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="pa-0">
            <EconomySkuTable :productInfo="item" />
          </td>
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
        <template v-slot:[`item.modifyTime`]="{ item }">
          {{ parseDateTime(item.modifyTime) }}
        </template>

        <!-- <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>商品信息</v-toolbar-title>
            </v-toolbar>
          </template> -->

        <template v-slot:[`header.actions`]="{ header }">
          <div class="d-flex mr-11">
            <v-spacer />
            {{ header.text }}
          </div>
        </template>
      </v-data-table>
    </div>
  </div>
</template>
  
  
  <script>
import { mapState } from "vuex";

import { saveAs } from "file-saver";

import { economyGetAllProducts } from "@/settings/product";
import { economyGetAllProductsDetails } from "@/settings/product";
//import { getClass } from "@/settings/product";

import { javaUTCDateToString } from "@/libs/utils";
import { javaDateTimeToString } from "@/libs/utils";

import EconomySkuTable from "@/components/EconomySkuTable/EconomySkuTable";
import PageHeader from "@/components/PageHeader";
//import SelectDialog from "@/components/SelectDialog";

export default {
  components: {
    EconomySkuTable,
    PageHeader,
    //SelectDialog,
  },
  data: () => ({
    date: "",
    productsDetails: [],
    copyContent: "",
    category: {},
    mode: 0,
    shopItems: [],

    //筛选菜单
    menu: {}, //类别可选项

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

    // searchPreview: "",

    //分页懒加载
    totalProducts: 50,
    options: {},
    //二级展开
    expanded: [],
    //主表加载
    loading: false,
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
      { text: "修改时间", value: "modifyTime" },
    ],
    datePicker: false,
  }),

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

  watch: {
    options: {
      handler() {
        console.log("watch 触发loaddata");
        this.loadData();
      },
      deep: true,
    },

    // copyContent: {

    // },

    "search.search": {
      handler() {
        this.loadData();
      },
      deep: true,
    },
  },

  created() {
    console.log(this.allShops);
  },

  mounted() {},

  methods: {
    copy(item) {
      console.log(item);
      var domNode = document.createElement("input");
      document.body.appendChild(domNode);
      domNode.value = item;
      domNode.focus();
      domNode.select();
      document.execCommand("copy");
      domNode.blur();
      document.body.removeChild(domNode);
      this.global.infoAlert("泼发EBC：复制成功");
    },
    parseDateTime(date) {
      return javaDateTimeToString(date);
    },
    remove(key, option) {
      console.log(option);
      console.log(this.options);
      console.log(this.search.search);
      this.search.search[key].splice(option.index, 1);
    },
    parseDate(time) {
      return javaUTCDateToString(time);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    init() {
      // getClass({})
      //   .then((res) => {
      //     this.menu = res.data;
      //     console.log(this.menu);
      //     console.log(res.data);
      //   })
      //   .catch(() => {});
      //有watch search.search, init时不需要loadData
    },

    showHeaders() {
      this.headers = this.headersContent;
      console.log(this.search);
    },

    refreshData(a) {
      if (a.select) {
        this.search.select[a.select.key] = a.select.value;
      } else {
        console.log("未知");
      }
      this.loadData();
    },

    clickRow(item, event) {
      if (!this.user.permission.g?.d) return;
      // console.log(this.departmentList);
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    getProductsDetailsData() {
      economyGetAllProductsDetails({ date: this.date.replaceAll("-", "/") })
        .then((res) => {
          console.log(res.data);
          this.downloadEconomyProductsList(res.data.productDetails);
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {});
    },

    async downloadEconomyProductsList(datas) {
      console.log(datas);
      const ExcelJS = require("exceljs");
      const workbook = new ExcelJS.Workbook();
      workbook.creator = "泼发EBC";
      workbook.lastModifiedBy = "泼发EBC";
      console.log(this.user);
      workbook.company = "浙江泼发进出口贸易有限公司";
      workbook.manager = this.user.nick + " " + this.user.username;
      workbook.created = new Date();
      workbook.modified = new Date();

      const sheetA = workbook.addWorksheet("商品清单", {
        views: [{ state: "frozen", ySplit: 1, xSplit: 6, zoomScale: 80 }],
      });

      var font = {
        name: "微软雅黑",
        size: 10,
      };
      var headerFont = {
        name: "微软雅黑",
        size: 10,
        bold: true,
      };

      var centerAlignment = {
        vertical: "center",
        horizontal: "center",
      };

      console.log(sheetA);

      if (this.user.permission.g?.d) {
        sheetA.columns = [
          {
            header: "商品ID",
            key: "id",
            width: 15,
            style: { font },
          },
          {
            header: "部门",
            key: "department",
            width: 10,
            style: { font },
          },
          {
            header: "组别",
            key: "team",
            width: 10,
            style: { font },
          },
          {
            header: "持品人",
            key: "owner",
            width: 10,
            style: { font },
          },
          {
            header: "店铺",
            key: "shopName",
            width: 10,
            style: { font },
          },
          {
            header: "产品名称",
            key: "productName",
            width: 20,
            style: { font },
          },
          {
            header: "一级类目",
            key: "categoryId",
            width: 20,
            style: { font },
          },
          {
            header: "品类扣点",
            key: "deduction",
            width: 10,
            style: { font },
          },
          {
            header: "品类运费险",
            key: "insurance",
            width: 10,
            style: { font },
          },
          {
            header: "发货方式",
            key: "transportWay",
            width: 10,
            style: { font },
          },
          {
            header: "聚水潭仓库",
            key: "storehouse",
            width: 30,
            style: { font },
          },
          {
            header: "EBC商品备注",
            key: "productNote",
            width: 30,
            style: { font },
          },
          {
            header: "是否下架",
            key: "deprecated",
            width: 10,
            style: { font },
          },
          {
            header: "厂家名",
            key: "manufacturerName",
            width: 30,
            style: { font },
          },
          {
            header: "厂家群名",
            key: "manufacturerGroup",
            width: 30,
            style: { font },
          },
          {
            header: "收款-收款方式",
            key: "manufacturerPaymentMethod",
            width: 13,
            style: { font },
          },
          {
            header: "收款-收款人",
            key: "manufacturerPaymentName",
            width: 10,
            style: { font },
          },
          {
            header: "收款-收款账户",
            key: "manufacturerPaymentId",
            width: 20,
            style: { font },
          },
          {
            header: "退货-收件人",
            key: "manufacturerRecipient",
            width: 10,
            style: { font },
          },
          {
            header: "退货-收件手机号",
            key: "manufacturerPhone",
            width: 20,
            style: { font },
          },
          {
            header: "退货-收件地址",
            key: "manufacturerAddress",
            width: 30,
            style: { font },
          },
          {
            header: "每单运费",
            key: "freight",
            width: 10,
            style: { font },
          },
          {
            header: "子/主订单附带比",
            key: "extraRatio",
            width: 10,
            style: { font },
          },
          {
            header: "运费/总货款",
            key: "freightToPayment",
            width: 10,
            style: { font },
          },
          {
            header: "EBC厂家备注",
            key: "manufacturerNote",
            width: 30,
            style: { font },
          },
        ];
      } else {
        sheetA.columns = [
          {
            header: "商品ID",
            key: "id",
            width: 15,
            style: { font },
          },
          {
            header: "部门",
            key: "department",
            width: 10,
            style: { font },
          },
          {
            header: "组别",
            key: "team",
            width: 10,
            style: { font },
          },
          {
            header: "持品人",
            key: "owner",
            width: 10,
            style: { font },
          },
          {
            header: "店铺",
            key: "shopName",
            width: 10,
            style: { font },
          },
          {
            header: "产品名称",
            key: "productName",
            width: 20,
            style: { font },
          },
          {
            header: "一级类目",
            key: "categoryId",
            width: 20,
            style: { font },
          },
          {
            header: "品类扣点",
            key: "deduction",
            width: 10,
            style: { font },
          },
          {
            header: "品类运费险",
            key: "insurance",
            width: 10,
            style: { font },
          },
          {
            header: "发货方式",
            key: "transportWay",
            width: 10,
            style: { font },
          },
          {
            header: "聚水潭仓库",
            key: "storehouse",
            width: 30,
            style: { font },
          },
          {
            header: "EBC商品备注",
            key: "productNote",
            width: 30,
            style: { font },
          },
          {
            header: "是否下架",
            key: "deprecated",
            width: 10,
            style: { font },
          },
        ];
      }

      //sheetA.autoFilter = 'B1:AM1';

      var convert = (row) => {
        return {
          id: row.id.toString(),
          department: this.departmentIdToName[row.department],
          team: this.teamIdToName[row.team],
          owner: this.userIdToNick[row.owner],
          shopName: row.shopName,
          categoryId: this.categoryIdToName[row.categoryId],
          deduction: row.deduction,
          insurance: row.insurance,
          productName: row.productName,
          transportWay: row.transportWay,
          storehouse: row.storehouse,
          productNote: row.productNote,
          deprecated: row.deprecated ? "是" : "否",
          manufacturerName: row.manufacturerName,
          manufacturerGroup: row.manufacturerGroup,
          manufacturerPaymentMethod: row.manufacturerPaymentMethod,
          manufacturerPaymentName: row.manufacturerPaymentName,
          manufacturerPaymentId: row.manufacturerPaymentId,
          manufacturerRecipient: row.manufacturerRecipient,
          manufacturerPhone: row.manufacturerPhone,
          manufacturerAddress: row.manufacturerAddress,
          freight: row.freight,
          extraRatio: row.extraRatio,
          freightToPayment: row.freightToPayment,
          manufacturerNote: row.manufacturerNote,
        };
      };

      sheetA.addRows(datas.map((i) => convert(i)));

      sheetA.getRow(1).alignment = centerAlignment;
      sheetA.getRow(1).font = headerFont;
      for (let columnNum = 1; columnNum <= sheetA.columns.length; columnNum++) {
        sheetA.getColumn(columnNum).alignment = centerAlignment;
        sheetA.getRow(1).getCell(columnNum).border = {
          bottom: { style: "medium", color: { argb: "FF000000" } },
        };
      }

      console.log("生成完毕");

      const buffer = await workbook.xlsx.writeBuffer();
      const fileType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

      const blob = new Blob([buffer], { type: fileType });

      saveAs(blob, `商品明细.xlsx`);
    },

    loadData() {
      console.log("loaddata");
      console.log("k", this.options);
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      // console.log({ page, itemsPerPage, match: JSON.stringify(this.search) });
      economyGetAllProducts({ page, itemsPerPage, match: JSON.stringify(this.search) })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.showHeaders();
          this.products = res.data.products;
          this.totalProducts = res.data.total;
          this.category = res.data.category;
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>
  
  <style src="./Economy.scss" lang="scss">
//we grow, we sow, we feed our people;
//we learn, we build, we protect our people.
//keep forward, we are the proletariet.
</style>
  
  