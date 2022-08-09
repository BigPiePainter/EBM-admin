<template>
  <div>
    <v-data-table
      :hide-default-footer="memberItems.length <= 10"
      :items-per-page="10"
      :footer-props="{
        'items-per-page-options': [10, 20, 50, 100],
        'items-per-page-text': '每页显示条数',
      }"
      :headers="headers"
      :items="memberItems"
    >
    </v-data-table>
  </div>
</template>

<script>
export default {
  comments: {},

  props: {
    allUsers: Array,
    allDepartments: Array,
    departmentInfo: Object,
  },

  created() {
    this.init();
  },

  data() {
    return {
      headers: [
        { text: "商品录入权限", value: "nick" },
        { text: "账号", value: "username" },
        { text: "账号下全部录入权限", value: "calculatedPermission" },
        { text: "联系方式", value: "contact" },
        { text: "备注", value: "note" },
      ],

      memberItems: [],

      userInfos: [],

      idToNick: {},
    };
  },

  methods: {
    init() {
      console.log(this.allDepartments);

      this.memberItems = this.allUsers.filter((i) => {
        var permission = JSON.parse(i.permission);
        return (
          permission.a &&
          permission.a.d &&
          permission.a.d.find((p) => p == this.departmentInfo.uid)
        );
      });

      this.memberItems.forEach((i) => {
        var permission = JSON.parse(i.permission);
        if (permission.a) {
          i.calculatedPermission = permission.a.d.map(
            (id) => this.allDepartments.find((d) => d.uid == id).name
          );
        }
      });
    },
  },
};
</script>