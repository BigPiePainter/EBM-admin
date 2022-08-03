<script>
import Vue from "vue";

export default {
  name: "Global",
  token: "",
  log() {
    console.log(...arguments);
  },
  infoAlert(message) {
    Vue.prototype.$toast.info(message, {
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
  errorAlert(message) {
    Vue.prototype.$toast.error(message, {
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

  //所有权限
  allPermissions: ["商品管理-显示", "订单管理-显示", "下级员工管理-显示", "事业部管理-显示", "组别管理-显示"],

  user: {},
};
</script>