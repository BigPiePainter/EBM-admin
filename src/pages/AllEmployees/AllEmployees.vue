<template>
  <v-card>
    <v-card-title> 123 </v-card-title>
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
      <template v-slot:top> </template>

      <template v-slot:[`item.actions`]="{ item }">
        <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
        <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
      </template>
    </v-data-table></v-card
  >
</template>







<script>
import { getSubUsers } from "@/settings/user";

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

    loading: true,

    userInfos: [],

    idToNick: {},
  }),

  computed: {},

  watch: {},

  created() {
    this.init();
  },

  methods: {
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