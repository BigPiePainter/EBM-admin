<template>
  <v-data-table
    show-expand
    item-key="group"
    :expanded.sync="expanded"
    :headers="headers"
    :items="items"
    class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>组别信息表</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="primary" dark class="mb-2" v-bind="attrs" v-on="on"
              >新组别信息</v-btn
            >
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">组名</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.group"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">备注</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.note"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">取消</v-btn>
              <v-btn color="blue darken-1" text @click="save">保存</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>

    <template v-slot:expanded-item="{ headers, item }">
      <td :colspan="headers.length">More info about {{ item.group }}</td>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-btn
        small
        depressed
        outlined
        color="green"
        @click="editItem(item)"
        class="ml-1"
      >
        修改
      </v-btn>
      <v-btn
        small
        depressed
        outlined
        color="red lighten-2"
        @click="deleteProduct(item)"
        class="ml-1"
      >
        删除
      </v-btn>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>
  </v-data-table>
</template>



<script>
export default {
  data: () => ({
    dialog: false,
    headers: [
      {
        text: "组名",
        align: "start",
        sortable: false,
        value: "group",
      },
      { text: "所属部门", value: "belong" },
      { text: "成员", value: "member" },
      { text: "备注", value: "note" },
      { text: "Actions", value: "actions", sortable: false },
    ],

    items: [],
    editedIndex: -1,
    expanded: [],

    editedItem: {
      group: "",
      belong: "",
      note: "",
      member: "",
    },

    defaultItem: {
      group: "",
      belong: "",
      note: "",
      member: "",
    },
  }),

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "新组别信息" : "编辑组别信息";
    },
  },

  watch: {
    dialog(val) {
      val || this.close();
    },
  },

  created() {
    this.initialize();
  },

  methods: {
    initialize() {
      this.items = [
        {
          group: "1",
          belong: "",
          note: "",
          member: 1,
        },
        {
          group: "2",
          belong: "",
          note: "",
          member: 2,
        },
        {
          group: "3",
          belong: "",
          note: "",
          member: 3,
        },
        {
          group: "4",
          belong: "",
          note: "",
          member: 4,
        },
        {
          group: "5",
          belong: "",
          note: "",
          member: 5,
        },
        {
          group: "6",
          belong: "",
          note: "",
          member: 6,
        },
        {
          group: "7",
          belong: "",
          note: "",
          member: 7,
        },
        {
          group: "8",
          belong: "",
          note: "",
          member: 8,
        },
        {
          group: "9",
          belong: "",
          note: "",
          member: 9,
        },
        {
          group: "0",
          belong: "",
          note: "",
          member: 0,
        },
      ];
    },

    editItem(item) {
      this.editedIndex = this.items.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },

    deleteItem(item) {
      const index = this.items.indexOf(item);
      confirm("是否确定删除数据?") && this.items.splice(index, 1);
    },

    close() {
      this.dialog = false;
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      });
    },

    save() {
      if (this.editedIndex > -1) {
        Object.assign(this.items[this.editedIndex], this.editedItem);
      } else {
        this.items.push(this.editedItem);
      }
      this.close();
    },
  },
};
</script>


<style src="./Group.scss" lang="scss">
</style>