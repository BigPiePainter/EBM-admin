
<template>
  <div>
    <div v-if="show">
      <v-tabs v-model="tabs" align-with-title>
        <!-- align-with-title -->
        <!-- <v-tabs-slider color="yellow"></v-tabs-slider> -->
        <v-tab>
          <span class="text-body-1">SKU信息</span>
        </v-tab>
        <v-tab>
          <span class="text-body-1">厂家信息</span>
        </v-tab>
        <v-toolbar flat v-if="tabs == 0" :key="1">
          <v-spacer></v-spacer>
          <v-switch
            v-model="check"
            label="有效SKU"
            class="pr-5 pt-6"
          ></v-switch>

          <v-btn
            color="green lighten-2"
            small
            dark
            @click="download"
            class="mr-3"
          >
            导出
          </v-btn>

          <SkuUpload :product="productsInfo" />
        </v-toolbar>
        <v-toolbar flat v-else :key="2">
          <v-spacer></v-spacer>
          <v-btn small color="primary" @click="addManufacturerDialog = true">
            新增厂家信息
          </v-btn>
        </v-toolbar>
      </v-tabs>
      <v-expand-transition>
        <v-tabs-items v-model="tabs" v-if="itemShow">
          <v-tab-item>
            <v-data-table
              loading-text="加载中... 请稍后"
              no-data-text="空"
              :headers="headers"
              :items="check ? validSkuInfo : skuInfo"
              :loading="loading"
              :hide-default-footer="
                (check ? validSkuInfo : skuInfo).length <= 10
              "
              :items-per-page="10"
              :footer-props="{
                'items-per-page-options': [10, 20, 50, 100],
                'items-per-page-text': '每页显示条数',
              }"
            >
              <template v-slot:[`item.actions`]="{ item }">
                <v-btn
                  small
                  depressed
                  outlined
                  color="red lighten-2"
                  @click="deleteSku(item)"
                  class="ml-1"
                >
                  <!-- <v-icon small class="mr-1"> mdi-delete </v-icon> -->
                  删除
                </v-btn>
              </template>
            </v-data-table>
          </v-tab-item>
          <v-tab-item>
            <v-data-table
              calculate-widths
              loading-text="加载中... 请稍后"
              no-data-text="空"
              :headers="manufacturerHeaders"
              :items="manufacturerInfo"
              :loading="loading"
              :hide-default-footer="manufacturerInfo.length <= 10"
              :items-per-page="10"
              :footer-props="{
                'items-per-page-options': [10, 20, 50, 100],
                'items-per-page-text': '每页显示条数',
              }"
            >
              <template v-slot:[`item.actions`]="{ item }">
                <v-btn
                  small
                  depressed
                  outlined
                  color="red lighten-2"
                  @click="deleteSku(item)"
                  class="ml-1"
                >
                  <!-- <v-icon small class="mr-1"> mdi-delete </v-icon> -->
                  删除
                </v-btn>
              </template>
            </v-data-table>
          </v-tab-item>
        </v-tabs-items>
      </v-expand-transition>
    </div>

    <!-- 删除SKU Dialog -->
    <v-dialog v-model="deleteDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1">{{
          deleteItem.skuName
        }}</v-card-title>

        <div class="delete-table-container mt-2">
          <v-data-table
            :headers="[
              { align: 'start', value: 'key' },
              { align: 'start', value: 'value' },
            ]"
            :items="deleteItemParse"
            hide-default-footer
            hide-default-header
            disable-sort
          >
            <template v-slot:[`item.key`]="{ item }">
              <div class="ml-3">
                {{ item.key }}
              </div>
            </template>
          </v-data-table>
        </div>

        <v-card-actions>
          <!-- <span class="text-body-2 text--secondary">
            删除后会进入回收站
          </span> -->
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="deleteDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDelete">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 新增厂家信息Dialog -->
    <v-dialog v-model="addManufacturerDialog" max-width="700px">
      <v-card>
        <v-col class="px-10 pt-10">
          <v-row>
            <span class="text-subtitle-1">基本信息</span>
          </v-row>
          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary">厂家名* </span>
              <v-text-field outlined dense hide-details></v-text-field>
            </v-col>
            <v-col>
              <span class="text-body-2 text--secondary">厂家群名* </span>
              <v-text-field outlined dense hide-details></v-text-field
            ></v-col>
          </v-row>

          <v-divider class="my-8" />

          <v-row>
            <span class="text-subtitle-1">收款信息</span>
          </v-row>
          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary"> 收款方式* </span>
              <v-text-field outlined dense hide-details></v-text-field>
            </v-col>
            <v-col>
              <span class="text-body-2 text--secondary"> 收款人* </span>
              <v-text-field outlined dense hide-details></v-text-field
            ></v-col>
          </v-row>
          <v-row
            ><v-col>
              <span class="text-body-2 text--secondary"> 收款账户* </span>
              <v-text-field outlined dense hide-details></v-text-field></v-col
          ></v-row>

          <v-divider class="my-8" />

          <v-row>
            <span class="text-subtitle-1">退货信息</span>
          </v-row>
          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary"> 收件人* </span>
              <v-text-field outlined dense hide-details></v-text-field>
            </v-col>
            <v-col>
              <span class="text-body-2 text--secondary"> 收件手机号* </span>
              <v-text-field outlined dense hide-details></v-text-field
            ></v-col>
          </v-row>
          <v-row
            ><v-col>
              <span class="text-body-2 text--secondary"> 收件地址* </span>
              <v-text-field outlined dense hide-details></v-text-field></v-col
          ></v-row>

        </v-col>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="addManufacturerDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="null">
           添加</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import SkuUpload from "@/components/SkuUpload/SkuUpload";
import { loadSkus } from "@/settings/sku";
import { deleteSku } from "@/settings/sku";

import { loadManufacturers } from "@/settings/manufacturer";
import { addManufacturer } from "@/settings/manufacturer";
//import { deleteSkus } from "@/settings/sku";
//import * as XLSX from 'xlsx/xlsx.mjs';

export default {
  components: {
    SkuUpload,
  },

  props: {
    //skuInfo: Array,
    productsInfo: Object,
  },

  created() {
    this.initialSkuInfo();
  },

  mounted() {
    //this.show = true
  },

  data() {
    return {
      show: false,
      itemShow: false,

      tabs: 0,

      deleteDialog: false, //删除弹框
      deleteItem: {}, //删除信息
      deleteItemParse: {}, //删

      addManufacturerDialog: false,

      headers: [
        { text: "SKUID", align: "start", value: "skuId" },
        { text: "SKU名称", align: "start", value: "skuName" },
        { text: "售卖价", align: "start", value: "skuPrice" },
        { text: "成本", align: "start", value: "skuCost" },
        { text: "价格开始时间", align: "start", value: "calculatedStartTime" },
        //{ text: "价格截止时间", align: "start", value: "endTime" },
        { text: "销售子订单条数", align: "start", value: "orderNum" },
        { text: "销售数", align: "start", value: "seleNum" },
        { text: "创建时间", align: "start", value: "calculatedCreateTime" },
        { text: "操作", align: "start", value: "actions" },
      ],
      skuInfo: [],
      validSkuInfo: [],

      manufacturerHeaders: [
        { text: "厂家名", align: "start", value: "skuId" },
        { text: "厂家群名", align: "start", value: "skuPrice" },
        { text: "厂家收款方式", align: "start", value: "skuCost" },
        { text: "厂家收款人", align: "start", value: "calculatedStartTime" },
        { text: "厂家收款号码", align: "start", value: "orderNum" },
        { text: "厂家退货-收件人", align: "start", value: "seleNum" },
        { text: "厂家退货-收件手机号", align: "start", value: "a" },
        { text: "厂家退货-收件地址", align: "start", value: "actions" },
        { text: "厂家生效时间", align: "start", value: "actions" },
        { text: "操作", align: "start", value: "actions" },
      ],
      manufacturerInfo: [],

      loading: false,

      check: true,

      subTableEdited: [],
      seditedIndex: -1,

      secondeditedItem: {
        name: "",
        skuId: "",
        price: "",
        cost: "",
        start: "",
        //end: "",
        orderNum: "",
        seleNum: "",
      },

      seconddefaultItem: {
        name: "",
        skuId: "",
        price: "",
        cost: "",
        start: "",
        //end: "",
        orderNum: "",
        seleNum: "",
      },
    };
  },

  watch: {},

  methods: {
    initialSkuInfo() {
      this.loading = true;
      //加载数据
      loadSkus({ productId: this.productsInfo.id })
        .then((res) => {
          console.log(res);
          this.loading = false;
          this.skuInfo = res.data.skus;

          //数据处理
          this.dataAnalyze();

          this.show = true;
          //this.itemShow = true;

          // setTimeout(() => {
          //   this.itemShow = true;
          // }, 0);

          this.$nextTick(() => {
            this.itemShow = true;
          });
        })
        .catch(() => {
          this.loading = false;
        });

      loadManufacturers({ productId: this.productsInfo.id })
        .then((res) => {
          console.log(res);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    dataAnalyze() {
      var date = new Date();
      var month, day;
      this.skuInfo.forEach((sku) => {
        console.log(sku);
        date.setTime(sku.startTime);
        month = date.getUTCMonth() + 1;
        day = date.getUTCDate();
        sku.calculatedStartTime = `${date.getUTCFullYear()}-${
          month < 10 ? "0" + month : month
        }-${day < 10 ? "0" + day : day}`;

        date.setTime(sku.createTime);
        month = date.getMonth() + 1;
        day = date.getDate();
        sku.calculatedCreateTime = `${date.getFullYear()}-${
          month < 10 ? "0" + month : month
        }-${
          day < 10 ? "0" + day : day
        } ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
      });

      var skuId = {};
      this.skuInfo.forEach((sku) => {
        if (skuId[sku.skuId]) {
          skuId[sku.skuId].count++;
          if (skuId[sku.skuId].sku.startTime < sku.startTime) {
            skuId[sku.skuId].sku = sku;
          } else if (skuId[sku.skuId].sku.startTime == sku.startTime) {
            if (skuId[sku.skuId].sku.createTime < sku.createTime) {
              skuId[sku.skuId].sku = sku;
            }
          }
        } else {
          skuId[sku.skuId] = { count: 1, sku: sku };
        }
      });
      console.log(skuId);

      this.validSkuInfo = [];
      for (let id in skuId) this.validSkuInfo.push(skuId[id].sku);
    },

    download() {
      var skuInfoCopy = [];
      for (let sku of this.skuInfo) {
        console.log(sku);
        skuInfoCopy.push({
          productId: sku.productId,
          skuId: sku.skuId,
          skuName: sku.skuName,
          skuPrice: sku.skuPrice,
          skuCost: sku.skuCost,
          startTime: sku.calculatedStartTime,
        });
      }

      const XLSX = require("xlsx");
      console.log(skuInfoCopy);
      const raw_data = skuInfoCopy; //this.check ? this.validSkuInfo : this.skuInfo;
      /*
      const prez = raw_data.filter((row) =>
        row.terms.some((term) => term.type === "prez")
      );*/
      const rows = raw_data.map((row) => row);
      /* generate worksheet and workbook */
      const worksheet = XLSX.utils.json_to_sheet(rows);
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, "SKU数据");
      /* fix headers */
      XLSX.utils.sheet_add_aoa(
        worksheet,
        [
          [
            "商品ID",
            "SKUID",
            "SKU名称",
            "售卖价",
            "成本",
            "价格开始时间",
            //"价格截止时间",
            "销售子订单条数",
            "销售数",
          ],
        ],
        {
          origin: "A1",
        }
      );

      worksheet["!cols"] = [
        { wch: 10 },
        { wch: 10 },
        { wch: 7 },
        { wch: 10 },
        { wch: 5 },
        { wch: 13 },
        //{ wch: 13 },
        { wch: 14 },
        { wch: 7 },
      ];

      /* create an XLSX file and try to save to Presidents.xlsx */
      XLSX.writeFile(
        workbook,
        `${this.productsInfo.owner}-${this.productsInfo.productName}-${this.productsInfo.id}.xlsx`
      );
    },

    deleteSku(item) {
      console.log(item);

      this.deleteItem = item;
      this.deleteItemParse = [
        {
          key: "SKUID",
          value: item.skuId,
        },
        {
          key: "售卖价",
          value: item.skuPrice,
        },
        {
          key: "单个成本",
          value: item.skuCost,
        },
        {
          key: "价格开始时间",
          value: item.calculatedStartTime,
        },
        {
          key: "创建时间",
          value: item.calculatedCreateTime,
        },
      ];

      this.deleteDialog = true;
    },

    sureDelete() {
      this.deleteDialog = false;
      deleteSku({ uid: this.deleteItem.uid })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.initialSkuInfo();
        })
        .catch(() => {});
    },

    newManufacturer() {
      addManufacturer({});
    },
  },
};
</script>



<style scoped lang="scss">
// .delete-table-container {
//   width: fit-content;
// }

.v-card__title {
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>