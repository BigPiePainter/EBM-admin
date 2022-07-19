<template>
  <div>
    <v-expansion-panels class="mb-3" multiple>
      <v-expansion-panel>
        <v-expansion-panel-header v-slot="{ open }">
          <v-row no-gutters>
            <v-col cols="4"> 筛选 </v-col>
            <v-fade-transition>
              <v-col v-if="!open" cols="8" class="text--secondary">
                <v-row no-gutters style="width: 100%">
                  <v-col cols="6"> 部门111 </v-col>
                  <v-col cols="6"> 组别222 </v-col>
                </v-row>
              </v-col>
            </v-fade-transition>
          </v-row>
        </v-expansion-panel-header>
        <v-expansion-panel-content>
          <v-container>
            <v-row>
              <v-col>
                <v-card class="mx-top-left" max-width="250"
                  ><SelectDialog
                    :title="'部门'"
                    :name="'department'"
                    :menu="menu"
                    @sendSelectData="refreshData"
                /></v-card>
              </v-col>
              <v-col>
                <SelectDialog
                  :title="'组别'"
                  :name="'groupName'"
                  :menu="menu"
                  @sendSelectData="refreshData"
                />
              </v-col>
              <v-col>
                <SelectDialog :title="'持品人'" :name="'owner'" :menu="menu" />
              </v-col>
              <v-col>
                <SelectDialog
                  :title="'一级类目'"
                  :name="'firstCategory'"
                  :menu="menu"
                  @sendSelectData="refreshData"
                />
              </v-col>
              <v-col>
                <SelectDialog
                  :title="'店铺名'"
                  :name="'shopName'"
                  :menu="menu"
                  @sendSelectData="refreshData"
                />
              </v-col>
              <v-col>
                <SelectDialog
                  :title="'发货方式'"
                  :name="'transportWay'"
                  :menu="menu"
                  @sendSelectData="refreshData"
                />
              </v-col>
            </v-row>
          </v-container>

          <v-expansion-panels class="mt-5 pl-8 pr-8">
            <v-expansion-panel>
              <v-expansion-panel-header> 模糊查找 </v-expansion-panel-header>
              <v-expansion-panel-content>
                <Search @sendSearchData="refreshData" />
              </v-expansion-panel-content>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>
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
        height="calc(100vh - 280px)"
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
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="sub-table pa-0">
            <v-scale-transition>
              <div class="sub-table-container elevation-20 ml-2 mb-3">
                <SkuTable :productsInfo="item" />
              </div>
            </v-scale-transition>
          </td>
        </template>

        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>商品清单</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>

            <v-spacer></v-spacer>

            <v-dialog v-model="dialog" max-width="1000px">
              <!--new item buttom-->
              <template v-slot:activator="{ on, attrs }">
                <v-btn small depressed color="primary" v-bind="attrs" v-on="on">
                  新增商品信息
                </v-btn>
              </template>

              <v-card>
                <v-card-title>
                  <span class="text-h5">{{ formTitle }}</span>
                </v-card-title>
                <!-- dialog of new input-->
                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.id"
                          label="id"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.department"
                          label="部门"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.groupName"
                          label="组别"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.owner"
                          label="持品人"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.shopName"
                          label="店铺名"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.productName"
                          label="产品名"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.firstCategory"
                          label="一级类目"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.productDeduction"
                          label="品类扣点"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.productInsurance"
                          label="品类运费险"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.productFreight"
                          label="每单运费"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.extraRatio"
                          label="子/主订单附带比"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.freightToPayment"
                          label="运费/总货款"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.transportWay"
                          label="发货方式"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.storehouse"
                          label="聚水潭仓库"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerName"
                          label="厂家名"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerGroup"
                          label="厂家群名"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerPaymentName"
                          label="厂家收款账户-收款人"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerPaymentMethod"
                          label="厂家收款账户"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerPaymentId"
                          label="厂家账户号码"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerRecipient"
                          label="厂家退货-收件人"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerPhone"
                          label="厂家退货-收件手机号"
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="6" md="4">
                        <v-text-field
                          v-model="editedItem.manufacturerAddress"
                          label="厂家退货-收件地址"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-card-text>
                <!-- until there is dialog of new input-->

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="close">
                    取消
                  </v-btn>
                  <v-btn color="blue darken-1" text @click="save"> 保存 </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>

            <v-dialog v-model="dialogDelete" max-width="500px">
              <v-card>
                <v-card-title class="text-h5">是否确定删除？</v-card-title>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeDelete"
                    >取消</v-btn
                  >
                  <v-btn color="blue darken-1" text @click="deleteItemConfirm"
                    >完成</v-btn
                  >
                  <v-spacer></v-spacer>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <v-icon small class="mr-2" @click="editItem(item)">
            mdi-pencil
          </v-icon>
          <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>







<script>
import { addProducts } from "@/settings/product";
import { loadProducts } from "@/settings/product";
import { getClass } from "@/settings/product";
import SkuTable from "@/components/SkuTable/SkuTable";
import SelectDialog from "@/components/SelectDialog";
//import Search from "@/components/Search";
import Search from "../../components/Search/Search.vue";
//import * as XLSX from 'xlsx/xlsx.mjs';

export default {
  components: {
    SkuTable,
    SelectDialog,
    Search,
  },
  data: () => ({
    //删选菜单
    menu: {},

    search: {
      select: {
        department: [],
        owner: [],
        groupName: [],
        transportWay: [],
        firstCategory: [],
        shopName: [],
      },
      search: {},
    },

    //分页懒加载
    totalProducts: 50,
    options: {},

    dialog: false,
    dialogDelete: false,

    //二级展开
    expanded: [],

    //主表加载
    loading: false,

    //主表头, 内容
    headers: [],
    products: [],

    editedIndex: -1,

    editedItem: {
      id: "",
      department: "",
      groupName: "",
      owner: "",
      shopName: "",
      productName: "",
      firstCategory: "",
      productDeduction: "",
      productInsurance: "",
      productFreight: "",
      extraRatio: "",
      freightToPayment: "",
      transportWay: "",
      storehouse: "",
      manufacturerName: "",
      manufacturerGroup: "",
      manufacturerPaymentName: "",
      manufacturerPaymentMethod: "",
      manufacturerPaymentId: "",
      manufacturerRecipient: "",
      manufacturerPhone: "",
      manufacturerAddress: "",
    },

    defaultItem: {
      id: "",
      department: "",
      groupName: "",
      owner: "",
      shopName: "",
      productName: "",
      firstCategory: "",
      productDeduction: "",
      productInsurance: "",
      productFreight: "",
      extraRatio: "",
      freightToPayment: "",
      transportWay: "",
      storehouse: "",
      manufacturerName: "",
      manufacturerGroup: "",
      manufacturerPaymentName: "",
      manufacturerPaymentMethod: "",
      manufacturerPaymentId: "",
      manufacturerRecipient: "",
      manufacturerPhone: "",
      manufacturerAddress: "",
    },
  }),

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    },
  },

  watch: {
    dialog(val) {
      val || this.close();
    },
    dialogDelete(val) {
      val || this.closeDelete();
    },

    sdialog(val) {
      val || this.secondclose();
    },
    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },
  },

  mounted() {
    getClass({})
      .then((res) => {
        this.menu = res.data;
        this.selectedMenu = this.menu;
        console.log(res.data);
      })
      .catch(() => {});
  },

  methods: {
    refreshData(a) {
      if (a.select) {
        this.search.select[a.select.key] = a.select.value;
      } else if (a.search) {
        this.search.search = a.search;
      } else {
        console.log("未知");
      }
      console.log(a);
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
      // this.hideHead();
      // this.products = [];

      console.log(this.options);
      const { page, itemsPerPage } = this.options;

      var args = { page, itemsPerPage, match: JSON.stringify(this.search) };

      console.log(args);
      loadProducts(args)
        .then((res) => {
          this.loading = false;

          console.log(res.data);

          this.showHead();
          this.products = res.data.products;
          this.totalProducts = res.data.total;

          //this.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    showHead() {
      //加载表头
      this.headers = [
        { text: "商品ID", sortable: true, value: "id" },
        { text: "产品名", value: "productName" },

        { text: "部门", value: "department" },
        { text: "组别", value: "groupName" },
        { text: "持品人", value: "owner" },
        { text: "店铺名", value: "shopName" },

        { text: "一级类目", value: "firstCategory" },
        { text: "品类扣点", value: "productDeduction" },
        { text: "品类运费险", value: "productInsurance" },
        { text: "每单运费", value: "productFreight" },
        { text: "子/主订单附带比", value: "extraRatio" },
        { text: "运费/总货款", value: "freightToPayment" },
        { text: "发货方式", value: "transportWay" },
        { text: "聚水潭仓库", value: "storehouse" },
        { text: "厂家名", value: "manufacturerName" },
        { text: "厂家群名", value: "manufacturerGroup" },
        { text: "厂家收款账户-收款人", value: "manufacturerPaymentName" },
        { text: "厂家收款账户", value: "manufacturerPaymentMethod" },
        { text: "厂家账户号码", value: "manufacturerPaymentId" },
        { text: "厂家退货-收件人", value: "manufacturerRecipient" },
        { text: "厂家退货-收件手机号", value: "manufacturerPhone" },
        { text: "厂家退货-收件地址", value: "manufacturerAddress" },
        { text: "Actions", value: "actions", sortable: false },
      ];
    },
    hideHead() {
      this.headers = [];
    },

    initialize() {},

    editItem(item) {
      this.editedIndex = this.products.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },

    deleteItem(item) {
      this.editedIndex = this.products.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialogDelete = true;
    },

    deleteItemConfirm() {
      this.products.splice(this.editedIndex, 1);
      this.closeDelete();
    },

    close() {
      this.dialog = false;
      this.$nextTick(() => {
        //this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      });
    },

    closeDelete() {
      this.dialogDelete = false;
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      });
    },

    save() {
      if (/[^\d]/.test(this.editedItem.id)) {
        this.infoAlert("泼发EBC：商品ID格式错误");
        return;
      } else {
        //this.products.push(this.editedItem);
        this.close();
      }

      this.loading = true;
      console.log(this.editedItem);
      addProducts(this.editedItem)
        .then((res) => {
          this.loading = false;
          this.infoAlert("泼发EBC：" + res.data);

          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },

    infoAlert(message) {
      this.$toast.info(message, {
        position: "top-right",
        timeout: 6000,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        draggablePercent: 0.6,
        showCloseButtonOnHover: false,
        hideProgressBar: true,
        closeButton: "button",
        icon: true,
      });
    },
  },
};
</script>

<style src="./PartnerGet.scss" lang="scss">
</style>