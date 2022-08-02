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
      :items="userInfos"
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
          <v-btn
            color="primary"
            dark
            small
            depressed
            class="mb-2"
            @click="createDialog = true"
            >添加新员工</v-btn
          >
        </v-toolbar>
      </template>

      <template v-slot:[`item.calculatedPermission`]="{ item }">
        <span v-for="permission in item.calculatedPermission" :key="permission">
          {{ permission + "," }}
        </span>
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
          <v-btn
            small
            depressed
            outlined
            color="red lighten-2"
            @click="deleteButton(item)"
            class="ml-1"
          >
            <!-- <v-icon small class="mr-1"> mdi-delete </v-icon> -->
            删除
          </v-btn>
        </div>
      </template>
    </v-data-table>

    <!-- 新建员工Dialog -->
    <v-dialog v-model="createDialog" max-width="500px">
      <v-card class="employee-dialog">
        <v-card-title>
          <span class="text-subtitle-1">新增员工</span>
        </v-card-title>

        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="4">
                <span class="text-body-2 text--secondary">姓名*</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.nick"
                ></v-text-field>
              </v-col>
              <v-col cols="2">
                <span class="text-body-2 text--secondary">性别</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.gender"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary">联系方式</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.contact"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-divider class="my-8" />
            <v-row>
              <v-col>
                <span class="text-body-2 text--secondary">登陆账号*</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.username"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary">登陆密码*</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.password"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-divider class="my-8" />
            <v-row>
              <v-col>
                <span class="text-body-2 text--secondary">上级*</span>
                <v-autocomplete
                  outlined
                  dense
                  hide-details
                  no-data-text="空！！"
                  :items="userInfos.map((i) => i.nick)"
                  v-model="userInfoEdit.creatorId"
                ></v-autocomplete>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary">备注</span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="userInfoEdit.note"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-divider class="my-8" />
            <v-row>
              <v-btn text @click="permissionDialog = true"> 权限分配 </v-btn>
            </v-row>
            <v-row class="ml-4 mt-5">
              <span
                v-for="permission in selectedPermission"
                :key="permission"
                small
              >
                {{ permission + "，" }}
              </span>
            </v-row>
          </v-container>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="createDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="newEmployee">新建</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 权限Dialog -->
    <v-dialog v-model="permissionDialog" max-width="300px">
      <v-card class="employee-dialog">
        <v-card-title>
          <span class="text-subtitle-1">权限分配</span>
        </v-card-title>

        <v-card-text>
          <v-container>
            <!-- <v-row v-for=""> </v-row> -->
            <v-col>
              <v-checkbox
                v-for="permission in global.user.permission"
                :key="permission"
                :label="permission"
                v-model="permissionCheckbox[permission]"
                dense
              >
              </v-checkbox>
            </v-col>
          </v-container>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="permissionDialog = false"
            >确定</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-card>
</template>







<script>
import { getSubUsers } from "@/settings/user";
import { registUser } from "@/settings/user";

export default {
  components: {},
  data: () => ({
    headers: [
      { text: "员工ID", value: "uid" },
      { text: "姓名", value: "nick" },
      { text: "性别", value: "calculatedGender" },
      { text: "联系方式", value: "contact" },
      { text: "权限", value: "calculatedPermission" },
      { text: "上级", value: "calculatedCreator" },

      //{ text: "事业部权限", value: "department" },
      //{ text: "组别权限", value: "groupName" },

      { text: "登陆账号", value: "username" },
      { text: "登陆密码", value: "password" },

      { text: "备注", value: "note" },

      { text: "操作", value: "actions" },
    ],

    userInfoEdit: {},

    loading: true,

    userInfos: [],

    createDialog: false,
    permissionDialog: false,
    permissionCheckbox: {},

    idToNick: {},

    //
  }),

  computed: {
    selectedPermission() {
      var result = [];
      for (const name in this.permissionCheckbox) {
        if (this.permissionCheckbox[name]) result.push(name);
      }
      return result;
    },
  },

  watch: {},

  created() {
    this.init();
    console.log(this.global.user);
  },

  methods: {
    newEmployee() {
      this.createDialog = false;

      var args = {
        permission: JSON.stringify(this.selectedPermission),
        ...this.userInfoEdit,
      };
      args.creatorId = this.userInfos.find((i) => i.nick == args.creatorId).uid;

      console.log(args);
      registUser(args)
        .then((res) => {
          console.log(res);
          this.global.infoAlert("泼发EBC：" + res.data);
          this.init();
        })
        .catch(() => {});
    },

    init() {
      this.loading = true;

      getSubUsers()
        .then((res) => {
          this.loading = false;
          this.userInfos = res.data.userInfos;

          this.userInfos = this.userInfos.filter(
            (i) => i.uid != this.global.user.uid
          );
          this.userAnalyze();
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
        user.calculatedGender = "";
        if (null != user.gender) {
          user.calculatedGender = user.gender == 1 ? "男" : "女";
        }
        user.calculatedPermission = JSON.parse(user.permission);
      });
      this.userInfos.forEach((user) => {
        console.log(user);
        if (user.uid == 1) return; //admin
        user.calculatedCreator = `${this.idToNick[user.creatorId]}`;
        //user.boss = `${this.idToNick[user.creatorId]} ID：${user.creatorId}`
      });
    },
  },
};
</script>

<style src="./AllEmployees.scss" lang="scss">
</style>