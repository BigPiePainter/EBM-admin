<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="统计图">
      <v-btn
        class="ml-2"
        text
        color="primary"
        :disabled="loading || datePicker"
        @click="changeDateRangeButton"
      >
        <v-icon v-if="isDateRange" size="20" style="padding-top: 2px"
          >mdi-calendar-blank</v-icon
        >
        <v-icon v-else size="20" style="padding-top: 2px"
          >mdi-calendar-blank-multiple</v-icon
        >
        <span> {{ isDateRange ? "关闭时间段模式" : "开启时间段模式" }} </span>
      </v-btn>
    </PageHeader>
    <div>
      <v-col md="auto" class="mx-2 mb-3">
        <v-row>
          <span class="group-title"> 日期选择 </span>
        </v-row>
        <v-row>
          <v-menu
            ref="menu"
            v-model="datePicker"
            :close-on-content-click="false"
            :return-value.sync="dates"
            offset-y
          >
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                class="date-picker-textfield search-input"
                style="max-width: 200px"
                v-model="dateRangeText"
                readonly
                v-bind="attrs"
                v-on="on"
                outlined
                dense
                hide-details
                color="primary"
              ></v-text-field>
            </template>
            <v-date-picker
              v-model="dates"
              no-title
              scrollable
              locale="zh-cn"
              color="primary"
              :range="isDateRange"
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
                  $refs.menu.save(dates);
                  loadData();
                "
              >
                确定
              </v-btn>
            </v-date-picker>
          </v-menu>
        </v-row>
      </v-col>
    </div>

    <div>
      <div class="d-flex">
        <v-container fluid id="mainContainer">
          <v-row>
            <v-col cols="4">
              <v-card class="ml-3 mx-1 mb-1">
                <v-card-title>
                  <p class="caption">部门真实金额</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart
                  style="height: 300px"
                  :option="departmentsOption"
                  ref="echartH"
                ></v-chart>
              </v-card>
            </v-col>

            <v-col cols="8">
              <v-card class="mr-3 mx-1 mb-1">
                <v-card-title>
                  <p class="caption">总成交额/售后毛利润</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart
                  style="height: 300px"
                  :option="sumProfitInLongTime"
                  ref="echartA"
                ></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="ml-3 mr-3 mx-1 mb-1">
                <v-card-title>
                  <p class="ml-3 pt-3 caption">
                    店铺真实成交数汇总(已减去个人及团队补单)
                  </p>
                </v-card-title>
                <v-chart
                  :style="{ height: echartShopHeight }"
                  :option="shopsOption"
                  ref="echartShop"
                >
                </v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="ml-3 mr-3 mx-1 mb-1">
                <v-card-title>
                  <p class="caption">小组成交额/小组真实金额</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart
                  :style="{ height: echartTeamAmountHeight }"
                  :option="teamsAmountOption"
                  ref="echartTeamAmount"
                ></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="ml-3 mr-3 mx-1 mb-1">
                <v-card-title>
                  <p class="caption">小组售后毛利润</p>
                </v-card-title>
                <v-chart
                  :style="{ height: echartTeamProfitHeight }"
                  :option="teamsProfitOption"
                  ref="echartTeamProfit"
                ></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-dialog width="100px" v-model="loadingDialog"
            ><v-card class="pl-4">正在加载</v-card></v-dialog
          >
        </v-container>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

import PageHeader from "@/components/PageHeader";

import VChart from "vue-echarts";

import {
  TooltipComponent,
  GridComponent,
  LegendComponent,
  MarkLineComponent,
  TitleComponent,
  ToolboxComponent,
} from "echarts/components";

import { BarChart, LineChart } from "echarts/charts";

import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

import { getProfitReport } from "@/settings/profitReport";
import { javaUTCDateToString } from "@/libs/utils";

use([
  TooltipComponent,
  GridComponent,
  LegendComponent,
  MarkLineComponent,
  BarChart,
  LineChart,
  CanvasRenderer,
  TitleComponent,
  ToolboxComponent,
]);

export const zeroPadding = (num) => {
  return (num + "").padStart(2, 0);
};

export default {
  name: "HelloWorld",
  components: {
    PageHeader,
    VChart,
  },
  data() {
    return {
      observer: null,

      a: [],
      menu: null,
      datePicker: false,
      chartDepartmentItems: {},
      chartTeamItems: {},
      profitItems: [],
      shopActualOrderCount: {},
      argsDays: [],
      daysProfitItems: [],
      daysProfitObj: {},
      dayProfitItem: [],
      dayAmountItem: [],

      departmentData: [],
      teamData: [],
      departmentSeries: [],
      departmentSeries2: [],
      teamSeries: [],
      teamSeries2: [],
      sumProfitInLongTimeSeries: [],

      showDepartmentChartDialog: false,
      showTeamChartDialog: false,
      loadingDialog: false,

      isDateRange: false,
      dates: [],
      loading: false,
      chartDateData: [],
      pp: [],
      aa: [],
    };
  },
  computed: {
    echartTeamAmountHeight() {
      var height;
      height = this.teamData.length * 35 + 150 + "px";
      return height;
    },

    echartTeamProfitHeight() {
      var height;
      height = this.teamData.length * 20 + 150 + "px";
      return height;
    },

    echartShopHeight() {
      var height;
      height = Object.keys(this.shopActualOrderCount).length * 20 + 150 + "px";
      return height;
    },

    dateRangeText() {
      if (this.isDateRange) {
        return new Date(this.dates[1]).getTime() -
          new Date(this.dates[0]).getTime() <
          0
          ? this.dates[1] + "  ~  " + this.dates[0]
          : this.dates.join("  ~  ");
      } else {
        return this.dates;
      }
    },

    shopsOption: function () {
      return {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "100",
          right: "30",
          bottom: "50",
          top: "0",
          //containLabel: true,
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        yAxis: {
          type: "category",
          data: Object.keys(this.shopActualOrderCount),
        },
        xAxis: {
          type: "value",
        },
        series: {
          label: {
            show: true,
            position: "right",
            valueAnimation: true,
          },
          //name: "店铺成交数汇总",
          type: "bar",
          barWidth: 15,
          data: Object.values(this.shopActualOrderCount),
        },
      };
    },

    departmentsOption: function () {
      return {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "100",
          right: "30",
          bottom: "40",
          //containLabel: true,
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        xAxis: {
          type: "category",
          data: this.departmentData,
        },
        yAxis: {
          type: "value",
        },
        series: this.departmentSeries,
      };
    },

    teamsAmountOption: function () {
      return {
        // tooltip: {
        //   trigger: "axis",
        // },
        legend: {},
        grid: {
          left: "100",
          right: "30",
          bottom: "50",
          top: "50",
          //containLabel: true,
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        xAxis: [
          {
            type: "value",
            axisLabel: {
              show: false,
              // interval: 0, //0：全部显示，1：间隔为1显示对应类目，2：依次类推，
              // rotate: -30, //倾斜显示，-：顺时针旋转，+或不写：逆时针旋转
            },
          },
        ],
        yAxis: [
          {
            inverse: true,
            type: "category",
            data: this.teamData,
          },
        ],
        series: [{ ...this.teamSeries[0] }, { ...this.teamSeries[1] }],
      };
    },

    teamsProfitOption: function () {
      return {
        // tooltip: {
        //   trigger: "axis",
        // },
        legend: {},
        grid: {
          left: "100",
          right: "30",
          bottom: "50",
          top: "0",
          //containLabel: true,
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        xAxis: [
          {
            type: "value",
            axisLabel: {
              show: false,
            },
          },
        ],
        yAxis: [
          {
            inverse: true,
            type: "category",
            data: this.teamData,
          },
        ],

        series: [{ ...this.teamSeries[2] }],
      };
    },

    sumProfitInLongTime: function () {
      return {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "50",
          right: "30",
          bottom: "100",
          top: "0",
          //containLabel: true,
        },
        toolbox: {},
        yAxis: [
          {
            type: "value",
            axisLabel: {
              show: false,
            },
          },
        ],
        xAxis: [
          {
            type: "category",
            axisLabel: {
              show: true,
              // interval: 0, //0：全部显示，1：间隔为1显示对应类目，2：依次类推，
              rotate: 90, //倾斜显示，-：顺时针旋转，+或不写：逆时针旋转
            },
            data: this.chartDateData,
          },
        ],

        series: [
          {
            name: "成交额总和",
            type: "line",
            data: this.dayAmountItem,
          },
          {
            name: "售后毛利润总和",
            type: "line",
            data: this.dayProfitItem,
          },
        ],
      };
    },

    getSize: function () {
      var size;
      size =
        "width:" +
        this.$refs.cardsize.clientWidth +
        ";" +
        "height:" +
        this.$refs.cardsize.clientHeight;
      return size;
    },

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
  },

  mounted() {
    var observer = new ResizeObserver(() => {
      this.$refs.echartA.resize();
      this.$refs.echartShop.resize();
      // this.$refs.echartC.resize();
      this.$refs.echartTeamAmount.resize();
      //this.$refs.echartE.resize();
      this.$refs.echartTeamProfit.resize();
      // this.$refs.echartG.resize();
      this.$refs.echartH.resize();
    });
    observer.observe(document.querySelector("#mainContainer"));
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.dates = javaUTCDateToString(date);
    this.loadData();
  },

  methods: {
    teamChartButton() {
      this.showTeamChartDialog = true;
    },
    departmentChartButton() {
      this.showDepartmentChartDialog = true;
    },

    parseDate(date) {
      return javaUTCDateToString(date);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    sortByDate(dayIndex) {
      return (a, b) => {
        var value1 = a[dayIndex];
        var value2 = b[dayIndex];
        return value1 - value2;
      };
    },

    changeDateRangeButton() {
      if (this.isDateRange) {
        var d2 = this.dates[1] || this.dates[0];
        this.isDateRange = false;
        this.dates = d2;
      } else {
        var d = this.dates;
        console.log(d);
        this.isDateRange = true;
        this.dates = [d, d];
        console.log(this.dates);
        setTimeout(() => {
          console.log(this.dates);
        }, 1000);
      }
    },

    loadData() {
      var args;
      this.daysProfitObj = {};
      this.daysProfitItems = [];
      this.argsDays = [];
      if (this.isDateRange) {
        var dayStartUTC = Date.parse(this.dates[0]);
        args = { startDate: this.dates[0], endDate: this.dates[1] };
        //计算日期，循环请求多天
        for (
          let i = 0;
          i <=
          (Date.parse(this.dates[1]) - Date.parse(this.dates[0])) / 86400000;
          i++
        ) {
          var days = new Date(dayStartUTC + i * 86400000);
          var argsDay = {
            startDate: `${days.getFullYear()}/${zeroPadding(
              days.getMonth() + 1
            )}/${zeroPadding(days.getDate())}`,
            endDate: `${days.getFullYear()}/${zeroPadding(
              days.getMonth() + 1
            )}/${zeroPadding(days.getDate())}`,
          };
          this.argsDays.push(argsDay);
        }
        console.log(this.argsDays);
        for (let i = 0; i < this.argsDays.length; i++) {
          getProfitReport(this.argsDays[i])
            .then((res) => {
              this.loadingDialog = false;
              console.log("返回每日数据：");
              console.log(res.data);
              if (!res.data.profitReport) {
                this.global.infoAlert("泼发EBC：" + res.data);
                this.daysProfitItems = [];
                return;
              }
              //将所请求的日期传到daysProfitAnalyze方法中作为参数使用
              for (let name in res.data) {
                this.daysProfitItems = res.data[name];
                this.daysProfitAnalyze(this.argsDays[i].startDate);
                break;
              }
              setTimeout(() => {}, 0);
            })
            .catch(() => {
              this.loading = false;
            });
        }
      } else {
        var dayStartUTCDef = Date.parse(this.dates);
        args = { startDate: this.dates, endDate: this.dates };
        for (let i = 0; i <= 30; i++) {
          var daysDef = new Date(dayStartUTCDef - i * 86400000);
          var argsDayDef = {
            startDate: `${daysDef.getFullYear()}/${zeroPadding(
              daysDef.getMonth() + 1
            )}/${zeroPadding(daysDef.getDate())}`,
            endDate: `${daysDef.getFullYear()}/${zeroPadding(
              daysDef.getMonth() + 1
            )}/${zeroPadding(daysDef.getDate())}`,
          };
          this.argsDays.push(argsDayDef);
        }
        for (let i = 0; i < this.argsDays.length; i++) {
          getProfitReport(this.argsDays[i])
            .then((res) => {
              this.loadingDialog = false;
              console.log("返回每日数据：");
              console.log(res.data);
              if (!res.data.profitReport) {
                this.global.infoAlert("泼发EBC：" + res.data);
                this.daysProfitItems = [];
                return;
              }
              //将所请求的日期传到daysProfitAnalyze方法中作为参数使用
              for (let name in res.data) {
                this.daysProfitItems = res.data[name];
                this.daysProfitAnalyze(this.argsDays[i].startDate);
                break;
              }
              setTimeout(() => {}, 0);
            })
            .catch(() => {
              this.loading = false;
            });
        }
      }
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
          //取出res.data中的key,传到adtaAnalyze方法中作为参数使用
          for (let name in res.data) {
            this.profitItems = res.data[name];
            this.dataAnalyze(name);
            break;
          }

          setTimeout(() => {}, 0);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    daysProfitAnalyze(date) {
      var dayIndex = new Date(date);
      this.daysProfitObj[date] = {
        dayIndex: 0,
        daysTotalProfit: 0,
        daysTotalAmount: 0,
      };
      this.daysProfitItems.forEach((item) => {
        item.date = date;
        item.deduction /= 100;
        item.freightToPayment /= 100;
        item.calculatedActualAmount = item.totalAmount - item.totalFakeAmount;
        item.calculatedActualOrderCount =
          item.orderCount - item.totalFakeCount - item.totalPersonalFakeCount;
        item.calculatedActualAverageAmount =
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
        item.calculatedProfitRatio /= item.calculatedActualAmount;
        item.calculatedActualIncome =
          item.calculatedActualAmount - item.totalRefundAmount;
        item.calculatedRefundWithNoShipAmount =
          item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
        if (isNaN(item.calculatedRefundWithNoShipAmount)) {
          item.calculatedRefundWithNoShipAmount = 0;
        }
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
        if (item.calculatedActualProfit !== item.calculatedActualProfit) {
          item.calculatedActualProfit = 0;
        }
        this.daysProfitObj[date]["daysTotalProfit"] =
          this.daysProfitObj[date]["daysTotalProfit"] +
          item.calculatedActualProfit;

        this.daysProfitObj[date]["daysTotalAmount"] =
          this.daysProfitObj[date]["daysTotalAmount"] + item.totalAmount;
      });
      this.daysProfitObj[date]["dayIndex"] = Date.parse(dayIndex);
      console.log("处理后的每日报表");
      console.log(this.daysProfitObj);
      // console.log(Object.keys(this.daysProfitObj).sort());
      this.chartDateData = Object.keys(this.daysProfitObj).sort();
      console.log(this.chartDateData);
      console.log(
        Object.values(this.daysProfitObj).sort(this.sortByDate("dayIndex"))
      );
      var chartArr = Object.values(this.daysProfitObj).sort(
        this.sortByDate("dayIndex")
      );
      this.dayAmountItem = [];
      this.dayProfitItem = [];
      chartArr.forEach((item) => {
        this.dayProfitItem.push(item.daysTotalProfit.toFixed());
        this.dayAmountItem.push(item.daysTotalAmount.toFixed());
      });
      console.log(this.dayAmountItem);
    },

    dataAnalyze(name) {
      this.profitItems.forEach((item) => {
        item.name = name;
        item.dates = this.dates;
        item.deduction /= 100;
        item.freightToPayment /= 100;

        item.calculatedActualAmount = item.totalAmount - item.totalFakeAmount;
        item.calculatedActualOrderCount =
          item.orderCount - item.totalFakeCount - item.totalPersonalFakeCount;
        item.calculatedActualAverageAmount =
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
        item.calculatedProfitRatio /= item.calculatedActualAmount;

        item.calculatedActualIncome =
          item.calculatedActualAmount - item.totalRefundAmount;
        item.calculatedRefundWithNoShipAmount =
          item.totalRefundWithNoShipAmount * item.calculatedCostRatio;

        //后加的
        if (isNaN(item.calculatedRefundWithNoShipAmount)) {
          item.calculatedRefundWithNoShipAmount = 0;
        }
        //

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

        item.calculatedActualProfitRatio =
          item.calculatedActualProfit / item.calculatedActualIncome;

        item.calculatedDiscount = item.totalAmount / item.totalPrice;
      });

      this.chartDepartmentItems = {};
      this.chartTeamItems = {};

      this.profitItems.forEach((i) => {
        if (!this.chartDepartmentItems[i.department]) {
          this.chartDepartmentItems[i.department] = {
            chartTotalAmount: 0,
            chartCalculatedActualAmount: 0,
            chartCalculatedActualProfit: 0,
          };
        }
        if (!this.chartTeamItems[i.team]) {
          this.chartTeamItems[i.team] = {
            chartTotalAmount: 0,
            chartCalculatedActualAmount: 0,
            chartCalculatedActualProfit: 0,
          };
        }
        if (i.totalAmount !== i.totalAmount) {
          i.totalAmount = 0;
        }
        if (i.calculatedActualAmount !== i.calculatedActualAmount) {
          i.calculatedActualAmount = 0;
        }
        if (i.calculatedActualProfit !== i.calculatedActualProfit) {
          i.calculatedActualProfit = 0;
        }

        this.chartDepartmentItems[i.department].chartTotalAmount +=
          i.totalAmount;
        this.chartDepartmentItems[i.department].chartCalculatedActualAmount +=
          i.calculatedActualAmount;
        this.chartDepartmentItems[i.department].chartCalculatedActualProfit +=
          i.calculatedActualProfit;

        this.chartTeamItems[i.team].chartTotalAmount += i.totalAmount;
        this.chartTeamItems[i.team].chartCalculatedActualAmount +=
          i.calculatedActualAmount;
        this.chartTeamItems[i.team].chartCalculatedActualProfit +=
          i.calculatedActualProfit;
      });

      this.shopActualOrderCount = {};

      for (let i = 0; i < this.profitItems.length; i++) {
        if (
          !Object.keys(this.shopActualOrderCount).includes(
            this.profitItems[i].shopName
          )
        ) {
          this.shopActualOrderCount[this.profitItems[i].shopName] =
            this.profitItems[i].calculatedActualOrderCount;
        } else {
          this.shopActualOrderCount[this.profitItems[i].shopName] +=
            this.profitItems[i].calculatedActualOrderCount;
        }
      }
      //console.log(this.shopActualOrderCount);

      this.departmentSeries = [
        {
          name: "成交额",
          type: "bar",
          data: [],
        },
        {
          name: "真实金额",
          type: "bar",
          data: [],
        },
        {
          name: "售后毛利润",
          type: "bar",
          data: [],
        },
      ];

      this.teamSeries = [
        {
          // realtimeSort: true,
          barGap: 0,
          label: {
            show: true,
            position: "right",
            valueAnimation: true,
          },
          name: "成交额",
          type: "bar",
          barWidth: 13,
          color: "#00bbff",
          data: [],
        },
        {
          label: {
            show: true,
            position: "right",
            valueAnimation: true,
          },
          realtimeSort: true,
          name: "真实金额",
          type: "bar",
          barWidth: 13,
          color: "#00AA11",
          data: [],
        },
        {
          label: {
            show: true,
            position: "right",
            valueAnimation: true,
          },
          realtimeSort: true,
          //name: "售后毛利润",
          type: "bar",
          barWidth: 15,
          color: "#00BBFF",
          data: [],
        },
      ];

      this.departmentData = [];
      var a = [
        "chartTotalAmount",
        "chartCalculatedActualAmount",
        "chartCalculatedActualProfit",
      ];
      // "chartCalculatedActualProfit",
      var b = Object.keys(this.chartDepartmentItems);

      // console.log(11111);
      // console.log(this.chartDepartmentItems);
      for (let i = 0; i < b.length; i++) {
        this.departmentData[i] =
          this.departmentIdToName[Object.keys(this.chartDepartmentItems)[i]];
      }

      for (let i = 0; i < a.length; i++) {
        // console.log(a[i]);
        for (let j = 0; j < b.length; j++) {
          // console.log(typeof a[i]);
          // console.log(this.chartDepartmentItems[b[j]]);
          this.departmentSeries[i].data.push(
            Math.round(this.chartDepartmentItems[b[j]][a[i]])
          );
        }
      }

      this.teamData = [];
      var c = Object.keys(this.chartTeamItems);

      for (let i = 0; i < c.length; i++) {
        this.teamData[i] =
          this.teamIdToName[Object.keys(this.chartTeamItems)[i]];
      }
      console.log(this.teamData);

      for (let i = 0; i < a.length; i++) {
        for (let j = 0; j < c.length; j++) {
          this.teamSeries[i].data.push(
            this.chartTeamItems[c[j]][a[i]].toFixed(2)
          );
        }
      }

      // console.log(this.chartTeamItems);
      // console.log(this.departmentSeries);
      // console.log(this.teamSeries);
      // console.log("生成teamSeries");

      // for (let i = 0; i < a.length; i++) {
      //   for (let j = 0; j < b.length; j++) {
      //     this.departmentSeries[i].data[j].map(function (item) {
      //       return {
      //         value: item,
      //         itemStyle: {
      //           normal: {
      //             label: {
      //               show: true,
      //               textStyle: {
      //                 fontSize: 12,
      //               },
      //             },
      //           },
      //         },
      //       };
      //     });
      //   }
      // }
    },
  },

  beforeDestroy() {
    this.observer.unobserve(document.querySelector("#mainContainer"));
  },
};
</script>

<style scoped>
</style>