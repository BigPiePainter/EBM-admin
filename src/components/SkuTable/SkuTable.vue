<template>
  <v-data-table
    calculate-widths
    dense
    loading
    loading-text="加载中... 请稍后"
    :headers="sheaders"
    :items="check ? validSkuInfo : skuInfo"
    class="elevation-1 mb-1"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>SKU信息</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>

        <v-spacer></v-spacer>
        <v-switch v-model="check" label="有效SKU" class="pr-10 pt-5"></v-switch>

        <v-dialog v-model="ssdialogs" width="500">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="red lighten-2" dark v-bind="attrs" v-on="on">
              上传SKU信息
            </v-btn>
          </template>

          <v-card>
            <v-card-title class="text-h5 grey lighten-2">
              <p>Upload SKU</p>
            </v-card-title>

            <div class="dropbox pa-16 mb-5">
              <h2 v-if="!progress" class="text-center">
                {{ status }}
              </h2>
              <div v-else>
                <v-progress-linear
                  indeterminate
                  color="yellow darken-2"
                ></v-progress-linear>
                <br />
                <v-progress-linear
                  indeterminate
                  color="green"
                ></v-progress-linear>
                <br />
                <v-progress-linear
                  indeterminate
                  color="teal"
                ></v-progress-linear>
                <br />
                <v-progress-linear
                  indeterminate
                  color="cyan"
                ></v-progress-linear>
              </div>
            </div>

            <v-divider></v-divider>

            <v-card-actions>
              <v-btn color="blue lighten-2" text> 下载SKU导入模板 </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>

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
export default {
  props: {
    skuInfo: Array,
  },

  created() {
    console.log(this.skuInfo)
    this.validSkuInfo = [];
    this.skuInfo.forEach((item) => {
      if (item.end == "至今") {
        this.validSkuInfo.push(item);
      }
    });
  },

  data() {
    return {
      sdialog: false,
      sdialogDelete: false,
      ssdialogs: false,

      status: "松开上传",
      progress: false,

      validSkuInfo: [],
      check: false,

      sheaders: [
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
      ],

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