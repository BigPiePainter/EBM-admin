<template>
  <v-navigation-drawer
    app
    clipped
    v-model="drawerState"
    :mini-variant="!drawerState"
    :width="sidebarWidth"
    :permanent="$vuetify.breakpoint.mdAndUp"
    :temporary="$vuetify.breakpoint.smAndDown"
    :mini-variant-width="sidebarMinWidth"
    :class="{ 'drawer-mini': !drawerState }"
  >
    <v-list>
      <template v-for="(item, i) in items">
        <div :key="item.heading">
          <v-row v-if="item.heading" align="center">
            <v-col cols="6" class="py-5">
              <span
                style="padding-left: 32px"
                class="text-body-1 subheader"
                :class="item.heading && drawerState ? 'show ' : 'hide'"
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
            v-else-if="item.children && drawerState"
            color="primary"
            :key="item.title"
            v-model="item.model"
            append-icon=""
          >
            <template v-slot:activator>
              <v-list-item-action>
                <v-icon dense :color="item.color ? item.color : ''">{{
                  item.icon
                }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title class="grey--text" link>
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
                <v-icon dense :color="child.color ? child.color : ''">{{
                  child.icon
                }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title class="grey--text" link>
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
              <v-icon dense :color="item.color ? item.color : ''">{{
                item.icon
              }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title class="grey--text" link>
                {{ item.title }}
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </div>
      </template>
    </v-list>
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
      items: [
        { heading: "POFA1" },
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
              title: "一级类目",
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
              title: "未匹配退单",
              icon: "mdi-circle-small",
              link: "/return",
            },
            {
              title: "未匹配补单",
              icon: "mdi-circle-small",
              link: "/brush",
            },
            {
              title: "发退货",
              icon: "mdi-circle-small",
              link: "/brush",
            },
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

        //{ title: "系统信息", icon: "mdi-bell-outline", link: "/notifications" },

        { divider: true },
        { heading: "POFA2" },

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
      ],
      sidebarWidth: 150,
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
