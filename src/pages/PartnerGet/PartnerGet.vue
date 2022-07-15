<template>
  <v-card class="products-list mb-1">
    <v-card-title>
      <p>测试</p>
    </v-card-title>

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
          <div class="sub-table-container elevation-20 ml-2 mb-3">
            <SkuTable :productsInfo="item" />
          </div>
        </td>
      </template>

      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>产品信息</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
          <v-spacer></v-spacer>

          <v-dialog v-model="dialog" max-width="1000px">
            <!--new item buttom-->
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="primary" dark class="mb-2" v-bind="attrs" v-on="on">
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
                        v-model="editedItem.group_name"
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
                        v-model="editedItem.shop_name"
                        label="店铺名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.product_name"
                        label="产品名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.first_category"
                        label="一级类目"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.product_deduction"
                        label="品类扣点"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.product_insurance"
                        label="品类运费险"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.product_freight"
                        label="每单运费"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.extra_ratio"
                        label="子/主订单附带比"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.freight_to_payment"
                        label="运费/总货款"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.transport_way"
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
                        v-model="editedItem.manufacturer_name"
                        label="厂家名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_group"
                        label="厂家群名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_payment_name"
                        label="厂家收款账户-收款人"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_payment_method"
                        label="厂家收款账户"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_payment_id"
                        label="厂家账户号码"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_recipient"
                        label="厂家退货-收件人"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_phone"
                        label="厂家退货-收件手机号"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.manufacturer_address"
                        label="厂家退货-收件地址"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>
              <!-- until there is dialog of new input-->

              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="close"> 取消 </v-btn>
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
        <!--
        <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
-->
        <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
      </template>
    </v-data-table>
  </v-card>
</template>







<script>
import { addProducts } from "@/settings/product";
import { loadProducts } from "@/settings/product";
import SkuTable from "@/components/SkuTable/SkuTable";
//import * as XLSX from 'xlsx/xlsx.mjs';

export default {
  components: {
    SkuTable,
  },
  data: () => ({
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

  created() {},

  methods: {
    clickRow(item, event) {
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    loadData() {
      this.loading = true;
      console.log(this.options);
      const { page, itemsPerPage } = this.options;
      loadProducts({ page, itemsPerPage })
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
      addProducts({
        id: this.editedItem.id,
        productName: this.editedItem.productName,
        department: this.editedItem.department,
        groupName: this.editedItem.groupName,
        owner: this.editedItem.owner,
        shopName: this.editedItem.shopName,
        firstCategory: this.editedItem.firstCategory,
        productDeduction: this.editedItem.productDeduction,
        productInsurance: this.editedItem.productInsurance,
        productFreight: this.editedItem.productFreight,
        extraRatio: this.editedItem.extraRatio,
        freightToPayment: this.editedItem.freightToPayment,
        transportWay: this.editedItem.transportWay,
        storehouse: this.editedItem.storehouse,
        manufacturerName: this.editedItem.manufacturerName,
        manufacturerGroup: this.editedItem.manufacturerGroup,
        manufacturerPaymentMethod: this.editedItem.manufacturerPaymentMethod,
        manufacturerPaymentName: this.editedItem.manufacturerPaymentName,
        manufacturerPaymentId: this.editedItem.manufacturerPaymentId,
        manufacturerRecipient: this.editedItem.manufacturerRecipient,
        manufacturerPhone: this.editedItem.manufacturerPhone,
        manufacturerAddress: this.editedItem.manufacturerGroup,
      })
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