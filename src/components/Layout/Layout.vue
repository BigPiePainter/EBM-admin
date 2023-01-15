<template>
  <v-app class="pa-6">
    <Header />
    <Sidebar />
    <v-main class="content">
      <keep-alive include="ProductCopy,ProfitTable,ProfitChart,MainPage">
        <router-view />
      </keep-alive>
    </v-main>

    <v-dialog :value="show" max-width="500px" min-width="500px" persistent>
      <v-card light>
        <v-card-title class="mb-2">
          公告： <v-spacer />
          <p style="font-size: 15px">{{ dateDiff }}</p>
        </v-card-title>

        <div style="max-height: calc(100vh - 400px); overflow-y: auto">
          <v-card-text style="max-height: 500px" class="py-0 px-8 text--secondary" v-for="(value, key) in content.split('\n')" :key="key">
            <!-- 取巧 -->
            {{ value.trim() == "" ? "ㅤ" : value }}
          </v-card-text>
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="show = false"> 确定 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-app>
</template>

<script>
import Header from "@/components/Header/Header";
import Sidebar from "@/components/Sidebar/Sidebar";

import "./Layout.scss";

export default {
  name: "Layout",
  components: { Header, Sidebar },

  data: () => ({
    show: false,
    date: new Date("2020"),
    websocket: null,
    content: "",

    interval: 0,
  }),

  computed: {
    dateDiff: function () {
      var diff = new Date() - this.date;
      if (diff < 1000 * 60) {
        return "刚刚";
      } else if (diff < 1000 * 60 * 60) {
        return Math.floor(diff / 1000 / 60) + "分钟前";
      } else if (diff < 1000 * 60 * 60 * 24) {
        return Math.floor(diff / 1000 / 60 / 60) + "小时前";
      } else {
        return Math.floor(diff / 1000 / 60 / 60 / 24) + "天前";
      }
    },
  },

  created() {
    var wsUri = "ws://" + process.env.VUE_APP_API_URL + "ws/global";

    this.interval = setInterval(() => {
      if (this.websocket) {
        console.log("发送消息");
        this.websocket.send("1");
        return;
      }
      this.websocket = new WebSocket(wsUri);
      this.websocket.onopen = () => {
        if (!this.showed) {
          this.showed = true;
          this.websocket.send("announcement");
        }
        console.log(this.websocket);
      };
      this.websocket.onclose = () => {
        console.log("DISCONNECTED");
        this.websocket = null;
      };
      this.websocket.onmessage = (evt) => {
        console.log("收到的消息", evt.data);
        var message = JSON.parse(evt.data);

        this.date = new Date();
        this.date.setTime(message.date);
        this.content = message.content;
        this.show = true;
      };
      this.websocket.onerror = () => {
        this.websocket = null;
      };
    }, 3000);
  },

  destroyed() {
    this.websocket.close();
    clearInterval(this.interval);
  },

  methods: {},
};
</script>

<style src="./Layout.scss" lang="scss" />
