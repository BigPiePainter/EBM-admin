<template>
  <!-- <div v-if="!drawerState" style="position: absolute; bottom: 7px; left: 16px; z-index:9999">
      <v-btn fab small @click="drawerState = true">
        <v-icon small> mdi-menu </v-icon>
      </v-btn>
    </div> -->
  <v-navigation-drawer
    app
    clipped
    v-model="drawerState"
    :width="sidebarWidth"
    :temporary="$vuetify.breakpoint.smAndDown"
    :mini-variant-width="sidebarMinWidth"
  >
    <div class="navigation-content d-flex flex-column">
      <v-btn tile depressed color="white" class="sider-block">
        <span class="text-body-1">泼发 EBC</span>
      </v-btn>
      <v-divider></v-divider>
      <v-list class="flex-grow-1 overflow-y-auto overflow-x-hidden" dense>
        <template v-for="(item, i) in items">
          <div :key="item.heading">
            <v-row v-if="item.heading" align="center">
              <v-col cols="6" class="py-5">
                <span
                  class="pl-8 text-body-1 subheader"
                  :class="item.heading ? 'show ' : 'hide'"
                >
                  {{ item.heading }}
                </span>
              </v-col>
              <v-col cols="6" class="text-center"> </v-col>
            </v-row>

            <v-divider
              v-else-if="item.divider"
              :key="i"
              dark
              class="my-4"
            ></v-divider>

            <v-list-group
              v-else-if="item.children"
              color="primary"
              :key="item.title"
              v-model="item.model"
              append-icon=""
            >
              <template v-slot:activator>
                <v-list-item-action>
                  <v-icon dense>{{ item.icon }}</v-icon>
                </v-list-item-action>
                <v-list-item-content>
                  <v-list-item-title link>
                    {{ item.title }}
                  </v-list-item-title>
                </v-list-item-content>
              </template>

              <v-list-item
                v-for="(child, i) in item.children"
                :key="i"
                :disabled="!item.show"
                :to="child.link"
                link
              >
                <v-list-item-action>
                  <v-icon dense>{{ child.icon }}</v-icon>
                </v-list-item-action>
                <v-list-item-content>
                  <v-list-item-title link>
                    {{ child.title }}
                  </v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list-group>

            <v-list-item
              color="primary"
              v-else
              :disabled="!item.show"
              :key="item.text"
              :href="item.href ? item.href : null"
              :to="item.link === '#' ? null : item.link"
              link
            >
              <v-list-item-action>
                <v-icon dense>{{ item.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title link>
                  {{ item.title }}
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </div>
        </template>
      </v-list>
      <v-divider></v-divider>
      <v-btn
        depressed
        tile
        class="sider-block d-flex align-center"
        color="white"
        @click.stop=!sideBarRight
      >
        <span class="text-body-2 grey--text"> 更新日志 </span>
      </v-btn>
      <v-divider></v-divider>

      <div class="sider-block d-flex align-center pl-4">
        <v-btn icon @click="drawerState = !drawerState">
          <v-icon small> mdi-arrow-collapse-left </v-icon>
        </v-btn>
      </div>
    </div>
  </v-navigation-drawer>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  props: {
    source: String,
  },
  data() {
    return {
      sideBarRight: false,
      items: [
        {
          title: "主页",
          icon: "mdi-home",
          link: "/mainpage",
          show: true,
        },
        {
          title: "商品管理",
          icon: "mdi-package-variant-closed",
          link: "/partnerget",
          show: this.$store.state.user.permission.a.a,
          children: [
            {
              title: "商品清单",
              icon: "mdi-circle-small",
              link: "/partnerget",
            },
            {
              title: "认领大厅",
              icon: "mdi-circle-small",
              link: "/mismatchProducts",
            },
            {
              title: "已下架商品",
              icon: "mdi-circle-small",
              link: "/deletedProducts",
            },
            {
              title: "类目/店铺",
              icon: "mdi-circle-small",
              link: "/category",
            },
          ],
        },

        {
          title: "订单管理",
          icon: "mdi-reorder-horizontal",
          link: "/input",
          show: this.$store.state.user.permission.b.a,
          children: [
            {
              title: "导入",
              icon: "mdi-circle-small",
              link: "/input",
            },
            {
              title: "订单",
              icon: "mdi-circle-small",
              link: "/order",
            },
            {
              title: "未完结退单",
              icon: "mdi-circle-small",
              link: "/return",
            },
            {
              title: "未匹配团队补单",
              icon: "mdi-circle-small",
              link: "/brush",
            },
            {
              title: "未匹配个人补单",
              icon: "mdi-circle-small",
              link: "/individualbrush",
            },
            // {
            //   title: "发退货",
            //   icon: "mdi-circle-small",
            //   link: "/brush",
            // },
          ],
        },

        {
          title: "利润报表",
          icon: "mdi-chart-areaspline",
          link: "/profitChart",
          show: true,
          children: [
            // {
            //   title: "xxxx",
            //   icon: "mdi-circle-small",
            //   link: "/dashboard",
            // },
            {
              title: "统计图",
              icon: "mdi-circle-small",
              link: "/profitChart",
            },
            {
              title: "利润报表",
              icon: "mdi-circle-small",
              link: "/profitTable",
            },
          ],
        },

        {
          title: "财务",
          icon: "mdi-cash",
          link: "/economy",
          show: true,
        },

        //{ title: "系统信息", icon: "mdi-bell-outline", link: "/notifications" },

        { divider: true },
        // { heading: "POFA2" },

        {
          title: "组别管理",
          icon: "mdi-account-group",
          link: "/team",
          show: this.$store.state.user.permission.e.a,
          children: [
            {
              title: "组别",
              icon: "mdi-circle-small",
              link: "/team",
            },
          ],
        },

        {
          title: "部门管理",
          icon: "mdi-domain",
          link: "/department",
          show: this.$store.state.user.permission.d.a,
          children: [
            { title: "部门", icon: "mdi-circle-small", link: "/department" },
          ],
        },

        {
          title: "员工管理",
          icon: "mdi-account-multiple",
          link: "/employee",
          show: this.$store.state.user.permission.c.a,
          children: [
            {
              title: "从属员工",
              icon: "mdi-circle-small",
              link: "/all_employees",
            },
            {
              title: "员工结构",
              icon: "mdi-circle-small",
              link: "/employee",
            },
          ],
        },

        { divider: true },
        
        {
          title: "实用工具",
          icon: "mdi-tools",
          show: true,
          children: [
            {
              title: "sku盗取",
              icon: "mdi-circle-small",
              link: "/skuhaker",
            },
            {
              title: "商品同步",
              icon: "mdi-circle-small",
              link: "/productcopy",
            },
          ],
        },
      ],
      sidebarWidth: 170,
      sidebarMinWidth: 50,
    };
  },
  computed: {
    ...mapState(["drawer"]),
    drawerState: {
      get() {
        return this.drawer;
      },
      set(newValue) {
        this.setDrawer(newValue);
      },
    },
  },
  methods: {
    ...mapMutations(["setDrawer"]),
  },
};
</script>

<style src="./Sidebar.scss" lang="scss"/>
