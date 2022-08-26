<template>
  <v-app>
    <div style="position: absolute; width: 100vw; height: 100vh">
      <v-chart :option="bgOption" ref="barChart"></v-chart>
    </div>

    <div
      class="d-flex flex-column justify-space-around align-center"
      style="height: 100vh"
    >
      <v-chart
        style="margin: 0 auto; width: 500px; height: 182px; z-index: 0"
        ref="title"
        :option="option"
      ></v-chart>
      <div class="login-part mb-15">
        <v-tabs grow>
          <v-tabs-slider></v-tabs-slider>
          <v-tab :href="`#tab-login`" loading> 登录 </v-tab>
          <v-tab-item :value="'tab-login'">
            <v-form style="position: relative; margin-bottom: 10px">
              <v-container>
                <v-row class="flex-column">
                  <v-form>
                    <v-col class="mt-8">
                      <v-text-field
                        v-model="email"
                        :rules="emailRules"
                        value=""
                        required
                        outlined
                        :loading="loading"
                      ></v-text-field>
                      <v-text-field
                        outlined
                        v-model="password"
                        :rules="passRules"
                        type="password"
                        hint="6-30个字符"
                        required
                        :loading="loading"
                        class="mt-6"
                      ></v-text-field>
                    </v-col>
                    <v-col class="d-flex justify-space-between">
                      <v-btn
                        class="text-capitalize"
                        large
                        :disabled="password.length === 0 || email.length === 0"
                        color="primary"
                        @click="login"
                      >
                        登录</v-btn
                      >
                      <v-btn large text class="text-capitalize primary--text"
                        >忘记密码</v-btn
                      >
                    </v-col>
                  </v-form>
                </v-row>
              </v-container>
            </v-form>
          </v-tab-item>
        </v-tabs>
      </div>
      <div class="d-flex mt-15">
        <v-spacer></v-spacer>
        <span class="primary--text pb-2 pr-5" style="z-index: 999"
          >© 浙江泼发进出口贸易有限公司</span
        >
      </div>
    </div>
  </v-app>
</template>
<script>
import { userLogin } from "@/settings/user";

import { mapActions, mapMutations } from "vuex";

import { isLogin } from "@/settings/user";

import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { VisualMapComponent } from "echarts/components";
import VChart from "vue-echarts";
import "echarts-gl";

use([CanvasRenderer, VisualMapComponent]);
require("echarts/lib/component/graphic");

const seriesData = [
  [0, 0, 5],
  [0, 1, 1],
  [0, 2, 0],
  [0, 3, 0],
  [0, 4, 0],
  [0, 5, 0],
  [0, 6, 0],
  [0, 7, 0],
  [0, 8, 0],
  [0, 9, 0],
  [0, 10, 0],
  [0, 11, 2],
  [0, 12, 4],
  [0, 13, 1],
  [0, 14, 1],
  [0, 15, 3],
  [0, 16, 4],
  [0, 17, 6],
  [0, 18, 4],
  [0, 19, 4],
  [0, 20, 3],
  [0, 21, 3],
  [0, 22, 2],
  [0, 23, 5],
  [1, 0, 7],
  [1, 1, 0],
  [1, 2, 0],
  [1, 3, 0],
  [1, 4, 0],
  [1, 5, 0],
  [1, 6, 0],
  [1, 7, 0],
  [1, 8, 0],
  [1, 9, 0],
  [1, 10, 5],
  [1, 11, 2],
  [1, 12, 2],
  [1, 13, 6],
  [1, 14, 9],
  [1, 15, 11],
  [1, 16, 6],
  [1, 17, 7],
  [1, 18, 8],
  [1, 19, 12],
  [1, 20, 5],
  [1, 21, 5],
  [1, 22, 7],
  [1, 23, 2],
  [2, 0, 1],
  [2, 1, 1],
  [2, 2, 0],
  [2, 3, 0],
  [2, 4, 0],
  [2, 5, 0],
  [2, 6, 0],
  [2, 7, 0],
  [2, 8, 0],
  [2, 9, 0],
  [2, 10, 3],
  [2, 11, 2],
  [2, 12, 1],
  [2, 13, 9],
  [2, 14, 8],
  [2, 15, 10],
  [2, 16, 6],
  [2, 17, 5],
  [2, 18, 5],
  [2, 19, 5],
  [2, 20, 7],
  [2, 21, 4],
  [2, 22, 2],
  [2, 23, 4],
  [3, 0, 7],
  [3, 1, 3],
  [3, 2, 0],
  [3, 3, 0],
  [3, 4, 0],
  [3, 5, 0],
  [3, 6, 0],
  [3, 7, 0],
  [3, 8, 1],
  [3, 9, 0],
  [3, 10, 5],
  [3, 11, 4],
  [3, 12, 7],
  [3, 13, 14],
  [3, 14, 13],
  [3, 15, 12],
  [3, 16, 9],
  [3, 17, 5],
  [3, 18, 5],
  [3, 19, 10],
  [3, 20, 6],
  [3, 21, 4],
  [3, 22, 4],
  [3, 23, 1],
  [4, 0, 1],
  [4, 1, 3],
  [4, 2, 0],
  [4, 3, 0],
  [4, 4, 0],
  [4, 5, 1],
  [4, 6, 0],
  [4, 7, 0],
  [4, 8, 0],
  [4, 9, 2],
  [4, 10, 4],
  [4, 11, 4],
  [4, 12, 2],
  [4, 13, 4],
  [4, 14, 4],
  [4, 15, 14],
  [4, 16, 12],
  [4, 17, 1],
  [4, 18, 8],
  [4, 19, 5],
  [4, 20, 3],
  [4, 21, 7],
  [4, 22, 3],
  [4, 23, 0],
  [5, 0, 2],
  [5, 1, 1],
  [5, 2, 0],
  [5, 3, 3],
  [5, 4, 0],
  [5, 5, 0],
  [5, 6, 0],
  [5, 7, 0],
  [5, 8, 2],
  [5, 9, 0],
  [5, 10, 4],
  [5, 11, 1],
  [5, 12, 5],
  [5, 13, 10],
  [5, 14, 5],
  [5, 15, 7],
  [5, 16, 11],
  [5, 17, 6],
  [5, 18, 0],
  [5, 19, 5],
  [5, 20, 3],
  [5, 21, 4],
  [5, 22, 2],
  [5, 23, 0],
  [6, 0, 1],
  [6, 1, 0],
  [6, 2, 0],
  [6, 3, 0],
  [6, 4, 0],
  [6, 5, 0],
  [6, 6, 0],
  [6, 7, 0],
  [6, 8, 0],
  [6, 9, 0],
  [6, 10, 1],
  [6, 11, 0],
  [6, 12, 2],
  [6, 13, 1],
  [6, 14, 3],
  [6, 15, 4],
  [6, 16, 0],
  [6, 17, 0],
  [6, 18, 0],
  [6, 19, 0],
  [6, 20, 1],
  [6, 21, 2],
  [6, 22, 2],
  [6, 23, 6],
];

export default {
  name: "Login",
  components: {
    VChart,
  },
  data() {
    return {
      bgOption: {
        visualMap: {
          max: 30,
          inRange: {
            color: [
              "#313695",
              "#4575b4",
              "#74add1",
              "#abd9e9",
              "#e0f3f8",
              "#ffffbf",
              "#fee090",
              "#fdae61",
              "#f46d43",
              "#d73027",
              "#a50026",
            ],
          },
        },
        xAxis3D: {
          type: "category",
          data: [],
        },
        yAxis3D: {
          type: "category",
          data: [],
        },
        zAxis3D: {
          type: "value",
        },
        grid3D: {
          boxWidth: 180,
          boxDepth: 60,
          light: {
            main: {
              intensity: 1.2,
            },
            ambient: {
              intensity:0.3,
            },
          },
          viewControl: {
            autoRotate: true,
            autoRotateSpeed: 0.7,
            alpha: -30,
            beta: 15,
            distance: 70,
          },
        },
        series: [
          {
            type: "bar3D",
            data: seriesData.map(function (item) {
              return {
                value: [item[1], item[0], item[2]],
              };
            }),
            shading: "color",
            label: {
              fontSize: 8,
              borderWidth: 1,
            },
            itemStyle: {
              opacity: 0.4,
            },
            emphasis: {
              label: {
                fontSize: 10,
                color: "#900",
              },
              itemStyle: {
                color: "#4575b4",
              },
            },
          },
        ],
      },
      option: {
        graphic: {
          elements: [
            {
              type: "text",
              left: "center",
              top: "center",
              style: {
                text: "POFA EBC",
                fontSize: 70,
                fontWeight: "400",
                lineDash: [0, 200],
                lineDashOffset: 10,
                fill: "#fff0",
                stroke: "#536DFE",
                lineWidth: 2,
              },
              keyframeAnimation: {
                duration: 3000,
                loop: false,
                keyframes: [
                  {
                    percent: 0.7,
                    style: {
                      fill: "#fff0",
                      lineDashOffset: 200,
                      lineDash: [200, 0],
                    },
                  },
                  {
                    // Stop for a while.
                    percent: 0.8,
                    style: {
                      fill: "#fff0",
                    },
                  },
                  {
                    percent: 1,
                    style: {
                      fill: "#536DFE",
                    },
                  },
                ],
              },
            },
          ],
        },
      },
      email: "",
      emailRules: [
        (v) => !!v || "账号不能为空",
        (v) => v.length >= 2 || "账号不能少于2个字符",
        (v) => v.length <= 30 || "账号不能多于30个字符",
        (v) => /^[0-9a-zA-Z]+$/.test(v) || "账号不能包含特殊符号",
      ],
      password: "",
      passRules: [
        (v) => !!v || "密码不能为空",
        (v) => v.length >= 6 || "密码不能少于6个字符",
        (v) => v.length <= 30 || "密码不能多于30个字符",
      ],
      loading: false,

      done: [false, false, false, false, true], //全部请求状态
    };
  },
  methods: {
    ...mapMutations(["setToken", "setUser"]),
    ...mapActions([
      "refreshAllDepartments",
      "refreshAllTeams",
      "refreshAllUsers",
      "refreshAllCategorys",
    ]),
    login() {
      this.loading = true;
      userLogin({ username: this.email, password: this.password })
        .then((res) => {
          this.loading = false;
          try {
            console.log(res);
            if (res.data.token && res.data.token.isLogin) {
              this.global.infoAlert("泼发EBC：登录成功");

              this.setUser(res.data.user);
              this.setToken(res.data.token.tokenValue);

              this.globalInitAndJump();
              return;
            }

            this.global.infoAlert("泼发EBC：" + res.data);
          } catch (error) {
            this.global.infoAlert("泼发EBC：登录失败");
          }
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：登录失败");
          }, 100);
        });
    },

    globalInitAndJump() {
      this.refreshAllDepartments();
      this.refreshAllTeams();
      this.refreshAllUsers();
      this.refreshAllCategorys();
      console.log("登录跳转");
      console.log("全局Global", this.global);
      this.$router.push("/mainpage");
    },
  },

  created() {
    isLogin({}).then((res) => {
      console.log("isLogin");
      console.log(res);

      if (!res.data.isLogin) return;

      this.global.infoAlert("泼发EBC：登录成功");

      this.setUser(res.data.user);
      this.setToken(res.data.token.tokenValue);

      this.globalInitAndJump();
    });

    //if (window.localStorage.getItem("authenticated") === "true") {
    //  this.$router.push("/partnerget");
    //}
  },

  mounted() {
    window.onresize = () => {
      this.$refs.barChart.resize();
      this.$refs.title.resize();
      console.log(this.$refs.barChart.getOption());
    };
  },

  beforeDestroy() {
    window.onresize = function () {};
  },
};
</script>

<style src="./Login.scss" lang=scss></style>