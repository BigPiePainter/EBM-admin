import Vue from 'vue';
import Vuex from 'vuex';

import { getDepartment } from "@/settings/department";
import { getTeam } from "@/settings/team";
import { getAllUsers } from "@/settings/user";
import { getCategory } from "@/settings/category";
import { getHistoryCategory } from "@/settings/category";

Vue.use(Vuex);

const store = new Vuex.Store({

  namespace: true,

  state: {
    drawer: true,  //sidebar状态

    user: {}, //自己
    token: "", //token

    allDepartments: [],
    allTeams: [],
    allUsers: [],
    allCategorys: [],
    allCategoryHistorys: [],
    allShops: [
      "方军",
      "利成",
      "鑫颂",
      "煊童",
      "天岑",
      "莲达",
      "聚瀚",
      "达赛斯",
      "一谦",
      "啦梦",
      "精英",
      "途旅",
      "万庄",
      "倍强",
      "心悦",
      "艾依（赦夏）",
      "俱佳",
      "静发",
      "阿伦歌",
      "陌枫",
      "嘉元",
      "辰琦（昶卿）",
      "至绚",
      "商周",
      "廷昊",
      "恒秋",
      "久秋",
      "霍克",
      "爱与家",
      "扩音",
      "六云",
      "媛茜",
      "辰行",
      "问福",
      "双卓",
      "依夏",
      "奇农",
      "宁锦",
      "简约",
      "问世",
      "虹柯",
      "何意",
      "瑞恋",
      "致泓",
      "欧垭",
      "犷劲",
      "垭励",
      "依冬",
      "半亩田",
      "昊办",
    ],

    userIdToNick: {},
    teamIdToName: {},
    departmentIdToName: {},
    departmentIdToInfo: {},
    categoryIdToName: {},
    categoryIdToInfo: {},


    //所有权限-模板
    allPermissions: {
      a: {
        //商品管理模块
        a: true, //avaliable
        d: [], //可录入的部门     如果拥有部门管理权限，那么可录入的部门为全部
        g: [], //可录入的组别       同上
        da: true, //删除商品归属记录的权限 da-deleteAscription
        fc: true, //管理一级类目的权限 fc-firstCategory
        dp: true, //彻底删除商品的权限
      },
      b: {
        //订单管理模块
        a: true, //avaliable
      },
      c: {
        //员工管理
        a: true, //avaliable
        b: true, //查看员工密码的权限

        d: [], //可管理的部门     如果拥有部门管理权限，那么可管理的部门为全部
      },
      d: {
        //部门管理
        a: true, //avaliable
      },
      e: {
        //组别管理
        a: true, //avaliable
      },
    },

  },

  mutations: {
    setDrawer(state, data) {
      state.drawer = data;
    },
    setUser(state, data) {
      state.user = data;
      if (state.user.uid == 1) {
        state.user.permission = state.allPermissions; //admin
      } else {
        state.user.permission = JSON.parse(state.user.permission);
      }
      //如果拥有部门管理权限，那么商品管理可录入的部门为全部
      if (state.user.permission.d.a) {
        state.user.permission.a.d = state.allDepartments.map(
          (i) => i.uid
        );
        //员工管理同理
        state.user.permission.c.d = state.allDepartments.map(
          (i) => i.uid
        );
      }
      //同上
      if (state.user.permission.e.a) {
        state.user.permission.a.g = state.allTeams.map(
          (i) => i.uid
        );
      }
    },
    setToken(state, data) {
      state.token = data;
      localStorage.token = data;
    },
    setAllDepartment(state, data) {
      state.allDepartments = data;
      state.departmentIdToName = {};
      state.departmentIdToInfo = {};
      state.allDepartments.forEach((i) => {
        state.departmentIdToName[i.uid] = i.name;
        state.departmentIdToInfo[i.uid] = i;
      });
      if (state.user.permission.d.a) {
        state.user.permission.a.d = state.allDepartments.map(
          (i) => i.uid
        );
        state.user.permission.c.d = state.allDepartments.map(
          (i) => i.uid
        );
      }
    },
    setAllTeams(state, data) {
      state.allTeams = data;
      state.teamIdToName = {};
      state.allTeams.forEach((i) => {
        state.teamIdToName[i.uid] = i.name;
      });
      if (state.user.permission.e.a) {
        state.user.permission.a.g = state.allTeams.map(
          (i) => i.uid
        );
      }
    },
    setAllUsers(state, data) {
      state.allUsers = data;
      state.userIdToNick = {};
      state.allUsers.forEach((i) => {
        state.userIdToNick[i.uid] = i.nick;
      });
    },
    setAllCategorys(state, datas) {
      state.allCategorys = datas.categorys;
      state.allCategoryHistorys = datas.categoryHistorys;

      state.categoryIdToName = {};
      state.categoryIdToInfo = {};
      state.allCategorys.forEach((i) => {
        state.categoryIdToName[i.uid] = i.name;
        state.categoryIdToInfo[i.uid] = {
          startTime: -1,
          createTime: -1,
          deduction: "空",
          insurance: "空",
        };
      });
      state.allCategoryHistorys.forEach((i) => {
        if (
          i.startTime > state.categoryIdToInfo[i.categoryId].startTime
        ) {
          state.categoryIdToInfo[i.categoryId] = i;
        } else if (
          i.startTime == state.categoryIdToInfo[i.categoryId].startTime
        ) {
          if (
            i.createTime > state.categoryIdToInfo[i.categoryId].createTime
          ) {
            state.categoryIdToInfo[i.categoryId] = i;
          }
        }
      });
    },

  },
  actions: {
    refreshAllDepartments({ commit }) {
      return new Promise((resolve, reject) => {
        getDepartment({}).then((res) => {
          commit('setAllDepartment', res.data.departments);
        }).then(resolve)
          .catch(() => {
            reject()
          });
      });
    },
    refreshAllTeams({ commit }) {
      return new Promise((resolve, reject) => {
        getTeam({}).then((res) => {
          commit('setAllTeams', res.data.teams);
        }).then(resolve)
          .catch(() => {
            reject()
          });
      });
    },
    refreshAllUsers({ commit }) {
      return new Promise((resolve, reject) => {
        getAllUsers({}).then((res) => {
          commit('setAllUsers', res.data.userInfos);
        }).then(resolve)
          .catch(() => {
            reject()
          });
      });
    },
    refreshAllCategorys({ commit }) {
      return new Promise((resolve, reject) => {
        Promise.all([
          getCategory({}),
          getHistoryCategory({})
        ]).then((res) => {
          console.log("结束了11")
          console.log(res);
          commit('setAllCategorys', { categorys: res[0].data.categorys, categoryHistorys: res[1].data.categoryHistorys });
          resolve()
        }).catch(reject);
      });
    },
  },
  getters: {
    DRAWER_STATE(state) {
      return state.drawer;
    }
  }
});

Vue.prototype.store = store;

export default store;
