<template>
  <div style="width: 800px; margin: 0 auto">
    <v-card class="products-list mb-1">
      <v-data-table
        :headers="categoryHeaders"
        :items="categoryItems"
        disable-sort
        @click:row="clickRow"
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
                  @click="addMode"
                >
                  新增类目
                </v-btn>
              </template>

              <v-card>
                <v-col class="px-10 pt-10">
                  <v-row>
                    <span class="text-subtitle-1">类目信息</span>
                  </v-row>
                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">名称*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.category"
                    >
                    </v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">品类扣点*</span>
                    <v-text-field
                      outlined
                      dense
                      hide-details
                      v-model="editedItem.rate"
                    ></v-text-field>
                  </v-col>

                  <v-col cols="12" sm="6" md="4">
                    <span class="text-body-2 text--secondary">品类运费险*</span>
                    <v-select
                      outlined
                      dense
                      v-model="editedItem.insurance"
                      hide-details
                      single-line
                    ></v-select>
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
        </template></v-data-table
      >
    </v-card>
  </div>
</template>

<script>
import { getCategory } from "@/settings/category";
export default {
  data() {
    return {
      categoryHeaders: [
        { text: "一级类目", value: "category" },
        { text: "品类扣点", valeu: "rate" },
        { text: "品类运费险", value: "insurance" },
        { text: "生效时间", valie: "creatTime" },
      ],
      categoryItems: [],
      editedItem:[],
    };
  },

  created() {
    this.loadData();
  },

  computed: {
    isEmp: function () {
      var check = [
        "category",
        "rate",
        "insurance",
      ]

      var pass = true;
      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false
      })

      console.log(pass)

      return !pass;
    }
  },

  methods: {
    loadData() {
      getCategory({});
    },

    clickRow() {},

    addMode() {},
  },
};
</script>