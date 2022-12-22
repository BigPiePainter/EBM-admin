<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="统计图"> </PageHeader>
    <v-col md="auto" class="mx-2">
      <v-row>
        <span class="group-title"> 日期选择 </span>
      </v-row>
      <v-row>
        <v-menu
          ref="menu"
          v-model="datePicker"
          :close-on-content-click="false"
          :return-value.sync="startTime"
          offset-y
        >
          <template v-slot:activator="{ on, attrs }">
            <v-text-field
              class="date-picker-textfield search-input"
              style="max-width: 120px"
              v-model="startTime"
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
            v-model="startTime"
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
                $refs.menu.save(startTime);
                loadData();
              "
            >
              确定
            </v-btn>
          </v-date-picker>
        </v-menu>
      </v-row>
    </v-col>
    <v-container fluid id="mainContainer">
      <div class="dashboard-page">
        <v-row>
          <v-col lg="4" md="6" sm="12">
            <v-card class="mx-1 mb-1">
              <v-card-title>
                <p class="caption">部门报表</p>
                <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                >
              </v-card-title>
              <v-chart
                style="height: 500px"
                :option="departmentsOption"
                ref="echartA"
              ></v-chart>
            </v-card>
          </v-col>
          <v-col lg="4" md="6" sm="12">
            <v-card class="mx-1 mb-1">
              <v-card-title>
                <p class="caption">小组报表</p>
                <v-spacer />
                <v-btn small color="primary" @click.stop="teamChartButton"
                  ><span>完整图表</span></v-btn
                >
              </v-card-title>
              <v-chart
                style="height: 500px"
                :option="teamsOption"
                ref="echartB"
              ></v-chart>
            </v-card>
          </v-col>
        </v-row>

        <v-dialog v-model="showDepartmentChartDialog"
          ><v-card>
            <v-card-title><p class="caption">部门报表</p></v-card-title
            ><v-chart
              style="height: 500px"
              :option="departmentsOption"
              ref="echartC"
            ></v-chart></v-card
        ></v-dialog>

        <v-dialog v-model="showTeamChartDialog"
          ><v-card
            ><v-card-title><p class="caption">小组报表</p></v-card-title
            ><v-chart
              style="height: 500px"
              :option="teamsOption"
              ref="echartD"
            ></v-chart></v-card
        ></v-dialog>
      </div>
    </v-container>
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

export default {
  name: "HelloWorld",
  components: {
    PageHeader,
    VChart,
  },
  data() {
    return {
      a: [],
      startTime: "",
      menu: null,
      datePicker: false,
      chartDepartmentItems: {},
      chartTeamItems: {},
      profitItems: [],

      departmentData: [],
      teamData: [],
      departmentSeries: [{}],
      teamSeries: [],

      showDepartmentChartDialog: false,
      showTeamChartDialog: false,
    };
  },
  computed: {
    departmentsOption: function () {
      return {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "10%",
          right: "10%",
          bottom: "3%",
          containLabel: true,
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
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

    teamsOption: function () {
      return {
        tooltip: {
          trigger: "axis",
          axisPointer: {
            type: "shadow",
          },
        },
        legend: {},
        grid: {
          left: "10%",
          right: "10%",
          bottom: "3%",
          containLabel: true,
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
        },
        xAxis: [
          {
            type: "category",
            data: this.teamData,
          },
        ],
        yAxis: [
          {
            type: "value",
          },
        ],
        series: this.teamSeries,
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
      this.$refs.echartB.resize();
      this.$refs.echartC.resize();
      this.$refs.echartD.resize();
    });
    observer.observe(document.querySelector("#mainContainer"));
  },

  created() {
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
    ];
    // {
    //     name: "售后毛利润",
    //     type: "bar",
    //     data: [],
    //   },
    this.teamSeries = [
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
    ];

    // this.a = [
    //   "chartTotalAmount",
    //   "chartCalculatedActualAmount",
    //   "chartCalculatedActualProfit",
    // ];

    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.startTime = javaUTCDateToString(date);
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
    loadData() {
      // var args = { date: this.startTime };
      // args.date = args.date.replaceAll("-", "/");

      var args;
      if (this.isDateRange) {
        args = { startDate: this.startTime, endDate: this.startTime };
      } else {
        args = { startDate: this.startTime, endDate: this.startTime };
      }

      args.startDate = args.startDate.replaceAll("-", "/");
      args.endDate = args.endDate.replaceAll("-", "/");

      this.loading = true;
      console.log("接口调用", args);
      getProfitReport(args)
        .then((res) => {
          this.loading = false;
          console.log(res.data);

          if (!res.data.profitReport) {
            this.global.infoAlert("泼发EBC：" + res.data);
            this.profitItems = [];
            //this.midVarOfProfitItems = this.profitItems;
            return;
          }

          for (let name in res.data) {
            this.profitItems = res.data[name];
            this.dataAnalyze(name);
            //this.midVarOfProfitItems = this.profitItems;
            this.filter();
            break;
          }

          setTimeout(() => {}, 0);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    dataAnalyze(date) {
      this.profitItems.forEach((item) => {
        item.date = date;
        item.deduction /= 100;
        item.freightToPayment /= 100;

        item.calculatedActualAmount = item.totalAmount - item.totalFakeAmount;
        item.calculatedActualOrderCount = item.orderCount - item.fakeOrderCount;
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

      console.log("1111");
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
      console.log(this.chartDepartmentItems);
      console.log(this.chartTeamItems);

      // for (let i = 0; i < this.profitItems.length; i++) {
      //   // console.log(this.chartDepartmentItems.some((id) => id == this.profitItems[i].department) );
      //   if (
      //     this.chartDepartmentItems.some((id) => id == this.profitItems[i].department) == false
      //   ) {
      //     this.chartDepartmentItems.push(this.profitItems[i].department);
      //   }
      //   if (
      //     this.chartTeamItems.some((id) => id == this.profitItems[i].team) == false
      //   ) {
      //     this.chartTeamItems.push(this.profitItems[i].team);
      //   }
      // }
      // console.log(this.chartDepartmentItems);
      // console.log(this.chartTeamItems);
      this.departmentData = [];
      var a = ["chartTotalAmount", "chartCalculatedActualAmount"];
      // "chartCalculatedActualProfit",
      var b = Object.keys(this.chartDepartmentItems);

      console.log(11111);
      console.log(this.chartDepartmentItems);
      for (let i = 0; i < b.length; i++) {
        this.departmentData[i] =
          this.departmentIdToName[Object.keys(this.chartDepartmentItems)[i]];
      }

      for (let i = 0; i < a.length; i++) {
        console.log(a[i]);
        for (let j = 0; j < b.length; j++) {
          console.log(typeof a[i]);
          console.log(this.chartDepartmentItems[b[j]]);
          this.departmentSeries[i].data.push(
            Math.round(this.chartDepartmentItems[b[j]][a[i]])
          );
          console.log(22222);
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
        console.log(3333);
        for (let j = 0; j < c.length; j++) {
          this.teamSeries[i].data.push(
            Math.round(this.chartTeamItems[c[j]][a[i]])
          );
        }
      }

      console.log(this.departmentSeries);

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
};
</script>

<style scoped>
</style>