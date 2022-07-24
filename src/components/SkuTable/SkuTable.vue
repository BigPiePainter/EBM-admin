:items="check ? validSkuInfo : skuInfo"
<template>
  <v-data-table
    calculate-widths
    :dense="dense"
    :loading="loading"
    loading-text="加载中... 请稍后"
    no-data-text="空"
    :headers="headers"
    :items="skuInfo"
    :items-per-page="50"
    :footer-props="{
      'items-per-page-options': [10, 20, 50, 100],
      'items-per-page-text': '每页显示条数',
    }"
    class="elevation-1 mb-1"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>SKU信息</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>

        <v-spacer></v-spacer>
        <v-switch v-model="check" label="有效SKU" class="pr-5 pt-6"></v-switch>

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

        <v-dialog v-model="sdialogDelete" max-width="500px">
          <v-card>
            <v-card-title class="text-h5">是否确定删除？</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="secondcloseDelete"
                >取消</v-btn
              >
              <v-btn color="blue darken-1" text @click="seconddeleteItemConfirm"
                >完成</v-btn
              >
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small @click="seconddeleteItem(item)"> mdi-delete </v-icon>
    </template>
  </v-data-table>
</template>



<script>
import SkuUpload from "@/components/SkuUpload/SkuUpload";
import { loadSkus } from "@/settings/sku";
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

  data() {
    return {
      // sdialog: false,
      sdialogDelete: false,
      ssdialogs: false,

      status: "松开上传",
      progress: false,

      headers: [],
      skuInfo: [],
      skuInfo1: [],
      validSkuInfo: [],

      dense: false,
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

  watch: {
    // sdialog(val) {
    //   val || this.secondclose();
    // },
    sdialogDelete(val) {
      val || this.secondcloseDelete();
    },
  },

  methods: {
    initialSkuInfo() {
      this.loading = true;

      //加载数据
      loadSkus({ productId: this.productsInfo.id })
        .then((res) => {
          //加载表头
          this.headers = [
            { text: "SKUID", align: "start", value: "skuId" },
            {
              text: "SKU名称",
              align: "start",
              sortable: false,
              value: "skuName",
            },
            { text: "售卖价", align: "start", value: "skuPrice" },
            { text: "成本", align: "start", value: "skuCost" },
            { text: "价格开始时间", align: "start", value: "startTime" },
            //{ text: "价格截止时间", align: "start", value: "endTime" },
            { text: "销售子订单条数", align: "start", value: "orderNum" },
            { text: "销售数", align: "start", value: "seleNum" },
            { text: "Actions", value: "actions", sortable: false },
          ];

          console.log(res);
          this.loading = false;
          this.skuInfo = res.data.skus;

          // this.skuInfo.forEach((item) => {
          //   if (item.end == "至今") {
          //     this.validSkuInfo.push(item);
          //   }
          // });
        })
        .catch(() => {
          this.loading = false;
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
          startTime: sku.startTime,
        });
      }

      var date = new Date();
      for (let i = 0; i < Object.keys(skuInfoCopy).length; i++) {
        date.setTime(skuInfoCopy[i].startTime);

        var month = date.getUTCMonth() + 1;
        var day = date.getUTCDate();

        date.setTime(skuInfoCopy[i].startTime);
        skuInfoCopy[i].startTime = `${date.getUTCFullYear()}-${
          month < 10 ? "0" + month : month
        }-${day < 10 ? "0" + day : day}`;
        console.log(date);
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

    // secondeditItem(item) {
    //   this.seditedIndex = this.subTableEdited.indexOf(item);
    //   this.secondeditedItem = Object.assign({}, item);
    //   this.sdialog = true;
    // },

    seconddeleteItem(item) {
      this.seditedIndex = this.subTableEdited.indexOf(item);
      this.secondeditedItem = Object.assign({}, item);
      this.sdialogDelete = true;
    },

    seconddeleteItemConfirm() {
      this.subTableEdited.splice(this.seditedIndex, 1);
      this.secondcloseDelete();
    },

    secondclose() {
      // this.sdialog = false;
      this.$nextTick(() => {
        this.secondeditedItem = Object.assign({}, this.seconddefaultItem);
        this.seditedIndex = -1;
      });
    },

    secondcloseDelete() {
      this.sdialogDelete = false;
      this.$nextTick(() => {
        this.secondeditedItem = Object.assign({}, this.seconddefaultItem);
        this.seditedIndex = -1;
      });
    },

    secondsave() {
      if (this.seditedIndex > -1) {
        console.log("444444444");
        Object.assign(
          this.subTableEdited[this.seditedIndex],
          this.secondeditedItem
        );
      } else {
        this.subTableEdited.push(this.secondeditedItem);
      }
      this.secondclose();
    },
  },
};
</script>



<style scoped lang="scss">
</style>