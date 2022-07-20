<template>
  <v-data-table :headers="headers" :items="items" class="elevation-1">
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
        text: "uid",
        align: "start",
        sortable: false,
        value: "id",
      },
      { text: "部门", value: "name" },
      { text: "创建时间", value: "create_time" },
      { text: "修改时间", value: "modify_time" },
      { text: "备注", value: "note" },
      { text: "Actions", value: "actions", sortable: false },
    ],
    items: [],
    editedIndex: -1,
    editedItem: {
      id: "",
      name: "",
      create_time: "",
      modify_time: "",
      note: "",
    },
    defaultItem: {
      id: "",
      name: "",
      create_time: "",
      modify_time: "",
      note: "",
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
          id: "191518",
          name: "Nick",
          create_time: "2000-1-1",
          modify_time: "",
          note: "no",
        },
        {
          id: "191410",
          name: "Aaron",
          create_time: "1998-1-1",
          modify_time: "",
          note: "no",
        },
        {
          id: "191517",
          name: "Jerry",
          create_time: "2000-1-1",
          modify_time: "",
          note: "no",
        },
        {
          id: "191516",
          name: "Andrew",
          create_time: "2000-1-1",
          modify_time: "",
          note: "no",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
        },
        {
          id: "",
          name: "",
          create_time: "",
          modify_time: "",
          note: "",
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

