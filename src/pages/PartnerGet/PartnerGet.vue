 <!--useless data-table set, but it's still possible to be use.
    <template v-slot:top>
    <v-data-table
      v-model="mock.productsTable.selected"
      :headers="mock.productsTable.headers"
      :items="mock.productsTable.products"
      :search="mock.productsTable.search"
      item-key="name"
      show-select>
-->

<template>
  <v-card class="products-list mb-1">
    <v-card-title>
      <p>测试</p>
    </v-card-title>

    <v-data-table
      single-expand
      show-expand
      loading
      loading-text="加载中... 请稍后"
      :headers="headers"
      :items="products"
      :expanded.sync="expanded"
      item-key="name"
      sort-by="name"
      class="elevation-1"
      @click:row="clickRow"
    >
      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length">
          <div>
            <v-data-table
              hide-default-footer
              :headers="sheaders"
              :items="desserts"
              :a="headers"
              :b="item"
              dense
              class="elevation-1"
            ></v-data-table>
          </div>
        </td>
      </template>

      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>产品信息</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
          <v-spacer></v-spacer>

          <v-dialog v-model="dialog" max-width="500px">
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
                        label="事业部"
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
export default {
  data: () => ({
    dialog: false,
    dialogDelete: false,
    expanded: [],
    headers: [
      {
        text: "商品ID",
        align: "start",
        sortable: true,
        value: "name",
      },
      { text: "部门", value: "company" },
      { text: "组别", value: "city" },
      { text: "持品人", value: "state" },
      { text: "店铺名", value: "aaaaa" },
      { text: "产品名", value: "s" },
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
    ],
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

    sheaders: [
      {
        text: "SKU名称",
        align: "start",
        sortable: false,
        value: "name",
      },
      { text: "Calories", value: "calories" },
      { text: "Fat (g)", value: "fat" },
      { text: "Carbs (g)", value: "carbs" },
      { text: "Protein (g)", value: "protein" },
      { text: "Iron (%)", value: "iron" },
    ],
    desserts: [
      {
        name: "尺寸:20寸【直接登机】送运费险*不满意包退;颜色分类:【商务黑】直角拉链款",
        calories: 159,
        fat: 6.0,
        carbs: 24,
        protein: 4.0,
        iron: "1%",
      },
      {
        name: "Ice cream sandwich",
        calories: 237,
        fat: 9.0,
        carbs: 37,
        protein: 4.3,
        iron: "1%",
      },
      {
        name: "Eclair",
        calories: 262,
        fat: 16.0,
        carbs: 23,
        protein: 6.0,
        iron: "7%",
      },
      {
        name: "Cupcake",
        calories: 305,
        fat: 3.7,
        carbs: 67,
        protein: 4.3,
        iron: "8%",
      },
      {
        name: "Gingerbread",
        calories: 356,
        fat: 16.0,
        carbs: 49,
        protein: 3.9,
        iron: "16%",
      },
      {
        name: "Jelly bean",
        calories: 375,
        fat: 0.0,
        carbs: 94,
        protein: 0.0,
        iron: "0%",
      },
      {
        name: "Lollipop",
        calories: 392,
        fat: 0.2,
        carbs: 98,
        protein: 0,
        iron: "2%",
      },
      {
        name: "Honeycomb",
        calories: 408,
        fat: 3.2,
        carbs: 87,
        protein: 6.5,
        iron: "45%",
      },
      {
        name: "Donut",
        calories: 452,
        fat: 25.0,
        carbs: 51,
        protein: 4.9,
        iron: "22%",
      },
      {
        name: "KitKat",
        calories: 518,
        fat: 26.0,
        carbs: 65,
        protein: 7,
        iron: "6%",
      },
    ],
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
  },

  created() {
    this.initialize();
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
      this.products = [];
      this.products = [
        {
          name: "334455461868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455451868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455861868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455761868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455061868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334452461868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "336455461868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455462868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455431868",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
        {
          name: "334455461468",
          company: "某某部",
          city: "某某组",
          state: "王毅",
          aaaaa: "李宁",
          s: "书包",
          d: "箱包皮具/热销女包",
          f: "0.11",
          g: "0.15",
          h: "0",
          j: "null",
          k: "null",
          l: "聚水潭/手动/其它",
          q: "null",
          w: "A",
          e: "null",
          r: "支付宝/某某银行",
          t: "null",
          y: "null",
          u: "null",
          i: "null",
        },
      ];
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
  },
};
</script>

<style src="./PartnerGet.scss" lang="scss">
</style>g