<template>
  <v-card class="products-list mb-1">
    <v-card-title>
      <p>测试</p>
    </v-card-title>

    <v-data-table
      height="calc(100vh - 280px)"
      single-expand
      show-expand
      fixed-header
      :loading="loading"
      loading-text="加载中... 请稍后"
      no-data-text="空"
      :headers="headers"
      :items="products"
      :expanded.sync="expanded"
      item-key="id"
      sort-by="id"
      class="elevation-1"
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

      <template v-slot:no-data>
        <v-btn color="primary" @click="initialize"> Reset </v-btn>
      </template>
    </v-data-table>
  </v-card>
</template>







<script>
import { addProducts } from "@/settings/product";
import SkuTable from "@/components/SkuTable/SkuTable";
//import * as XLSX from 'xlsx/xlsx.mjs';

export default {
  components: {
    SkuTable,
  },
  data: () => ({
    dialog: false,
    dialogDelete: false,
    sdialog: false,
    sdialogDelete: false,
    ssdialogs: [],
    status: "松开上传",
    progress: false,
    expanded: [],

    loading: false,

    headers: [],
    products: [],

    editedIndex: -1,

    editedItem: {
      id: "",
      department: "",
      group_name: "",
      owner: "",
      shop_name: "",
      product_name: "",
      first_category: "",
      product_deduction: "",
      product_insurance: "",
      product_freight: "",
      extra_ratio: "",
      freight_to_payment: "",
      transport_way: "",
      storehouse: "",
      manufacturer_name: "",
      manufacturer_group: "",
      manufacturer_payment_name: "",
      manufacturer_payment_method: "",
      manufacturer_payment_id: "",
      manufacturer_recipient: "",
      manufacturer_phone: "",
      manufacturer_address: "",
    },

    defaultItem: {
      id: "",
      department: "",
      group_name: "",
      owner: "",
      shop_name: "",
      product_name: "",
      first_category: "",
      product_deduction: "",
      product_insurance: "",
      product_freight: "",
      extra_ratio: "",
      freight_to_payment: "",
      transport_way: "",
      storehouse: "",
      manufacturer_name: "",
      manufacturer_group: "",
      manufacturer_payment_name: "",
      manufacturer_payment_method: "",
      manufacturer_payment_id: "",
      manufacturer_recipient: "",
      manufacturer_phone: "",
      manufacturer_address: "",
    },

    subTableItems: [],
    seditedIndex: -1,

    secondeditedItem: {
      name: "",
      price: "",
      cost: "",
      start: "",
      end: "",
      orderNum: "",
      seleNum: "",
    },

    seconddefaultItem: {
      name: "",
      price: "",
      cost: "",
      start: "",
      end: "",
      orderNum: "",
      seleNum: "",
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
    sdialogDelete(val) {
      val || this.secondcloseDelete();
    },
  },

  created() {
    this.initialize();
    this.buttonBoolean();
    console.log(this.subTableItems);
  },

  methods: {
    clickRow(item, event) {
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    initialize() {
      //数据初始化
      this.loading = true;

      setTimeout(() => {
        this.loading = false;

        //加载表头
        this.headers = [
          { text: "商品ID", sortable: true, value: "id" },
          { text: "产品名", value: "product_name" },

          { text: "部门", value: "department" },
          { text: "组别", value: "group_name" },
          { text: "持品人", value: "owner" },
          { text: "店铺名", value: "shop_name" },

          { text: "一级类目", value: "first_category" },
          { text: "品类扣点", value: "product_deduction" },
          { text: "品类运费险", value: "product_insurance" },
          { text: "每单运费", value: "product_freight" },
          { text: "子/主订单附带比", value: "extra_ratio" },
          { text: "运费/总货款", value: "freight_to_payment" },
          { text: "发货方式", value: "transport_way" },
          { text: "聚水潭仓库", value: "storehouse" },
          { text: "厂家名", value: "manufacturer_name" },
          { text: "厂家群名", value: "manufacturer_group" },
          { text: "厂家收款账户-收款人", value: "manufacturer_payment_name" },
          { text: "厂家收款账户", value: "manufacturer_payment_method" },
          { text: "厂家账户号码", value: "manufacturer_payment_id" },
          { text: "厂家退货-收件人", value: "manufacturer_recipient" },
          { text: "厂家退货-收件手机号", value: "manufacturer_phone" },
          { text: "厂家退货-收件地址", value: "manufacturer_address" },
          { text: "Actions", value: "actions", sortable: false },
        ];

        //加载数据
        for (let index = 0; index < 1000; index++) {
          this.products.push({
            id: Math.floor(Math.random() * 1000000000000000).toString(),
            department: "某某部",
            group_name: "某某组",
            owner: "王毅",
            shop_name: "李宁",
            product_name: "书包",
            first_category: "箱包皮具/热销女包",
            product_deduction: "0.11",
            product_insurance: "0.15",
            product_freight: "0",
            extra_ratio: "",
            freight_to_payment: "",
            transport_way: "聚水潭/手动/其它",
            storehouse: "",
            manufacturer_name: "A",
            manufacturer_group: "",
            manufacturer_payment_name: "",
            manufacturer_payment_method: "支付宝/某某银行",
            manufacturer_payment_id: "",
            manufacturer_recipient: "",
            manufacturer_phone: "",
            manufacturer_address: "",
          });
        }
      }, 1000);
    },

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
        this.editedItem = Object.assign({}, this.defaultItem);
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
      if (this.editedIndex > -1) {
        Object.assign(this.products[this.editedIndex], this.editedItem);
      } else {
        if (/[^\d]/.test(this.editedItem.id)) {
          this.infoAlert("泼发EBC：商品ID格式错误");
          return;
        } else {
          //this.products.push(this.editedItem);
          this.close();
        }
      }

      this.loading = true;
      console.log(this.editedItem)
      addProducts({
        id: this.editedItem.id,
        product_name: this.editedItem.product_name,
        department: this.editedItem.department,
        group_name: this.editedItem.group_name,
        owner: this.editedItem.owner,
        shop_name: this.editedItem.shop_name,
        first_category: this.editedItem.first_category,
        product_deduction: this.editedItem.product_deduction,
        product_insurance: this.editedItem.product_insurance,
        product_freight: this.editedItem.product_freight,
        extra_ratio: this.editedItem.extra_ratio,
        freight_to_payment: this.editedItem.freight_to_payment,
        transport_way: this.editedItem.transport_way,
        storehouse: this.editedItem.storehouse,
        manufacturer_name: this.editedItem.manufacturer_name,
        manufacturer_group: this.editedItem.manufacturer_group,
        manufacturer_payment_method:
          this.editedItem.manufacturer_payment_method,
        manufacturer_payment_name: this.editedItem.manufacturer_payment_name,
        manufacturer_payment_id: this.editedItem.manufacturer_payment_id,
        manufacturer_recipient: this.editedItem.manufacturer_recipient,
        manufacturer_phone: this.editedItem.manufacturer_phone,
        manufacturer_address: this.editedItem.manufacturer_group,
      })
        .then((res) => {
          this.loading = false;

          this.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },

    buttonBoolean() {
      for (let j = 0; j < this.products.length; j++) {
        this.ssdialogs[j] = false;
      }
    },

    secondeditItem(item) {
      this.seditedIndex = this.subTableItems.indexOf(item);
      this.secondeditedItem = Object.assign({}, item);
      this.sdialog = true;
    },

    seconddeleteItem(item) {
      this.seditedIndex = this.subTableItems.indexOf(item);
      this.secondeditedItem = Object.assign({}, item);
      this.sdialogDelete = true;
    },

    seconddeleteItemConfirm() {
      this.subTableItems.splice(this.seditedIndex, 1);
      this.secondcloseDelete();
    },

    secondclose() {
      this.sdialog = false;
      this.$nextTick(() => {
        this.secondeditedItem = Object.assign({}, this.seconddefaultItem);
        this.seditedIndex = -1;
      });
    },

    secondcloseDelete() {
      this.sdialogDelete = false;
      this.$nextTick(() => {
        this.secondeditedItem = Object.assign({}, this.seconddefaultItem);
        this.seditedIndex = -1;
      });
    },

    secondsave() {
      if (this.seditedIndex > -1) {
        Object.assign(
          this.subTableItems[this.seditedIndex],
          this.secondeditedItem
        );
      } else {
        this.subTableItems.push(this.secondeditedItem);
      }
      this.secondclose();
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