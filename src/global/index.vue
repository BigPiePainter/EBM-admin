<script>
import Vue from "vue";

// import { getDepartment } from "@/settings/department";
// import { getTeam } from "@/settings/team";
// import { getAllUsers } from "@/settings/user";

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
      da: true, //删除商品归属记录的权限 da-deleteAscription
      fc: true, //管理一级类目的权限 fc-firstCategory
    },
    b: {
      //订单管理模块
      a: true, //avaliable
    },
    c: {
      //下级员工管理
      a: true, //avaliable

      b: true, //查看下级员工密码的权限
    },
    d: {
      //事业部管理
      a: true, //avaliable
    },
    e: {
      //组别管理
      a: true, //avaliable
    },
  },

  user: {}, //自己

  //------------------------------------------------------------------
  //👇全局缓存的数据👇

  allDepartments: [],
  allTeams: [],
  allUsers: [],
  allCategorys: [],
  allCategoryHistorys: [],

  allShops: [
    //所有店铺, 暂时采用手动记录的方式
    "店铺A",
    "店铺B",
    "店铺C",
    "店铺D",
    "店铺E",
    "店铺F",
    "店铺G",
    "店铺H",
    "店铺I",
  ],

  userIdToNick: {},
  teamIdToName: {},
  departmentIdToName: {},
  categoryIdToName: {},
  categoryIdToInfo: {},
};
</script>