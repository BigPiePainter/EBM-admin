<template>
  <div style="width: 800px; margin: 0 auto">
    <v-card class="products-list mb-1">
      <v-data-table
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="category"
        show-expand
        height="calc(100vh - 200px)"
        :expanded.sync="expanded"
        :loading="loading"
        :headers="categoryHeaders"
        :items="categoryItems"
        disable-sort
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>一级类目管理</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>

            <v-dialog v-model="dialog" max-width="300px">
              <!--new item buttom-->
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  small
                  depressed
                  color="primary"
                  v-bind="attrs"
                  v-on="on"
                  @click="addButton"
                >
                  新增类目
                </v-btn>
              </template>

              <v-card>
                <v-col class="px-10 pt-10">
                  <v-row>
                    <span class="text-subtitle-1">类目信息</span>
                  </v-row>
                  <v-col cols="12">
                    <span class="text-body-2 text--secondary">名称*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.category"
                      :readonly="checkReadOnly"
                    >
                    </v-text-field>
                  </v-col>

                  <v-col cols="12">
                    <span class="text-body-2 text--secondary">品类扣点*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.ratio"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12">
                    <span class="text-body-2 text--secondary">品类运费险*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.insurance"
                    ></v-text-field>
                  </v-col>
                </v-col>

                <!-- until there is dialog of new input-->
                <v-card-actions>
                  <p class="caption font-italic font-weight-thin">
                    带*为必填项目
                  </p>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="close">
                    取消
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="save"
                    :disabled="isEmp"
                  >
                    保存
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
          <v-btn
            small
            depressed
            outlined
            color="green"
            @click="editButton(item)"
            class="ml-1"
          >
            修改
          </v-btn>

          <v-btn
            small
            depressed
            outlined
            color="red lighten-2"
            @click="deleteButton"
            class="ml-1"
          >
            删除
          </v-btn>
          <v-dialog v-model="deleteDialog" max-width="190px">
            <v-card class="pl-2 pt-2">
              是否确定删除此条类目？
              <v-card-actions>
                <v-btn color="blue darken-1" text @click="deleteClose">
                  取消
                </v-btn>
                <v-btn color="blue darken-1" text @click="deleteConfirm">
                  确认
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </template>
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length">More info about {{ item.category }}</td>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import { getCategory } from "@/settings/category";
import { addCategory } from "@/settings/category";
import { editCategory } from "@/settings/category";
import { deleteCategory } from "@/settings/category";
export default {
  data() {
    return {
      dialog: false,
      deleteDialog: false,
      categoryHeaders: [
        { text: "一级类目", value: "category" },
        { text: "品类扣点", value: "ratio" },
        { text: "品类运费险", value: "insurance" },
        { text: "生效时间", value: "creatTime" },
        { text: "操作", value: "actions" },
      ],
      categoryItems: [
        { category: "1", ratio: "1111111", insurance: "1", creatTime: "11111" },
      ],
      editedItem: [],
      mode: 0,
      checkReadOnly: true,
    };
  },

  created() {
    this.loadData();
    console.log(this.categoryItems);
  },

  computed: {
    isEmp: function () {
      var check = ["category", "ratio", "insurance"];
      var pass = true;
      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false;
      });
      console.log(pass);
      return !pass;
    },
  },

  methods: {
    loadData() {
      getCategory({});
    },

//----------------------------------------------------------------------------------------
    addButton() {
      this.mode = 1;
      this.editedItem = [];
      this.checkReadOnly = false;
    },
    editButton(item) {
      this.mode = 2;
      this.editedItem = Object.assign({}, item);
      this.checkReadOnly = true;
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    save() {
      if (this.mode == 1) {
        this.add();
      } else if (this.mode == 2) {
        this.edit();
      }
    },
    add() {
      addCategory({});
      this.dialog = false;
    },
    edit() {
      editCategory({});
      this.dialog = false;
    },
//----------------------------------------------------------------------------------------
    deleteButton() {
      this.deleteDialog = true;
    },
    deleteClose() {
      this.deleteDialog = false;
    },
    deleteConfirm() {
      this.deleteDialog = false;
      this.delete();
    },
    delete() {
      deleteCategory({});
    },
  },
};
</script>