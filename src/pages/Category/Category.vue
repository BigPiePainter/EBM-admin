<template>
  <div style="width: 800px; margin: 0 auto">
    <v-card class="products-list mb-1">
      <v-data-table
        fixed-header
        no-data-text="空"
        item-key="uid"
        show-expand
        height="calc(100vh - 200px)"
        :headers="categoryHeaders"
        :items="calculatedCategorys"
        disable-sort
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>一级类目管理</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>

            <v-dialog v-model="dialog" max-width="300px">
              <!--new item buttom-->
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  small
                  depressed
                  color="primary"
                  v-bind="attrs"
                  v-on="on"
                  @click="addButton"
                >
                  新增类目
                </v-btn>
              </template>

              <v-card>
                <v-col class="px-10 pt-10">
                  <v-row>
                    <span class="text-subtitle-1">类目信息</span>
                  </v-row>
                  <v-col cols="12">
                    <span class="text-body-2 text--secondary">名称*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.name"
                      :readonly="checkReadOnly"
                    >
                    </v-text-field>
                  </v-col>

                  <v-col cols="12" :hidden="newCate">
                    <span class="text-body-2 text--secondary">品类扣点*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.deduction"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" :hidden="newCate">
                    <span class="text-body-2 text--secondary">品类运费险*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.insurance"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" :hidden="newCate">
                    <span class="text-body-2 text--secondary">
                      选择生效日期*
                    </span>
                    <v-menu
                      ref="menu"
                      v-model="datePicker"
                      :close-on-content-click="false"
                      :return-value.sync="editedItem.startTime"
                      offset-y
                      min-width="auto"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field
                          v-model="editedItem.startTime"
                          readonly
                          v-bind="attrs"
                          v-on="on"
                          outlined
                          dense
                          hide-details
                        ></v-text-field>
                      </template>
                      <v-date-picker
                        v-model="editedItem.startTime"
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
                          @click="$refs.menu.save(editedItem.startTime)"
                        >
                          确定
                        </v-btn>
                      </v-date-picker>
                    </v-menu>
                  </v-col>

                  <v-col cols="12">
                    <span class="text-body-2 text--secondary">备注</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.note"
                    >
                    </v-text-field>
                  </v-col>
                </v-col>

                <!-- until there is dialog of new input-->
                <v-card-actions>
                  <p class="caption font-italic font-weight-thin">
                    带*为必填项目
                  </p>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="close">
                    取消
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="save"
                    :disabled="isEmp"
                  >
                    保存
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
          <v-btn
            small
            depressed
            outlined
            color="green"
            @click="editButton(item)"
            class="ml-1"
          >
            变动
          </v-btn>

          <v-btn
            small
            depressed
            outlined
            color="red lighten-2"
            @click="deleteButton(item)"
            class="ml-1"
          >
            删除
          </v-btn>
        </template>
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="px-0">
            <v-card tile elevation="0">
              <v-data-table
                :headers="subHeaders"
                :items="
                  allCategoryHistorys.filter((i) => item.uid == i.categoryId)
                "
              >
              </v-data-table>
            </v-card>
          </td>
        </template>
      </v-data-table>
    </v-card>

    <v-dialog v-model="deleteDialog" max-width="190px">
      <v-card class="pl-2 pt-2">
        是否确定删除此条类目？
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="deleteClose"> 取消 </v-btn>
          <v-btn color="blue darken-1" text @click="deleteConfirm">
            确认
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { getCategory } from "@/settings/category";
import { addCategory } from "@/settings/category";
import { addHistoryCategory } from "@/settings/category";
import { getHistoryCategory } from "@/settings/category";
import { javaUTCDateToString } from "@/libs/utils";

export default {
  data() {
    return {
      datePicker: false,
      editedItem: [],
      mode: 0,
      checkReadOnly: true,
      dialog: false,
      deleteDialog: false,
      categoryHeaders: [
        { text: "一级类目", value: "name" },
        { text: "品类扣点", value: "deduction" },
        { text: "品类运费险", value: "insurance" },
        { text: "备注", value: "note" },
        { text: "操作", value: "actions" },
      ],
      calculatedCategorys: [],

      allCategorys: [],
      subHeaders: [
        { text: "品类扣点", value: "deduction" },
        { text: "品类运费险", value: "insurance" },
        { text: "生效时间", value: "calculatedStartTime" },
        { text: "备注", value: "note" },
      ],
      subItems: [],
      allCategoryHistorys: [],
      newCate: true,
      done: [false, false],
    };
  },

  created() {
    this.loadData();
    console.log(this.editedItem.uid);
  },

  computed: {
    isEmp: function () {
      var check1 = ["name"];
      var check = ["name", "deduction", "insurance", "startTime"];
      var pass = true;
      if (this.mode == 1) {
        check1.forEach((item) => {
          if (!this.editedItem[item]) pass = false;
        });
      } else if (this.mode == 2) {
        check.forEach((item) => {
          if (!this.editedItem[item]) pass = false;
        });
      }
      //console.log(pass);
      return !pass;
    },
  },

  methods: {
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    loadData() {
      this.done.fill(false);
      getHistoryCategory({}).then((res) => {
        this.allCategoryHistorys = res.data.categoryHistorys;
        console.log(this.allCategoryHistorys);
        this.requestDone(0);
      });
      getCategory({}).then((res) => {
        this.allCategorys = res.data.categorys;
        console.log(this.allCategorys);
        console.log(this.allCategorys[0]);
        this.requestDone(1);
      });
    },
    requestDone(i) {
      this.done[i] = true;
      console.log("done");
      if (this.done.find((i) => !i) == false) return;
      this.dataAnalyze();
    },
    //----------------------------------------------------------------------------------------
    dataAnalyze() {
      this.allCategoryHistorys.forEach((i) => {
        i.calculatedStartTime = javaUTCDateToString(i.startTime);
      });
      console.log("dataAnalyze1");
      this.calculatedCategorys = [];
      this.allCategorys.forEach((i) => {
        this.calculatedCategorys.push({
          name: i.name,
          deduction: this.newest(this.allCategoryHistorys, i.uid).deduction,
          insurance: this.newest(this.allCategoryHistorys, i.uid).insurance,
          note: i.note,
          uid: i.uid,
        });
      });
      // console.log(this.calculatedCategorys);
      // console.log(this.allCategorys);
      // //this.calculatedCategorys = this.allCategorys;
      // console.log("dataAnalyze");
      // console.log(this.calculatedCategorys);
      // console.log(this.allCategorys);
      // for (let i = 0; i < this.allCategorys.length; i++) {
      //   this.calculatedCategorys[i] = {};
      //    this.subItems[i] = [];
      //    for (let j = 0; j < this.allCategoryHistorys.length; j++) {
      //      if (this.allCategoryHistorys[j].categoryId == this.allCategorys[i].uid) {
      //        this.subItems[i].push(this.allCategoryHistorys[j]);
      //      }
      //    }
      // }
      //        if (
      //          this.allCategoryHistorys[j + 1].startTime >
      //          this.allCategoryHistorys[k].startTime
      //        ) {
      //          k = j + 1;
      //        }
      //     }
      //    }
      //    this.calculatedCategorys[i].note = this.allCategorys[i].note;
      //    this.calculatedCategorys[i].name = this.allCategorys[i].name;
      //     this.calculatedCategorys[i].calculatedStartTime = this.allCategoryHistorys[k].calculatedStartTime;
      //     this.calculatedCategorys[i].deduction = this.allCategoryHistorys[k].deduction;
      //     this.calculatedCategorys[i].insurance = this.allCategoryHistorys[k].insurance;
      // }
      // console.log(this.calculatedCategorys);
      // console.log(this.subItems);
    },
    //----------------------------------------------------------------------------------------
    addButton() {
      this.mode = 1;
      this.editedItem = [];
      this.checkReadOnly = false;
      this.newCate = true;
    },
    editButton(item) {
      this.mode = 2;
      this.editedItem = Object.assign({}, item);
      console.log(this.editedItem);
      this.checkReadOnly = true;
      this.dialog = true;
      this.newCate = false;
    },
    close() {
      this.dialog = false;
    },
    save() {
      console.log(this.mode);
      if (this.mode == 1) {
        this.add();
      } else if (this.mode == 2) {
        this.edit();
        console.log(this.editedItem);
      }
    },
    add() {
      var args = { ...this.editedItem };
      args.categoryId = args.uid;
      args.startTime = args.startTime.replaceAll("-", "/");
      addCategory(args)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
            this.loadData();
          }, 100);
        });
      this.dialog = false;
    },
    edit() {
      var args = { ...this.editedItem };
      args.categoryId = args.uid;
      args.startTime = args.startTime.replaceAll("-", "/");
      console.log(args);
      addHistoryCategory(args)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
      this.dialog = false;
    },
    //----------------------------------------------------------------------------------------
    deleteButton(item) {
      this.deleteDialog = true;
      item
    },
    deleteClose() {
      this.deleteDialog = false;
    },
    deleteConfirm() {
      this.deleteDialog = false;
      this.delete();
    },
    delete() {},

    newest(array, id) {
      var newest = { startTime: 0, deduction: "无数据", insurance: "无数据" };
      array.forEach((i) => {
        if (i.uid != id) return;
        i.startTime >= newest.startTime && (newest = i);
      });
      return newest;
    },
  },
};
</script>