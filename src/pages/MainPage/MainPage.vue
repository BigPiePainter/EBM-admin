<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="主页"> </PageHeader>
    <v-container fluid id="mainContainer">
      <div class="dashboard-page mt-2">

        <h2 class="mt-3 ml-6 font-weight-light">单日汇总({{ dates }})</h2>

        <v-row>
          <v-col cols="4">
            <v-card outlined class="ml-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">所有订单管理的总成交额({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">33333333.3 ￥</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表总成交额({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">{{ totalAmount.toFixed(2) }} ￥</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">差额({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">33333333.3 ￥</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <v-card outlined class="ml-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表中的总订单数({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">
                  {{ mainPageCardOrderCount }}
                </p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表的真实单数({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">
                  {{ mainPageCardActualOrderCount }}
                </p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表的真实毛利({{ dates }})</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center font-weight-thin">{{ totalProfit.toFixed(2) }} ￥</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <p class="mt-3 ml-6 text-body-2 text--secondary">利润最高({{ dates }}): {{ champion.name }}，毛利润: {{ champion.profit.toFixed(2) }}￥</p>

      </div>
    </v-container>
  </div>
</template>

<script>
// import axios from "axios";

// import VChart from "vue-echarts";
import { mapState } from "vuex";
import { TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, TitleComponent, ToolboxComponent } from "echarts/components";
import { BarChart, LineChart, PieChart } from "echarts/charts";
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

import PageHeader from "@/components/PageHeader";
import { getProfitReport } from "@/settings/profitReport";
import { javaUTCDateToString } from "@/libs/utils";

use([PieChart, TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, BarChart, LineChart, CanvasRenderer, TitleComponent, ToolboxComponent]);

const reg = /-?\d{1,3}(?=(\d{3})+(\.|$))/gy
export const amountBeautify = (num, currency, fixed, error) => {
  if (isNaN(num)) {
    return error
  }
  if (!num && num != 0) {
    return error
  }

  return (currency ? currency + " " : "") + Number(num).toFixed(fixed == 0 ? fixed : fixed || 2).replace(reg, '$&,')
};

export default {
  name: "HelloWorld",
  components: {
    PageHeader,
    // VChart,
  },
  data() {
    return {
      champion: {},
      mainPageCardActualOrderCount: 0,
      mainPageCardOrderCount: 0,
      totalAmount: 0,
      totalProfit: 0,
      profitItems: [],
      observer: null,
      dates: [],
      loading: false,
    };
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 3);
    this.dates = javaUTCDateToString(date);
    this.loadData();
  },

  computed: {
    ...mapState([
      "user",
      "allDepartments",
      "allShops",
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
    ]),

    // chartOption: function () {
    //   return {
    //     tooltip: {
    //       trigger: "axis",
    //     },
    //     legend: {},
    //     grid: {
    //       left: "20",
    //       right: "30",
    //       bottom: "10",
    //       top: "20",
    //       containLabel: true,
    //     },
    //     toolbox: {},
    //     yAxis: [
    //       {
    //         type: "value",
    //         // axisLabel: {
    //         //   show: false,
    //         // },
    //       },
    //     ],
    //     xAxis: [
    //       {
    //         type: "category",
    //         axisLabel: {
    //           show: true,
    //           // interval: 0, //0：全部显示，1：间隔为1显示对应类目，2：依次类推，
    //           rotate: 90, //倾斜显示，-：顺时针旋转，+或不写：逆时针旋转
    //         },
    //         data: this.chartDateData,
    //       },
    //     ],

    //     series: [
    //       {
    //         name: "成交额总和",
    //         type: "line",
    //         data: this.dayAmountItem,
    //       },
    //       {
    //         name: "售后毛利润总和",
    //         type: "line",
    //         data: this.dayProfitItem,
    //       },
    //     ],
    //   };
    // },

    getSize: function () {
      var size;
      size = "width:" + this.$refs.cardsize.clientWidth + ";" + "height:" + this.$refs.cardsize.clientHeight;
      return size;
    },
  },

  mounted() {
    this.observer = new ResizeObserver(() => {
      // this.$refs.echartPersonalRange.resize();
      // this.$refs.echartD.resize();
      // this.$refs.dataCardChart.resize();
      // this.$refs.pieA.resize();
      // this.$refs.pieB.resize();
      // this.$refs.pieC.resize();
    });
    this.observer.observe(document.querySelector("#mainContainer"));
  },

  beforeDestroy() {
    this.observer.unobserve(document.querySelector("#mainContainer"));
  },

  methods: {
    parseDate(date) {
      return javaUTCDateToString(date);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    loadData() {
      var args;
      args = { startDate: this.dates, endDate: this.dates };
      args.startDate = args.startDate.replaceAll("-", "/");
      args.endDate = args.endDate.replaceAll("-", "/");
      this.loadingDialog = true;
      console.log("接口调用", args);
      getProfitReport(args)
        .then((res) => {
          this.loadingDialog = false;
          console.log(res.data);
          if (!res.data.profitReport) {
            this.global.infoAlert("泼发EBC：" + res.data);
            this.profitItems = [];
            return;
          }
          console.log("load");
          this.profitItems = res.data.profitReport;
          this.dataAnalyze();
        })
        .catch(() => {
          this.loading = false;
        });
    },

    dataAnalyze() {
      var personalData = {};
      this.profitItems.forEach((item) => {
        item.calculatedDepartment = this.departmentIdToName[item.department];
        item.calculatedTeam = this.teamIdToName[item.team];
        item.calculatedOwner = this.userIdToNick[item.owner];
        item.calculatedFirstCategory = this.categoryIdToName[item.firstCategory];

        if (item.orderCount == null) {
          item.orderCount = 0;
        }
        if (item.productCount == null) {
          item.productCount = 0;
        }
        if (item.totalAmount == null) {
          item.totalAmount = 0;
        }

        item.deduction /= 100;
        item.freightToPayment /= 100;

        item.calculateTotalAllFakeAmount = item.totalFakeAmount + item.totalPersonalFakeAmount + item.totalPersonalFakeEnablingAmount;

        item.calculatedActualAmount = item.totalAmount - item.calculateTotalAllFakeAmount;
        item.calculatedActualOrderCount = item.orderCount - item.totalFakeCount - item.totalPersonalFakeCount - item.totalPersonalFakeEnablingCount;

        if (item.calculatedActualOrderCount == 0) {
          item.calculatedActualAverageAmount = 0;
        } else {
          item.calculatedActualAverageAmount = item.calculatedActualAmount / item.calculatedActualOrderCount;
        }

        item.calculatedCostRatio = item.totalCost / item.calculatedActualAmount;

        item.calculatedProfitRatio = item.freightToPayment
          ? item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - item.insurance * item.calculatedActualOrderCount - item.freightToPayment * item.totalCost
          : item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - (item.insurance + item.freight) * item.calculatedActualOrderCount;
        item.calculatedProfitRatio /= item.calculatedActualAmount;

        item.calculatedActualIncome = item.calculatedActualAmount - item.totalRefundAmount;
        item.calculatedRefundWithNoShipAmount = item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
        //后加的
        if (isNaN(item.calculatedRefundWithNoShipAmount)) {
          item.calculatedRefundWithNoShipAmount = 0;
        }
        //
        item.calculatedActualCost = item.totalCost - item.calculatedRefundWithNoShipAmount;
        item.calculatedTmallTokeRatio = item.deduction * (item.totalAmount - item.totalRefundAmount - item.totalPersonalFakeAmount);
        item.calculatedTotalFreight = item.freightToPayment ? item.freightToPayment * item.calculatedActualCost : item.freight * (item.calculatedActualOrderCount - item.totalRefundWithNoShipCount);
        item.calculatedTotalInsurance = item.insurance * (item.orderCount - item.totalRefundWithNoShipCount);
        item.calculatedActualProfit =
          item.calculatedActualIncome - item.calculatedActualCost - item.calculatedTmallTokeRatio - item.calculatedTotalInsurance - item.calculatedTotalFreight - item.totalBrokerage;

        item.calculatedActualProfitRatio = item.calculatedActualProfit / item.calculatedActualIncome;

        if (item.calculatedActualProfit < 0 && item.calculatedActualProfitRatio > 0) {
          item.calculatedActualProfitRatio *= -1;
        }

        item.calculatedDiscount = item.totalAmount / item.totalPrice;

        if (item.calculatedActualProfit !== item.calculatedActualProfit) {
          item.calculatedActualProfit = 0;
        }

        if (!personalData[item.calculatedOwner]) {
          personalData[item.calculatedOwner] = 0;
        }
        personalData[item.calculatedOwner] += item.calculatedActualProfit;

        this.mainPageCardActualOrderCount += item.calculatedActualOrderCount;
        this.mainPageCardOrderCount += item.orderCount;
        this.totalAmount += item.totalAmount;
        this.totalProfit += item.calculatedActualProfit;
      });
      console.log(personalData);
      var personalDataArr = [];
      Object.keys(personalData).forEach((key) => {
        personalDataArr.push(key, personalData[key]);
      });
      console.log(personalDataArr);
      var j = 1;
      for (let i = 3; i < personalDataArr.length; i = i + 2) {
        if (personalDataArr[i] > personalDataArr[j]) {
          j = i;
        }
      }
      console.log(personalDataArr[j - 1], personalDataArr[j]);
      this.champion.name = personalDataArr[j - 1];
      this.champion.profit = personalDataArr[j];
    },
  },
};
</script>

<style scoped>
</style>