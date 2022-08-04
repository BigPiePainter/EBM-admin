<template>
  <div>
    <v-data-table
      class="elevation-2"
      fixed-header
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="uid"
      show-expand
      disable-sort
      height="calc(100vh - 200px)"
      :expanded.sync="expanded"
      :headers="headers"
      :items="groupInfo"
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
          <v-toolbar-title>组别</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
          <v-spacer></v-spacer>
          <v-btn small depressed color="primary" dark @click="addGroupButton">
            新组别
          </v-btn>
        </v-toolbar>
      </template>

      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length">aaaa {{ item.name }}</td>
      </template>

      <template v-slot:[`header.calculatedCreateTime`]="{ header }">
        <div class="d-flex mr-8">
          <v-spacer />
          {{ header.text }}
        </div>
      </template>
      <template v-slot:[`item.calculatedCreateTime`]="{ item }">
        <div class="d-flex">
          <v-spacer />
          {{ item.calculatedCreateTime }}
        </div>
      </template>
      <template v-slot:[`header.calculatedModifyTime`]="{ header }">
        <div class="d-flex mr-8">
          <v-spacer />
          {{ header.text }}
        </div>
      </template>
      <template v-slot:[`item.calculatedModifyTime`]="{ item }">
        <div class="d-flex">
          <v-spacer />
          {{ item.calculatedModifyTime }}
        </div>
      </template>

      <template v-slot:[`item.calculatedAdmin`]="{ item }">
        <span v-for="nick in item.calculatedAdmin" :key="nick">
          {{ nick + "," }}
        </span>
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
            @click="editGroupButton(item)"
            class="ml-1"
          >
            修改
          </v-btn>
        </div>
      </template>
    </v-data-table>

    <!-- 组别信息Dialog -->
    <v-dialog v-model="groupInfoDialog" max-width="450px" persistent>
      <v-card>
        <v-col class="px-10 pt-10 group-dialog">
          <v-row>
            <span color="" class="text-subtitle-1">{{
              groupMode == 1 ? "新组别" : "编辑组别"
            }}</span>
          </v-row>
          <v-row>
            <v-col cols="8">
              <span class="text-body-2 text--secondary">名称</span>
              <v-text-field
                outlined
                dense
                hide-details
                color="blue-grey lighten-1"
                v-model="groupEdit.name"
              ></v-text-field>
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
                chips
                color="blue-grey lighten-1"
                item-text="uid"
                item-value="uid"
                multiple
              >
                <template v-slot:selection="data">
                  <span>{{ data.item.nick + "，" }}</span>
                </template>

                <template v-slot:item="data">
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ data.item.nick }}

                      <span class="text--secondary text-body-2 ml-3">{{
                        data.item.note
                      }}</span></v-list-item-title
                    >
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
                v-model="groupEdit.note"
                color="blue-grey lighten-1"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-col>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="groupInfoDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="save">保存</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import { getGroup } from "@/settings/group";
import { addGroup } from "@/settings/group";
import { modifyGroup } from "@/settings/group";

import { getAllUsers } from "@/settings/user";

import { javaDateTimeToString } from "@/libs/utils";

export default {
  data: () => ({
    allUsers: [],

    selectedAdmin: [],

    headers: [
      {
        text: "编号",
        align: "start",
        sortable: false,
        value: "uid",
      },
      { text: "组别名称", value: "name" },
      { text: "管理员", value: "calculatedAdmin" },
      { text: "备注", value: "note" },
      { text: "创建时间", value: "calculatedCreateTime" },
      { text: "修改时间", value: "calculatedModifyTime" },
      { text: "操作", value: "actions", sortable: false },
    ],
    groupInfo: [],
    expanded: [],

    groupInfoDialog: false,
    groupEdit: {},
    groupMode: 0, // 1--添加模式,  2--修改模式

    loading: false,

    groupDone: false,
    allUserDone: false,
  }),

  created() {
    this.init();
  },

  methods: {
    init() {
      this.groupDone = false;
      this.allUserDone = false;
      this.loading = true;
      getGroup({})
        .then((res) => {
          console.log(res.data.teams);
          this.groupInfo = res.data.teams; //team => group
          // this.groupInfo = res.data.group;
          this.groupDone = true;
          this.initDone();
        })
        .catch(() => {
          this.loading = false;
        });
      getAllUsers({})
        .then((res) => {
          console.log(res);
          this.allUsers = res.data.userInfos;
          this.allUserDone = true;
          this.initDone();
        })
        .catch(() => {
          this.loading = false;
        });
    },

    initDone() {
      if (!this.groupDone || !this.allUserDone) return;

      this.dataAnalyze();
      this.loading = false;
    },

    dataAnalyze() {
      console.log(this.allUsers);
      this.groupInfo.forEach((group) => {
        group.calculatedCreateTime = javaDateTimeToString(group.createTime);
        group.calculatedModifyTime = javaDateTimeToString(group.modifyTime);

        group.calculatedAdmin = [];
        if (group.admin) {
          group.calculatedAdmin = group.admin
            .split(",")
            .map((id) => this.allUsers.find((i) => i.uid == id).nick);
        }
      });
    },

    clickRow() {},

    editGroupButton(item) {
      this.groupMode = 2; //"修改"模式
      this.groupEdit = { ...item };
      this.selectedAdmin = item.admin
        ? item.admin.split(",").map((i) => Number(i))
        : [];
      this.groupInfoDialog = true;
    },

    addGroupButton() {
      this.groupMode = 1; //"添加"模式
      this.groupEdit = {};
      this.selectedAdmin = [];
      this.groupInfoDialog = true;
    },

    save() {
      console.log(this.selectedAdmin);
      this.groupMode == 1 ? this.newGroup() : this.editGroup();
      this.groupInfoDialog = false;
    },

    newGroup() {
      var args = { admin: this.selectedAdmin.join(), ...this.groupEdit };
      console.log(args);

      addGroup(args).then((res) => {
        this.global.infoAlert("泼发EBC：" + res.data);
        console.log(this.groupEdit);
        this.init();
      });
    },

    editGroup() {
      var args = { ...this.groupEdit };

      args.admin = this.selectedAdmin.join();
      console.log(args);

      modifyGroup(args).then((res) => {
        this.global.infoAlert("泼发EBC：" + res.data);
        console.log(this.groupEdit);
        this.init();
      });
    },
  },
};
</script>

<style scoped lang="scss">
.group-dialog {
  .col {
    padding-top: 5px;
    padding-bottom: 5px;
  }
}
</style>