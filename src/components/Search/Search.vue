<template>
  <v-container>
    <v-row>
      <v-col>
        <v-chip>
          商品id
          <v-text-field v-model="searchItem.id"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip>
          部门
          <v-text-field v-model="searchItem.department"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip>
          组别
          <v-text-field v-model="searchItem.groupName"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip>
          持品人
          <v-text-field v-model="searchItem.owner"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >店铺名
          <v-text-field v-model="searchItem.shopName"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >产品名
          <v-text-field v-model="searchItem.productName"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >一级类目
          <v-text-field v-model="searchItem.firstCategory"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >品类扣点
          <v-text-field v-model="searchItem.productDeduction"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >品类运费险
          <v-text-field v-model="searchItem.productInsurance"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >每单运费
          <v-text-field v-model="searchItem.productFreight"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >子/主订单附带比
          <v-text-field v-model="searchItem.extraRatio"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >运费/总货款
          <v-text-field v-model="searchItem.freightToPayment"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >发货方式
          <v-text-field v-model="searchItem.transportWay"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >聚水潭仓库
          <v-text-field v-model="searchItem.storehouse"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家名
          <v-text-field v-model="searchItem.manufacturerName"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家群名
          <v-text-field v-model="searchItem.manufacturerGroup"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家收款账户-收款人
          <v-text-field
            v-model="searchItem.manufacturerPaymentName"
          ></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家收款账户
          <v-text-field
            v-model="searchItem.manufacturerPaymentMethod"
          ></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家账户号码
          <v-text-field
            v-model="searchItem.manufacturerPaymentId"
          ></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家退货-收件人
          <v-text-field
            v-model="searchItem.manufacturerRecipient"
          ></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家退货-收件手机号
          <v-text-field v-model="searchItem.manufacturerPhone"></v-text-field>
        </v-chip>
      </v-col>
      <v-col>
        <v-chip
          >厂家退货-收件地址
          <v-text-field v-model="searchItem.manufacturerAddress"></v-text-field>
        </v-chip>
      </v-col>
    </v-row>

    <v-row> </v-row>
    <v-row> </v-row>
    <v-row> </v-row>
    <v-row> </v-row>
  </v-container>
</template>

<script>
export default {
  data: () => ({
    searchItem: {
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

    timer:null,
  }),

  watch: {
    searchItem: {
      handler: function () {
        clearTimeout(this.timer);
        this.timer=setTimeout(()=>{
        this.$emit("sendSearchData", { search: this.searchItem })
        },500)
      },
      deep: true,
    },
  },

  methods: {
  },
};
</script>

<style src="./Search.scss" lang="scss"></style>


