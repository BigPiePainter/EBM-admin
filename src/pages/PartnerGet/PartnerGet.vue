<template>
  <div>
    <v-card class="products-list mb-1">
      <v-data-table
        single-expand
        show-expand
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="id"
        disable-sort
        class="elevation-1"
        height="calc(100vh - 200px)"
        :loading="loading"
        :headers="headers"
        :items="products"
        :expanded.sync="expanded"
        :server-items-length="totalProducts"
        :options.sync="options"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100],
          'items-per-page-text': '每页显示条数',
        }"
        @click:row="clickRow"
      >
        <template
          v-for="header in headersContent"
          v-slot:[`header.${header.value}`]="props"
        >
          <v-edit-dialog :key="header.value" @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span class=""> {{ props.header.text }} </span>
                <v-text-field
                  color="blue-grey lighten-1"
                  v-model="search.search[props.header.value]"
                  single-line
                  counter
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="sub-table pa-0">
            <div class="sub-table-container elevation-20 ml-2 mb-3">
              <SkuTable :productInfo="item" />
            </div>
          </td>
        </template>

        <template v-slot:[`item.owner`]="{ item }">
          {{
            subUsers.find((i) => i.uid == item.owner)
              ? subUsers.find((i) => i.uid == item.owner).nick
              : "..."
          }}
        </template>

        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>商品清单</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <span class="grey--text body-2 overflow-y-auto">{{
              searchPreview
            }}</span>

            <v-spacer></v-spacer>

            <v-dialog v-model="dialog" max-width="550px">
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
                  新增商品信息
                </v-btn>
              </template>

              <v-card>
                <v-col class="px-10 pt-10 product-dialog">
                  <v-row>
                    <span class="text-subtitle-1">商品信息</span>
                  </v-row>
                  <v-row>
                    <v-col cols="5">
                      <span class="text-body-2 text--secondary">商品ID*</span>
                      <v-text-field
                        color="blue-grey lighten-1"
                        :readonly="checkReadOnly"
                        outlined
                        dense
                        hide-details
                        v-model="editedItem.id"
                      >
                      </v-text-field>
                    </v-col>

                    <v-col cols="7">
                      <span class="text-body-2 text--secondary">商品名*</span>
                      <v-text-field
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        hide-details
                        v-model="editedItem.productName"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="7">
                      <span class="text-body-2 text--secondary">一级类目*</span>
                      <v-combobox
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        hide-details
                        :items="menu.firstCategory"
                        v-model="editedItem.firstCategory"
                      ></v-combobox>
                    </v-col>
                    <v-col cols="5">
                      <span class="text-body-2 text--secondary">店铺名*</span>
                      <v-combobox
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        hide-details
                        :items="menu.shopName"
                        v-model="editedItem.shopName"
                      ></v-combobox>
                    </v-col>
                  </v-row>
                  <v-divider class="my-8" />
                  <v-row>
                    <span class="text-subtitle-1">内部归属</span>
                  </v-row>
                  <v-row>
                    <v-col cols="5">
                      <span class="text-body-2 text--secondary">事业部*</span>
                      <v-autocomplete
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        :items="
                          allDepartment.filter((d) =>
                            global.user.permission.a.d.find((i) => i == d.uid)
                          )
                        "
                        no-data-text="无"
                        v-model="editedItem.department"
                        menu-props="auto"
                        hide-details
                        single-line
                        item-text="name"
                        item-value="uid"
                      ></v-autocomplete>
                    </v-col>

                    <v-col cols="4">
                      <span class="text-body-2 text--secondary">组别*</span>
                      <v-autocomplete
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        v-model="editedItem.groupName"
                        :items="
                          allGroup.filter((g) =>
                            global.user.permission.a.g.find((i) => i == g.uid)
                          )
                        "
                        no-data-text="无"
                        menu-props="auto"
                        hide-details
                        item-text="name"
                        item-value="uid"
                        single-line
                      ></v-autocomplete>
                    </v-col>

                    <v-col cols="3">
                      <span class="text-body-2 text--secondary">持品人*</span>
                      <v-autocomplete
                        outlined
                        dense
                        color="blue-grey lighten-1"
                        v-model="editedItem.owner"
                        :items="subUsers"
                        no-data-text="无"
                        menu-props="auto"
                        hide-details
                        single-line
                        item-text="nick"
                        item-value="uid"
                      ></v-autocomplete>
                    </v-col>
                  </v-row>
                  <v-divider class="my-8" />
                  <v-row>
                    <v-col cols="4">
                      <span class="text-body-2 text--secondary">发货方式</span>
                      <v-text-field
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        hide-details
                        v-model="editedItem.transportWay"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="8">
                      <span class="text-body-2 text--secondary"
                        >聚水潭仓库</span
                      >
                      <v-text-field
                        color="blue-grey lighten-1"
                        outlined
                        dense
                        hide-details
                        v-model="editedItem.storehouse"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row></v-row>
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
            @click.stop="editItem(item)"
            class="ml-1"
          >
            修改
          </v-btn>

          <v-btn
            small
            depressed
            outlined
            color="red lighten-2"
            @click.stop="deleteProduct(item)"
            class="ml-1"
          >
            删除
          </v-btn>
        </template>
      </v-data-table>
    </v-card>

    <!-- 删除Dialog -->
    <v-dialog v-model="deleteDialog" max-width="450px">
      <v-card class="delete-dialog">
        <v-card-title class="text-subtitle-1"
          >{{ deleteItem.productName }}
          <span class="text--secondary text-body-2 ml-5 mt-1">
            同时删除SKU与厂家信息
          </span>
        </v-card-title>

        <div class="delete-table-container mt-2 mb-1">
          <v-data-table
            :headers="[
              { align: 'start', value: 'key' },
              { align: 'start', value: 'value' },
            ]"
            :items="deleteItemParse"
            hide-default-footer
            hide-default-header
            disable-sort
          >
            <template v-slot:[`item.key`]="{ item }">
              <div class="ml-3">
                {{ item.key }}
              </div>
            </template>
          </v-data-table>
        </div>

        <v-card-actions>
          <v-switch v-model="deleteConfirm" dense class="mt-1 mr-3"
            ><template v-slot:label>
              <span class="body-2">确定</span>
            </template></v-switch
          >

          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="deleteDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="red darken-1"
            text
            @click="sureDelete"
            :disabled="!deleteConfirm"
          >
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>


<script>
import { addProducts } from "@/settings/product";
import { editProduct } from "@/settings/product";
import { loadProducts } from "@/settings/product";
import { getClass } from "@/settings/product";

import { getSubUsers } from "@/settings/user";

import { getDepartment } from "@/settings/department";
import { getGroup } from "@/settings/group";

import SkuTable from "@/components/SkuTable/SkuTable";
//import SelectDialog from "@/components/SelectDialog";

export default {
  components: {
    SkuTable,
    //SelectDialog,
  },
  data: () => ({
    allDepartment: [],
    allGroup: [],

    mode: 0,
    checkReadOnly: "",

    //筛选菜单
    menu: {}, //类别可选项

    search: {
      //选中项
      select: {
        //类别筛选
        department: [],
        owner: [],
        groupName: [],
        transportWay: [],
        firstCategory: [],
        shopName: [],
      },
      search: {
        //模糊查找
      },
    },

    searchPreview: "",

    //分页懒加载
    totalProducts: 50,
    options: {},

    dialog: false,

    deleteDialog: false, //删除弹框
    deleteItem: {},
    deleteItemParse: [],
    deleteConfirm: false,

    //二级展开
    expanded: [],

    //主表加载
    loading: false,

    //主表头, 内容
    headers: [],
    products: [],

    headersContent: [
      { text: "商品ID", value: "id" },
      { text: "商品名", value: "productName" },

      { text: "事业部", value: "department" },
      { text: "组别", value: "groupName" },
      { text: "持品人", value: "owner" },
      { text: "店铺名", value: "shopName" },

      { text: "一级类目", value: "firstCategory" },

      { text: "发货方式", value: "transportWay" },
      { text: "聚水潭仓库", value: "storehouse" },
      { text: "操作", value: "actions" },
    ],

    editedItem: {},

    subUsers: [],
    idToNick: {},
  }),

  computed: {
    isEmp: function () {
      var check = [
        "id",
        "department",
        "groupName",
        "owner",
        "shopName",
        "productName",
        "firstCategory",
        "productDeduction",
        "productInsurance",
        "productFreight",
        "extraRatio",
      ];

      var pass = true;
      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false;
      });

      console.log(pass);

      return !pass;
    },
  },

  watch: {
    dialog(val) {
      val || this.close();
    },

    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },

    "search.search": {
      handler() {
        this.searchPreview = "";
        for (let name in this.search.search) {
          if (!this.search.search[name]) continue;
          this.search.search[name] = this.search.search[name].trim();
          if (this.search.search[name]) {
            this.searchPreview += `${
              this.headersContent.find((i) => i.value == name).text
            }：${this.search.search[name]} ，`;
          }
        }
        this.searchPreview = this.searchPreview
          ? this.searchPreview.slice(0, -1)
          : "点击列名可以进行模糊搜索";
      },
      deep: true,
      immediate: true,
    },
  },

  created() {
    this.init();
  },

  methods: {
    init() {
      getClass({})
        .then((res) => {
          this.menu = res.data;
          console.log("this.menu");
          console.log(res.data);
        })
        .catch(() => {});
      getDepartment({}).then(
        (res) => (this.allDepartment = res.data.departments)
      );
      getGroup({}).then((res) => (this.allGroup = res.data.teams));
      getSubUsers({}).then((res) => (this.subUsers = res.data.userInfos));

      //有watch search.search, init时不需要loadData
    },

    addMode() {
      this.editedItem = {};
      this.mode = 1; //新增
      this.checkReadOnly = false;
    },
    showHeaders() {
      this.headers = this.headersContent;
    },

    refreshData(a) {
      if (a.select) {
        this.search.select[a.select.key] = a.select.value;
      } else {
        console.log("未知");
      }
      this.loadData();
    },

    clickRow(item, event) {
      console.log(this.departmentList);
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      console.log({ page, itemsPerPage, match: JSON.stringify(this.search) });
      loadProducts({ page, itemsPerPage, match: JSON.stringify(this.search) })
        .then((res) => {
          this.loading = false;

          console.log(res.data);

          this.showHeaders();
          this.products = res.data.products;
          this.totalProducts = res.data.total;
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    editItem(item) {
      // this.editedIndex = this.products.indexOf(item);
      this.mode = 2; //修改
      this.editedItem = Object.assign({}, item);
      this.checkReadOnly = true;
      this.dialog = true;
    },

    deleteProduct(item) {
      console.log(item);
      this.deleteItem = item;
      this.deleteItemParse = [
        {
          key: "商品ID",
          value: item.id,
        },
        {
          key: "商品名",
          value: item.productName,
        },
        {
          key: "店铺名",
          value: item.shopName,
        },
        {
          key: "一级类目",
          value: item.firstCategory,
        },
      ];
      this.deleteConfirm = false;

      this.deleteDialog = true;
    },

    sureDelete() {
      console.log(this.deleteConfirm);
    },

    close() {
      this.dialog = false;
    },

    // initialData() {
    //   var iniData = []
    //   for (let i = 0; i < Object.keys(iniData).length; i++) {
    //     setTimeout(function () {
    //       console.log(iniData.length);
    //       console.log(iniData[i]);
    //       addProducts(iniData[i]).then(() => {
    //         //刷新页面数据
    //         //this.loadData();
    //       });
    //       console.log(i);
    //     }, 100 * i);
    //   }
    // },

    save() {
      if (this.mode == 1) {
        this.add();
      } else if (this.mode == 2) {
        this.edit();
      }
    },

    add() {
      if (/[^\d]/.test(this.editedItem.id)) {
        this.global.infoAlert("泼发EBC：商品ID格式错误");
        return;
      } else {
        this.close();
      }
      this.loading = true;
      console.log(this.editedItem);
      addProducts(this.editedItem)
        .then((res) => {
          this.loading = false;
          this.global.infoAlert("泼发EBC：" + res.data);
          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },

    edit() {
      this.loading = true;
      // var args = { ...this.editedItem };
      // console.log(this.editedItem);
      // console.log(args);
      // if (args.freightToPayment == null) { delete args.freightToPayment; }
      // console.log(args);
      editProduct(this.editedItem)
        .then((res) => {
          this.loading = false;
          this.global.infoAlert("泼发EBC：" + res.data);
          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },
  },
};
</script>

<style src="./PartnerGet.scss" lang="scss">
</style>