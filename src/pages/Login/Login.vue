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
                  <v-tab :href="`#tab-login`" loading> 登录 </v-tab>

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
                                登录</v-btn
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

import { mapActions, mapMutations } from "vuex";

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

      done: [false, false, false, false, true], //全部请求状态
    };
  },
  methods: {
    ...mapMutations(["setToken", "setUser"]),
    ...mapActions([
      "refreshAllDepartment",
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
      this.refreshAllDepartment();
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
};
</script>

<style src="./Login.scss" lang="scss"/>
