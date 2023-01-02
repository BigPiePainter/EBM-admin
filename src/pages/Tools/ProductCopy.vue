<template>
  <div>
    <PageHeader title="商品同步"> </PageHeader>
    <div>
      <ul class="ma-5 text-body-2">
        <li>将一个商品的SKU信息、厂家信息完全同步到另一个商品里</li>
        <li>被同步商品的对应信息将会被覆盖，不会保留</li>
        <li>适用于在EBC中主销与淘特商品的同步</li>
      </ul>
      <v-col class="ml-5">
        <v-row>
          <v-col class="ma-5" md="auto">
            <v-row>
              <span class="group-title">主商品ID:</span>
            </v-row>
            <v-row>
              <v-text-field
                v-model="productIdA"
                style="width: 220px"
                class="search-input mr-3"
                outlined
                clearable
                dense
                hide-details
                color="primary"
              ></v-text-field>
              <v-icon>mdi-arrow-right</v-icon>
            </v-row>
            <v-row v-if="productA">
              <span class="text-body-2 pt-5">
                商品名： {{ productA?.productName }}
              </span>
            </v-row>
            <v-row v-if="productA">
              <span class="text-body-2 pt-5 text--secondary">
                备注：{{ productA?.note }}
              </span>
            </v-row>
          </v-col>

          <v-col class="ma-5">
            <v-row>
              <span class="group-title">附属商品ID:</span>
            </v-row>
            <v-row>
              <v-text-field
                v-model="productIdB"
                style="max-width: 220px"
                class="search-input mr-3"
                outlined
                dense
                clearable
                hide-details
                color="primary"
              ></v-text-field>
              <v-btn
                small
                color="primary"
                @click="check"
                depressed
                :loading="loading"
                class="ml-1"
              >
                检查
              </v-btn>
              <span
                v-if="pass"
                class="text-body-2 pl-3 pt-1"
              >
                仔细核对商品名，防止同步到不相关的商品上
              </span>
              <v-btn
                v-if="pass"
                small
                outlined
                color="green"
                @click="synchronization"
                depressed
                :loading="loading"
                class="ml-5"
              >
                同步
              </v-btn>
              <span
                v-if="showErrorMessage"
                class="text-body-2 pl-3 pt-1"
                style="color: red"
              >
                {{ errorMessage }}
              </span>
            </v-row>
            <v-row v-if="productB">
              <span class="text-body-2 pt-5">
                商品名： {{ productB?.productName }}
              </span>
            </v-row>
            <v-row v-if="productB">
              <span class="text-body-2 pt-5 text--secondary">
                备注：{{ productB?.note }}
              </span>
            </v-row>
          </v-col>
        </v-row>
      </v-col>
    </div>
  </div>
</template>
  
<script>
import PageHeader from "@/components/PageHeader";

import { loadProducts } from "@/settings/product";

export default {
  name: "ProductCopy",
  components: {
    PageHeader,
  },
  data: () => ({
    showErrorMessage: false,
    errorMessage: "",

    loading: false,

    productIdA: "",
    productIdB: "",

    productA: null,
    productB: null,

    pass: false,
  }),

  created() {},

  methods: {
    synchronization(){
      this.global.errorAlert("泼发EBC：这个功能还在制作中...就快做完了");
    },
    check() {
      this.showErrorMessage = false;
      this.loading = true;

      if (this.productIdA?.length != 12 || this.productIdB?.length != 12) {
        this.showErrorMessage = true;
        this.loading = false;
        this.errorMessage = "商品ID长度不对";
        return;
      }

      if (this.productIdA == this.productIdB) {
        this.showErrorMessage = true;
        this.loading = false;
        this.errorMessage = "商品ID相同";
        return;
      }

      Promise.all([
        loadProducts({
          page: 1,
          itemsPerPage: 1,
          match: JSON.stringify({
            select: {
              department: [],
              owner: [],
              team: [],
              transportWay: [],
              firstCategory: [],
              shopName: [],
            },
            search: {
              id: this.productIdA,
            },
          }),
        }),
        loadProducts({
          page: 1,
          itemsPerPage: 1,
          match: JSON.stringify({
            select: {
              department: [],
              owner: [],
              team: [],
              transportWay: [],
              firstCategory: [],
              shopName: [],
            },
            search: {
              id: this.productIdB,
            },
          }),
        }),
      ]).then((res) => {
        this.loading = false;
        console.log(res);
        this.productA = res[0].data.products[0];
        this.productB = res[1].data.products[0];

        if (!this.productA || !this.productB) {
          this.showErrorMessage = true;
          this.errorMessage = "商品未找到";
          return;
        }

        if (res[0].data.products.length > 1 || res[0].data.products.length > 1) {
          this.showErrorMessage = true;
          this.errorMessage = "存在多个商品";
          return;
        }


        this.pass = true;
      });
    },
  },

  watch: {
    productIdA() {
      this.pass = false;
    },
    productIdB() {
      this.pass = false;
    },
  },
};
</script>
  
  
<style>
</style>
  