<template>
  <v-card>
    <v-card-title> 测试TEST </v-card-title>

    <v-row class="pa-4" justify="space-between">
      <v-col md="auto">
        <v-text-field
          v-model="search"
          flat
          shaped
          hide-details
          clearable
          clear-icon="mdi-close-circle-outline"
          prepend-inner-icon="mdi-magnify"
          class="pl-3 pb-3"
        >
        </v-text-field>
        <v-treeview
          :active.sync="active"
          :items="items"
          :load-children="fetchUsers"
          :open.sync="open"
          open-on-click
          open-all
          transition
          dense
          :search="search"
          :filter="filter"
        >
          <template v-slot:prepend="{ item }">
            <v-icon v-if="item.add" dense> mdi-account-plus </v-icon>
            <v-icon v-else dense> mdi-account </v-icon>
          </template>

          <template v-slot:label="{ item }">
            {{ item.name }}
            <span class="text--secondary text-left ml-10">部门A主管</span>
          </template>

          <!-- <template v-slot:append="{}">
            <v-container fluid width="300px">
              <span class="text--secondary text-left">备注... 部门A主管</span>
            </v-container>
          </template> -->
        </v-treeview>
      </v-col>

      <!-- <v-divider vertical inset></v-divider> -->

      <v-col>
        <v-scroll-y-transition mode="out-in">
          <div>
            <v-card class="pt-3" elevation="0">
              <v-card-text>
                <h6 class="black--text">张清宇</h6>
              </v-card-text>

              <v-divider></v-divider>
              <div class="mt-5 ml-5">
                <p>张清宇</p>
                <p>张清宇</p>
                <p>张清宇</p>
                <p>张清宇</p>
                <p>张清宇</p>
                <p>张清宇</p>
                <p>张清宇</p>
              </div>
            </v-card>
          </div>
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
    //搜索
    search: "",

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