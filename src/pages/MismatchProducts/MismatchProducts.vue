<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="认领大厅">
    </PageHeader>
    <v-data-table
      fixed-header
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key="id"
      height="calc(100vh - 197px)"
      class=""
      sort-by="totalAmount"
      sort-desc
      :loading="loading"
      :headers="[
        { text: '商品ID', value: 'id', sortable: false },
        { text: '宝贝标题', value: 'productTitle', sortable: false },
        { text: '30天内成交额', value: 'totalAmount' },
        { text: '操作', value: 'actions', sortable: false },
      ]"
      :items="allMismatchProducts"
      :items-per-page="20"
      :footer-props="{
        'items-per-page-options': [10, 20, 50, 100],
        'items-per-page-text': '每页显示条数',
      }"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title @click="showMissMoney">待认领商品</v-toolbar-title>
          <v-divider class="mx-4" inset vertical></v-divider>
        </v-toolbar>
      </template>

      <template v-slot:[`header.id`]="{ header }">
        <span class="ml-15">
          {{ header.text }}
        </span>
      </template>

      <template v-slot:[`header.productTitle`]="{ header }">
        <span style="margin-left: 150px">
          {{ header.text }}
        </span>
      </template>

      <template v-slot:[`item.id`]="{ item }">
        <span class="ml-10">
          {{global.log(user.uid)}}
          {{
            user.uid == 1
              ? item.id
              : item.id.toString().substring(0, 4) +
                "****" +
                item.id.toString().substr(-4)
          }}
        </span>
      </template>
      <!-- 
        -->

      <template v-slot:[`item.totalAmount`]="{ item }">
        {{ amountFormat(item.totalAmount, "￥", 2, 0) }}
      </template>

      <template v-slot:[`header.actions`]="{ header }">
        <span class="ml-4">
          {{ header.text }}
        </span>
      </template>

      <template v-slot:[`item.actions`]="{ item }">
        <v-btn
          small
          depressed
          outlined
          color="green"
          class="ml-1"
          @click.stop="accept(item)"
        >
          认领
        </v-btn>
      </template>

      <template v-slot:[`item.productTitle`]="{ item }">
        {{
          item.productTitle[0] == "【"
            ? item.productTitle.substr(item.productTitle.lastIndexOf("】") + 1)
            : item.productTitle
        }}
      </template>
    </v-data-table>

    <!-- 认领商品 Dialog -->
    <v-dialog v-model="acceptDialog" max-width="350px">
      <v-card>
        <div class="mx-5 pt-4">
          <span> {{ acceptItem.productTitle }} </span>
        </div>

        <div class="mt-5">
          <TableKV :items="productItemParse" />
        </div>

        <v-container class="px-7 mt-3 mt-2 mb-1">
          <span class="text-body-2 text--secondary">
            输入12位商品ID自动跳转到录入界面
          </span>
          <v-text-field
            outlined
            dense
            hide-details
            type="number"
            v-model="productIdEdited"
          >
          </v-text-field>
        </v-container>

        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="acceptDialog = false"
            >取消</v-btn
          >
          <v-btn color="blue darken-1" text @click="sureAcceptButton">
            <v-icon small class="mr-1"> mdi-pencel </v-icon>跳转</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { amountBeautify } from "@/libs/utils";
import { getMismatchProducts } from "@/settings/product";

import { mapState } from "vuex";

import TableKV from "@/components/TableKV/TableKV";
import PageHeader from "@/components/PageHeader";

export default {
  name: "MismatchProducts",
  components: {
    TableKV,
    PageHeader,
  },
  data() {
    return {
      loading: false,
      allMismatchProducts: [],

      productItemParse: [],
      acceptDialog: false,
      acceptItem: {},
      productIdEdited: "",
    };
  },

  created() {
    console.log = function (){}
    this.loadData();
  },

  computed: {
    ...mapState([
      "user",
      "allDepartments",
      "allTeams",
      "allUsers",
      "allCategorys",
      "allCategoryHistorys",
      "allShops",
      "userIdToNick",
      "teamIdToName",
      "departmentIdToName",
      "categoryIdToName",
      "categoryIdToInfo",
    ])
  },

  methods: {
    amountFormat() {
      return amountBeautify(...arguments);
    },

    showMissMoney() {
      var money = 0;
      for (let i = 0; i < this.allMismatchProducts.length; i++) {
        money = money + this.allMismatchProducts[i].totalAmount;
      }
      console.log(money + 0.0000000001);
    },

    loadData() {
      this.loading = true;
      getMismatchProducts({})
        .then((res) => {
          console.log("接口读取测试", res);
          this.loading = false;
          this.allMismatchProducts = res.data.mismatchProducts;
        })
        .catch((err) => {
          console.log(err);
          this.loading = false;
        });
    },
    accept(item) {
      //console.log(item);
      this.productIdEdited = "";
      this.acceptItem = item;
      this.productItemParse = [
        {
          key: "商品ID",
          value:
            item.id.toString().substring(0, 4) +
            "****" +
            item.id.toString().substr(-4),
        },
        {
          key: "30天内销售额",
          value: "￥ " + item.totalAmount,
        },
      ];
      this.acceptDialog = true;
    },

    sureAcceptButton() {
      if (this.productIdEdited == this.acceptItem.id) {
        localStorage.ProductIdAutoComplete = this.acceptItem.id;
        this.$router.push("/partnerget");
        return;
      } else {
        this.global.infoAlert("泼发EBC：输入的ID不正确");
      }
    },
  },
};
</script>

<style scoped>
</style>