<template>
  <v-app>
    <v-container fluid>
      <v-row no-gutters>
        <v-col cols="7" class="main-part d-none d-md-none d-lg-flex">
          <div class="d-flex">
            <v-img src="@/assets/logo3.svg" contain></v-img>
            <p>POFA EBC</p>
          </div>
        </v-col>
        <v-col
          cols="12"
          lg="5"
          class="login-part d-flex align-center justify-center"
        >
          <v-row no-gutters class="align-start">
            <v-col
              cols="12"
              class="login-part d-flex align-center justify-center flex-column"
            >
              <div class="login-wrapper pt-md-4 pt-0">
                <v-tabs grow>
                  <v-tabs-slider></v-tabs-slider>
                  <v-tab :href="`#tab-login`" loading> 登陆 </v-tab>

                  <v-tab-item :value="'tab-login'">
                    <v-form>
                      <v-container>
                        <v-row class="flex-column">
                          <v-form>
                            <v-col class="mt-8">
                              <v-text-field
                                v-model="email"
                                :rules="emailRules"
                                value=""
                                label="账号"
                                required
                                :loading="loading"
                              ></v-text-field>
                              <v-text-field
                                v-model="password"
                                :rules="passRules"
                                type="password"
                                label="密码"
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
                                :disabled="
                                  password.length === 0 || email.length === 0
                                "
                                color="primary"
                                @click="login"
                              >
                                登陆</v-btn
                              >
                              <v-btn
                                large
                                text
                                class="text-capitalize primary--text"
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
            </v-col>
            <v-col cols="12" class="d-flex justify-center">
              <v-footer>
                <div class="primary--text">© 浙江泼发进出口贸易有限公司</div>
              </v-footer>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>
  </v-app>
</template>

<script>
import { userLogin } from "@/settings/user";
import { getDepartment } from "@/settings/department";
import { getTeam } from "@/settings/team";
import { getAllUsers } from "@/settings/user";
import { getCategory } from "@/settings/category";

import { isLogin } from "@/settings/user";

export default {
  name: "Login",
  data() {
    return {
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

      allTeams: [],
      allDepartments: [],
      allUsers: [],
      allCategorys: [],

      done: [false, false, false, false], //三个请求状态
    };
  },
  methods: {
    login() {
      this.loading = true;
      userLogin({ username: this.email, password: this.password })
        .then((res) => {
          this.loading = false;
          try {
            console.log(res);
            if (res.data.token && res.data.token.isLogin) {
              this.infoAlert("泼发EBC：登陆成功");

              //this.global.token = res.data.token.tokenValue
              localStorage.token = res.data.token.tokenValue;
              this.global.user = res.data.user;

              this.globalInitAndJump();
              return;
            }

            this.infoAlert("泼发EBC：" + res.data);
          } catch (error) {
            this.infoAlert("泼发EBC：登陆失败");
          }
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.infoAlert("泼发EBC：登陆失败");
          }, 100);
        });
    },

    infoAlert(message) {
      this.$toast.info(message, {
        position: "top-right",
        timeout: 6000,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        draggablePercent: 0.6,
        showCloseButtonOnHover: false,
        hideProgressBar: true,
        closeButton: "button",
        icon: true,
      });
    },

    globalInitAndJump() {
      this.done.fill(false);

      getDepartment({}).then((res) => {
        this.allDepartments = res.data.departments;
        this.requestDone(0);
      });
      getTeam({}).then((res) => {
        this.allTeams = res.data.teams;
        this.requestDone(1);
      });
      getAllUsers({}).then((res) => {
        this.allUsers = res.data.userInfos;
        this.requestDone(2);
      });
      getCategory({}).then((res) => {
        this.allCategorys = res.data.categorys;
        this.requestDone(3);
      });
    },

    requestDone(i) {
      this.done[i] = true;
      console.log("done");
      console.log(this.done);
      if (this.done.find((i) => !i) == false) return;

      this.global.allDepartments = this.allDepartments;
      this.global.allTeams = this.allTeams;
      this.global.allUsers = this.allUsers;
      this.global.allCategorys = this.allCategorys;

      if (this.global.user.uid == 1) {
        this.global.user.permission = this.global.allPermissions; //admin
      } else {
        this.global.user.permission = JSON.parse(this.global.user.permission);
      }

      //如果拥有事业部管理权限，那么商品管理可录入的事业部为全部
      if (this.global.user.permission.d.a) {
        this.global.user.permission.a.d = this.global.allDepartments.map(
          (i) => i.uid
        );
      }

      //同上
      if (this.global.user.permission.e.a) {
        this.global.user.permission.a.g = this.global.allTeams.map(
          (i) => i.uid
        );
      }

      this.global.departmentIdToName = {};
      this.global.allDepartments.forEach((i) => {
        this.global.departmentIdToName[i.uid] = i.name;
      });
      this.global.teamIdToName = {};
      this.global.allTeams.forEach((i) => {
        this.global.teamIdToName[i.uid] = i.name;
      });
      this.global.categoryIdToName = {};
      this.global.allCategorys.forEach((i) => {
        this.global.categoryIdToName[i.uid] = i.name;
      });

      this.global.userIdToNick = {};
      this.global.allUsers.forEach((i) => {
        this.global.userIdToNick[i.uid] = i.nick;
      });

      console.log("登陆跳转");
      console.log(this.global);
      this.$router.push("/mainpage");
    },
  },
  created() {
    isLogin({}).then((res) => {
      console.log("isLogin");
      console.log(res);

      if (!res.data.isLogin) return;

      this.infoAlert("泼发EBC：登陆成功");

      //this.global.token = res.data.token.tokenValue
      localStorage.token = res.data.token.tokenValue;
      this.global.user = res.data.user;

      this.globalInitAndJump();
    });

    //if (window.localStorage.getItem("authenticated") === "true") {
    //  this.$router.push("/partnerget");
    //}
  },
};
</script>

<style src="./Login.scss" lang="scss"/>
