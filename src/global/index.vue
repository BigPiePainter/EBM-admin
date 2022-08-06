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

  //所有权限-模板
  allPermissions: {
    a: {
      //商品管理模块
      a: true, //avaliable
      d: [], //可录入的事业部     如果拥有事业部管理权限，那么可录入的事业部为全部
      g: [], //可录入的组别       同上
    },
    b: {
      a: true, //avaliable
      //订单管理模块
    },
    c: {
      a: true, //avaliable
      //下级员工管理
    },
    d: {
      a: true, //avaliable
      //事业部管理
    },
    e: {
      a: true, //avaliable
      //组别管理

    },
  },

  user: {},
};
</script>