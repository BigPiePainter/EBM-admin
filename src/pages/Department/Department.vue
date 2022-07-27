<template>
  <v-data-table
    class="elevation-1 mx-5"
    fixed-header
    loading-text="加载中... 请稍后"
    no-data-text="空"
    item-key="uid"
    :expanded.sync="expanded"
    show-expand
    disable-sort
    height="calc(100vh - 257px)"
    :headers="headers"
    :items="items"
    :loading="loading"
    :server-items-length="totalProducts"
    :options.sync="options"
    :items-per-page="50"
    :footer-props="{
      'items-per-page-options': [10, 20, 50, 100],
      'items-per-page-text': '每页显示条数',
    }"
    @click:row="clickRow"
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
                    <span class="text-body-2 text--secondary">部门</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.name"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">负责人</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.manager"
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
      <td :colspan="headers.length">More info about {{ item.name }}</td>
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
import { getDepartment } from "@/settings/department";
import { addDepartment } from "@/settings/department";
export default {
  data: () => ({
    dialog: false,
    headers: [
      {
        text: "编号",
        align: "start",
        sortable: false,
        value: "uid",
      },
      { text: "事业部名称", value: "name" },
      { text: "负责人", value: "manager" },
      { text: "人数", value: "a" },
      { text: "组成", value: "c" },
      { text: "创建时间", value: "create_time" },
      { text: "修改时间", value: "modify_time" },
      { text: "备注", value: "note" },
      { text: "Actions", value: "actions", sortable: false },
    ],
    items: [],
    expanded: [],
    editedIndex: -1,
    editedItem: {
      uid: "",
      name: "",
      manager: "",
      b: "",
      c: "",
      create_time: "",
      modify_time: "",
      note: "",
    },
    defaultItem: {
      uid: "",
      name: "",
      manager: "",
      b: "",
      c: "",
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
      getDepartment({})
      .then((res) => {
      console.log(res.data.department);
      // this.items = res.data.department;
    });
    },

    clickRow() {},

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
       addDepartment({ name: this.editedItem.name, note:this.editedItem.note }).then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          console.log(this.editedItem);
          this.initialize();
       });
      }
      this.close();
    },
  },
};
</script>

