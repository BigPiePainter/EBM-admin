<template>
  <v-data-table
    :headers="headers"
    :items="items"
    class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>部门信息表</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="primary" dark class="mb-2" v-bind="attrs" v-on="on"
              >新部门信息</v-btn
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
                    <v-text-field
                      v-model="editedItem.department"
                      label="部门"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="editedItem.member"
                      label="成员"
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
    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
      <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
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
        text: "部门",
        align: "start",
        sortable: false,
        value: "department",
      },
      { text: "成员", value: "member" },
      { text: 'Actions', value: 'actions', sortable: false },
    ],
    items: [],
    editedIndex: -1,
    editedItem: {
      department: "",
      member: "",
    },
    defaultItem: {
      department: "",
      member: "",
    },
  }),

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "新部门信息" : "编辑部门信息";
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
          department: "1",
          member: 1,
        },
        {
          department: "2",
          member: 2,
        },
        {
          department: "3",
          member: 3,
        },
        {
          department: "4",
          member: 4,
        },
        {
          department: "5",
          member: 5,
        },
        {
          department: "6",
          member: 6,
        },
        {
          department: "7",
          member: 7,
        },
        {
          department: "8",
          member: 8,
        },
        {
          department: "9",
          member: 9,
        },
        {
          department: "0",
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

