<template>
  <div>
    <v-card>
      <v-card-title>
        <span>利润报表（单日）</span>
        <v-spacer></v-spacer>
        <v-btn
          small
          depressed
          class="ml-2"
          v-model="check"
          @click="check = !check"
        >
          <v-icon small class="mr-1">
            {{
              check
                ? "mdi-checkbox-marked-outline"
                : "mdi-checkbox-blank-outline"
            }}
          </v-icon>
          <span> 展开全部列 </span>
        </v-btn>
      </v-card-title>
      <v-data-table
        :items="profitItems"
        :headers="check ? profitHeadersHide : profitHeadersAll"
        :loading="loading"
      >
        <template v-slot:[`item.calculatedActualAmount`]="{ item }">
          {{ item.totalAmount - item.totalFakeAmount + " ￥" }}
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>


<script>
import { getDailyReport } from "@/settings/order";
export default {
  data() {
    return {
      check: false,
      loading: false,
      profitItems: [],
      profitHeadersAll: [
        { text: "日期", value: "date" },
        { text: "组别", value: "team" }, //1
        { text: "店铺", value: "shop" }, //1
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "一级类目", value: "firstCategory" }, //1
        { text: "商品编码ID", value: "productId" }, //1
        { text: "扣点", value: "deduction" }, //1
        { text: "运费险", value: "insurance" }, //1
        { text: "运费", value: "calculatedFreight" }, //1,2 freight or topayment
        { text: "子/主", value: "extraRatio" }, //1
        { text: "成交额", value: "totalAmount" }, //1
        { text: "订单数", value: "orderCount" }, //1
        { text: "销售数", value: "productCount" }, //1
        { text: "补单额", value: "totalFakeAmount" }, //1
        { text: "补单数", value: "fakeOrderCount" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //成交额-补单额
        { text: "真实单数", value: "calculatedActualOrderCount" }, //订单数-补单数
        { text: "单均价", value: "calculated" }, //真实金额/真实单数
        { text: "拿货成本", value: "totalCost" }, //1
        { text: "成本率", value: "calculatedCostRatio" },//拿货成本/真实金额
        { text: "利润率", value: "calculatedProfitRatio" },//每单运费：真实金额-拿货成本-扣点*真实金额-（运费险+运费）*真实单数；运费/货品成本：真实金额-拿货成本-扣点*真实金额-运费险*真实单数-运费*拿货成本
        { text: "退款金额", value: "totalRefundAmount" }, //1
        { text: "净收入额", value: "calculatedActualIncome" },//真实金额-退款金额
        { text: "未发仅退", value: "totalRefundWithNoShipAmount" }, //1
        { text: "未发退本", value: "calculatedRefundWithNoShipAmount" },//未发仅退*成本率
        { text: "未发数", value: "refundWithNoShipCount" }, //1
        { text: "拿货成本（售后）", value: "calculatedActualCost" }, //拿货成本-未发退本
        { text: "平台扣点", value: "calculatedTmallTokeRatio" }, //扣点*（成交额-退款金额）
        { text: "快递费", value: "calculatedTotalFreight" },//每单运费：运费*（真实单数-未发数）；运费/货品成本：运费*拿货成本（售后）
        { text: "运费险", value: "calculatedTotalInsurance" }, //运费险1*（订单数-未发数）
        { text: "刷单佣金", value: "" },
        { text: "售后毛利润", value: "calculatedActualProfit" },//净收入额-拿货成本（售后）-平台扣点-运费险-快递费-刷单佣金
        { text: "售后利润率", value: "calculatedActualProfitRatio" },//售后毛利率/净收入额(为负时显示"-")
        { text: "SKU", value: "calculatedSkuCorrection" },//ok or 有误
        { text: "错数", value: "skuWithNoCostCount" },//1
        { text: "折扣", value: "discount" },//成交额/原售价
        { text: "错数", value: "" },//(定价<实际成交价 的订单条数)
        { text: "原售价", value: "" },
        { text: "厂家返款", value: "" },
        //----------------------------------------------------------------------
      ],
      profitHeadersHide: [
        { text: "日期", value: "date" },
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "商品编码ID", value: "productId" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //2
        { text: "真实单数", value: "calculatedActualOrderCount" }, //2
        { text: "单均价", value: "calculated" }, //真实金额/真实单数
        { text: "拿货成本", value: "totalCost" }, //1
        { text: "成本率", value: "calculated" },
        { text: "利润率", value: "" },
        { text: "退款金额", value: "totalRefundAmount" }, //1
        { text: "净入金额", value: "" },
        { text: "未发仅退", value: "totalRefundWithNoShipAmount" }, //1
        { text: "未发退本", value: "" },
        { text: "未发数", value: "refundWithNoShipCount" }, //1
        { text: "拿货成本（售后）", value: "calculatedActualCost" }, //2
        { text: "平台扣点", value: "calculatedTmallTokeRatio" }, //2
        { text: "快递费", value: "" },
        { text: "运费险", value: "calculatedTotalInsurance" }, //2
        { text: "刷单佣金", value: "" },
        { text: "售后毛利润", value: "" },
        { text: "售后利润率", value: "" },
        { text: "SKU", value: "" },
        { text: "错数", value: "" },
        { text: "折扣", value: "" },
        { text: "错数", value: "" },
        { text: "原售价", value: "" },
        { text: "厂家返款", value: "" },
        //----------------------------------------------------------------------
      ],
    };
  },

  created() {
    this.loadData();
  },

  watch: {
    expendHeaders() {
      if (this.check == false) {
        this.profitHeaders = this.profitHeadersHide;
      } else if (this.check == true) {
        this.profitHeaders = this.profitHeadersAll;
      }
    },
  },

  methods: {
    loadData() {
      this.loading = true;
      getDailyReport({ date: "2022/08/21" })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          for (let name in res.data) {
            this.profitItems = res.data[name];
            break;
          }
        })
        .catch(() => {
          this.loading = true;
        });
    },
  },
};
</script>
