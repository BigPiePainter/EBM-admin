<template>
  <div>
    <v-dialog v-model="dialog" :max-width="maxWidth">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="red lighten-2" dark v-bind="attrs" v-on="on">
          导入SKU信息
        </v-btn>
      </template>

      <v-card>
        <v-card-title>
          <p>
            {{ `${product.product_name}（${product.first_category}）上传SKU` }}
          </p>
        </v-card-title>

        <v-card
          id="dropbox"
          class="d-flex align-center justify-center mx-10 my-5 transition-swing"
          :min-height="180"
          :color="hover ? '#fafafa' : '#fff'"
          @dragenter.prevent="dragenter($event)"
          @dragleave.prevent="dragleave($event)"
          @drop.prevent="drop($event)"
          @dragover.prevent=""
          @dragend.prevent=""
        >
          <h5>{{ status }}</h5>
        </v-card>

        <v-card-actions>
          <v-btn color="blue lighten-2" text> 下载SKU导入模板 </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="loading" fullscreen>
      <v-overlay :value="true">
        <v-progress-circular indeterminate size="64"></v-progress-circular>
      </v-overlay>
    </v-dialog>
    <v-dialog
      v-if="!checkInfoDialogDestroy"
      v-model="checkInfoDialog"
      fullscreen
      class="checkInfo"
    >
      <div class="topBar">
        <v-toolbar dark color="primary" dense>
          <v-btn icon dark @click="cancel">
            <v-icon>mdi-close</v-icon>
          </v-btn>
          <v-toolbar-title>{{
            `${product.id}   ${product.product_name}（${product.first_category}）SKU上传检索`
          }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-toolbar-items>
            <v-btn dark text> {{ wrong + " 格式错误" }}</v-btn>
            <v-btn dark text @click="upload" :disabled="wrong > 0">
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
      status: "",
      file: null,
      dialog: false,
      checkInfoDialog: false,
      checkInfoDialogDestroy: true,

      dropActive: false,

      hover: false,
      maxWidth: 500,

      loading: false,

      wrong: 0,
    };
  },
  mounted() {
    this.status = "拖拽上传SKU信息";
  },
  watch: {
    hover(value) {
      this.status = value ? "松开上传" : "拖拽上传SKU信息";
    },
    checkInfoDialog(value) {
      if (value) {
        this.checkInfoDialogDestroy = false;
      } else {
        setTimeout(() => {
          this.checkInfoDialogDestroy = true;
        }, 300);
      }
    },
  },
  methods: {
    upload() {},
    showInfo(text) {
      this.$toast.info(text, {
        position: "top-right",
        timeout: 6000,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        draggablePercent: 0.6,
        showCloseButtonOnHover: false,
        hideProgressBar: true,
        closeButton: "button",
        icon: true,
      });
    },
    cancel() {
      this.checkInfoDialog = false;
      this.showInfo("泼发EBC：取消上传");
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
        this.showInfo("泼发EBC：拖拽文件数量过多");
        return;
      }

      this.file = event.dataTransfer.files[0];
      console.log(this.file);

      if (!this.file.name.endsWith(".xlsx")) {
        console.log("拦截");
        this.showInfo("泼发EBC: 只支持xlsx格式");
        return;
      }

      this.loading = true;
      this.dialog = false;

      var reader = new FileReader();
      reader.onload = (e) => {
        console.log("加载完毕");

        console.log("数据处理");

        var data = new Uint8Array(e.target.result);
        data = this.stox(XLSX.read(data, { type: "array" }));

        //额外处理
        //data[0].freeze = "A2",

        data[0].cols = {
          0: { width: 113 },
          1: { width: 750 },
          2: { width: 80 },
          3: { width: 80 },
          4: { width: 100 },
          5: { width: 100 },
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
      };

      console.log("加载文件");
      reader.readAsArrayBuffer(event.dataTransfer.files[0]);
    },
    cellCheck(cell, row, col) {
      if (!cell) return;
      //console.log(cell);

      if (row == 0) {
        //表头
        cell.style = 9;
        return;
      }

      var alreadyError = cell.error;

      switch (col) {
        case 0:
          if (/[^\d]/.test(cell.text) || cell.text.trim() == "") {
            cell.error = true;
            this.wrong += alreadyError ? 0 : 1;
            cell.style = 4;
          } else {
            cell.error = false;
            cell.style = 7;
            this.wrong -= alreadyError ? 1 : 0;
          }
          break;
        case 1:
          cell.style = 7;
          break;
        case 2:
          if (/[^\d.]/.test(cell.text) || cell.text.trim() == "") {
            cell.error = true;
            this.wrong += alreadyError ? 0 : 1;
            cell.style = 4;
          } else {
            cell.error = false;
            cell.style = 7;
            this.wrong -= alreadyError ? 1 : 0;
          }
          break;
        case 3:
          if (/[^\d.]/.test(cell.text) || cell.text.trim() == "") {
            cell.error = true;
            this.wrong += alreadyError ? 0 : 1;
            cell.style = 4;
          } else {
            cell.error = false;
            this.wrong -= alreadyError ? 1 : 0;
            cell.style = 7;
          }
          break;
        case 4:
          cell.style = 7;
          break;
        case 5:
          if (!cell) {
            cell.error = true;
            this.wrong += alreadyError ? 0 : 1;
            cell.style = 4;
          } else {
            cell.error = false;
            cell.style = 7;
            this.wrong -= alreadyError ? 1 : 0;
          }
          break;
        default:
          break;
      }
    },
    stox(wb) {
      var out = [];

      wb.SheetNames.forEach(function (name) {
        var o = { name: name, rows: {} };
        var ws = wb.Sheets[name];
        var range = XLSX.utils.decode_range(ws["!ref"]);
        // sheet_to_json will lost empty row and col at begin as default
        range.s = { r: 0, c: 0 };
        var aoa = XLSX.utils.sheet_to_json(ws, {
          raw: false,
          header: 1,
          range: range,
        });

        var len = 0;
        aoa.forEach(function (r, i) {
          len++;
          var cells = {};
          r.forEach(function (c, j) {
            cells[j] = { text: c };

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
        var xs = new Spreadsheet("#x-spreadsheet", {
          showToolbar: false,
          showGrid: true,
          showContextmenu: false,
          view: {
            height: () => document.documentElement.clientHeight - 48,
            width: () => document.documentElement.clientWidth,
          },
        })
          .loadData(data)
          .change((cdata) => {
            console.log(cdata);
            console.log(">>>", xs.getData());
          });

        var cellSellected;
        xs.on("cell-selected", (cell, ri, ci) => {
          cellSellected = cell;
          console.log("cell:", cell, ", ri:", ri, ", ci:", ci);
        }).on("cell-edited", (text, ri, ci) => {
          console.log("text:", text, ", ri: ", ri, ", ci:", ci);

          this.cellCheck(cellSellected, ri, ci);
        });

        xs.reRender();
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
  border-radius: 10px;
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