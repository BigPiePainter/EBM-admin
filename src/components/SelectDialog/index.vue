<template>
  <v-menu :close-on-content-click="false" offset-y>
    <template v-slot:activator="{ on, attrs }">
      <v-btn
        color="indigo"
        class="ml-15"
        width="40"
        height="28"
        dark
        v-bind="attrs"
        v-on="on"
      >
        {{ title }}
      </v-btn>
    </template>
    <v-card max-height="50vh" class="select-menu"
      ><v-data-table
        :headers="[{ text: '', value: 'name' }]"
        :items="groupList"
        hide-default-footer
        hide-default-header
        item-key="name"
        show-select
        v-model="selected"
        :items-per-page="1000"
        @click:row="showSelected"
      >
      </v-data-table
    ></v-card>
  </v-menu>
</template>


<script>
export default {
  props: {
    title: String,
    menu: Array,
    header: Array,
  },
  data() {
    return {
      selected: [],
    };
  },

  created() {},

  watch:{

   // refresh(value){

    //},
  },

  computed: {
    groupList() {
      var list = [];
      if (!this.menu) return [];
      for (let i = 0; i < this.menu.length; i++) {
        list[i] = { name: this.menu[i] };
      }
      return list;
    },
  },

  methods: {
    showSelected() {
      console.log(this.selected);
    },
  },
};
</script>


<style lang="scss">
.select-menu {
  .v-data-table {
    td:nth-child(1) {
      padding-right: 0px !important;
      //padding-left: 0px !important;
    }
    td:nth-child(2) {
      //padding-right: 0px !important;
      padding-left: 3px !important;
    }
  }
}
</style>

