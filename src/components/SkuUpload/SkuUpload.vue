<template>
  <div>
    <v-dialog v-model="dialog" :max-width="maxWidth">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" depressed small dark v-bind="attrs" v-on="on">
          导入SKU信息
        </v-btn>
      </template>

      <v-card>
        <v-card-title>
          {{
            `${product.productName}（${
              categoryIdToName[product.firstCategory]
            }）上传SKU`
          }}
        </v-card-title>

        <v-card
          id="dropbox"
          class="d-flex align-center justify-center mx-10 my-5 transition-swing"
          :min-height="180"
          :color="hover ? '#fafafa' : '#fff'"
          @click.stop="showFileSelect = true"
          @dragenter.prevent="dragenter($event)"
          @dragleave.prevent="dragleave($event)"
          @drop.prevent="drop($event)"
          @dragover.prevent=""
          @dragend.prevent=""
        >
          <h4>{{ status }}</h4>
        </v-card>

        <v-expand-transition>
          <v-file-input
            v-if="showFileSelect"
            accept=".xlsx"
            prepend-icon="mdi-file-excel"
            class="mx-8"
            color="primary"
            v-model="fileSelect"
          ></v-file-input>
        </v-expand-transition>

        <v-card-actions>
          <v-btn color="primary" text @click="downloadModel">
            下载SKU导入模板
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="loading" fullscreen persistent transition="none">
      <v-overlay :value="true">
        <v-progress-circular indeterminate size="64"></v-progress-circular>
      </v-overlay>
    </v-dialog>
    <v-dialog v-model="checkInfoDialog" fullscreen class="checkInfo" persistent>
      <div class="topBar">
        <v-toolbar dark color="primary" dense>
          <v-btn class="ml-0" icon dark  @click="cancel" :disabled="this.uploading">
            <v-icon small>mdi-close</v-icon>
          </v-btn>

          <span class="pl-5">{{
            `${product.id}   ${product.productName}（${
              categoryIdToName[product.firstCategory]
            }）SKU上传检索`
          }}</span>

          <v-spacer></v-spacer>
          <v-toolbar-items>
            <v-btn dark text> {{ wrong + " 格式错误" }}</v-btn>
            <v-btn
              dark
              text
              @click="upload"
              :disabled="wrong > 0"
              :loading="uploading"
            >
              确认上传
            </v-btn>
          </v-toolbar-items>
        </v-toolbar>
      </div>
      <div id="x-spreadsheet"></div>
    </v-dialog>
  </div>
</template>
<script>
import { saveAs } from "file-saver";

import { mapState } from "vuex";

import { addSkus } from "@/settings/sku";
import Spreadsheet from "x-data-spreadsheet";
import zhCN from "x-data-spreadsheet/src/locale/zh-cn";
import * as XLSX from "xlsx";

export default {
  name: "SkuUpload",
  components: {},

  props: {
    product: Object,
  },
  data() {
    return {
      dataCopy: [],
      status: "",
      file: null,
      dialog: false,
      checkInfoDialog: false,

      dropActive: false,

      hover: false,
      maxWidth: 500,

      loading: false,

      showFileSelect: false,
      fileSelect: null,

      wrong: 0,

      uploading: false,

      xs: null,
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
  mounted() {
    this.status = "点击 & 拖拽上传SKU信息";
  },
  created() {
    console.log("created");
  },
  watch: {
    hover(value) {
      this.status = value ? "松开上传" : "点击 & 拖拽上传SKU信息";
    },
    fileSelect(file) {
      if (file) {
        this.file = file;
        this.fileProcess();
      }
    },
  },
  methods: {
    async downloadModel() {
      const ExcelJS = require("exceljs");
      const workbook = new ExcelJS.Workbook();
      workbook.creator = "泼发EBC";
      workbook.lastModifiedBy = "泼发EBC";
      workbook.company = "浙江泼发进出口贸易有限公司";
      workbook.manager = this.user.nick + " " + this.user.username;
      workbook.created = new Date();
      workbook.modified = new Date();

      const sheet = workbook.addWorksheet("SKU信息", {
        views: [{ state: "frozen", ySplit: 1 }],
      });

      var font = {
        name: "微软雅黑",
        size: 10,
      };
      var centerAlignment = {
        vertical: "center",
        horizontal: "center",
      };
      var background = {
        type: "pattern",
        pattern: "solid",
        fgColor: { argb: "FFFFFF00" },
      };

      console.log(sheet);
      sheet.columns = [
        {
          header: "商品ID",
          key: "id",
          width: 16,
          style: { font },
        },
        {
          header: "SKUID",
          key: "name",
          width: 16,
          style: { font },
        },
        {
          header: "SKU名称",
          key: "DOB",
          width: 70,
          style: { font },
        },
        {
          header: "售卖价",
          key: "DOB",
          width: 16,
          style: { font },
        },
        {
          header: "成本",
          key: "DOB",
          width: 16,
          style: { font },
        },
        {
          header: "价格开始时间",
          key: "DOB",
          width: 16,
          style: { font },
        },
      ];

      sheet.getCell("A1").alignment = centerAlignment;
      sheet.getCell("B1").alignment = centerAlignment;
      sheet.getCell("C1").alignment = centerAlignment;
      sheet.getCell("D1").alignment = centerAlignment;
      sheet.getCell("E1").alignment = centerAlignment;
      sheet.getCell("F1").alignment = centerAlignment;

      sheet.getCell("A1").fill = background;
      sheet.getCell("B1").fill = background;
      sheet.getCell("C1").fill = background;
      sheet.getCell("D1").fill = background;
      sheet.getCell("E1").fill = background;
      sheet.getCell("F1").fill = background;

      sheet.getColumn(4).numFmt =
        '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
      sheet.getColumn(5).numFmt =
        '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
      sheet.getColumn(6).numFmt = "[$-x-sysdate]dddd, mmmm dd, yyyy";

      const data = [
        [
          "1234567890123",
          "1234567890123",
          "XXXXX-XXXXX-XXXXXX-XXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXX",
          10,
          5,
          new Date("2022-11-11"),
        ],
        [
          "123456789012",
          "1234567890123",
          "XXXXX-XXXXX-XXXXXX-XXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXX",
          10,
          5,
          new Date("2022-11-11"),
        ],
      ];
      sheet.addRows(data);
      const buffer = await workbook.xlsx.writeBuffer();
      const fileType =
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
      const blob = new Blob([buffer], { type: fileType });
      saveAs(blob, "SKU导入模板.xlsx");
    },
    upload() {
      this.uploading = true;

      var dataii = [];
      //处理data，数据展开

      console.log("start");
      for (let i = 1; i < Object.keys(this.dataCopy[0].rows).length; i++) {
        dataii[i - 1] = [];
        for (let j = 0; j < 6; j++) {
          dataii[i - 1][j] = this.dataCopy[0].rows[i].cells[j].text;
        }
      }

      console.log("dataii", dataii);
      console.log("dataCopy", this.dataCopy);
      console.log("length", Object.keys(this.dataCopy[0].rows).length);

      //var pars = { productId: this.product.id, data: JSON.stringify(dataii) };
      console.log("done");
      addSkus({ data: dataii })
        .then((res) => {
          this.uploading = false;
          this.checkInfoDialog = false;
          this.global.infoAlert("泼发EBC：" + res.data);
          this.$emit("refresh");
        })
        .catch(() => {
          this.uploading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },

    cancel() {
      this.checkInfoDialog = false;
      this.global.infoAlert("泼发EBC：取消上传");
    },
    dragenter() {
      this.maxWidth = 550;
      this.hover = true;
    },
    dragleave() {
      this.maxWidth = 500;
      this.hover = false;
    },
    drop(event) {
      this.maxWidth = 500;
      this.hover = false;
      console.log(event);

      //加载
      if (event.dataTransfer.files.length == 0) {
        console.log("拦截");
        return;
      }

      if (event.dataTransfer.files.length > 1) {
        console.log("拦截");
        this.global.infoAlert("泼发EBC：拖拽文件数量过多");
        return;
      }

      this.file = event.dataTransfer.files[0];
      this.fileProcess();
    },

    fileProcess() {
      console.log(this.file);
      if (!this.file.name.endsWith(".xlsx")) {
        console.log("拦截");
        this.global.infoAlert("泼发EBC: 只支持xlsx格式");
        return;
      }

      this.loading = true;
      this.dialog = false;

      //this.$nextTick
      setTimeout(() => {
        var reader = new FileReader();
        reader.onload = (e) => {
          try {
            console.log("加载完毕");

            console.log("数据处理");

            var data = new Uint8Array(e.target.result);
            data = this.stox(XLSX.read(data, { type: "array" }));
            this.dataCopy = data;

            //额外处理
            //data[0].freeze = "A2",

            data[0].cols = {
              0: { width: 113 },
              1: { width: 113 },
              2: { width: 750 },
              3: { width: 80 },
              4: { width: 80 },
              5: { width: 100 },
              // 6: { width: 100 },
            };

            // /4FF200

            var warning = {
              //bgcolor: "#f4f5f8",
              color: "#ff0000",
              border: {
                top: ["thin", "#ff0000"],
                bottom: ["thin", "#ff0000"],
                right: ["thin", "#ff0000"],
                left: ["thin", "#ff0000"],
              },
            };

            var success = {
              bgcolor: "#E5FFE5",
              //color: "#99CC66",
              border: {
                //top: ["thin", "#00CC99"],
                //bottom: ["thin", "#00CC99"],
                //right: ["thin", "#00CC99"],
                //left: ["thin", "#00CC99"],
              },
            };

            data[0].styles = [];
            data[0].styles.push({
              align: "center",
            });
            data[0].styles.push({
              align: "left",
            });
            data[0].styles.push({
              align: "right",
            });

            data[0].styles.push({
              align: "center",
              ...warning,
            });
            data[0].styles.push({
              align: "left",
              ...warning,
            });
            data[0].styles.push({
              align: "right",
              ...warning,
            });

            data[0].styles.push({
              align: "center",
              ...success,
            });
            data[0].styles.push({
              align: "left",
              ...success,
            });
            data[0].styles.push({
              align: "right",
              ...success,
            });

            data[0].styles.push({
              font: {
                bold: true,
              },
              ...success,
            });
            data[0].styles.push({
              font: {
                bold: true,
              },
              ...warning,
            });

            this.wrong = 0;
            for (let row in data[0].rows) {
              if (!data[0].rows[row].cells) continue;
              for (let col = 0; col < 6; col++) {
                var cell = data[0].rows[row].cells[col];
                if (!cell) data[0].rows[row].cells[col] = { test: "" };
                cell = data[0].rows[row].cells[col];

                this.cellCheck(cell, row, col);
              }
            }

            console.log(data);
            console.log("数据处理完毕");

            this.loading = false;
            this.checkInfoDialog = true;
            this.dataInit(data);
          } catch (error) {
            this.loading = false;
            this.global.infoAlert("泼发EBC：文件有点问题啊。。。");
          }
        };

        console.log("加载文件");
        reader.readAsArrayBuffer(this.file);
      }, 50);
    },

    cellCheck(cell, row, col) {
      if (!cell) return;

      var alreadyError = cell.error;

      if (row == 0) {
        var colName = "";
        switch (col) {
          case 0:
            colName = "商品ID";
            break;
          case 1:
            colName = "SKUID";
            break;
          case 2:
            colName = "SKU名称";
            break;
          case 3:
            colName = "售卖价";
            break;
          case 4:
            colName = "成本";
            break;
          case 5:
            colName = "价格开始时间";
            break;
          // case 6:
          //   colName = "价格截止时间";
          //   break;
          default:
            break;
        }

        if (!cell.text) {
          cell.error = true;
        } else {
          cell.error = cell.text != colName;
        }
      } else {
        var rules = [
          RegExp("^" + this.product.id + "$"),
          /^\d+$/,
          /./,
          /^[0-9]+(\.[0-9]{1,5})?$/,
          /^[0-9]+(\.[0-9]{1,5})?$/,
          /^\d{4}-\d{2}-\d{2}$/,

          // /^\d{4}-\d{2}-\d{2}$|^\s+$|^至今$/,
        ];

        if (!cell.text) {
          cell.error = true;
        } else {
          cell.error = !rules[col].test(cell.text);
        }
      }

      cell.style = cell.error ? 4 : 7;
      this.wrong += cell.error ? (alreadyError ? 0 : 1) : alreadyError ? -1 : 0;
    },
    stox(wb) {
      var out = [];

      wb.SheetNames.forEach(function (name) {
        var o = { name: name, rows: {} };
        var ws = wb.Sheets[name];
        console.log(ws);

        var range = XLSX.utils.decode_range(ws["!ref"]);
        // sheet_to_json will lost empty row and col at begin as default
        range.s = { r: 0, c: 0 };
        var aoa = XLSX.utils.sheet_to_json(ws, {
          raw: true,
          header: 1,
          range: range,
        });

        console.log(aoa);

        var len = 0;
        var time = new Date();

        aoa.forEach(function (r, i) {
          len++;
          var cells = {};

          r.forEach(function (c, j) {
            if (typeof c == "number" && c > 40000) {
              time.setTime(-2209016202000 + (c - 1) * 24 * 60 * 60 * 1000);

              var month = time.getUTCMonth() + 1;
              var day = time.getUTCDate();
              cells[j] = {
                text: `${time.getUTCFullYear()}-${
                  month < 10 ? "0" + month : month
                }-${day < 10 ? "0" + day : day}`,
              };
            } else {
              cells[j] = { text: c.toString().trim() };
            }

            //var cellRef = XLSX.utils.encode_cell({ r: i, c: j });
            //
            //if (ws[cellRef] != null && ws[cellRef].f != null) {
            //  cells[j].text = "=" + ws[cellRef].f;
            //}
          });
          o.rows[i] = { cells };
        });

        o.rows.len = len;

        /*
        o.merges = [];
        (ws["!merges"] || []).forEach(function (merge, i) {
          //Needed to support merged cells with empty content
          if (o.rows[merge.s.r] == null) {
            o.rows[merge.s.r] = { cells: {} };
          }
          if (o.rows[merge.s.r].cells[merge.s.c] == null) {
            o.rows[merge.s.r].cells[merge.s.c] = {};
          }

          o.rows[merge.s.r].cells[merge.s.c].merge = [
            merge.e.r - merge.s.r,
            merge.e.c - merge.s.c,
          ];

          o.merges[i] = XLSX.utils.encode_range(merge);
        });
        */

        out.push(o);
      });

      return out;
    },

    dataInit(data) {
      Spreadsheet.locale("zh-cn", zhCN);
      console.log(data);

      this.$nextTick(() => {
        if (!this.xs) {
          this.xs = new Spreadsheet("#x-spreadsheet", {
            showToolbar: false,
            showGrid: true,
            showContextmenu: false,
            view: {
              height: () => document.documentElement.clientHeight - 48,
              width: () => document.documentElement.clientWidth,
            },
          });
        }

        this.xs.loadData(data).change((cdata) => {
          console.log(cdata);
          console.log(">>>", this.xs.getData());
        });

        var cellSellected;
        this.xs
          .on("cell-selected", (cell, ri, ci) => {
            cellSellected = cell;
            console.log("cell:", cell, ", ri:", ri, ", ci:", ci);
          })
          .on("cell-edited", (text, ri, ci) => {
            console.log("text:", text, ", ri: ", ri, ", ci:", ci);
            this.cellCheck(cellSellected, ri, ci);
          });

        this.xs.reRender();
      });
    },
  },
};
</script>
<style scoped lang="scss">
.v-card__title {
  font-size: 1rem !important;
}

#dropbox {
  border-radius: 5px;
  color: #777;
  h5 {
    pointer-events: none;
  }
}

.checkInfo {
  .topBar {
    height: 65px;
  }
}
.v-application .v-card .v-card__title p {
  font-size: 1rem;
}

.loading {
  width: 100%;
  height: 100%;
  background-color: #777;
}
</style>