<template>
  <v-card>
    <v-data-table
      fixed-header
      show-select
      disable-sort
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="uid"
      class="elevation-1"
      height="calc(100vh - 195px)"
      :loading="loading"
      :headers="headers"
      :items="userInfosWithoutSelf"
      :items-per-page="50"
      :footer-props="{
        'items-per-page-options': [10, 20, 50, 100],
        'items-per-page-text': '每页显示条数',
      }"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>员工信息</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
          <v-spacer />
          <v-btn small depressed class="mr-2 text--secondary">导出</v-btn>
          <v-btn
            color="primary"
            dark
            small
            depressed
            @click="newEmployeeButton"
          >
            新建员工
          </v-btn>
        </v-toolbar>
      </template>

      <template v-slot:[`item.calculatedPermission`]="{ item }">
        <span v-for="(permission, key) in item.calculatedPermission" :key="key">
          <span v-if="permission.a">
            {{
              {
                a: "商品管理",
                b: "订单管理",
                c: "员工管理",
                d: "部门管理",
                e: "组别管理",
              }[key] + ","
            }}
          </span>
        </span>
      </template>

      <template v-slot:[`item.department`]="{ item }">
        {{ departmentIdToName[item.department] }}
      </template>

      <template v-slot:[`item.gender`]="{ item }">
        {{ item.gender == 1 ? "男" : item.gender == 2 ? "女" : "" }}
      </template>

      <template v-slot:[`item.onboardingTime`]="{ item }">
        {{ parseDate(item.onboardingTime) }}
      </template>

      <template v-slot:[`item.password`]="{ item }">
        {{ user.permission.c.b ? item.password : "隐藏" }}
      </template>

      <template v-slot:[`header.actions`]="{ header }">
        <div class="d-flex mr-12">
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
            @click="editButton(item)"
            class="ml-1"
          >
            修改
          </v-btn>
          <!-- <v-btn
            small
            depressed
            outlined
            color="red lighten-2"
            @click="deleteButton(item)"
            class="ml-1"
          >
            删除
          </v-btn> -->
        </div>
      </template>
    </v-data-table>

    <!-- 员工信息Dialog -->
    <v-dialog v-model="userInfoDialog" max-width="500px">
      <v-card class="employee-dialog">
        <v-tabs v-model="tabs" align-with-title>
          <!-- align-with-title -->
          <!-- <v-tabs-slider color="yellow"></v-tabs-slider> -->
          <v-tab>
            <span class="text-body-1">员工信息</span>
          </v-tab>
          <v-tab>
            <span class="text-body-1">权限</span>
          </v-tab>
        </v-tabs>
        <v-tabs-items v-model="tabs">
          <v-tab-item>
            <v-col class="px-7 py-7">
              <v-row>
                <v-col cols="3">
                  <span class="text-body-2 text--secondary">姓名*</span>
                  <v-text-field
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    v-model="userInfoEdit.nick"
                  >
                  </v-text-field>
                </v-col>
                <v-col cols="3" class="pr-8">
                  <span class="text-body-2 text--secondary">性别</span>
                  <v-select
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    :items="[
                      { k: '男', v: 1 },
                      { k: '女', v: 2 },
                    ]"
                    item-text="k"
                    item-value="v"
                    v-model="userInfoEdit.gender"
                  >
                  </v-select>
                </v-col>
                <v-col>
                  <span class="text-body-2 text--secondary">联系方式</span>
                  <v-text-field
                    outlined
                    color="blue-grey lighten-1"
                    dense
                    hide-details
                    v-model="userInfoEdit.contact"
                  >
                  </v-text-field>
                </v-col>
              </v-row>
              <v-divider class="my-8" />
              <v-row>
                <v-col>
                  <span class="text-body-2 text--secondary">登录账号*</span>
                  <v-text-field
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    v-model="userInfoEdit.username"
                  >
                  </v-text-field>
                </v-col>
                <v-col>
                  <span class="text-body-2 text--secondary">登录密码*</span>
                  <v-text-field
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    v-model="userInfoEdit.password"
                  >
                  </v-text-field>
                </v-col>
              </v-row>
              <v-row>
                <v-col>
                  <span class="text-body-2 text--secondary">所属部门*</span>
                  {{global.log(user.permission.c.d)}}
                  <v-autocomplete
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    no-data-text="空！！"
                    :items="
                      user.permission.c.d.map((i) => departmentIdToInfo[i])
                    "
                    item-text="name"
                    item-value="uid"
                    v-model="userInfoEdit.department"
                  ></v-autocomplete>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="4">
                  <span class="text-body-2 text--secondary">入职日期*</span>
                  <v-menu
                    ref="menu"
                    v-model="datePicker"
                    :close-on-content-click="false"
                    :return-value.sync="userInfoEdit.onboardingTime"
                    offset-y
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field
                        v-model="userInfoEdit.onboardingTime"
                        readonly
                        v-bind="attrs"
                        v-on="on"
                        outlined
                        dense
                        hide-details
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="userInfoEdit.onboardingTime"
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
                        @click="$refs.menu.save(userInfoEdit.onboardingTime)"
                      >
                        确定
                      </v-btn>
                    </v-date-picker>
                  </v-menu>
                </v-col>
                <v-col>
                  <span class="text-body-2 text--secondary">备注</span>
                  <v-text-field
                    color="blue-grey lighten-1"
                    outlined
                    dense
                    hide-details
                    v-model="userInfoEdit.note"
                  >
                  </v-text-field>
                </v-col>
              </v-row>
            </v-col>
          </v-tab-item>
          <v-tab-item>
            <div style="height: 350px; overflow: auto">
              <v-col class="px-10 py-10">
                <v-row v-if="user.permission.a.a">
                  <span class="text-subtitle-1">商品管理模块</span>
                  <v-checkbox
                    v-model="selectedPermission.a.a"
                    label="授权"
                    hide-details
                    class="ml-10 mt-0 pt-0"
                  />
                </v-row>

                <v-expand-transition>
                  <v-container v-if="selectedPermission.a.a">
                    <v-row class="mt-5">
                      <v-col cols="10">
                        <span class="text-body-2 text--secondary">
                          部门录入权限
                        </span>
                        <v-autocomplete
                          v-model="selectedPermission.a.d"
                          :items="
                            allDepartments.filter((d) =>
                              user.permission.a.d.find((i) => i == d.uid)
                            )
                          "
                          no-data-text="无"
                          outlined
                          dense
                          hide-details
                          color="blue-grey lighten-1"
                          item-text="name"
                          item-value="uid"
                          multiple
                        >
                        </v-autocomplete>
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-col cols="10">
                        <span class="text-body-2 text--secondary"
                          >组别录入权限</span
                        >
                        <v-autocomplete
                          v-model="selectedPermission.a.g"
                          :items="
                            allTeams.filter((g) =>
                              user.permission.a.g.find((i) => i == g.uid)
                            )
                          "
                          no-data-text="无"
                          outlined
                          dense
                          hide-details
                          color="blue-grey lighten-1"
                          item-text="name"
                          item-value="uid"
                          multiple
                        >
                        </v-autocomplete>
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-col>
                        <v-checkbox
                          v-model="selectedPermission.a.da"
                          hide-details
                          dense
                          :disabled="!user.permission.a.da"
                        >
                          <template v-slot:label>
                            <span class="text-subtitle-2"
                              >删除商品归属变更记录</span
                            >
                          </template>
                        </v-checkbox>
                      </v-col>
                      <v-col>
                        <v-checkbox
                          v-model="selectedPermission.a.fc"
                          hide-details
                          dense
                          :disabled="!user.permission.a.fc"
                        >
                          <template v-slot:label>
                            <span class="text-subtitle-2">管理一级类目</span>
                          </template>
                        </v-checkbox>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-expand-transition>

                <v-divider class="my-8" v-if="user.permission.b.a" />
                <v-row v-if="user.permission.b.a">
                  <span class="text-subtitle-1">订单管理模块</span>
                  <v-checkbox
                    v-model="selectedPermission.b.a"
                    label="授权"
                    hide-details
                    class="ml-10 mt-0 pt-0"
                  >
                    <template v-slot:label>
                      <span class="text-subtitle-1">授权</span>
                    </template>
                  </v-checkbox>
                </v-row>
                <v-divider class="my-8" v-if="user.permission.c.a" />
                <v-row v-if="user.permission.c.a">
                  <span class="text-subtitle-1">员工管理模块</span>
                  <v-checkbox
                    v-model="selectedPermission.c.a"
                    label="授权"
                    hide-details
                    class="ml-10 mt-0 pt-0"
                  />
                </v-row>

                <v-expand-transition>
                  <v-container v-if="selectedPermission.c.a">
                    <v-row class="mt-5">
                      <v-col cols="10">
                        <span class="text-body-2 text--secondary">
                          部门管理权限
                        </span>
                        <Help text="可以创建并管理哪个部门的员工" />
                        <v-autocomplete
                          v-model="selectedPermission.c.d"
                          :items="
                            allDepartments.filter((d) =>
                              user.permission.c.d.find((i) => i == d.uid)
                            )
                          "
                          no-data-text="无"
                          outlined
                          dense
                          hide-details
                          color="blue-grey lighten-1"
                          item-text="name"
                          item-value="uid"
                          multiple
                        >
                        </v-autocomplete>
                      </v-col>
                    </v-row>
                    <v-row class="mt-5">
                      <v-col>
                        <v-checkbox
                          v-model="selectedPermission.c.b"
                          hide-details
                          dense
                          :disabled="!user.permission.c.b"
                        >
                          <template v-slot:label>
                            <span class="text-subtitle-2">查看员工密码</span>
                          </template>
                        </v-checkbox>
                      </v-col>
                      <v-col> </v-col>
                    </v-row>
                  </v-container>
                </v-expand-transition>

                <v-divider class="my-8" v-if="user.permission.d.a" />
                <v-row v-if="user.permission.d.a">
                  <span class="text-subtitle-1">部门管理模块</span>
                  <v-checkbox
                    v-model="selectedPermission.d.a"
                    label="授权"
                    hide-details
                    class="ml-10 mt-0 pt-0"
                  />
                </v-row>

                <v-divider class="my-8" v-if="user.permission.e.a" />
                <v-row v-if="user.permission.e.a">
                  <span class="text-subtitle-1">组别管理模块</span>
                  <v-checkbox
                    v-model="selectedPermission.e.a"
                    label="授权"
                    hide-details
                    class="ml-10 mt-0 pt-0"
                  />
                </v-row>
              </v-col>
            </div>
          </v-tab-item>
        </v-tabs-items>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">带*为必填项目</p>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="userInfoDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="save" :disabled="isEmpty"
            >保存</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-card>
</template>







<script>
import { mapState } from "vuex";
import { javaUTCDateToString } from "@/libs/utils";
import { getSubUsers } from "@/settings/user";
import { registUser } from "@/settings/user";
import { modifyUser } from "@/settings/user";

import Help from "@/components/Help";

export default {
  components: {
    Help,
  },
  data: () => ({
    headers: [
      { text: "员工ID", value: "uid" },
      { text: "姓名", value: "nick" },

      { text: "性别", value: "gender" },
      { text: "所属部门", value: "department" },
      { text: "联系方式", value: "contact" },
      { text: "入职日期", value: "onboardingTime" },
      { text: "权限", value: "calculatedPermission" },

      { text: "登录账号", value: "username" },
      { text: "登录密码", value: "password" },

      { text: "备注", value: "note" },

      { text: "操作", value: "actions" },
    ],

    mode: 0,

    userInfoEdit: {},

    datePicker: null,

    loading: true,

    userInfos: [],
    userInfosWithoutSelf: [],

    userInfoDialog: false,

    idToNick: {},

    tabs: 0,

    selectedPermission: {
      a: {},
      b: {},
      c: {},
      d: {},
      e: {},
    },
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
      "departmentIdToInfo",
      "categoryIdToName",
      "categoryIdToInfo",
    ]),
    isEmpty: function () {
      var check = ["nick", "username", "password", "department"];
      var pass = true;
      check.forEach((item) => {
        if (!this.userInfoEdit[item]) pass = false;
      });

      console.log(pass);

      return !pass;
    },
  },

  watch: {},

  created() {
    this.init();
    console.log(this.user);
  },

  methods: {
    parseDate(date) {
      return javaUTCDateToString(date);
    },

    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    newEmployeeButton() {
      this.userInfoEdit = {};
      this.selectedPermission = {
        a: {},
        b: {},
        c: {},
        d: {},
        e: {},
      };
      this.mode = 0; // 0-添加模式   1-修改模式
      this.userInfoDialog = true;
    },

    deleteButton() {},

    editButton(item) {
      this.userInfoEdit = { ...item };
      this.selectedPermission = JSON.parse(
        this.userInfos.find((i) => i.uid == item.uid).permission
      );
      console.log(this.userInfoEdit);

      this.userInfoEdit.onboardingTime = this.parseDate(
        this.userInfoEdit.onboardingTime
      );
      this.mode = 1;
      this.userInfoDialog = true;
    },

    editEmployee() {
      this.userInfoDialog = false;

      var args = { ...this.userInfoEdit };

      console.log(this.selectedPermission.a.a);
      args.permission = JSON.stringify(this.selectedPermission);
      args.note == null && delete args.note;
      args.contact == null && delete args.contact;
      args.gender == null && (args.gender = 3);
      args.onboardingTime = args.onboardingTime.replaceAll("-", "/");

      console.log(args);
      modifyUser(args)
        .then((res) => {
          console.log(res);
          this.global.infoAlert("泼发EBC：" + res.data);
          this.init();
        })
        .catch(() => {});
      this.mode = 0;
    },

    newEmployee() {
      this.userInfoDialog = false;

      console.log("------");
      console.log(this.userInfoEdit);
      var args = {
        permission: JSON.stringify(this.selectedPermission),
        ...this.userInfoEdit,
      };

      args.onboardingTime = args.onboardingTime.replaceAll("-", "/");
      console.log(args);
      registUser(args)
        .then((res) => {
          console.log(res);
          this.global.infoAlert("泼发EBC：" + res.data);
          this.init();
        })
        .catch(() => {});
      this.mode = 0;
    },

    save() {
      if (this.mode == 0) {
        this.newEmployee();
      } else if (this.mode == 1) {
        this.editEmployee();
      }
    },

    init() {
      this.loading = true;

      getSubUsers()
        .then((res) => {
          this.loading = false;
          this.userInfos = res.data.userInfos;
          this.userAnalyze();

          this.userInfosWithoutSelf = this.userInfos.filter(
            (i) => i.uid != this.user.uid
          );
          //this.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },
    userAnalyze() {
      this.userInfos.forEach((user) => {
        console.log(user);
        this.idToNick[user.uid] = user.nick;
        user.calculatedPermission = JSON.parse(user.permission);
      });
    },
  },
};
</script>

<style src="./AllEmployees.scss" lang="scss">
</style>