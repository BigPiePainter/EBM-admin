<template>
  <v-navigation-drawer
    app
    clipped
    v-model="DRAWER_STATE"
    :mini-variant="!DRAWER_STATE"
    :width="sidebarWidth"
    :permanent="$vuetify.breakpoint.mdAndUp"
    :temporary="$vuetify.breakpoint.smAndDown"
    :mini-variant-width="sidebarMinWidth"
    :class="{ 'drawer-mini': !DRAWER_STATE }"
  >
    <v-list>
      <template v-for="(item, i) in items">
        <v-row v-if="item.heading" :key="item.heading" align="center">
          <v-col cols="6" class="py-5">
            <span
              style="padding-left: 32px"
              class="text-body-1 subheader"
              :class="item.heading && DRAWER_STATE ? 'show ' : 'hide'"
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
          v-else-if="item.children && DRAWER_STATE"
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
      </template>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapActions, mapState } from "vuex";

export default {
  props: {
    source: String,
  },
  data() {
    return {
      items: [
        { heading: "POFA1" },
        { title: "发/退货状态", icon: "mdi-account-multiple", link: "/transport" },
        //{ title: "主页", icon: "mdi-home", link: "/dashboard" },

        {
          title: "商品管理",
          icon: "mdi-book-variant-multiple",
          link: "/partnerget",
        },
        {
          title: "订单管理",
          icon: "mdi-book-variant-multiple",
          link: "/employee",
          children: [
            {
              title: "订单",
              icon: "mdi-book-variant-multiple",
              link: "/order",
            },
          ],
        },
        {
          title: "员工管理",
          icon: "mdi-account-multiple",
          link: "/employee",
          children: [
            {
              title: "员工结构",
              icon: "mdi-account-multiple",
              link: "/employee",
            },
          ],
        },
        {
          title: "部门管理",
          icon: "mdi-account-multiple",
          link: "/department",
          children: [
            { title: "部门", icon: "mdi-circle-small", link: "/department" },
          ],
        },
        {
          title: "组别管理",
          icon: "mdi-account-multiple",
          link: "/icons",
          children: [
            {
              title: "组别",
              icon: "mdi-account-multiple",
              link: "/group",
            },
          ],
        },

        //{ title: "系统信息", icon: "mdi-bell-outline", link: "/notifications" },

        { divider: true },
        { heading: "POFA2" },
      ],
      sidebarWidth: 150,
      sidebarMinWidth: 50,
    };
  },
  computed: {
    ...mapState(["drawer"]),
    DRAWER_STATE: {
      get() {
        return this.drawer;
      },
      set(newValue) {
        if (newValue === this.drawer) return;
        this.TOGGLE_DRAWER();
      },
    },
  },
  methods: {
    ...mapActions(["TOGGLE_DRAWER"]),
  },
};
</script>

<style src="./Sidebar.scss" lang="scss" scoped/>
