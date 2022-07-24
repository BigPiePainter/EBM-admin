<template>
  <v-container fluid>
    <v-row align="center">
      <v-col cols="6">
        <v-select
          v-model="e4"
          :items="group"
          menu-props="auto"
          label="Select"
          hide-details
          single-line
          @click="show1"
        ></v-select>
      </v-col>
      <v-col cols="6">
        <v-select
          :items="department"
          v-model="e3"
          menu-props="auto"
          hide-details
          label="Select"
          single-line
          @click="show2"
        ></v-select>
      </v-col>
    </v-row>
  </v-container>
</template>


<script>
import { getClass } from "@/settings/product";
export default {
  data() {
    return {
      e3: null,
      e4: null,
      department: [],
      group:[],
    };
  },

  created(){
    this.department=[];
    this.group=[];
    getClass({})
      .then((res) => {
        this.menu = res.data;
        this.department = this.menu.department;
        this.group = this.menu.groupName;
        console.log(res.data);
      })
      .catch(() => {});
  },

  methods: {
    show1() {
      console.log(this.e4)
    },

    show2() {
      console.log(this.e3)
      console.log(this.menu)
    },
  },
};
</script>