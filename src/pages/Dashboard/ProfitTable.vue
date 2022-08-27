<template>
  <div>
    <v-container class="main-container ma-0">
      <v-card class="products-list mb-1">
        <v-data-table
          height="calc(100vh - 155px)"
          fixed-header
          :items-per-page="50"
          :footer-props="{
            'items-per-page-options': [10, 20, 50, 100, 500],
            'items-per-page-text': '每页显示条数',
          }"
          :items="profitItems"
          :headers="check ? profitHeadersAll : profitHeadersHide"
          :loading="loading"
        >
          <template v-slot:[`item.calculatedActualAmount`]="{ item }">
            {{ "￥ " + item.calculatedActualAmount }}
          </template>
          <template v-slot:[`item.calculatedActualOrderCount`]="{ item }">
            {{ item.calculatedActualOrderCount }}
          </template>
          <template v-slot:[`item.calculatedAveragePriceOfSubOrder`]="{ item }">
            {{ "￥ " + item.calculatedAveragePriceOfSubOrder }}
          </template>
          <template v-slot:[`item.calculatedCostRatio`]="{ item }">
            {{ item.calculatedCostRatio + "%" }}
          </template>
          <template v-slot:[`item.calculatedProfitRatio`]="{ item }">
            {{ item.calculatedProfitRatio + "%" }}
          </template>
          <template v-slot:[`item.calculatedActualIncome`]="{ item }">
            {{ "￥ " + item.calculatedActualIncome }}
          </template>
          <template v-slot:[`item.calculatedRefundWithNoShipAmount`]="{ item }">
            {{ "￥ " + item.calculatedRefundWithNoShipAmount }}
          </template>
          <template v-slot:[`item.calculatedActualCost`]="{ item }">
            {{ "￥ " + item.calculatedActualCost }}
          </template>
          <template v-slot:[`item.calculatedTmallTokeRatio`]="{ item }">
            {{ item.calculatedTmallTokeRatio + "%" }}
          </template>
          <template v-slot:[`item.calculatedTotalFreight`]="{ item }">
            {{ "￥ " + item.calculatedTotalFreight }}
          </template>
          <template v-slot:[`item.calculatedTotalInsurance`]="{ item }">
            {{ "￥ " + item.calculatedTotalInsurance }}
          </template>
          <template v-slot:[`item.calculatedActualProfit`]="{ item }">
            {{ "￥ " + item.calculatedActualProfit }}
          </template>
          <template v-slot:[`item.calculatedActualProfitRatio`]="{ item }">
            {{ item.calculatedActualProfitRatio }}
          </template>
          <template v-slot:[`item.calculatedDiscount`]="{ item }">
            {{ item.calculatedDiscount + "%" }}
          </template>
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>利润报表（单日）</v-toolbar-title>
              <v-divider class="mx-1" inset vertical></v-divider>
              <span class="ml-1">选择日期</span>
              <v-menu
                ref="menu"
                v-model="datePicker"
                :close-on-content-click="false"
                :return-value.sync="date"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    class="shrink ml-1"
                    v-model="date"
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    outlined
                    dense
                    hide-details
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="date"
                  no-title
                  scrollable
                  locale="zh-cn"
                  first-day-of-week="1"
                  :day-format="dayFormat"
                  min="2021-01-01"
                  :max="parseDate(new Date())"
                >
                  <v-spacer></v-spacer>
                  <v-btn text color="primary" @click="datePicker = false">
                    取消
                  </v-btn>
                  <v-btn
                    text
                    color="primary"
                    @click="
                      $refs.menu.save(date);
                      loadData();
                    "
                  >
                    确定
                  </v-btn>
                </v-date-picker>
              </v-menu>
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
              <v-btn @click="showDate"></v-btn>
            </v-toolbar>
          </template>
        </v-data-table>
      </v-card>
    </v-container>
  </div>
</template>


<script>
import { javaUTCDateToString } from "@/libs/utils";
import { getDailyReport } from "@/settings/order";
export default {
  data() {
    return {
      date: "",
      datePicker: false,
      check: false,
      loading: false,
      profitItems: [],
      profitHeadersAll: [
        { text: "部门", value: "department" },
        { text: "组别", value: "team" }, //1
        { text: "店铺", value: "shop" }, //1
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "一级类目", value: "firstCategory" }, //1
        { text: "商品编码ID", value: "productId" }, //1
        { text: "扣点", value: "deduction" }, //1
        { text: "运费险", value: "insurance" }, //1
        { text: "运费", value: "calculatedFreight" }, //1,2 freight or topayment1
        { text: "子/主", value: "extraRatio" }, //1
        { text: "成交额", value: "totalAmount" }, //1
        { text: "订单数", value: "orderCount" }, //1
        { text: "销售数", value: "productCount" }, //1
        { text: "补单额", value: "totalFakeAmount" }, //1
        { text: "补单数", value: "fakeOrderCount" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //成交额-补单额1
        { text: "真实单数", value: "calculatedActualOrderCount" }, //订单数-补单数1
        { text: "单均价", value: "calculatedAveragePriceOfSubOrder" }, //真实金额/真实单数1
        { text: "拿货成本", value: "totalCost" }, //1
        { text: "成本率", value: "calculatedCostRatio" }, //拿货成本/真实金额1
        { text: "利润率", value: "calculatedProfitRatio" }, //每单运费：真实金额-拿货成本-扣点*真实金额-（运费险+运费）*真实单数；运费/货品成本：真实金额-拿货成本-扣点*真实金额-运费险*真实单数-运费*拿货成本
        { text: "退款金额", value: "totalRefundAmount" }, //1
        { text: "净收入额", value: "calculatedActualIncome" }, //真实金额-退款金额1
        { text: "未发仅退", value: "totalRefundWithNoShipAmount" }, //1
        { text: "未发退本", value: "calculatedRefundWithNoShipAmount" }, //未发仅退*成本率1
        { text: "未发数", value: "refundWithNoShipCount" }, //1
        { text: "拿货成本（售后）", value: "calculatedActualCost" }, //拿货成本-未发退本1
        { text: "平台扣点", value: "calculatedTmallTokeRatio" }, //扣点*（成交额-退款金额）1
        { text: "快递费", value: "calculatedTotalFreight" }, //每单运费：运费*（真实单数-未发数）；运费/货品成本：运费*拿货成本（售后）1
        { text: "运费险", value: "calculatedTotalInsurance" }, //运费险1*（订单数-未发数）1
        { text: "刷单佣金", value: "totalBrokerage" },
        { text: "售后毛利润", value: "calculatedActualProfit" }, //净收入额-拿货成本（售后）-平台扣点-运费险-快递费-刷单佣金1
        { text: "售后利润率", value: "calculatedActualProfitRatio" }, //售后毛利润/净收入额(为负时显示"-")
        { text: "SKU", value: "calculatedSkuCorrection" }, //ok or 有误
        { text: "错数", value: "skuWithNoCostCount" }, //1
        { text: "折扣", value: "calculatedDiscount" }, //成交额/原售价
        { text: "错数", value: "operatorGivenWrongPriceCount" }, //(定价<实际成交价 的订单条数)
        { text: "原售价", value: "originalTotalPrice" }, //1
        //{ text: "厂家返款", value: "" },
        //----------------------------------------------------------------------
      ],
      profitHeadersHide: [
        { text: "部门", value: "department" },
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "商品编码ID", value: "productId" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //2
        { text: "真实单数", value: "calculatedActualOrderCount" }, //2
        { text: "单均价", value: "calculated" }, //真实金额/真实单数
        { text: "拿货成本", value: "totalCost" }, //1
        { text: "成本率", value: "calculated" },
        { text: "利润率", value: "calculatedProfitRatio" },
        { text: "退款金额", value: "totalRefundAmount" }, //1
        { text: "净收入额", value: "calculatedActualIncome" },
        { text: "未发仅退", value: "totalRefundWithNoShipAmount" }, //1
        { text: "未发退本", value: "calculatedRefundWithNoShipAmount" },
        { text: "未发数", value: "refundWithNoShipCount" }, //1
        { text: "拿货成本（售后）", value: "calculatedActualCost" }, //2
        { text: "平台扣点", value: "calculatedTmallTokeRatio" }, //2
        { text: "快递费", value: "calculatedTotalFreight" },
        { text: "运费险", value: "calculatedTotalInsurance" }, //2
        { text: "刷单佣金", value: "totalBrokerage" },
        { text: "售后毛利润", value: "calculatedActualProfit" },
        { text: "售后利润率", value: "calculatedActualProfitRatio" },
        { text: "SKU", value: "calculatedSkuCorrection" },
        { text: "错数", value: "skuWithNoCostCount" },
        { text: "折扣", value: "calculatedDiscount" },
        { text: "错数", value: "operatorGivenWrongPriceCount" },
        { text: "原售价", value: "originalTotalPrice" },
        //----------------------------------------------------------------------
      ],
    };
  },

  created() {
    this.date = this.parseDate(new Date());
    this.loadData();
  },

  methods: {
    showDate() {
      console.log(this.date);
    },
    parseDate(date) {
      return javaUTCDateToString(date);
    },

    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    loadData() {
      var args = { date: this.date };
      args.date = args.date.replaceAll("-", "/");

      this.loading = true;
      getDailyReport(args)
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          for (let name in res.data) {
            this.profitItems = res.data[name];
            break;
          }

          this.dataAnalyze();
        })
        .catch(() => {
          this.loading = false;
        });
    },
    dataAnalyze() {
      this.profitItems.forEach((item) => {
        item.calculatedFreight = item.freightToPayment
          ? item.freightToPayment + "%"
          : "￥" + item.freight;
        item.calculatedActualAmount = item.totalAmount - item.totalFakeAmount;
        item.calculatedActualOrderCount = item.orderCount - item.fakeOrderCount;
        item.calculatedAveragePriceOfSubOrder =
          item.calculatedActualAmount / item.calculatedActualOrderCount;
        item.calculatedCostRatio = item.totalCost / item.calculatedActualAmount;
        item.calculatedProfitRatio = item.freightToPayment
          ? item.calculatedActualAmount -
            item.totalCost -
            item.deduction * item.calculatedActualAmount -
            item.insurance * item.calculatedActualOrderCount -
            item.freightToPayment * item.totalCost
          : item.calculatedActualAmount -
            item.totalCost -
            item.deduction * item.calculatedActualAmount -
            (item.insurance + item.freight) * item.calculatedActualOrderCount;
        item.calculatedActualIncome =
          item.calculatedActualAmount - item.totalRefundAmount;
        item.calculatedRefundWithNoShipAmount =
          item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
        item.calculatedActualCost =
          item.totalCost - item.calculatedRefundWithNoShipAmount;
        item.calculatedTmallTokeRatio =
          item.deduction * (item.totalAmount - item.totalRefundAmount);
        item.calculatedTotalFreight = item.freightToPayment
          ? item.freightToPayment * item.calculatedActualCost
          : item.freight *
            (item.calculatedActualOrderCount - item.refundWithNoShipCount);
        item.calculatedTotalInsurance =
          item.insurance * (item.orderCount - item.refundWithNoShipCount);
        item.calculatedActualProfit =
          item.calculatedActualIncome -
          item.calculatedActualCost -
          item.calculatedTmallTokeRatio -
          item.calculatedTotalInsurance -
          item.calculatedTotalFreight -
          item.totalBrokerage;
        if (item.calculatedActualProfit / item.calculatedActualIncome < 0) {
          item.calculatedActualProfitRatio =
            item.calculatedActualProfit / item.calculatedActualIncome + "%";
        } else {
          item.calculatedActualProfitRatio = "--";
        }
        if (item.skuWithNoCostCount > 0) {
          item.calculatedSkuCorrection = "有误";
        } else {
          item.calculatedSkuCorrection = "ok";
        }
        item.calculatedDiscount = item.totalAmount / item.originalTotalPrice;
      });
    },
  },
};
</script>

<style lang="css">
tr {
  height: 10px !important;
}
</style>