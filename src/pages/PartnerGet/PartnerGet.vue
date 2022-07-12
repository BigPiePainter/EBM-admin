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
      item-key="name"
      sort-by="name"
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
            <SkuTable :productId="item.name" />
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
                        v-model="editedItem.name"
                        label="id"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.company"
                        label="部门"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.city"
                        label="组别"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.state"
                        label="持品人"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.aaaaa"
                        label="店铺名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.s"
                        label="产品名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.d"
                        label="一级类目"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.f"
                        label="品类扣点"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.g"
                        label="品类运费险"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.h"
                        label="每单运费"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.j"
                        label="子/主订单附带比"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.k"
                        label="运费/总货款"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.l"
                        label="发货方式"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.q"
                        label="聚水潭仓库"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.w"
                        label="厂家名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.e"
                        label="厂家群名"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.r"
                        label="厂家收款账户"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.t"
                        label="厂家账户号码"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.y"
                        label="厂家退货-收件人"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.u"
                        label="厂家退货-收件手机号"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="editedItem.i"
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
        <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
        <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
      </template>

      <template v-slot:no-data>
        <v-btn color="primary" @click="initialize"> Reset </v-btn>
      </template>
    </v-data-table>
  </v-card>
</template>







<script>
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
    sexpanded: [],

    loading: false,

    headers: [],
    products: [],

    editedIndex: -1,

    editedItem: {
      name: "",
      company: "",
      city: "",
      state: "",
      aaaaa: "",
      s: "",
      d: "",
      f: "",
      g: "",
      h: "",
      j: "",
      k: "",
      l: "",
      q: "",
      w: "",
      e: "",
      r: "",
      t: "",
      y: "",
      u: "",
      i: "",
    },

    defaultItem: {
      name: "",
      company: "",
      city: "",
      state: "",
      aaaaa: "",
      s: "",
      d: "",
      f: "",
      g: "",
      h: "",
      j: "",
      k: "",
      l: "",
      q: "",
      w: "",
      e: "",
      r: "",
      t: "",
      y: "",
      u: "",
      i: "",
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
          { text: "商品ID", sortable: true, value: "name" },
          { text: "产品名", value: "s" },

          { text: "部门", value: "company" },
          { text: "组别", value: "city" },
          { text: "持品人", value: "state" },
          { text: "店铺名", value: "aaaaa" },

          { text: "一级类目", value: "d" },
          { text: "品类扣点", value: "f" },
          { text: "品类运费险", value: "g" },
          { text: "每单运费", value: "h" },
          { text: "子/主订单附带比", value: "j" },
          { text: "运费/总货款", value: "k" },
          { text: "发货方式", value: "l" },
          { text: "聚水潭仓库", value: "q" },
          { text: "厂家名", value: "w" },
          { text: "厂家群名", value: "e" },
          { text: "厂家收款账户", value: "r" },
          { text: "厂家账户号码", value: "t" },
          { text: "厂家退货-收件人", value: "y" },
          { text: "厂家退货-收件手机号", value: "u" },
          { text: "厂家退货-收件地址", value: "i" },
          { text: "Actions", value: "actions", sortable: false },
        ];

        //加载数据
        for (let index = 0; index < 1000; index++) {
          this.products.push({
            link: "/SkuTable",
            name: Math.floor(Math.random() * 1000000000000000).toString(),
            company: "某某部",
            city: "某某组",
            state: "王毅",
            aaaaa: "李宁",
            s: "书包",
            d: "箱包皮具/热销女包",
            f: "0.11",
            g: "0.15",
            h: "0",
            j: "",
            k: "",
            l: "聚水潭/手动/其它",
            q: "",
            w: "A",
            e: "",
            r: "支付宝/某某银行",
            t: "",
            y: "",
            u: "",
            i: "",
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
        this.products.push(this.editedItem);
      }
      this.close();
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
        console.log("444444444");
        Object.assign(
          this.subTableItems[this.seditedIndex],
          this.secondeditedItem
        );
      } else {
        this.subTableItems.push(this.secondeditedItem);
      }
      this.secondclose();
    },
  },
};
</script>

<style src="./PartnerGet.scss" lang="scss">
</style>