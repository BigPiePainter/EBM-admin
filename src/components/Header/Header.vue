<template>
  <v-app-bar class="main-header" height="45" fixed color="primary" dense dark>
    <v-btn icon class="ml-1" @click.stop="setDrawer(!drawer)" large>
      <template v-if="drawer">
        <v-icon small>mdi-arrow-left</v-icon>
      </template>
      <template v-else>
        <v-icon small>mdi-menu</v-icon>
      </template>
    </v-btn>
    <v-toolbar-title>浙江泼发进出口贸易有限公司EBC</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-btn v-if="user.uid == 1" class="mr-7" small text @click="announcement()"
      >发布公告</v-btn
    >

    <!-- <v-menu offset-y bottom nudge-bottom="10" left>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          @click="
            notificationsBadge ? (notificationsBadge = !notificationsBadge) : ''
          "
          v-bind="attrs"
          v-on="on"
          style="font-size: 28px"
          icon
          class="mr-2"
        >
          <v-badge
            :value="notificationsBadge"
            color="error"
            content="4"
            overlap
          >
            <v-icon style="font-size: 28px" color="rgba(255, 255, 255, 0.35)"
              >mdi-bell-outline</v-icon
            >
          </v-badge>
        </v-btn>
      </template>
      <v-list>
        <v-list-item-group color="primary">
          <v-list-item v-for="(item, i) in notifications" :key="i">
            <v-list-item-icon class="mr-4 mb-1">
              <v-icon :color="item.color" v-text="item.icon"> </v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title v-text="item.text"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-menu>
    <v-menu max-width="280" offset-y bottom nudge-bottom="10" left>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          @click="messageBadge ? (messageBadge = !messageBadge) : ''"
          v-bind="attrs"
          v-on="on"
          style="font-size: 28px"
          icon
          class="mr-2"
        >
          <v-badge :value="messageBadge" color="warning" content="3" overlap>
            <v-icon :color="config.light.iconColor" style="font-size: 28px">
              mdi-email-outline</v-icon
            >
          </v-badge>
        </v-btn>
      </template>
      <v-list>
        <div class="text-h5 grey--text text--darken-3 px-4 pt-4">
          New Messages
        </div>
        <div
          class="subtitle-2 error--text font-weight-regular px-4 pb-2 link-item"
        >
          4 new Messages
        </div>
        <v-list-item-group color="primary">
          <v-list-item v-for="(item, i) in messages" :key="i">
            <v-list-item-icon class="mr-4 mb-1 d-flex flex-column">
              <v-btn fab x-small depressed :color="item.color"
                >{{ item.text }}
              </v-btn>
              <div style="font-size: 11px">{{ item.time }}</div>
            </v-list-item-icon>
            <v-list-item two-line>
              <v-list-item-content style="width: 190px">
                <v-list-item-title
                  v-text="item.name"
                  class="pb-2"
                ></v-list-item-title>
                <v-list-item-subtitle
                  v-text="item.message"
                  class="text-truncate"
                ></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list-item>
        </v-list-item-group>
        <div class="d-flex justify-center my-3">
          <v-btn
            large
            color="primary"
            rounded
            elevation="5"
            class="text-capitalize"
          >
            Send New Message
            <v-icon right dark>mdi-send</v-icon>
          </v-btn>
        </div>
      </v-list>
    </v-menu> -->

    <v-menu min-width="180" offset-y bottom left vnudge-bottom="10">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          class="mr-2"
          fab
          depressed
          v-bind="attrs"
          v-on="on"
          color="#78909C"
          x-small
        >
          <span style="font-size: 1rem">{{
            $store.state.user.nick.substr(0, 1)
          }}</span>
        </v-btn>
      </template>
      <v-list>
        <div class="text-h5 grey--text text--darken-3 px-4 pt-4" @click.stop="">
          {{ $store.state.user.nick }}
        </div>
        <div
          class="subtitle-2 primary--text font-weight-regular px-4"
          @click.stop=""
        >
          {{ $store.state.user.username }}
        </div>
        <div class="d-flex justify-center my-3" @click.stop="">
          <v-btn
            width="80%"
            outlined
            color="primary"
            class="text-capitalize"
            @click.stop="logOut"
            :loading="loading"
            >登出
          </v-btn>
        </div>
        <div class="d-flex justify-end mx-2" @click.stop="">
          <v-btn
            v-if="showChangePassword"
            text
            color="primary"
            @click.stop="showChangePassword = false"
            class="caption"
            small
          >
            取消
          </v-btn>
          <v-btn
            text
            color="primary"
            @click.stop="
              showChangePassword
                ? confirmChangePassword()
                : (showChangePassword = true)
            "
            class="caption"
            small
          >
            {{ showChangePassword ? "确认" : "修改密码" }}
          </v-btn>
        </div>

        <v-expand-transition>
          <div
            class="d-flex flex-column align-center mx-2"
            v-if="showChangePassword"
            @click.stop=""
          >
            <div class="d-flex my-1">
              <span class="caption pt-2 pr-2">旧密码</span>
              <v-text-field
                v-model="oldPassword"
                dense
                type="password"
                hide-details
                @click.stop=""
                color="primary"
                style="width: 100px"
              >
              </v-text-field>
            </div>
            <div class="d-flex my-1">
              <span class="caption pt-2 pr-2">新密码</span>
              <v-text-field
                v-model="newPassword"
                dense
                type="password"
                hide-details
                @click.stop=""
                color="primary"
                style="width: 100px"
              >
              </v-text-field>
            </div>
            <div class="d-flex my-1 mb-3">
              <span class="caption pt-2 pr-2" style="margin-left: 13px"
                >重复</span
              >
              <v-text-field
                v-model="repeatPassword"
                dense
                type="password"
                hide-details
                @click.stop=""
                color="primary"
                style="width: 100px"
              >
              </v-text-field>
            </div>
          </div>
        </v-expand-transition>
      </v-list>
    </v-menu>
    <!-- <v-btn
      @click="
        notificationsBadge ? (notificationsBadge = !notificationsBadge) : ''
      "
      style="font-size: 28px"
      icon
      class="mr-2"
    >
      <v-badge :value="notificationsBadge" color="error" content="4" overlap>
        <v-icon color="rgba(255, 255, 255, 0.35)">mdi-bell-outline</v-icon>
      </v-badge>
    </v-btn>
    <v-btn
      @click="messageBadge ? (messageBadge = !messageBadge) : ''"
      style="font-size: 28px"
      icon
      class="mr-2"
    >
      <v-badge :value="messageBadge" color="warning" content="3" overlap>
        <v-icon :color="config.light.iconColor"> mdi-email-outline</v-icon>
      </v-badge>
    </v-btn> -->
    <v-dialog v-model="announcementDialog" scrollable width="500px">
      <v-card>
        <v-card-title class="text-subtitle-1 pt-5 mb-3">
          公告内容：
        </v-card-title>
        <v-card-text class="pb-0 mb-3">
          <v-textarea
            style="font-size: 15px"
            height="350px"
            outlined
            v-model="announcementText"
            hide-details=""
          >
          </v-textarea>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer
          ><v-btn
            color="blue darken-1"
            text
            @click.stop="(announcementDialog = false), (announcementText = '')"
          >
            取消
          </v-btn>
          <v-btn color="blue darken-1" text @click.stop="setAnnouncement">
            发布公告
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-app-bar>
</template>

<script>
import { mapMutations, mapState } from "vuex";
import { userLogout } from "@/settings/user";
import { setAnnouncement } from "@/settings/announcement";
import { changePassword } from "@/settings/user";
// import Help from "@/components/Help";

import config from "../../config";

export default {
  name: "Header",
  components: {},
  data: () => ({
    showChangePassword: false,
    oldPassword: "",
    newPassword: "",
    repeatPassword: "",

    announcementText: "",
    announcementDialog: false,
    loading: false,
    config,
    searchCollapse: true,
    notifications: [
      {
        text: "Check out this awesome ticket",
        icon: "mdi-tag",
        color: "warning",
      },
      {
        text: "What is the best way to get ...",
        icon: "mdi-thumb-up",
        color: "success",
      },
      {
        text: "This is just a simple notification",
        icon: "mdi-flag",
        color: "error",
      },
      {
        text: "12 new orders has arrived today",
        icon: "mdi-cart",
        color: "primary",
      },
    ],
    messages: [
      {
        text: "JH",
        name: "Jane Hew",
        message: "Hey! How is it going?",
        time: "09:32",
        color: "warning",
      },
      {
        text: "LB",
        name: "Lloyd Brown",
        message: "Check out my new Dashboard",
        time: "10:02",
        color: "success",
      },
      {
        text: "MW",
        name: "Mark Winstein",
        message: "I want rearrange the appointment",
        time: "12:16",
        color: "error",
      },
      {
        text: "LD",
        name: "Liana Dutti",
        message: "Good news from sale department",
        time: "14:56",
        color: "primary",
      },
    ],
    account: [
      { text: "Profile", icon: "mdi-account", color: "textColor" },
      { text: "Tasks", icon: "mdi-thumb-up", color: "textColor" },
      { text: "Messages", icon: "mdi-flag", color: "textColor" },
    ],
    notificationsBadge: true,
    messageBadge: true,
  }),
  computed: {
    ...mapState(["user", "drawer"]),
  },
  methods: {
    ...mapMutations(["setDrawer"]),

    confirmChangePassword() {
      console.log("------");

      changePassword({
        oldPassword: this.oldPassword,
        newPassword: this.newPassword,
        repeatPassword: this.repeatPassword,
      })
        .then((res) => {
          console.log(res);
          this.global.infoAlert("泼发EBC：" + res.data);
          if (res.code == 1) {
            this.logOut();
          }
        })
        .catch(() => {});
    },

    announcement() {
      this.announcementDialog = true;
    },

    setAnnouncement() {
      console.log(this.user);
      console.log(this.announcementText);
      this.announcementDialog = false;
      setAnnouncement({ content: this.announcementText })
        .then((res) => {
          console.log(res.data);
          this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {});
      this.announcementText = "";
    },

    logOut: function () {
      //this.$router.push("/login");
      this.loading = true;
      setTimeout(() => {
        userLogout({})
          .then((res) => {
            console.log(res.data);
            localStorage.token = "";
            location.reload();
          })
          .catch(() => {});
      }, 300);
    },
  },
};
</script>

<style src="./Header.scss" lang="scss"></style>
