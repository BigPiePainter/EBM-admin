<template>
  <div>
    <v-data-table :headers="headers" :items="memberItems"> </v-data-table>
  </div>
</template>

<script>
export default {
  comments: {},

  props: {
    allUsers: Array,
    allTeams: Array,
    teamInfo: Object,
  },

  created() {
    this.init();
    // console.log(this.allUsers);
    // console.log(this.teamInfo);
  },

  data() {
    return {
      headers: [
        { text: "组员姓名", value: "nick" },
        { text: "账号", value: "username" },
        { text: "所属小组", value: "calculatedPermission" },
        { text: "联系方式", value: "contact" },
        { text: "备注", value: "note" },
      ],

      memberItems: [],
    };
  },
  methods: {
    init() {
      console.log(this.allTeams); 
      console.log(this.allUsers);
      this.memberItems = this.allUsers.filter((i) => {
        var permission = JSON.parse(i.permission);
        return (
          permission.a &&
          permission.a.g &&
          permission.a.g.find((p) => p == this.teamInfo.uid)
        );
      });
      this.memberItems.forEach((i) => {
        var permission = JSON.parse(i.permission);
        if (permission.a) {
          i.calculatedPermission = permission.a.g.map(
            (id) => this.allTeams.find((g) => g.uid == id).name
          );
        }
      });
    },
  },
};
</script>