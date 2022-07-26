<template>
  <v-data-table
    fixed-header
    show-expand
    loading-text="加载中... 请稍后"
    no-data-text="空"
    item-key="uid"
    class="elevation-1"
    height="calc(100vh - 150px)"
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
      <v-toolbar>
        <v-toolbar-title>员工信息</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer />
        <v-dialog v-model="createDialog" max-width="500px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="primary"
              dark
              class="mb-2"
              @click="dialog"
              v-bind="attrs"
              v-on="on"
              >添加新员工</v-btn
            >
          </template>
          <v-card>
            <v-card-title>
              <span class="text-subtitle-1">新增员工</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">姓名</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.nick"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-divider class="my-8" />
                <v-row>
                  <v-col >
                    <span class="text-body-2 text--secondary">上级</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.boss"
                    ></v-text-field>
                  </v-col>
                  <v-col >
                    <span class="text-body-2 text--secondary">从属</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.location"
                    ></v-text-field>
                  </v-col> </v-row
                ><v-divider class="my-8" />
                <v-row>
                  <v-col >
                    <span class="text-body-2 text--secondary">注册用户名</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.username"
                    ></v-text-field>
                  </v-col> </v-row
                ><v-divider class="my-8" />
                <v-row>
                  <v-col >
                    <span class="text-body-2 text--secondary">注册密码</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.password"
                    ></v-text-field>
                  </v-col> </v-row
                ><v-divider class="my-8" />
                <v-row>
                  <v-col >
                    <span class="text-body-2 text--secondary">备注</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="createUser.note"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">取消</v-btn>
              <v-btn color="blue darken-1" text @click="save">保存</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
      <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
    </template>
  </v-data-table>
</template>







<script>
import { getSubUsers } from "@/settings/user";
import { createSubUsers } from "@/settings/user";

export default {
  components: {},
  data: () => ({
    headers: [
      { text: "员工ID", value: "uid" },
      { text: "姓名", value: "nick" },
      { text: "归属", value: "location" },
      { text: "上级", value: "boss" },

      //{ text: "事业部权限", value: "department" },
      //{ text: "组别权限", value: "groupName" },

      { text: "登陆账号", sortable: false, value: "username" },
      { text: "登陆密码", sortable: false, value: "password" },

      { text: "备注", sortable: false, value: "note" },
    ],

    createUser: {
      nick: "",
      boss: "",
      location: "",
      username: "",
      password: "",
      note: "",
    },

    loading: true,

    userInfos: [],

    createDialog: false,

    idToNick: {},
  }),

  computed: {},

  watch: {},

  created() {
    this.init();
  },

  methods: {
    dialog() {
      this.createDialog = true;
    },

    close() {
      this.createDialog = false;
    },

    save() {
      this.uploadUser;
      this.createDialog = false;
    },

    uploadUser() {
      createSubUsers({ user: this.createUser });
    },

    init() {
      this.loading = true;

      getSubUsers({})
        .then((res) => {
          this.loading = false;
          this.userInfos = res.data.userInfos;
          this.createrAnalyze();
          //this.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },
    createrAnalyze() {
      this.userInfos.forEach((user) => {
        console.log(user);
        this.idToNick[user.uid] = user.nick;
        user.boss = "";
      });
      this.userInfos.forEach((user) => {
        console.log(user);
        if (user.uid == 1) return;
        user.boss = `${this.idToNick[user.creatorId]}`;
        //user.boss = `${this.idToNick[user.creatorId]} ID：${user.creatorId}`
      });
    },
  },
};
</script>

<style src="./AllEmployees.scss" lang="scss">
</style>