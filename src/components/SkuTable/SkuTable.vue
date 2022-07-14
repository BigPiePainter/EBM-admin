<template>
  <v-data-table
    calculate-widths
    :dense="dense"
    :loading="loading"
    loading-text="加载中... 请稍后"
    no-data-text="空"
    :headers="headers"
    :items="check ? validSkuInfo : skuInfo"
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

        <v-btn color="green lighten-2" dark @click="download" class="mr-3">
          导出
        </v-btn>

        <SkuUpload
          :product="productsInfo"
        />

        <v-dialog v-model="sdialog" max-width="500px">
          <v-card>
            <v-card-title>
              <span class="text-h5">SKU信息修改</span>
            </v-card-title>
            <v-card-text class="mt-6">
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.name"
                      label="SKU"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.price"
                      label="售卖价"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.cost"
                      label="成本"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.start"
                      label="价格开始时间"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.end"
                      label="价格截止时间"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.orderNum"
                      label="销售子订单条数"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="secondeditedItem.seleNum"
                      label="销售数"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>
            <!-- until there is dialog of new input-->

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="secondclose">
                取消
              </v-btn>
              <v-btn color="blue darken-1" text @click="secondsave">
                保存
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

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
      <v-icon small class="mr-2" @click="secondeditItem(item)">
        mdi-pencil
      </v-icon>
      <v-icon small @click="seconddeleteItem(item)"> mdi-delete </v-icon>
    </template>
  </v-data-table>
</template>



<script>
import SkuUpload from "@/components/SkuUpload/SkuUpload";
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
    //从数据库中获取skuInfo
    (this.loading = true),
      setTimeout(() => {
        //加载表头
        (this.loading = false),
          (this.headers = [
            {
              text: "SKU名称",
              align: "start",
              sortable: false,
              value: "name",
            },
            { text: "售卖价", align: "start", value: "price" },
            { text: "成本", align: "start", value: "cost" },
            { text: "价格开始时间", align: "start", value: "start" },
            { text: "价格截止时间", align: "start", value: "end" },
            { text: "销售子订单条数", align: "start", value: "orderNum" },
            { text: "销售数", align: "start", value: "seleNum" },
            { text: "Actions", value: "actions", sortable: false },
          ]);

        //加载数据
        this.skuInfo = [
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "2022-07-09",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "至今",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "2022-07-09",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "至今",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "2022-07-09",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "至今",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "至今",
            orderNum: "100",
            seleNum: "80",
          },
          {
            name: this.productsInfo.id,
            price: Math.floor(Math.random() * 1000),
            cost: 68,
            start: "2022-07-09",
            end: "2022-07-09",
            orderNum: "100",
            seleNum: "80",
          },
        ];

        //this.skuInfo = []

        this.validSkuInfo = [];
        this.skuInfo.forEach((item) => {
          if (item.end == "至今") {
            this.validSkuInfo.push(item);
          }
        });
      }, 500);
  },

  data() {
    return {
      sdialog: false,
      sdialogDelete: false,
      ssdialogs: false,

      status: "松开上传",
      progress: false,

      headers: [],
      skuInfo: [],
      validSkuInfo: [],

      dense: false,
      loading: false,

      check: true,

      subTableEdited: [],
      seditedIndex: -1,

      secondeditedItem: {
        name: "",
        price: "",
        cost: "",
        start: "",
        end: "",
        orderNum: "",
        seleNum: "",
      },

      seconddefaultItem: {
        name: "",
        price: "",
        cost: "",
        start: "",
        end: "",
        orderNum: "",
        seleNum: "",
      },
    };
  },

  watch: {
    sdialog(val) {
      val || this.secondclose();
    },
    sdialogDelete(val) {
      val || this.secondcloseDelete();
    },
  },

  methods: {
    //   upload() {
    //   const XLSX = require("xlsx");
    //
    //    const url = "*/public/demo.xslx";
    //  const data = await(await fetch(url)).arrayBuffer();
    /* data is an ArrayBuffer */
    //const workbook = XLSX.read(data);
    //},

    download() {
      const XLSX = require("xlsx");

      console.log(this.skuInfo);
      const raw_data = this.check ? this.validSkuInfo : this.skuInfo;

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
            "SKU名称",
            "售卖价",
            "成本",
            "价格开始时间",
            "价格结束时间",
            "a",
            "b",
          ],
        ],
        {
          origin: "A1",
        }
      );

      /* calculate column width */
      //const max_width = rows.reduce((w, r) => Math.max(w, r.name.length), 10);
      //worksheet["!cols"] = [{ wch: 60 }, { wch: 5 }, { wch: 5 }];

      /* create an XLSX file and try to save to Presidents.xlsx */
      XLSX.writeFile(
        workbook,
        `${this.productsInfo.owner}-${this.productsInfo.product_name}-${this.productsInfo.id}.xlsx`
      );
    },

    secondeditItem(item) {
      this.seditedIndex = this.subTableEdited.indexOf(item);
      this.secondeditedItem = Object.assign({}, item);
      this.sdialog = true;
    },

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
      this.sdialog = false;
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