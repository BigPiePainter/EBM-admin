<template>
  <div>
    <v-container class="main-container ma-0">
      <v-row>
        <v-col>
          <v-card>
            <v-data-table
              class="card-shadow"
              fixed-header
              no-data-text="空"
              item-key="uid"
              show-expand
              :expanded.sync="expanded"
              height="calc(100vh - 151px)"
              hide-default-footer
              :headers="categoryHeaders"
              :items="allCategorys"
              disable-sort
              :items-per-page="1000"
              @click:row="clickRow"
            >
              <template v-slot:[`item.deduction`]="{ item }">
                {{
                  categoryIdToInfo[item.uid].deduction != "空"
                    ? categoryIdToInfo[item.uid].deduction + " %"
                    : categoryIdToInfo[item.uid].deduction
                }}
              </template>
              <template v-slot:[`item.insurance`]="{ item }">
                {{
                  categoryIdToInfo[item.uid].insurance != "空"
                    ? categoryIdToInfo[item.uid].insurance + " ￥"
                    : categoryIdToInfo[item.uid].deduction
                }}
              </template>
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title>一级类目</v-toolbar-title>
                  <v-divider class="mx-4" inset vertical></v-divider>

                  <v-spacer></v-spacer>

                  <v-btn small depressed color="primary" @click="addButton">
                    新增类目
                  </v-btn>
                </v-toolbar>
              </template>
              <template v-slot:[`header.actions`]="{ header }">
                <div class="d-flex mr-4">
                  <v-spacer />
                  {{ header.text }}
                </div>
              </template>
              <template v-slot:[`item.actions`]="{ item }">
                <div class="d-flex">
                  <v-spacer />
                  <v-btn
                    small
                    depressed
                    outlined
                    color="green"
                    @click.stop="deleteButton(item)"
                    class="ml-1"
                  >
                    删除
                  </v-btn>
                  <v-btn
                    small
                    depressed
                    outlined
                    color="green"
                    @click.stop="editButton(item)"
                    class="ml-1"
                  >
                    修改
                  </v-btn>
                </div>
              </template>
              <template v-slot:expanded-item="{ headers, item }">
                <td :colspan="headers.length" class="pa-0">
                  <div class="sub-table elevation-20 ml-2 mb-3 mr-12">
                    <v-data-table
                      no-data-text="空"
                      :sort-by="['startTime']"
                      :sort-desc="[true]"
                      :hide-default-footer="
                        allCategoryHistorys.filter(
                          (i) => item.uid == i.categoryId
                        ).length <= 10
                      "
                      :items-per-page="10"
                      :footer-props="{
                        'items-per-page-options': [10, 20, 50, 100],
                        'items-per-page-text': '每页显示条数',
                      }"
                      :headers="subHeaders"
                      :items="
                        allCategoryHistorys.filter(
                          (i) => item.uid == i.categoryId
                        )
                      "
                    >
                      <template v-slot:[`item.startTime`]="{ item }">
                        {{ parseDate(item.startTime) }}
                      </template>
                      <template v-slot:[`item.deduction`]="{ item }">
                        {{ item.deduction + " %" }}
                      </template>
                      <template v-slot:[`item.insurance`]="{ item }">
                        {{ item.insurance + " ￥" }}
                      </template>

                      <template v-slot:[`header.action`]="{ header }">
                        <div class="d-flex mr-4">
                          <v-spacer />
                          {{ header.text }}
                        </div>
                      </template>
                      <template v-slot:[`item.action`]="{ item }">
                        <div class="d-flex">
                          <v-spacer />
                          <v-btn
                            small
                            depressed
                            outlined
                            color="red lighten-2"
                            @click="deleteCategoryHistoryButton(item)"
                            class="ml-1"
                          >
                            <!-- <v-icon small class="mr-1"> mdi-delete </v-icon> -->
                            删除
                          </v-btn>
                        </div>
                      </template>
                    </v-data-table>
                  </div>
                </td>
              </template>
            </v-data-table>
          </v-card>
        </v-col>
        <v-col>
          <v-card>
            <v-card-title> ..... </v-card-title>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

    <!-- 类目名称 Dialog -->
    <v-dialog v-model="categoryNameDialog" max-width="400px">
      <v-card>
        <v-card-title class="text-subtitle-1"> 类目名称 </v-card-title>

        <v-container class="px-7">
          <v-row>
            <v-col cols="12">
              <v-text-field
                color="blue-grey lighten-1"
                outlined
                dense
                hide-details
                v-model="editedItem.name"
              >
              </v-text-field>
            </v-col>
          </v-row>
        </v-container>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="categoryNameDialog = false">
            取消
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="addCategorySaveButton"
            :disabled="!editedItem.name || editedItem.name == ''"
          >
            新增
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除一级类目历史信息 Dialog -->
    <v-dialog v-model="deleteCategoryHistoryDialog" max-width="360px">
      <v-card>
        <v-card-title class="text-subtitle-1">
          删除这条一级类目变更记录？
        </v-card-title>

        <div class="mt-2">
          <TableKV :items="deleteCategoryHistoryItemParse" />
        </div>

        <v-card-actions>
          <span class="text--secondary caption font-italic font-weight-thin"
            >无法恢复</span
          >
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="deleteCategoryHistoryDialog = false"
          >
            取消
          </v-btn>
          <v-btn
            color="red darken-1"
            text
            @click="sureDeleteCategoryHistoryButton"
          >
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除类目 dialog -->
    <v-dialog v-model="categoryDeleteDialog">
      <v-card>
        <span>
          是否删除此一级类目：{{
            this.deleteCategory && this.deleteCategory.name
          }}
        </span>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="categoryDeleteDialog = false"
          >
            取消
          </v-btn>
          <v-btn color="blue darken-1" text @click="sureDeleteCategoryButton">
            确定
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 修改类目 Dialog -->
    <v-dialog v-model="categoryInfoDialog" max-width="370px">
      <v-card class="input-dialog">
        <v-container class="px-8 pt-10 pb-8">
          <v-row>
            <span class="text-subtitle-1">类目信息</span>
          </v-row>
          <v-row>
            <v-col cols="12">
              <span class="text-body-2 text--secondary">名称*</span>
              <v-text-field
                color="blue-grey lighten-1"
                outlined
                dense
                hide-details
                v-model="editedItem.name"
              >
              </v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="6">
              <span class="text-body-2 text--secondary">品类扣点*</span>
              <v-text-field
                color="blue-grey lighten-1"
                suffix="%"
                outlined
                dense
                type="number"
                hide-details
                v-model="editedItem.deduction"
              ></v-text-field>
            </v-col>

            <v-col cols="6">
              <span class="text-body-2 text--secondary">品类运费险*</span>
              <v-text-field
                color="blue-grey lighten-1"
                suffix="￥"
                type="number"
                outlined
                dense
                hide-details
                v-model="editedItem.insurance"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-container>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">带*为必填项目</p>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="categoryInfoDialog = false">
            取消
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="editCategorySaveButton"
            :disabled="isEmp"
          >
            保存
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 一级类目属性变化Dialog -->
    <v-dialog v-model="categoryChangeDialog" max-width="400px">
      <v-card>
        <v-card-title>
          <span class="text-subtitle-1">一级类目：{{ editedItem.name }}</span>
        </v-card-title>

        <div class="my-1">
          <v-data-table
            :headers="[
              { align: 'right', value: 'a' },
              { align: 'start', value: 'b', text: '旧数据' },
              { align: 'start', value: 'c' },
              { align: 'start', value: 'd', text: '新数据' },
              { align: 'start', value: 'e' },
            ]"
            :items="[
              {
                a: '品类扣点',
                b:
                  typeof oldItem.deduction == 'string'
                    ? '没有啊'
                    : oldItem.deduction + ' %',
                c: '👉👉👉',
                d: editedItem.deduction + ' %',
              },
              {
                a: '品类运费险',
                b:
                  typeof oldItem.insurance == 'string'
                    ? '没有啊'
                    : oldItem.insurance + ' %',
                c: '👉👉👉',
                d: editedItem.insurance + ' ￥',
              },
            ]"
            hide-default-footer
            disable-sort
          >
            <template v-slot:[`item.d`]="{ item }">
              <span class="mr-3">
                {{ item.d }}
              </span>
            </template>
          </v-data-table>
        </div>
        <v-container class="px-8 pt-3 pb-7 input-dialog">
          <v-row>
            <v-col cols="5">
              <span class="text-body-2 text--secondary"> 选择变化日期* </span>
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
                  min="2021-01-01"
                  :max="parseDate(new Date())"
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
            <v-col cols="7">
              <span class="text-body-2 text--secondary"> 变化原因* </span>
              <v-text-field
                outlined
                dense
                hide-details
                v-model="editedItem.note"
              ></v-text-field
            ></v-col>
          </v-row>
        </v-container>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">
            重要数据发生变化，需要提供信息
          </p>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="categoryChangeDialog = false"
          >
            取消
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="categorySave"
            :disabled="!editedItem.startTime || !editedItem.note"
          >
            保存
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapState, mapActions } from "vuex";

import TableKV from "@/components/TableKV/TableKV";

import { addCategory } from "@/settings/category";
import { editCategory } from "@/settings/category";
import { addHistoryCategory } from "@/settings/category";
import { editHistoryCategory } from "@/settings/category";
import { deleteCategoryHistory } from "@/settings/category";
import { deleteCategory } from "@/settings/category";
import { javaUTCDateToString } from "@/libs/utils";

export default {
  components: {
    TableKV,
  },

  data() {
    return {
      expanded: [],
      datePicker: false,

      oldItem: [],
      editedItem: [],

      categoryNameDialog: false,
      categoryInfoDialog: false,

      deleteCategoryHistoryDialog: false, //删除一级类目弹框
      deleteCategoryHistoryItem: {},
      deleteCategoryHistoryItemParse: {},

      categoryChangeDialog: false,
      categoryDeleteDialog: false,
      deleteCategoryItem: [],

      categoryHeaders: [
        { text: "一级类目", value: "name" },
        { text: "品类扣点", align: "right", value: "deduction" },
        { text: "品类运费险", align: "right", value: "insurance" },
        //{ text: "备注", value: "note" },
        { text: "操作", value: "actions" },
      ],
      calculatedCategorys: [],

      subHeaders: [
        { text: "生效时间", value: "startTime" },
        { text: "备注", value: "note", sortable: false },
        { text: "品类扣点", align: "right", value: "deduction" },
        { text: "品类运费险", align: "right", value: "insurance" },

        { text: "操作", align: "right", value: "action", sortable: false },
      ],

      subItems: [],
      hide: false,
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

    isEmp: function () {
      var check = ["name", "deduction", "insurance"];
      var pass = true;

      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false;
      });

      return !pass;
    },
  },

  methods: {
    ...mapActions(["refreshAllCategorys"]),
    parseDate(date) {
      return javaUTCDateToString(date);
    },
    clickRow(item, event) {
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    //----------------------------------------------------------------------------------------
    //dataAnalyze() {
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
    //},
    //----------------------------------------------------------------------------------------
    addButton() {
      if (!this.user.permission.a.fc) {
        this.global.infoAlert("泼发EBC：权限不足");
        return;
      }

      this.editedItem = [];
      this.categoryNameDialog = true;
    },
    addCategorySaveButton() {
      addCategory({ name: this.editedItem.name })
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：新增失败");
          }, 100);
        });
      this.categoryNameDialog = false;
    },

    editButton(item) {
      if (!this.user.permission.a.fc) {
        this.global.infoAlert("泼发EBC：权限不足");
        return;
      }

      this.oldItem = { ...item };
      this.editedItem = { ...item };

      typeof this.editedItem.deduction == "string" &&
        (this.editedItem.deduction = null);
      typeof this.editedItem.insurance == "string" &&
        (this.editedItem.insurance = null);

      console.log("editedItem", this.editedItem);

      this.categoryInfoDialog = true;
    },

    deleteButton(item) {
      if (!this.user.permission.a.fc) {
        this.global.infoAlert("泼发EBC：权限不足");
        return;
      }
      this.deleteCategoryItem = { ...item };
      this.categoryDeleteDialog = true;
    },

    sureDeleteCategoryButton() {
      deleteCategory({ uid: this.deleteCategory.uid })
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.categoryDeleteDialog = false;
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC： error");
          }, 100);
        });
    },

    deleteCategoryHistoryButton(item) {
      if (!this.user.permission.a.fc) {
        this.global.infoAlert("泼发EBC：权限不足");
        return;
      }
      console.log("delete", item);
      this.deleteCategoryHistoryItem = { ...item };
      this.deleteCategoryHistoryItemParse = [
        {
          key: "生效时间",
          value: javaUTCDateToString(item.startTime),
        },
        {
          key: "备注",
          value: item.note,
        },
        {
          key: "品类扣点",
          value: item.deduction + " %",
        },
        {
          key: "品类运费险",
          value: item.insurance + " ￥",
        },
      ];

      this.deleteCategoryHistoryDialog = true;
    },

    sureDeleteCategoryHistoryButton() {
      console.log(this.deleteCategoryHistoryItem.uid);
      deleteCategoryHistory({ uid: this.deleteCategoryHistoryItem.uid })
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.deleteCategoryHistoryDialog = false;
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：error");
          }, 100);
        });
    },

    editCategorySaveButton() {
      this.categoryInfoDialog = false;
      if (
        this.editedItem.deduction != this.oldItem.deduction ||
        this.editedItem.insurance != this.oldItem.insurance
      ) {
        this.editedItem.startTime = "";
        this.editedItem.note = "";
        this.categoryChangeDialog = true;
      } else {
        this.modifyCategoryName();
      }
    },

    categorySave() {
      this.categoryChangeDialog = false;
      this.modifyCategoryInfo();
    },

    modifyCategoryName() {
      editCategory(this.editedItem)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：修改失败");
          }, 100);
        });
    },

    modifyCategoryInfo() {
      var args = { ...this.editedItem };

      //预处理
      args.categoryId = args.uid;
      args.startTime && (args.startTime = args.startTime.replaceAll("-", "/"));

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
      this.categoryInfoDialog = false;
    },

    subEdit() {
      var args = { ...this.editedItem };
      args.startTime = args.startTime.replaceAll("-", "/");
      console.log(args);
      editHistoryCategory(args)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.loadData();
        })
        .catch(() => {
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
      this.categoryInfoDialog = false;
    },
    //----------------------------------------------------------------------------------------
    newest(array, id) {
      var newest = { startTime: 0, deduction: "无数据", insurance: "无数据" };
      array.forEach((i) => {
        if (i.categoryId != id) return;
        i.startTime >= newest.startTime && (newest = i);
      });
      return newest;
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

.v-menu__content {
  .v-list {
    .v-list-item__title {
      font-size: 15px;
    }
  }
}

.input-dialog {
  .col {
    padding-top: 8px;
    padding-bottom: 8px;
  }

  .v-input {
    font-size: 15px;
  }
}
</style>