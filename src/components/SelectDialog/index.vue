<template>
  <v-card max-height="50vh" class="select-menu"
    ><v-data-table
      height="300px"
      :headers="[{ text: '', value: 'name' }]"
      :items="groupList"
      hide-default-footer
      hide-default-header
      item-key="name"
      show-select
      v-model="selected"
      :items-per-page="1000"
    >
    </v-data-table
  ></v-card>
</template>


<script>
export default {
  props: {
    title: String,
    menu: Object,
    name: String,
  },
  data() {
    return {
      refresh: false,
      selected: [],
      timer: null,
    };
  },

  watch: {
    selected() {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => {
        this.sendSelect();
      }, 500);
    },
  },

  computed: {
    groupList() {
      if (!this.menu) return [];

      var list = [];
      for (let i = 0; i < this.menu[this.name].length; i++) {
        list[i] = { name: this.menu[this.name][i] };
      }
      return list;
    },
  },

  methods: {
    sendSelect() {
      //(value)
      this.$emit("sendSelectData", {
        select: {
          key: this.name,
          value: this.selected.map((i) => i.name),
          list: this.groupList,
        },
      });
    },
  },
};
</script>


<style lang="scss">
.select-menu {
  .v-data-table {
    td:nth-child(1) {
      padding-right: 0px !important;
    }
    td:nth-child(2) {
      padding-left: 3px !important;
    }
  }
}
</style>

