<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="部门管理">
      <v-btn class="ml-2" text color="primary" @click="addDepartmentButton">
        <v-icon size="20" style="padding-top: 2px">mdi-bookmark-plus</v-icon>
        新增部门
      </v-btn>
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
    </PageHeader>
    <v-data-table
      class=""
      height="calc(100vh - 197px)"
      fixed-header
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="uid"
      show-expand
      disable-sort
      :expanded.sync="expanded"
      :headers="headers"
      :items="allDepartments"
      :loading="loading"
      :items-per-page="50"
      :footer-props="{
        'items-per-page-options': [10, 20, 50, 100],
        'items-per-page-text': '每页显示条数',
      }"
      @click:row="clickRow"
    >
      <template v-slot:top>
        <v-toolbar flat color="white" dense>
          <v-toolbar-title>全部部门</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
          <v-spacer></v-spacer>
        </v-toolbar>
      </template>

      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length" class="sub-table pa-0">
          <div
            style="width: 800px"
            class="sub-table-container elevation-20 ml-2 mb-3"
          >
            <DepartmentMemberTable
              :departmentInfo="item"
              :allUsers="allUsers"
              :allDepartments="allDepartments"
            />
          </div>
        </td>
      </template>

      <template v-slot:[`item.admin`]="{ item }">
        {{
          item.admin
            .split(",")
            .map((i) => userIdToNick[i])
            .join("，")
        }}
      </template>

      <template v-slot:[`item.createTime`]="{ item }">
        {{ parseDateTime(item.createTime) }}
      </template>
      <template v-slot:[`item.modifyTime`]="{ item }">
        {{ parseDateTime(item.modifyTime) }}
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
            @click.stop="editDepartmentButton(item)"
            class="ml-1"
          >
            修改
          </v-btn>
        </div>
      </template>
    </v-data-table>

    <!-- 部门信息Dialog -->
    <v-dialog
      v-model="departmentInfoDialog"
      max-width="450px"
      :persistent="dialogPersistent"
    >
      <v-card>
        <v-col class="px-10 pt-10 department-dialog">
          <v-row>
            <span color="" class="text-subtitle-1">{{
              departmentMode == 1 ? "新部门" : "编辑部门"
            }}</span>
          </v-row>
          <v-row>
            <v-col cols="8">
              <span class="text-body-2 text--secondary">名称</span>
              <v-text-field
                outlined
                dense
                hide-details
                color="primary"
                v-model="departmentEdit.name"
              >
              </v-text-field>
            </v-col>
          </v-row>

          <v-divider class="my-7" />

          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary">管理员</span>
              <v-autocomplete
                v-model="selectedAdmin"
                :items="allUsers"
                no-data-text="无"
                outlined
                dense
                hide-details
                color="primary"
                item-text="nick"
                item-value="uid"
                multiple
                @focus="autocompleteFocus = true"
                @blur="autocompleteFocus = false"
              >
                <template v-slot:item="data">
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ data.item.nick }}

                      <span class="text--secondary text-body-2 ml-3">{{
                        data.item.note
                      }}</span>
                    </v-list-item-title>
                    <v-list-item-subtitle class="mt-1">{{
                      data.item.username
                    }}</v-list-item-subtitle>
                  </v-list-item-content>
                </template>
              </v-autocomplete>
            </v-col>
          </v-row>

          <v-divider class="my-7" />

          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary">备注</span>
              <v-text-field
                outlined
                dense
                hide-details
                v-model="departmentEdit.note"
                color="primary"
              >
              </v-text-field>
            </v-col>
          </v-row>
        </v-col>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="departmentInfoDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="save">保存</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import { mapState, mapActions } from "vuex";

import { addDepartment } from "@/settings/department";
import { modifyDepartment } from "@/settings/department";
import DepartmentMemberTable from "../../components/DepartmentMemberTable/DepartmentMemberTable.vue";

import { javaDateTimeToString } from "@/libs/utils";

import PageHeader from "@/components/PageHeader";

export default {
  components: {
    PageHeader,
    DepartmentMemberTable,
  },
  data: () => ({
    autocompleteFocus: false,
    dialogPersistent: false,

    selectedAdmin: [],

    headers: [
      {
        text: "编号",
        align: "start",
        sortable: false,
        value: "uid",
      },
      { text: "部门名称", value: "name" },
      { text: "管理员", value: "admin" },
      { text: "备注", value: "note" },
      { text: "创建时间", value: "createTime" },
      { text: "修改时间", value: "modifyTime" },
      { text: "操作", value: "actions", sortable: false },
    ],
    expanded: [],

    departmentInfoDialog: false,
    departmentEdit: {},
    departmentMode: 0, // 1--添加模式,  2--修改模式

    loading: false,

    departmentDone: false,
    allUserDone: false,
  }),

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

  watch: {
    autocompleteFocus(v) {
      if (v) {
        this.dialogPersistent = v;
      } else {
        setTimeout(() => {
          this.dialogPersistent = false;
        }, 100);
      }
    },
  },

  methods: {
    ...mapActions(["refreshAllDepartments"]),

    parseDateTime(date) {
      return javaDateTimeToString(date);
    },

    clickRow(item, event) {
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    editDepartmentButton(item) {
      this.departmentMode = 2; //"修改"模式
      this.departmentEdit = { ...item };
      this.selectedAdmin = item.admin
        ? item.admin.split(",").map((i) => Number(i))
        : [];
      this.departmentInfoDialog = true;
    },

    addDepartmentButton() {
      this.departmentMode = 1; //"添加"模式
      this.departmentEdit = {};
      this.selectedAdmin = [];
      this.departmentInfoDialog = true;
    },

    save() {
      console.log(this.selectedAdmin);
      this.departmentMode == 1 ? this.newDepartment() : this.editDepartment();
      this.departmentInfoDialog = false;
    },

    newDepartment() {
      var args = { admin: this.selectedAdmin.join(), ...this.departmentEdit };
      console.log(args);

      //预处理
      if (args.note == null) delete args.note;

      addDepartment(args)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          console.log(this.departmentEdit);
        })
        .then(() => {
          this.loading = true;
          this.refreshAllDepartments().then(() => {
            this.loading = false;
          });
        });
    },

    editDepartment() {
      var args = { ...this.departmentEdit };

      args.admin = this.selectedAdmin.join();
      console.log(args);

      modifyDepartment(args)
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          console.log(this.departmentEdit);
        })
        .then(() => {
          this.loading = true;
          this.refreshAllDepartments().then(() => {
            this.loading = false;
          });
        });
    },
  },
};
</script>

<style scoped lang="scss">
.department-dialog {
  .col {
    padding-top: 5px;
    padding-bottom: 5px;
  }
}
</style>