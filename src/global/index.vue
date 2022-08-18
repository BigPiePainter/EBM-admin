<script>
import Vue from "vue";

// import { getDepartment } from "@/settings/department";
// import { getTeam } from "@/settings/team";
// import { getAllUsers } from "@/settings/user";

export default {
  name: "Global",
  token: "", //token


  log() { //方便用{{ }}测试输出
    console.log(...arguments);
  },
  infoAlert(message) {
    Vue.prototype.$toast.info(message);
  },
  errorAlert(message) {
    Vue.prototype.$toast.error(message);
  },

};
</script>