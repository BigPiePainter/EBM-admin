
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
          <v-tab>
            <span class="text-body-1">内部归属</span>
          </v-tab>
          <v-toolbar flat v-if="tabs == 0" :key="1">
  
            <v-btn small depressed class="ml-2" @click="download">
              <v-icon small class="mr-1"> mdi-export </v-icon>
              <span> 导出 </span>
            </v-btn>

            <v-btn small depressed class="ml-2" @click="check = !check">
              <v-icon small class="mr-1">
                {{
                  check
                    ? "mdi-checkbox-marked-outline"
                    : "mdi-checkbox-blank-outline"
                }}
              </v-icon>
              <span> 有效SKU </span>
            </v-btn>
          </v-toolbar>
          <v-toolbar flat v-else-if="tabs == 1" :key="2">
  
            <v-btn small depressed class="ml-2">
              <v-icon small class="mr-1"> mdi-export </v-icon>
              <span class="" color=""> 导出 </span>
            </v-btn>
            
            <v-btn
              small
              depressed
              class="ml-2"
              @click="showRecipientInfo = !showRecipientInfo"
            >
              <v-icon small class="mr-1">
                {{
                  showRecipientInfo
                    ? "mdi-checkbox-marked-outline"
                    : "mdi-checkbox-blank-outline"
                }}
              </v-icon>
              <span> 显示收款信息 </span>
            </v-btn>
            <v-btn
              small
              depressed
              class="ml-2"
              @click="showDeliveryInfo = !showDeliveryInfo"
            >
              <v-icon small class="mr-1">
                {{
                  showDeliveryInfo
                    ? "mdi-checkbox-marked-outline"
                    : "mdi-checkbox-blank-outline"
                }}
              </v-icon>
              <span> 显示退货信息 </span>
            </v-btn>
          </v-toolbar>
          <v-toolbar flat v-else-if="tabs == 2" :key="3">
          </v-toolbar>
        </v-tabs>
        <v-expand-transition>
          <v-tabs-items v-model="tabs" v-if="itemShow">
            <v-tab-item>
              <v-data-table
                v-model="skuSelected"
                loading-text="加载中... 请稍后"
                no-data-text="空"
                :headers="headers"
                :show-select="skuAction"
                @click:row="showselect"
                :items="check ? validSkuInfos : skuInfos"
                :loading="loading"
                item-key="uid"
                :hide-default-footer="
                  (check ? validSkuInfos : skuInfos).length <= 10
                "
                :items-per-page="10"
                :footer-props="{
                  'items-per-page-options': [10, 20, 50, 100],
                  'items-per-page-text': '每页显示条数',
                }"
              >
                <template v-slot:[`header.skuPrice`]="{ header }">
                  <span class="mr-1">
                    {{ header.text }}
                  </span>
                </template>
                <template v-slot:[`header.skuCost`]="{ header }">
                  <span class="mr-2">
                    {{ header.text }}
                  </span>
                </template>
                <template v-slot:[`item.skuPrice`]="{ item }">
                  ￥{{ item.skuPrice }}
                </template>
                <template v-slot:[`item.skuCost`]="{ item }">
                  ￥{{ item.skuCost }}
                </template>
  
                <template v-slot:[`item.startTime`]="{ item }">
                  {{ parseDate(item.startTime) }}
                </template>
                <template v-slot:[`item.createTime`]="{ item }">
                  {{ parseDateTime(item.createTime) }}
                </template>
              </v-data-table>
            </v-tab-item>
            <v-tab-item>
              <v-data-table
                item-key="uid"
                v-model="manufactureSelected"
                :show-select="manufactureAction"
                single-select
                calculate-widths
                loading-text="加载中... 请稍后"
                no-data-text="空"
                :headers="calculatedManufacturerHeaders"
                :items="manufacturerInfos"
                :loading="loading"
                :hide-default-footer="manufacturerInfos.length <= 10"
                :items-per-page="10"
                :footer-props="{
                  'items-per-page-options': [10, 20, 50, 100],
                  'items-per-page-text': '每页显示条数',
                }"
              >
                <template v-slot:[`item.freight`]="{ item }">
                  {{ !item.freightToPayment ? "￥ " + item.freight : "" }}
                </template>
                <!-- <template v-slot:[`item.extraRatio`]="{ item }">
                  {{ !item.freightToPayment ? item.extraRatio + " %" : "" }}
                </template> -->
                <template v-slot:[`item.freightToPayment`]="{ item }">
                  {{
                    item.freightToPayment > 0 ? item.freightToPayment + " %" : ""
                  }}
                </template>
  
                <template v-slot:[`item.startTime`]="{ item }">
                  {{ parseDate(item.startTime) }}
                </template>
              </v-data-table>
            </v-tab-item>
            <v-tab-item>
              <v-data-table
                item-key="uid"
                v-model="ascriptionSelected"
                :show-select="ascriptionAction"
                calculate-widths
                loading-text="加载中... 请稍后"
                no-data-text="空"
                :headers="ascriptionHeaders"
                :items="ascriptionInfos"
                :loading="loading"
                :sort-by="['startTime']"
                :sort-desc="[true]"
                :hide-default-footer="ascriptionInfos.length <= 3"
                :items-per-page="3"
                :footer-props="{
                  'items-per-page-options': [3, 10, 20, 50],
                  'items-per-page-text': '每页显示条数',
                }"
              >
                <template v-slot:[`item.department`]="{ item }">
                  {{ departmentIdToName[item.department] }}
                </template>
                <template v-slot:[`item.team`]="{ item }">
                  {{ teamIdToName[item.team] }}
                </template>
                <template v-slot:[`item.owner`]="{ item }">
                  {{ userIdToNick[item.owner] }}
                </template>
                <template v-slot:[`item.startTime`]="{ item }">
                  {{ parseDate(item.startTime) }}
                </template>
              </v-data-table>
            </v-tab-item>
          </v-tabs-items>
        </v-expand-transition>
      </div>
      <div v-else>
        <v-progress-circular
          class="ml-10 mb-2 mt-2"
          size="25"
          width="3"
          indeterminate
          color="grey"
        >
        </v-progress-circular>
      </div>

    </div>
  </template>
  
  
  
  <script>
  import { saveAs } from "file-saver";
  import { mapState } from "vuex";
  import { loadSkus } from "@/settings/sku";
  import { loadAscriptions } from "@/settings/ascription";
  import { loadManufacturers } from "@/settings/manufacturer";
  import { javaUTCDateToString } from "@/libs/utils";
  import { javaDateTimeToString } from "@/libs/utils";
  
  export default {
    components: {
    },
  
    props: {
      //skuInfos: Array,
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
        valid: false,
        ascriptionSelected: [],
        ascriptionAction: false,
        manufactureAction: false,
        manufactureSelected: [],
        skuAction: false,
        skuSelected: [],
        show: false,
        itemShow: false,
  
        tabs: 0,
  
        deleteSkuDialog: false, //删除SKU弹框
        mutipleDeleteDialog: false,
        deleteSkuUid: [], //删除信息
        deleteSkuItemParse: [], //删
  
        deleteAscriptionDialog: false, //删除商品归属弹框
        deleteAscriptionItem: {},
        deleteAscriptionItemParse: {},
  
        deleteManufacturerDialog: false, //删除厂家弹框
        deleteManufacturerItem: {},
        deleteManufacturerItemParse: {},
  
        manufacturerInfoDialog: false,
        manufacturerEdit: {},
        manufacturerMode: 0, // 1--添加模式,  2--修改模式
  
        headers: [
          { text: "SKUID", align: "start", value: "skuId" },
          { text: "SKU名称", align: "start", value: "skuName" },
          { text: "售卖价", align: "end", value: "skuPrice" },
          { text: "成本", align: "end", value: "skuCost" },
          { text: "价格开始时间", align: "start", value: "startTime" },
          //{ text: "价格截止时间", align: "start", value: "endTime" },
          { text: "销售子订单条数", align: "start", value: "orderNum" },
          { text: "销售数", align: "start", value: "seleNum" },
          { text: "创建时间", align: "start", value: "createTime" },
        ],
        skuInfos: [],
        validSkuInfos: [],
  
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
          {
            text: "每单运费",
            align: "end",
            value: "freight",
          },
          // {
          //   text: "子/主订单附带比",
          //   align: "end",
          //   value: "extraRatio",
          // },
          {
            text: "运费/货品成本",
            align: "end",
            value: "freightToPayment",
          },
          { text: "厂家生效时间", align: "start", value: "startTime" },
          // { text: "创建时间", align: "start", value: "createTime" },
          // { text: "修改时间", align: "start", value: "modifyTime" },
          { text: "备注", align: "start", value: "note" },
        ],
        manufacturerInfos: [],
  
        ascriptionHeaders: [
          { text: "部门", align: "start", value: "department" },
          { text: "组别", align: "start", value: "team" },
          {
            text: "持品人",
            align: "start",
            value: "owner",
          },
          {
            text: "生效时间",
            align: "start",
            value: "startTime",
          },
          { text: "备注", align: "start", value: "note" },
          { text: "操作", align: "start", value: "actions" },
        ],
        ascriptionInfos: [],
  
        datePicker: false,
  
        loading: false,
  
        check: true,
        showRecipientInfo: false,
        showDeliveryInfo: false,
  
        done: [false, false, false],
      };
    },
  
    watch: {},
  
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
  
      calculatedManufacturerHeaders: function () {
        var headers = this.manufacturerHeaders;
        if (!this.showRecipientInfo) {
          headers = headers.filter(
            (i) =>
              i.value != "manufacturerPaymentMethod" &&
              i.value != "manufacturerPaymentName" &&
              i.value != "manufacturerPaymentId"
          );
        }
        if (!this.showDeliveryInfo) {
          headers = headers.filter(
            (i) =>
              i.value != "manufacturerRecipient" &&
              i.value != "manufacturerAddress" &&
              i.value != "manufacturerPhone"
          );
        }
        return headers;
      },
    },
  
    methods: {
      // resetValidation() {
      //   this.$refs.form.resetValidation();
      //   this.manufacturerInfoDialog = false;
      // },
  
      showselect() {
        console.log(this.skuSelected);
      },
      parseDate(date) {
        return javaUTCDateToString(date);
      },
      parseDateTime(date) {
        return javaDateTimeToString(date);
      },
      dayFormat(date) {
        return Number(date.split("-")[2]);
      },
  
      init() {
        this.loading = true;
        //加载数据
        Promise.all([
          loadSkus({ productId: this.productInfo.id }),
          loadManufacturers({ productId: this.productInfo.id }),
          loadAscriptions({ productId: this.productInfo.id }),
        ]).then((res) => {
          // console.log("请求结束");
          // console.log(res);
          this.skuInfos = res[0].data.skus;
          this.manufacturerInfos = res[1].data.manufacturers;
          this.ascriptionInfos = res[2].data.ascriptions;
          this.dataAnalyze();
          // console.log("显示");
          this.loading = false;
          this.show = true;
          //this.itemShow = true;
          // setTimeout(() => {
          //   this.itemShow = true;
          // }, 0);
          this.$nextTick(() => {
            this.itemShow = true;
          });
        });
      },
  
      dataAnalyze() {
        var skuId = {};
        this.skuInfos.forEach((sku) => {
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
        console.log(this.skuInfos);
  
        this.validSkuInfos = [];
        for (let id in skuId) this.validSkuInfos.push(skuId[id].sku);
      },
  
      async download() {
        const ExcelJS = require("exceljs");
  
        const workbook = new ExcelJS.Workbook();
        workbook.creator = "泼发EBC";
        workbook.lastModifiedBy = "泼发EBC";
        console.log(this.user);
        workbook.company = "浙江泼发进出口贸易有限公司";
        workbook.manager = this.user.nick + " " + this.user.username;
        workbook.created = new Date();
        workbook.modified = new Date();
  
        const sheetA = workbook.addWorksheet("有效SKU信息", {
          views: [{ state: "frozen", ySplit: 1 }],
        });
        const sheetB = workbook.addWorksheet("全部SKU信息", {
          views: [{ state: "frozen", ySplit: 1 }],
        });
  
        var font = {
          name: "微软雅黑",
          size: 10,
        };
        var font2 = {
          name: "微软雅黑",
          size: 10,
          color: { argb: "FFAAAAAA" },
        };
  
        var centerAlignment = {
          vertical: "center",
          horizontal: "center",
        };
        var ltAlignment = {
          vertical: "top",
          horizontal: "left",
        };
        var rtAlignment = {
          vertical: "top",
          horizontal: "right",
        };
        var backgroundYellow = {
          type: "pattern",
          pattern: "solid",
          fgColor: { argb: "FFFFFF00" },
        };
        // var backgroundBlue = {
        //   type: "pattern",
        //   pattern: "solid",
        //   fgColor: { argb: "FFDCE6F1" },
        // };
  
        console.log(sheetA);
        sheetA.columns = [
          {
            header: "商品ID",
            key: "productId",
            width: 15,
            style: { font },
          },
          {
            header: "SKUID",
            key: "skuId",
            width: 16,
            style: { font },
          },
          {
            header: "SKU名称",
            key: "skuName",
            width: 70,
            style: { font },
          },
          {
            header: "售卖价",
            key: "skuPrice",
            width: 13,
            style: { font },
          },
          {
            header: "成本",
            key: "skuCost",
            width: 13,
            style: { font },
          },
          {
            header: "价格开始时间",
            key: "startTime",
            width: 15,
            style: { font },
          },
          {
            header: "EBC导入时间",
            key: "createTime",
            width: 20,
            style: { font: font2 },
          },
        ];
  
        sheetA.getColumn(6).alignment = rtAlignment;
        sheetA.getColumn(7).alignment = rtAlignment;
        sheetA.getRow(1).alignment = centerAlignment;
        sheetA.getCell("A1").fill = backgroundYellow;
        sheetA.getCell("B1").fill = backgroundYellow;
        sheetA.getCell("C1").fill = backgroundYellow;
        sheetA.getCell("D1").fill = backgroundYellow;
        sheetA.getCell("E1").fill = backgroundYellow;
        sheetA.getCell("F1").fill = backgroundYellow;
        // sheetA.getCell("G1").fill = backgroundBlue;
  
        sheetA.getColumn(4).numFmt =
          '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
        sheetA.getColumn(5).numFmt =
          '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
        // sheetA.getColumn(6).numFmt = "yyyy年m月d日";
        // sheetA.getColumn(7).numFmt = "yyyy-m-d hh:mm:ss";
  
        sheetB.columns = [
          {
            header: "商品ID",
            key: "productId",
            width: 15,
            style: { font },
          },
          {
            header: "SKUID",
            key: "skuId",
            width: 16,
            style: { font },
          },
          {
            header: "SKU名称",
            key: "skuName",
            width: 70,
            style: { font },
          },
          {
            header: "售卖价",
            key: "skuPrice",
            width: 13,
            style: { font },
          },
          {
            header: "成本",
            key: "skuCost",
            width: 13,
            style: { font },
          },
          {
            header: "价格开始时间",
            key: "startTime",
            width: 15,
            style: { font },
          },
          {
            header: "EBC导入时间",
            key: "createTime",
            width: 20,
            style: { font: font2 },
          },
        ];
  
        sheetB.getColumn(1).alignment = ltAlignment;
        sheetB.getColumn(2).alignment = ltAlignment;
        sheetB.getColumn(6).alignment = rtAlignment;
        sheetB.getColumn(7).alignment = rtAlignment;
        sheetB.getRow(1).alignment = centerAlignment;
        sheetB.getCell("A1").fill = backgroundYellow;
        sheetB.getCell("B1").fill = backgroundYellow;
        sheetB.getCell("C1").fill = backgroundYellow;
        sheetB.getCell("D1").fill = backgroundYellow;
        sheetB.getCell("E1").fill = backgroundYellow;
        sheetB.getCell("F1").fill = backgroundYellow;
        // sheetB.getCell("G1").fill = backgroundBlue;
  
        sheetB.getColumn(4).numFmt =
          '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
        sheetB.getColumn(5).numFmt =
          '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
        // sheetB.getColumn(6).numFmt = "yyyy年m月d日";
        // sheetB.getColumn(7).numFmt = "yyyy-m-d hh:mm:ss";
  
        var skus = {};
        this.skuInfos.forEach((i) => {
          if (skus[i.skuId]) {
            skus[i.skuId].push(i);
          } else {
            skus[i.skuId] = [i];
          }
        });
        for (let name in skus) {
          skus[name].sort((b, a) => {
            if (a.startTime == b.startTime) {
              return a.createTime - b.createTime;
            } else {
              return a.startTime - b.startTime;
            }
          });
          console.log(name);
        }
        console.log(skus);
  
        var convert = (i, lite) => {
          return {
            productId: lite ? "" : i.productId.toString(),
            skuId: lite ? "" : i.skuId.toString(),
            skuName: i.skuName,
            skuPrice: i.skuPrice,
            skuCost: i.skuCost,
            startTime: this.parseDate(i.startTime),
            createTime: this.parseDateTime(i.createTime),
          };
        };
  
        var sheetAData = [];
        for (let id in skus) {
          sheetAData.push(skus[id][0]);
        }
        sheetA.addRows(sheetAData.map((i) => convert(i)));
  
        for (let id in skus) {
          var startRow = sheetB.addRow(convert(skus[id].shift()));
          console.log(startRow);
          for (let index = 1; index <= 6; index++) {
            //startRow.getCell(index).fill = backgroundBlue;
          }
  
          for (let index = 1; index <= 7; index++) {
            startRow.getCell(index).border = {
              //top: { style: "thin", color: { argb: "FF000000" } },
              //left: { style: "thin", color: { argb: "FF95B3D7" } },
            };
          }
  
          var totalLength = skus[id].length;
          for (let index = 0; index < totalLength - 1; index++) {
            var row = sheetB.addRow(convert(skus[id].shift(), true));
            row.getCell(2).border = {
              //left: { style: "thin", color: { argb: "FFFFFFFF" } },
            };
          }
  
          if (skus[id].length > 0) {
            var endRow = sheetB.addRow(convert(skus[id].shift()));
  
            sheetB.mergeCells(
              startRow.getCell(1).address,
              endRow.getCell(1).address
            );
            sheetB.mergeCells(
              startRow.getCell(2).address,
              endRow.getCell(2).address
            );
          }
        }
  
        console.log("生成完毕");
  
        const buffer = await workbook.xlsx.writeBuffer();
        const fileType =
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
  
        const blob = new Blob([buffer], { type: fileType });
  
        saveAs(
          blob,
          `${this.userIdToNick[this.productInfo.owner]}-${
            this.productInfo.productName
          }-${this.productInfo.id}.xlsx`
        );
  
        // var skuInfoCopy = [];
  
        // for (let sku of this.check ? this.validSkuInfos : this.skuInfos) {
        //   console.log(sku);
        //   skuInfoCopy.push({
        //     productId: sku.productId + "",
        //     skuId: sku.skuId + "",
        //     skuName: sku.skuName,
        //     skuPrice: sku.skuPrice,
        //     skuCost: sku.skuCost,
        //     startTime: javaUTCDateToString(sku.startTime),
        //   });
        // }
  
        // const XLSX = require("xlsx");
  
        // console.log(skuInfoCopy);
        // const raw_data = skuInfoCopy;
        // //this.check ? this.validSkuInfos : this.skuInfos;
        // /*
        // const prez = raw_data.filter((row) =>
        //   row.terms.some((term) => term.type === "prez")
        // );*/
        // const rows = raw_data.map((row) => row);
        // /* generate worksheet and workbook */
        // const worksheet = XLSX.utils.json_to_sheet(rows);
        // const workbook = XLSX.utils.book_new();
        // XLSX.utils.book_append_sheet(workbook, worksheet, "SKU数据");
        // /* fix headers */
        // XLSX.utils.sheet_add_aoa(
        //   worksheet,
        //   [["商品ID", "SKUID", "SKU名称", "售卖价", "成本", "价格开始时间"]],
        //   {
        //     origin: "A1",
        //   }
        // );
  
        // worksheet["!cols"] = [
        //   { wch: 14 },
        //   { wch: 14 },
        //   { wch: 70 },
        //   { wch: 8 },
        //   { wch: 8 },
        //   { wch: 13 },
        // ];
  
        // /* create an XLSX file and try to save to Presidents.xlsx */
        // XLSX.writeFile(
        //   workbook,
        //   `${this.productInfo.owner}-${this.productInfo.productName}-${this.productInfo.id}.xlsx`
        // );
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
  //关山难越，谁悲失路之人
  //萍水相逢，尽是他乡之客
  </style>