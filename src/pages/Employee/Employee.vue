<template>
  <v-card>
    <v-row class="pa-4" justify="space-between">
      <v-col cols="5">
        <v-treeview
          :active.sync="active"
          :items="items"
          :load-children="fetchUsers"
          :open.sync="open"
          open-on-click
          open-all
          transition
          dense
        >
          <template v-slot:prepend="{ item }">
            <v-icon v-if="item.add" dense> mdi-account-plus </v-icon>
            <v-icon v-else dense> mdi-account </v-icon>
          </template>

          <template v-slot:append="{}">
            <v-container fluid width="300px">
              <span class="text--secondary text-left">备注... 部门A主管</span>
            </v-container>
          </template>
        </v-treeview>
      </v-col>

      <v-divider vertical></v-divider>

      <v-col class="d-flex text-center">
        <v-scroll-y-transition mode="out-in">
          <div
            v-if="!selected"
            class="text-h6 grey--text text--lighten-1 font-weight-light"
            style="align-self: center"
          >
            aaaaa
          </div>
          <v-card
            v-else
            :key="selected.id"
            class="pt-6 mx-auto"
            flat
            max-width="400"
          >
            <v-card-text>
              <v-avatar v-if="avatar" size="88">
                <v-img
                  :src="`https://avataaars.io/${avatar}`"
                  class="mb-6"
                ></v-img>
              </v-avatar>
              <h3 class="text-h5 mb-2">
                {{ selected.name }}
              </h3>
              <div class="blue--text mb-2">
                {{ selected.email }}
              </div>
              <div class="blue--text subheading font-weight-bold">
                {{ selected.username }}
              </div>
            </v-card-text>
            <v-divider></v-divider>
            <v-row class="text-left" tag="v-card-text">
              <v-col class="text-right mr-4 mb-2" tag="strong" cols="5">
                Company:
              </v-col>
              <v-col>{{ selected.company.name }}</v-col>
              <v-col class="text-right mr-4 mb-2" tag="strong" cols="5">
                Website:
              </v-col>
              <v-col>
                <a :href="`//${selected.website}`" target="_blank">{{
                  selected.website
                }}</a>
              </v-col>
              <v-col class="text-right mr-4 mb-2" tag="strong" cols="5">
                Phone:
              </v-col>
              <v-col>{{ selected.phone }}</v-col>
            </v-row>
          </v-card>
        </v-scroll-y-transition>
      </v-col>
    </v-row>
  </v-card>
</template>







<script>
//import * as XLSX from 'xlsx/xlsx.mjs';

export default {
  components: {},
  data: () => ({
    active: [],
    avatar: null,
    open: [],
    users: [],
    items: [
      {
        id: 5,
        name: "Admin",
        children: [
          {
            id: 6,
            name: "张清宇",
            children: [
              {
                id: 7,
                name: "张三",
                children: [
                  { id: 8, name: "张清宇 2" },
                  { id: 9, name: "王绿原 2" },
                  {
                    id: 11,
                    name: "王绿原",
                    children: [
                      {
                        id: 12,
                        name: "张四",
                        children: [
                          {
                            id: 13,
                            name: "张三",
                            children: [
                              { id: 14, name: "张清宇 2" },
                              { id: 15, name: "王绿原 2" },
                              {
                                id: 16,
                                name: "王绿原",
                                children: [
                                  {
                                    id: 17,
                                    name: "张四",
                                    children: [
                                      {
                                        id: 11,
                                        name: "王绿原",
                                        children: [
                                          {
                                            id: 12,
                                            name: "张四",
                                            children: [
                                              {
                                                id: 13,
                                                name: "张三",
                                                children: [
                                                  { id: 14, name: "张清宇 2" },
                                                  { id: 15, name: "王绿原 2" },
                                                  {
                                                    id: 16,
                                                    name: "王绿原",
                                                    children: [
                                                      {
                                                        id: 17,
                                                        name: "张四",
                                                        children: [
                                                          {
                                                            id: 13,
                                                            name: "张清宇 3",
                                                          },
                                                        ],
                                                      },
                                                    ],
                                                  },
                                                ],
                                              },
                                            ],
                                          },
                                        ],
                                      },
                                    ],
                                  },
                                ],
                              },
                            ],
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
            ],
          },
          {
            id: 10,
            name: "王绿原",
            children: [
              {
                id: 11,
                name: "张四",
                children: [
                  { id: 12, name: "张清宇 3" },
                  { id: 13, name: "张清宇 4" },
                  { id: 14, name: "王绿原 3" },
                ],
              },
            ],
          },
        ],
      },
    ],
  }),

  computed: {},

  watch: {},

  created() {
    this.addNewButton();
  },

  methods: {
    addNewButton() {
      console.log(this.items);
      //this._addNewButton(this.items[0]);
    },

    _addNewButton(item) {
      for (let subItem of item.children) {
        console.log(subItem);
        console.log(subItem.name);
        if (subItem.children) {
          this._addNewButton(subItem);
          subItem.children.unshift({
            id: subItem.id + 1000000,
            name: "添加新员工",
            add: true,
            children: [],
          });
        }
      }
    },
  },
};
</script>

<style src="./Employee.scss" lang="scss">
</style>