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
                      v-model="editedItem.name"
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
  </v-data-table>
</template>



<script>
import { getTeam } from "@/settings/group";
import { addTeam } from "@/settings/group";
export default {
  data: () => ({
    dialog: false,
    headers: [
      {
        text: "组ID",
        align: "start",
        sortable: false,
        value: "uid",
      },
      {
        text: "组名",
        sortable: false,
        value: "name",
      },
      { text: "所属部门", value: "belong" },
      { text: "成员", value: "member" },
      { text: "创建时间", value: "createTime" },
      { text: "修改时间", value: "modifyTime" },
      { text: "备注", value: "note" },
      { text: "Actions", value: "actions", sortable: false },
    ],

    items: [],
    editedIndex: -1,
    expanded: [],

    editedItem: {
      uid: "",
      name: "",
      createTime: "",
      modifyTime: "",
      note: "",
    },

    defaultItem: {
      uid: "",
      name: "",
      createTime: "",
      modifyTime: "",
      note: "",
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
    this.initialGroup();
  },

  methods: {

    initialGroup(){
      getTeam({}).then((res) => {
      console.log(res.data.teams);
      this.items = res.data.teams;
    });
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
        addTeam({ name: this.editedItem.name, note:this.editedItem.note }).then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          console.log(this.editedItem);
          this.initialGroup();
        });
      }
      this.close();
    },
  },
};
</script>


<style src="./Group.scss" lang="scss">
</style>