
<template>
  <div>
    <div v-if="show" class="sub-table elevation-20 ml-2 mb-3">
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
          <v-spacer />
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

          <SkuUpload :product="productInfo" />
        </v-toolbar>
        <v-toolbar flat v-else :key="2">
          <v-spacer />
          <v-btn small color="primary" @click="addManufacturerButton">
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
                  color="green"
                  @click="editManufacturerButton(item)"
                  class="ml-1"
                >
                  修改
                </v-btn>
                <v-btn
                  small
                  depressed
                  outlined
                  color="red lighten-2"
                  @click="deleteManufacturerButton(item)"
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
    <div v-else>
      <v-progress-circular
        class="ml-10 mb-2"
        size="25"
        width="3"
        indeterminate
        color="grey"
      >
      </v-progress-circular>
    </div>

    <!-- 删除SKU Dialog -->
    <v-dialog v-model="deleteSkuDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1">{{
          deleteSkuItem.skuName
        }}</v-card-title>

        <div class="mt-2">
          <TableKV :items="deleteSkuItemParse" />
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="deleteSkuDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDeleteSkuButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 厂家信息Dialog -->
    <v-dialog v-model="manufacturerInfoDialog" max-width="600px">
      <v-card>
        <v-form>
          <v-col class="px-10 py-10 manufacturer-dialog">
            <v-row>
              <span class="text-subtitle-1">基本信息</span>
            </v-row>
            <v-row>
              <v-col>
                <span class="text-body-2 text--secondary">厂家名* </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  required
                  v-model="manufacturerEdit.manufacturerName"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary">厂家群名 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerGroup"
                ></v-text-field
              ></v-col>
            </v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">收款信息</span>
            </v-row>
            <v-row>
              <v-col cols="5">
                <span class="text-body-2 text--secondary"> 收款人 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPaymentName"
                ></v-text-field
              ></v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 收款方式 </span>

                <v-combobox
                  outlined
                  dense
                  hide-details
                  :items="[
                    '支付宝',
                    '中国银行',
                    '中国农业银行',
                    '中国工商银行',
                  ]"
                  v-model="manufacturerEdit.manufacturerPaymentMethod"
                ></v-combobox>
              </v-col>
            </v-row>
            <v-row
              ><v-col>
                <span class="text-body-2 text--secondary"> 收款账户 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPaymentId"
                ></v-text-field></v-col
            ></v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">退货信息</span>
            </v-row>
            <v-row>
              <v-col cols="5">
                <span class="text-body-2 text--secondary"> 收件人 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerRecipient"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 收件手机号 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPhone"
                ></v-text-field
              ></v-col>
            </v-row>
            <v-row
              ><v-col>
                <span class="text-body-2 text--secondary"> 收件地址 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerAddress"
                ></v-text-field></v-col
            ></v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">运费信息</span>
            </v-row>
            <v-row>
              <v-col cols="4">
                <span class="text-body-2 text--secondary"> 每单运费 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.freight"
                  suffix="￥"
                ></v-text-field>
              </v-col>
              <v-col cols="4">
                <span class="text-body-2 text--secondary">
                  子/主订单附带比
                </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.extraRatio"
                ></v-text-field
              ></v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 运费/总货款 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.freightToPayment"
                ></v-text-field
              ></v-col>
            </v-row>

            <v-divider class="my-7" />

            <v-row>
              <v-col cols="3">
                <span class="text-body-2 text--secondary"> 选择起始日期* </span>
                <v-menu
                  ref="menu"
                  v-model="datePicker"
                  :close-on-content-click="false"
                  :return-value.sync="manufacturerEdit.startTime"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="manufacturerEdit.startTime"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                      outlined
                      dense
                      hide-details
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="manufacturerEdit.startTime"
                    no-title
                    scrollable
                    locale="zh-cn"
                    first-day-of-week="1"
                    :day-format="dayFormat"
                  >
                    <v-spacer></v-spacer>
                    <v-btn text color="primary" @click="datePicker = false">
                      取消
                    </v-btn>
                    <v-btn
                      text
                      color="primary"
                      @click="$refs.menu.save(manufacturerEdit.startTime)"
                    >
                      确定
                    </v-btn>
                  </v-date-picker>
                </v-menu>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 备注 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.note"
                ></v-text-field
              ></v-col>
            </v-row>
          </v-col>
        </v-form>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">带*为必填项目</p>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="manufacturerInfoDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="blue darken-1"
            text
            @click="sureButton"
            type="submit"
            :disabled="isEmpty"
          >
            {{ manufacturerMode == 1 ? "添加" : "修改" }}</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除厂家 Dialog -->
    <v-dialog v-model="deleteManufacturerDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1">{{
          deleteManufacturerItem.manufacturerName
        }}</v-card-title>

        <div class="mt-2">
          <TableKV :items="deleteManufacturerItemParse" />
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="deleteManufacturerDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="red darken-1"
            text
            @click="sureDeleteManufacturerButton"
          >
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import SkuUpload from "@/components/SkuUpload/SkuUpload";
import TableKV from "@/components/TableKV/TableKV";
import { loadSkus } from "@/settings/sku";
import { deleteSku } from "@/settings/sku";

import { loadManufacturers } from "@/settings/manufacturer";
import { addManufacturer } from "@/settings/manufacturer";
import { deleteManufacturer } from "@/settings/manufacturer";
import { editManufacturer } from "@/settings/manufacturer";

editManufacturer;
//import { deleteSkus } from "@/settings/sku";
//import * as XLSX from 'xlsx/xlsx.mjs';

import { javaUTCDateToString } from "@/libs/utils";
import { javaDateTimeToString } from "@/libs/utils";

export default {
  components: {
    SkuUpload,
    TableKV,
  },

  props: {
    //skuInfo: Array,
    productInfo: Object,
  },

  created() {
    this.init();
  },

  mounted() {
    //this.show = true
  },

  data() {
    return {
      show: false,
      itemShow: false,

      tabs: 0,

      deleteSkuDialog: false, //删除SKU弹框
      deleteSkuItem: {}, //删除信息
      deleteSkuItemParse: {}, //删

      deleteManufacturerDialog: false, //删除厂家弹框
      deleteManufacturerItem: {},
      deleteManufacturerItemParse: {},

      manufacturerInfoDialog: false,
      manufacturerEdit: {},
      manufacturerMode: 0, // 1--添加模式,  2--修改模式

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
        { text: "厂家名", align: "start", value: "manufacturerName" },
        { text: "厂家群名", align: "start", value: "manufacturerGroup" },
        {
          text: "厂家收款方式",
          align: "start",
          value: "manufacturerPaymentMethod",
        },
        {
          text: "厂家收款人",
          align: "start",
          value: "manufacturerPaymentName",
        },
        {
          text: "厂家收款号码",
          align: "start",
          value: "manufacturerPaymentId",
        },
        {
          text: "厂家退货-收件人",
          align: "start",
          value: "manufacturerRecipient",
        },
        {
          text: "厂家退货-收件手机号",
          align: "start",
          value: "manufacturerPhone",
        },
        {
          text: "厂家退货-收件地址",
          align: "start",
          value: "manufacturerAddress",
        },
        { text: "厂家生效时间", align: "start", value: "calculatedStartTime" },
        { text: "创建时间", align: "start", value: "calculatedCreateTime" },
        { text: "修改时间", align: "start", value: "calculatedModifyTime" },
        { text: "备注", align: "start", value: "note" },
        { text: "操作", align: "start", value: "actions" },
      ],
      manufacturerInfo: [],

      datePicker: false,

      loading: false,

      check: true,
    };
  },

  watch: {},

  computed: {
    isEmpty: function () {
      var check = ["manufacturerName", "startTime"];
      var pass = true;
      check.forEach((item) => {
        if (!this.manufacturerEdit[item]) pass = false;
      });

      console.log(pass);

      return !pass;
    },
  },

  methods: {
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    initDone() {
      console.log("check done");
      if (!this.skuDone || !this.manufacturerDone) return;

      console.log("显示");
      this.loading = false;
      this.show = true;
      //this.itemShow = true;

      // setTimeout(() => {
      //   this.itemShow = true;
      // }, 0);

      this.$nextTick(() => {
        this.itemShow = true;
      });
    },

    init() {
      this.loading = true;
      //加载数据
      loadSkus({ productId: this.productInfo.id })
        .then((res) => {
          console.log(res);
          this.skuInfo = res.data.skus;
          //数据处理
          this.dataAnalyze();
          this.skuDone = true;
          this.initDone();
        })
        .catch(() => {
          this.loading = false;
        });
      loadManufacturers({ productId: this.productInfo.id })
        .then((res) => {
          console.log(res);
          this.manufacturerInfo = res.data.manufacturers;
          this.dataAnalyzeManufacturer();
          this.manufacturerDone = true;
          console.log(this.manufacturerInfo);
          this.initDone();
        })
        .catch(() => {
          this.loading = false;
        });
    },

    dataAnalyze() {
      this.skuInfo.forEach((sku) => {
        sku.calculatedStartTime = javaUTCDateToString(sku.startTime);
        sku.calculatedCreateTime = javaDateTimeToString(sku.createTime);
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

    dataAnalyzeManufacturer() {
      this.manufacturerInfo.forEach((manufacturer) => {
        console.log(manufacturer);
        manufacturer.calculatedStartTime = javaUTCDateToString(
          manufacturer.startTime
        );
        manufacturer.calculatedCreateTime = javaDateTimeToString(
          manufacturer.createTime
        );
        manufacturer.calculatedModifyTime = javaDateTimeToString(
          manufacturer.modifyTime
        );
      });
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
        `${this.productInfo.owner}-${this.productInfo.productName}-${this.productInfo.id}.xlsx`
      );
    },

    deleteSku(item) {
      console.log(item);

      this.deleteSkuItem = { ...item };
      this.deleteSkuItemParse = [
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

      this.deleteSkuDialog = true;
    },

    sureDeleteSkuButton() {
      this.deleteSkuDialog = false;
      deleteSku({ uid: this.deleteSkuItem.uid })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
    },

    deleteManufacturerButton(item) {
      console.log(item);

      this.deleteManufacturerItem = { ...item };
      this.deleteManufacturerItemParse = [
        {
          key: "厂家名",
          value: item.manufacturerName,
        },
        {
          key: "厂家群名",
          value: item.manufacturerGroup,
        },
        {
          key: "厂家收款方式",
          value: item.manufacturerPaymentMethod,
        },
        {
          key: "厂家收款人",
          value: item.manufacturerPaymentName,
        },
        {
          key: "厂家收款号码",
          value: item.manufacturerPaymentId,
        },
        {
          key: "厂家生效时间",
          value: item.calculatedStartTime,
        },
      ];

      this.deleteManufacturerDialog = true;
    },

    //deleteManufacturer

    sureDeleteManufacturerButton() {
      this.deleteManufacturerDialog = false;
      deleteManufacturer({ uid: this.deleteManufacturerItem.uid })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
    },

    editManufacturerButton(item) {
      this.manufacturerMode = 2; //"修改"模式
      this.manufacturerEdit = { ...item };
      //注意
      this.manufacturerEdit.startTime =
        this.manufacturerEdit.calculatedStartTime;
      this.manufacturerInfoDialog = true;
    },

    addManufacturerButton() {
      this.manufacturerMode = 1; //"添加"模式
      this.manufacturerEdit = {};
      this.manufacturerInfoDialog = true;
    },

    sureButton() {
      this.manufacturerMode == 1
        ? this.newManufacturer()
        : this.modifyManufacturer();
    },

    newManufacturer() {
      this.manufacturerInfoDialog = false;
      console.log(this.manufacturerEdit);
      var pars = { productId: this.productInfo.id, ...this.manufacturerEdit };
      pars.startTime = pars.startTime.replaceAll("-", "/");
      console.log(pars);
      addManufacturer(pars)
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
    },

    modifyManufacturer() {
      this.manufacturerInfoDialog = false;
      var pars = { ...this.manufacturerEdit };

      //参数预处理
      pars.startTime = pars.startTime.replaceAll("-", "/");
      for (let name in pars) pars[name] == null && delete pars[name];
      pars.manufacturerPaymentMethod || (pars.manufacturerPaymentMethod = "");

      console.log(pars);
      editManufacturer(pars)
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
    },
  },
};
</script>



<style scoped lang="scss">
// .delete-table-container {
//   width: fit-content;
// }
.sub-table {
  width: fit-content;
  // background-color: red;
  transform: translateY(-5px);
  border-radius: 20px;
}

.v-card__title {
  overflow: hidden;
  text-overflow: ellipsis;
}

.manufacturer-dialog {
  .col {
    padding-top: 5px;
    padding-bottom: 5px;
  }

  .v-input {
    font-size: 15px;
  }
}

.v-menu__content {
  .v-list {
    .v-list-item__title {
      font-size: 15px;
    }
  }
}
</style>