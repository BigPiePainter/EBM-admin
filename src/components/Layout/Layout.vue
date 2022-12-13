<template>
  <v-app class="pa-6">
    <Header />
    <Sidebar />
    <v-main class="content">
      <router-view />
    </v-main>

    <v-dialog
      :value="show"
      max-width="500px"
      min-width="500px"
      persistent
      scrollable
    >
      <v-card light>
        <v-card-title>
          公告： <v-spacer />
          <p style="font-size: 15px">{{ dateDiff }}</p>
        </v-card-title>
        <v-card-text
          style="max-height: 500px"
          class="py-0 px-8"
          v-for="(value, key) in content.split('\n')"
          :key="key"
        >
          <!-- 取巧 -->
          {{ value.trim() == "" ? "ㅤ" : value }}
        </v-card-text>

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
    date: new Date("2022-12-13 10:15:21"),
    websocket: null,
    content: `
EBC在12月13日下午5点进行了更新
ㅤ
本次更新内容包括：
1. 修复利润报表的真实拿货成本计算错误的问题，现在已经完全正确（终于修了）
2. 商品清单的部门，组别，持品人支持多选筛选
3. 新增在EBC中误下架商品的重新上架功能
4. 新增全局公告，就像现在这样，可以用来提醒什么什么
5. 细微修改了大量界面样式
      `,

    interval: 0,
  }),

  computed: {
    dateDiff: function () {
      var diff = new Date() - this.date;
      if (diff < 1000 * 60) {
        return "刚刚";
      } else if (diff < 1000 * 60 * 60) {
        return Math.ceil(diff / 1000 / 60) + "分钟前";
      } else if (diff < 1000 * 60 * 60 * 24) {
        return Math.ceil(diff / 1000 / 60 / 60) + "小时前";
      } else {
        return Math.ceil(diff / 1000 / 60 / 60 / 24) + "天前";
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
