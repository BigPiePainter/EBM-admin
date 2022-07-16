<template>
  <v-menu :close-on-content-click="false" offset-y>
    <template v-slot:activator="{ on, attrs }">
      <v-btn color="indigo" dark v-bind="attrs" v-on="on"> {{ title }} </v-btn>
    </template>
    <v-card max-height="50vh"
      ><v-data-table
        :headers="header"
        :items="menu"
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
      groupList: [],
    };
  },

  created() {
    for (let i = 0; i < this.menu.length; i++) {
      this.groupList[i] = {name: this.menu[i]};
    }
  },

  methods: {
    showSelected() {
      console.log(this.selected);
    },
  },
};
</script>
