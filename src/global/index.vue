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
  allPermissions: ["商品管理", "订单管理", "员工管理", "事业部管理", "组别管理"],
  permissionTranslate: {
    pr: "商品管理",
    or: "订单管理",
    em: "员工管理",
    de: "事业部管理",
    gr: "组别管理",

    a: "可见",
  },

  user: {},
};
</script>