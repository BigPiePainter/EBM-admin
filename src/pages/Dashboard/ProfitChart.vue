<template>
  <Page>
    <PageHeader title="统计图">
      <v-menu ref="menu" v-model="datePicker" :close-on-content-click="false" :return-value.sync="date" offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn class="ml-2" text v-bind="attrs" v-on="on" color="primary" :disabled="loading || datePicker">
            <v-icon size="20" style="padding-top: 2px">mdi-calendar-blank</v-icon>
            <span> 日期选择 </span>
          </v-btn>
        </template>
        <v-date-picker v-model="date" no-title scrollable locale="zh-cn" color="primary" first-day-of-week="1" :day-format="dayFormat" min="2021-01-01" :max="parseDate(new Date())">
          <v-spacer></v-spacer>
          <v-btn text color="primary" @click="datePicker = false"> 取消 </v-btn>
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
    </PageHeader>
    <PageBody>
      <div class="d-flex">
        <v-col id="profitChartMainContainer">
          <v-row v-if="Object.keys(departmentChartOptions).length == 0">
            <v-col>
              <v-card class="mx-1 mb-1" outlined :loading="loadingDialogDaily">
                <v-card-title>
                  <p class="text-body-1">部门统计</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <div style="height: 600px"></div>
              </v-card>
            </v-col>
          </v-row>
          <v-row v-else v-for="(item, i) in departmentChartOptions" :key="i">
            <v-col>
              <v-card class="mx-1 mb-1" outlined :loading="loadingDialogDaily">
                <v-card-title>
                  <p class="text-body-1">{{ departmentIdToName[i] + " 的月度统计" }}</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart style="height: 600px" :option="item" ref="departmentCharts"></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="mx-1 mb-1" outlined :loading="!(teamChartOption.series?.length > 0)">
                <v-card-title>
                  <p class="text-body-1">小组 的单日利润剖析与排名 {{ this.date }}</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart :style="{ height: teamChartHeight }" :option="teamChartOption" ref="teamChart"></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="mx-1 mb-1" outlined :loading="!(ownerChartOption.series?.length > 0)">
                <v-card-title>
                  <p class="text-body-1">持品人 的单日利润剖析与排名 {{ this.date }}</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart :style="{ height: ownerChartHeight }" :option="ownerChartOption" ref="ownerChart"></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-card class="mx-1 mb-1" outlined :loading="!(shopChartOption.series?.length > 0)">
                <v-card-title>
                  <p class="text-body-1">店铺 的单日利润剖析与排名 {{ this.date }}</p>
                  <!-- <v-spacer />
                <v-btn small color="primary" @click="departmentChartButton"
                  ><span>完整图表</span></v-btn
                > -->
                </v-card-title>
                <v-chart :style="{ height: shopChartHeight }" :option="shopChartOption" ref="shopChart"></v-chart>
              </v-card>
            </v-col>
          </v-row>
        </v-col>
      </div>
    </PageBody>
  </Page>
</template>

<script>
import { mapState } from "vuex";

import Page from "@/components/Page";
import PageHeader from "@/components/PageHeader";
import PageBody from "@/components/PageBody";

import VChart from "vue-echarts";

import { TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, TitleComponent, ToolboxComponent } from "echarts/components";

import { BarChart, LineChart } from "echarts/charts";

import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

import { getProfitReport } from "@/settings/profitReport";
import { javaUTCDateToString } from "@/libs/utils";

use([TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, BarChart, LineChart, CanvasRenderer, TitleComponent, ToolboxComponent]);

export default {
  name: "ProfitChart",
  components: {
    Page,
    PageHeader,
    PageBody,
    VChart,
  },
  data() {
    return {
      observer: null,

      menu: null,
      datePicker: false,

      loadingDialog: false,
      loadingDialogDaily: false,

      date: "", //当前选择的date
      loading: false,

      profitHeadersForSumup: [
        //进行简单求和的列
        "totalAmount", //1
        "orderCount", //1
        "productCount", //1
        "calculateTotalAllFakeAmount", //1

        "totalFakeCount", //1
        "totalFakeAmount", //1
        "totalPersonalFakeCount",
        "totalPersonalFakeAmount",
        "totalPersonalFakeEnablingCount",
        "totalPersonalFakeEnablingAmount",

        "calculatedActualAmount", //成交额-补单额1
        "calculatedActualOrderCount", //订单数-补单数-个人补单数1
        "totalCost", //1
        "totalRefundAmount", //1
        "calculatedActualIncome", //真实金额-退款金额1
        "totalRefundWithNoShipAmount", //1
        "calculatedRefundWithNoShipAmount", //未发仅退*成本率1
        "calculatedActualCost", //拿货成本-未发退本1
        "calculatedTmallTokeRatio", //扣点*（成交额-退款金额）1
        "calculatedTotalFreight", //每单运费：运费*（真实单数-未发数）；运费/货品成本：运费*拿货成本（售后）1
        "calculatedTotalInsurance", //运费险1*（订单数-未发数）1
        "totalBrokerage", //1
        "calculatedActualProfit", //净收入额-拿货成本（售后）-平台扣点-运费险-快递费-刷单佣金1
        "totalPrice", //1
        //----------------------------------------------------------------------
      ],

      profitItems: {},
      profitItemsCluster: {},

      profitHeadersForGroupby: ["department", "team", "owner", "shopName", "firstCategory"],

      departmentChartOptions: {},

      teamChartOption: {},
      teamChartHeight: "300px",

      ownerChartOption: {},
      ownerChartHeight: "300px",

      shopChartOption: {},
      shopChartHeight: "300px",

      refreshTimeout: 0,
      lastRefreshTime: 0,
    };
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
      return this.date;
    },

    shopsOption: function () {
      return {
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
          top: "23",
          left: "20",
          right: "30",
          bottom: "10",
          containLabel: true,
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        xAxis: {
          type: "category",
          axisLabel: {
            show: true,
            // interval: 0, //0：全部显示，1：间隔为1显示对应类目，2：依次类推，
            rotate: 45, //倾斜显示，-：顺时针旋转，+或不写：逆时针旋转
          },
          data: this.departmentData,
        },
        yAxis: {
          type: "value",
        },
        series: this.departmentSeries,
      };
    },

    getSize: function () {
      var size;
      size = "width:" + this.$refs.cardsize.clientWidth + ";" + "height:" + this.$refs.cardsize.clientHeight;
      return size;
    },
  },

  mounted() {
    var observer = new ResizeObserver(() => {
      console.log(this.$refs);

      this.$refs.departmentCharts?.forEach((i) => i.resize());
      this.$refs.teamChart.resize();
      this.$refs.ownerChart.resize();
      this.$refs.shopChart.resize();
    });
    observer.observe(document.querySelector("#profitChartMainContainer"));
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.date = javaUTCDateToString(date);
    this.loadData();
  },

  methods: {
    zeroPadding(num) {
      return (num + "").padStart(2, 0);
    },
    refreshSingleDayChartData() {
      console.log(this.profitItemsCluster[this.date].team);

      var teamDatas = Object.values(this.profitItemsCluster[this.date].team);
      teamDatas.sort((a, b) => b.calculatedActualProfit - a.calculatedActualProfit);

      var ownerDatas = Object.values(this.profitItemsCluster[this.date].owner);
      ownerDatas.sort((a, b) => b.calculatedActualProfit - a.calculatedActualProfit);

      var shopDatas = Object.values(this.profitItemsCluster[this.date].shopName);
      shopDatas.sort((a, b) => b.calculatedActualProfit - a.calculatedActualProfit);

      console.log(teamDatas);

      this.teamChartHeight = teamDatas.length * 50 + 150 + "px";
      this.ownerChartHeight = ownerDatas.length * 50 + 150 + "px";
      this.shopChartHeight = shopDatas.length * 50 + 150 + "px";

      this.$refs.teamChart.resize();
      this.$refs.ownerChart.resize();
      this.$refs.shopChart.resize();

      this.teamChartOption = {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "80",
          right: "0",
          bottom: "20",
          top: "30",
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        yAxis: [
          {
            inverse: true,
            type: "category",
            data: [], //y轴坐标数据
          },
        ],
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
        series: [],
      };

      this.ownerChartOption = {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "80",
          right: "0",
          bottom: "20",
          top: "30",
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        yAxis: [
          {
            inverse: true,
            type: "category",
            data: [], //y轴坐标数据
          },
        ],
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
        series: [],
      };

      this.shopChartOption = {
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        grid: {
          left: "80",
          right: "0",
          bottom: "20",
          top: "30",
        },
        toolbox: {
          // feature: {
          //   saveAsImage: {},
          // },
        },
        yAxis: [
          {
            inverse: true,
            type: "category",
            data: [], //y轴坐标数据
          },
        ],
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
        series: [],
      };

      this.teamChartOption.yAxis[0].data = teamDatas.map((i) => this.teamIdToName[i.team]);
      this.teamChartOption.series.push({
        name: "总成交额",
        type: "bar",
        stack: "amount",
        data: teamDatas.map((d) => d.totalAmount.toFixed(2)),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });
      this.teamChartOption.series.push({
        name: "拿货成本",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => (d.calculatedActualCost < 0 ? 0 : d.calculatedActualCost.toFixed(2))),
      });
      this.teamChartOption.series.push({
        name: "扣点",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => (d.calculatedTmallTokeRatio < 0 ? 0 : d.calculatedTmallTokeRatio.toFixed(2))),
      });
      this.teamChartOption.series.push({
        name: "运费险",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => (d.calculatedTotalInsurance < 0 ? 0 : d.calculatedTotalInsurance.toFixed(2))),
      });
      this.teamChartOption.series.push({
        name: "运费",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => (d.calculatedTotalFreight < 0 ? 0 : d.calculatedTotalFreight.toFixed(2))),
      });
      this.teamChartOption.series.push({
        name: "刷单佣金",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => (d.totalBrokerage < 0 ? 0 : d.totalBrokerage.toFixed(2))),
      });
      this.teamChartOption.series.push({
        name: "总退款",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => d.totalRefundAmount.toFixed(2)),
      });
      this.teamChartOption.series.push({
        name: "补单额",
        type: "bar",
        stack: "amount3",
        data: teamDatas.map((d) => d.calculateTotalAllFakeAmount.toFixed(2)),
      });
      this.teamChartOption.series.push({
        name: "售后毛利润",
        type: "bar",
        stack: "amount3",
        color: "#91cc75",
        data: teamDatas.map((d) => (d.calculatedActualProfit < 0 ? 0 : d.calculatedActualProfit.toFixed(2))),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });

      this.ownerChartOption.yAxis[0].data = ownerDatas.map((i) => this.userIdToNick[i.owner]);
      this.ownerChartOption.series.push({
        name: "总成交额",
        type: "bar",
        stack: "amount",
        data: ownerDatas.map((d) => d.totalAmount.toFixed(2)),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });
      this.ownerChartOption.series.push({
        name: "拿货成本",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => (d.calculatedActualCost < 0 ? 0 : d.calculatedActualCost.toFixed(2))),
      });
      this.ownerChartOption.series.push({
        name: "扣点",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => (d.calculatedTmallTokeRatio < 0 ? 0 : d.calculatedTmallTokeRatio.toFixed(2))),
      });
      this.ownerChartOption.series.push({
        name: "运费险",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => (d.calculatedTotalInsurance < 0 ? 0 : d.calculatedTotalInsurance.toFixed(2))),
      });
      this.ownerChartOption.series.push({
        name: "运费",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => (d.calculatedTotalFreight < 0 ? 0 : d.calculatedTotalFreight.toFixed(2))),
      });
      this.ownerChartOption.series.push({
        name: "刷单佣金",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => (d.totalBrokerage < 0 ? 0 : d.totalBrokerage.toFixed(2))),
      });
      this.ownerChartOption.series.push({
        name: "总退款",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => d.totalRefundAmount.toFixed(2)),
      });
      this.ownerChartOption.series.push({
        name: "补单额",
        type: "bar",
        stack: "amount3",
        data: ownerDatas.map((d) => d.calculateTotalAllFakeAmount.toFixed(2)),
      });
      this.ownerChartOption.series.push({
        name: "售后毛利润",
        type: "bar",
        stack: "amount3",
        color: "#91cc75",
        data: ownerDatas.map((d) => (d.calculatedActualProfit < 0 ? 0 : d.calculatedActualProfit.toFixed(2))),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });

      this.shopChartOption.yAxis[0].data = shopDatas.map((i) => i.shopName);
      this.shopChartOption.series.push({
        name: "总成交额",
        type: "bar",
        stack: "amount",
        data: shopDatas.map((d) => d.totalAmount.toFixed(2)),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });
      this.shopChartOption.series.push({
        name: "拿货成本",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => (d.calculatedActualCost < 0 ? 0 : d.calculatedActualCost.toFixed(2))),
      });
      this.shopChartOption.series.push({
        name: "扣点",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => (d.calculatedTmallTokeRatio < 0 ? 0 : d.calculatedTmallTokeRatio.toFixed(2))),
      });
      this.shopChartOption.series.push({
        name: "运费险",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => (d.calculatedTotalInsurance < 0 ? 0 : d.calculatedTotalInsurance.toFixed(2))),
      });
      this.shopChartOption.series.push({
        name: "运费",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => (d.calculatedTotalFreight < 0 ? 0 : d.calculatedTotalFreight.toFixed(2))),
      });
      this.shopChartOption.series.push({
        name: "刷单佣金",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => (d.totalBrokerage < 0 ? 0 : d.totalBrokerage.toFixed(2))),
      });
      this.shopChartOption.series.push({
        name: "总退款",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => d.totalRefundAmount.toFixed(2)),
      });
      this.shopChartOption.series.push({
        name: "补单额",
        type: "bar",
        stack: "amount3",
        data: shopDatas.map((d) => d.calculateTotalAllFakeAmount.toFixed(2)),
      });
      this.shopChartOption.series.push({
        name: "售后毛利润",
        type: "bar",
        stack: "amount3",
        color: "#91cc75",
        data: shopDatas.map((d) => (d.calculatedActualProfit < 0 ? 0 : d.calculatedActualProfit.toFixed(2))),
        label: {
          show: true,
          position: "right",
          formatter: "￥{c}",
        },
      });

      this.$refs.teamChart.resize();
      this.$refs.ownerChart.resize();
      this.$refs.shopChart.resize();
    },
    refreshBigChartData(force) {
      var now = new Date();
      if (!force && now.getTime() - this.lastRefreshTime < 2000) {
        clearTimeout(this.refreshTimeout);
        this.refreshTimeout = setTimeout(this.refreshBigChartData, 1000);
        return;
      }
      clearTimeout(this.refreshTimeout);
      this.lastRefreshTime = now.getTime();

      var datas = Object.values(this.profitItemsCluster);

      var endDay = new Date(this.date);
      var startDate = new Date(this.date);
      startDate.setDate(startDate.getDate() - 31);

      var startTimeStemp = startDate.getTime();
      var endTimeStemp = endDay.getTime();

      datas = datas.filter((i) => i.timeStemp <= endTimeStemp && i.timeStemp > startTimeStemp);
      datas.sort((a, b) => a.timeStemp - b.timeStemp);
      //console.log(datas);

      this.departmentChartOptions = {};

      //var colors = ["#5470C6", "#91CC75", "#EE6666"];

      datas.forEach((i) => {
        for (let name in i.department) {
          this.departmentChartOptions[name] = {
            // color: colors,
            tooltip: {
              trigger: "axis",
              axisPointer: {
                type: "cross",
              },
            },
            legend: {},
            grid: {
              left: "20",
              right: "30",
              bottom: "20",
              top: "30",
              containLabel: true,
            },
            toolbox: {},
            yAxis: [
              {
                type: "value",
                position: "left",
                // name: "金额",
                // axisLabel: {
                //   show: false,
                // },
                axisLabel: {
                  formatter: "￥{value}",
                },
                axisLine: {
                  show: true,
                  lineStyle: {
                    //color: colors[0],
                  },
                },
              },
              {
                type: "value",
                position: "right",
                name: "利润",
                // axisLabel: {
                //   show: false,
                // },
                axisLabel: {
                  formatter: "￥{value}",
                },
                axisLine: {
                  show: true,
                  lineStyle: {
                    //color: colors[1],
                  },
                },
              },
              {
                type: "value",
                position: "right",
                name: "订单数",
                // axisLabel: {
                //   show: false,
                // },
                offset: 80,
                axisLine: {
                  show: true,
                  lineStyle: {
                    //color: colors[1],
                  },
                },
              },
            ],
            xAxis: [
              {
                type: "category",
                axisLabel: {
                  show: true,
                  // interval: 0, //0：全部显示，1：间隔为1显示对应类目，2：依次类推，
                  rotate: 45, //倾斜显示，-：顺时针旋转，+或不写：逆时针旋转
                },
                data: [], //x坐标轴数据
              },
            ],

            series: [],
          };
        }
      });

      //console.log(this.departmentChartOptions);

      for (let id in this.departmentChartOptions) {
        this.departmentChartOptions[id].xAxis[0].data = datas.map((i) => i.date.split("-")[1] + "月" + i.date.split("-")[2]);

        this.departmentChartOptions[id].series.push({
          name: "真实成交额",
          stack: "amount",
          barWidth: "40%",
          type: "bar",
          data: datas.map((d) => (d.department[id] ? d.department[id].calculatedActualAmount.toFixed(2) : 0)),
          label: {
            show: true,
            position: "inside",
            rotate: 90,
            fontSize: 12,
            formatter: "￥{c}",
          },
        });
        this.departmentChartOptions[id].series.push({
          name: "售后毛利润",
          type: "line",
          yAxisIndex: 1,
          data: datas.map((d) => (d.department[id] ? d.department[id].calculatedActualProfit.toFixed(2) : 0)),
          label: {
            show: true,
            fontSize: 10,
            formatter: "￥{c}",
          },
          symbolSize: 10,
          itemStyle: {
            normal: {
              lineStyle: {
                width: 5,
              },
            },
          },
        });

        this.departmentChartOptions[id].series.push({
          name: "补单额",
          stack: "amount",
          type: "bar",
          data: datas.map((d) => (d.department[id] ? d.department[id].calculateTotalAllFakeAmount.toFixed(2) : 0)),
        });

        this.departmentChartOptions[id].series.push({
          name: "平台扣点",
          type: "bar",
          barWidth: "20%",
          stack: "amount2",
          data: datas.map((d) => (d.department[id] ? d.department[id].calculatedTmallTokeRatio.toFixed(2) : 0)),
        });

        this.departmentChartOptions[id].series.push({
          name: "退款额",
          type: "bar",
          barWidth: "20%",
          stack: "amount2",
          data: datas.map((d) => (d.department[id] ? d.department[id].totalRefundAmount.toFixed(2) : 0)),
        });

        this.departmentChartOptions[id].series.push({
          name: "真实订单数",
          type: "line",
          yAxisIndex: 2,
          data: datas.map((d) => (d.department[id] ? d.department[id].calculatedActualOrderCount : 0)),
          label: {
            show: true,
            fontSize: 8,
          },
        });
        this.departmentChartOptions[id].series.push({
          name: "补单数",
          type: "line",
          yAxisIndex: 2,
          data: datas.map((d) => (d.department[id] ? d.department[id].totalFakeCount + d.department[id].totalPersonalFakeCount + d.department[id].totalPersonalFakeEnablingCount : 0)),
          label: {
            show: true,
            fontSize: 8,
          },
        });

        this.departmentChartOptions[id].series.push({
          name: "拿货成本",
          type: "bar",
          barWidth: "20%",
          stack: "amount2",
          data: datas.map((d) => (d.department[id] ? d.department[id].calculatedActualCost.toFixed(2) : 0)),
        });
      }

      // Object.keys(this.departmentChartOptions).map((i) => {
      //     return {
      //       name: this.departmentIdToName[i],
      //       type: "bar",
      //       data: datas.map((d) => (d.department[i] ? d.department[i].totalAmount : 0)),
      //     };
      //   });
    },

    parseDate(date) {
      return javaUTCDateToString(date);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    // sortByDate(dayIndex) {
    //   return ;
    // },

    loadData() {
      console.log("loadData");

      this.teamChartOption = {};

      this.loadingDialogDaily = true;

      var loadingFinished = [];

      var totalDays = 31;
      var currentDay = new Date(this.date);

      console.log(totalDays);
      console.log("thisDates", this.date);

      var argsDays = [];

      for (let i = 0; i < totalDays; i++) {
        var daysDef = new Date(currentDay);

        var argsDayDef = {
          startDate: `${daysDef.getFullYear()}/${this.zeroPadding(daysDef.getMonth() + 1)}/${this.zeroPadding(daysDef.getDate())}`,
          endDate: `${daysDef.getFullYear()}/${this.zeroPadding(daysDef.getMonth() + 1)}/${this.zeroPadding(daysDef.getDate())}`,
        };
        argsDays.push(argsDayDef);

        //生成空数据
        this.dataAnalyze(argsDayDef.startDate.replaceAll("/", "-"), []);

        currentDay.setDate(currentDay.getDate() - 1);
      }
      this.refreshBigChartData();

      for (let i = 0; i < argsDays.length; i++) {
        getProfitReport(argsDays[i])
          .then((res) => {
            loadingFinished.push("got");
            if (loadingFinished.length == totalDays) {
              this.loadingDialogDaily = false;
            }

            this.dataAnalyze(argsDays[i].startDate.replaceAll("/", "-"), res.data.profitReport);
            this.refreshBigChartData(!this.loadingDialogDaily);
            if (argsDays[i].startDate.replaceAll("/", "-") == this.date) {
              this.refreshSingleDayChartData();
            }
          })
          .catch(() => {
            this.loading = false;
          });
      }
    },

    // daysProfitAnalyze(date, daysProfitItems) {
    //   this.daysProfitObj[date] = {
    //     dayIndex: new Date(date).getTime(),
    //     daysTotalProfit: 0,
    //     daysTotalAmount: 0,
    //   };

    //   daysProfitItems.forEach((item) => {
    //     item.date = date;
    //     item.calculatedDepartment = this.departmentIdToName[item.department];
    //     item.calculatedTeam = this.teamIdToName[item.team];
    //     item.calculatedOwner = this.userIdToNick[item.owner];
    //     item.calculatedFirstCategory = this.categoryIdToName[item.firstCategory];

    //     if (item.orderCount == null) {
    //       item.orderCount = 0;
    //     }
    //     if (item.productCount == null) {
    //       item.productCount = 0;
    //     }
    //     if (item.totalAmount == null) {
    //       item.totalAmount = 0;
    //     }

    //     item.deduction /= 100;
    //     item.freightToPayment /= 100;

    //     item.calculateTotalAllFakeAmount = item.totalFakeAmount + item.totalPersonalFakeAmount + item.totalPersonalFakeEnablingAmount;

    //     item.calculatedActualAmount = item.totalAmount - item.calculateTotalAllFakeAmount;
    //     item.calculatedActualOrderCount = item.orderCount - item.totalFakeCount - item.totalPersonalFakeCount - item.totalPersonalFakeEnablingCount;

    //     if (item.calculatedActualOrderCount == 0) {
    //       item.calculatedActualAverageAmount = 0;
    //     } else {
    //       item.calculatedActualAverageAmount = item.calculatedActualAmount / item.calculatedActualOrderCount;
    //     }

    //     item.calculatedCostRatio = item.totalCost / item.calculatedActualAmount;

    //     item.calculatedProfitRatio = item.freightToPayment
    //       ? item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - item.insurance * item.calculatedActualOrderCount - item.freightToPayment * item.totalCost
    //       : item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - (item.insurance + item.freight) * item.calculatedActualOrderCount;
    //     item.calculatedProfitRatio /= item.calculatedActualAmount;

    //     item.calculatedActualIncome = item.calculatedActualAmount - item.totalRefundAmount;
    //     item.calculatedRefundWithNoShipAmount = item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
    //     //后加的
    //     if (isNaN(item.calculatedRefundWithNoShipAmount)) {
    //       item.calculatedRefundWithNoShipAmount = 0;
    //     }
    //     //
    //     item.calculatedActualCost = item.totalCost - item.calculatedRefundWithNoShipAmount;
    //     item.calculatedTmallTokeRatio = item.deduction * (item.totalAmount - item.totalRefundAmount - item.totalPersonalFakeAmount);
    //     item.calculatedTotalFreight = item.freightToPayment ? item.freightToPayment * item.calculatedActualCost : item.freight * (item.calculatedActualOrderCount - item.totalRefundWithNoShipCount);
    //     item.calculatedTotalInsurance = item.insurance * (item.orderCount - item.totalRefundWithNoShipCount);
    //     item.calculatedActualProfit =
    //       item.calculatedActualIncome - item.calculatedActualCost - item.calculatedTmallTokeRatio - item.calculatedTotalInsurance - item.calculatedTotalFreight - item.totalBrokerage;

    //     item.calculatedActualProfitRatio = item.calculatedActualProfit / item.calculatedActualIncome;

    //     if (item.calculatedActualProfit < 0 && item.calculatedActualProfitRatio > 0) {
    //       item.calculatedActualProfitRatio *= -1;
    //     }

    //     item.calculatedDiscount = item.totalAmount / item.totalPrice;

    //     if (item.calculatedActualProfit !== item.calculatedActualProfit) {
    //       item.calculatedActualProfit = 0;
    //     }

    //     this.daysProfitObj[date].daysTotalProfit += item.calculatedActualProfit;
    //     this.daysProfitObj[date].daysTotalAmount += item.totalAmount;
    //   });

    //   console.log("处理后的每日报表");
    //   //console.log(this.daysProfitObj);

    //   // console.log(Object.keys(this.daysProfitObj).sort());
    //   this.chartDateData = Object.keys(this.daysProfitObj).sort();
    //   //console.log(this.chartDateData);

    //   var chartArr = Object.values(this.daysProfitObj).sort((a, b) => a.dayIndex - b.dayIndex);

    //   console.log(chartArr);

    //   this.dayProfitItem = chartArr.map((i) => i.daysTotalProfit.toFixed(2));
    //   this.dayAmountItem = chartArr.map((i) => i.daysTotalAmount.toFixed(2));

    //   console.log(this.dayAmountItem);
    // },

    // dataAnalyze() {
    //   this.profitItems.forEach((item) => {
    //     item.dates = this.date;
    //     item.calculatedDepartment = this.departmentIdToName[item.department];
    //     item.calculatedTeam = this.teamIdToName[item.team];
    //     item.calculatedOwner = this.userIdToNick[item.owner];
    //     item.calculatedFirstCategory =
    //       this.categoryIdToName[item.firstCategory];

    //     if (item.orderCount == null) {
    //       item.orderCount = 0;
    //     }
    //     if (item.productCount == null) {
    //       item.productCount = 0;
    //     }
    //     if (item.totalAmount == null) {
    //       item.totalAmount = 0;
    //     }

    //     item.deduction /= 100;
    //     item.freightToPayment /= 100;

    //     item.calculateTotalAllFakeAmount =
    //       item.totalFakeAmount +
    //       item.totalPersonalFakeAmount +
    //       item.totalPersonalFakeEnablingAmount;

    //     item.calculatedActualAmount =
    //       item.totalAmount - item.calculateTotalAllFakeAmount;
    //     item.calculatedActualOrderCount =
    //       item.orderCount -
    //       item.totalFakeCount -
    //       item.totalPersonalFakeCount -
    //       item.totalPersonalFakeEnablingCount;

    //     if (item.calculatedActualOrderCount == 0) {
    //       item.calculatedActualAverageAmount = 0;
    //     } else {
    //       item.calculatedActualAverageAmount =
    //         item.calculatedActualAmount / item.calculatedActualOrderCount;
    //     }

    //     item.calculatedCostRatio = item.totalCost / item.calculatedActualAmount;

    //     item.calculatedProfitRatio = item.freightToPayment
    //       ? item.calculatedActualAmount -
    //         item.totalCost -
    //         item.deduction * item.calculatedActualAmount -
    //         item.insurance * item.calculatedActualOrderCount -
    //         item.freightToPayment * item.totalCost
    //       : item.calculatedActualAmount -
    //         item.totalCost -
    //         item.deduction * item.calculatedActualAmount -
    //         (item.insurance + item.freight) * item.calculatedActualOrderCount;
    //     item.calculatedProfitRatio /= item.calculatedActualAmount;

    //     item.calculatedActualIncome =
    //       item.calculatedActualAmount - item.totalRefundAmount;
    //     item.calculatedRefundWithNoShipAmount =
    //       item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
    //     //后加的
    //     if (isNaN(item.calculatedRefundWithNoShipAmount)) {
    //       item.calculatedRefundWithNoShipAmount = 0;
    //     }
    //     //
    //     item.calculatedActualCost =
    //       item.totalCost - item.calculatedRefundWithNoShipAmount;
    //     item.calculatedTmallTokeRatio =
    //       item.deduction *
    //       (item.totalAmount -
    //         item.totalRefundAmount -
    //         item.totalPersonalFakeAmount);
    //     item.calculatedTotalFreight = item.freightToPayment
    //       ? item.freightToPayment * item.calculatedActualCost
    //       : item.freight *
    //         (item.calculatedActualOrderCount - item.totalRefundWithNoShipCount);
    //     item.calculatedTotalInsurance =
    //       item.insurance * (item.orderCount - item.totalRefundWithNoShipCount);
    //     item.calculatedActualProfit =
    //       item.calculatedActualIncome -
    //       item.calculatedActualCost -
    //       item.calculatedTmallTokeRatio -
    //       item.calculatedTotalInsurance -
    //       item.calculatedTotalFreight -
    //       item.totalBrokerage;

    //     item.calculatedActualProfitRatio =
    //       item.calculatedActualProfit / item.calculatedActualIncome;

    //     if (
    //       item.calculatedActualProfit < 0 &&
    //       item.calculatedActualProfitRatio > 0
    //     ) {
    //       item.calculatedActualProfitRatio *= -1;
    //     }

    //     item.calculatedDiscount = item.totalAmount / item.totalPrice;
    //   });

    //   this.chartDepartmentItems = {};
    //   this.chartTeamItems = {};

    //   this.profitItems.forEach((i) => {
    //     if (!this.chartDepartmentItems[i.department]) {
    //       this.chartDepartmentItems[i.department] = {
    //         chartTotalAmount: 0,
    //         chartCalculatedActualAmount: 0,
    //         chartCalculatedActualProfit: 0,
    //       };
    //     }
    //     if (!this.chartTeamItems[i.team]) {
    //       this.chartTeamItems[i.team] = {
    //         chartTotalAmount: 0,
    //         chartCalculatedActualAmount: 0,
    //         chartCalculatedActualProfit: 0,
    //       };
    //     }
    //     if (i.totalAmount !== i.totalAmount) {
    //       i.totalAmount = 0;
    //     }
    //     if (i.calculatedActualAmount !== i.calculatedActualAmount) {
    //       i.calculatedActualAmount = 0;
    //     }
    //     if (i.calculatedActualProfit !== i.calculatedActualProfit) {
    //       i.calculatedActualProfit = 0;
    //     }

    //     this.chartDepartmentItems[i.department].chartTotalAmount +=
    //       i.totalAmount;
    //     this.chartDepartmentItems[i.department].chartCalculatedActualAmount +=
    //       i.calculatedActualAmount;
    //     this.chartDepartmentItems[i.department].chartCalculatedActualProfit +=
    //       i.calculatedActualProfit;

    //     this.chartTeamItems[i.team].chartTotalAmount += i.totalAmount;
    //     this.chartTeamItems[i.team].chartCalculatedActualAmount +=
    //       i.calculatedActualAmount;
    //     this.chartTeamItems[i.team].chartCalculatedActualProfit +=
    //       i.calculatedActualProfit;
    //   });

    //   this.shopActualOrderCount = {};
    //   this.profitItems.forEach((i) => {
    //     if (!this.shopActualOrderCount[i.shopName]) {
    //       this.shopActualOrderCount[i.shopName] = 0;
    //     }
    //     this.shopActualOrderCount[i.shopName] += i.calculatedActualOrderCount;
    //   });

    //   //console.log(this.shopActualOrderCount);

    //   this.departmentSeries = [
    //     {
    //       barGap: 0,
    //       name: "成交额",
    //       type: "bar",
    //       data: [],
    //     },
    //     {
    //       name: "真实金额",
    //       type: "bar",
    //       data: [],
    //     },
    //     {
    //       name: "售后毛利润",
    //       type: "bar",
    //       data: [],
    //     },
    //   ];

    //   this.teamSeries = [
    //     {
    //       // realtimeSort: true,
    //       barGap: 0,
    //       label: {
    //         show: true,
    //         position: "right",
    //         valueAnimation: true,
    //       },
    //       name: "成交额",
    //       type: "bar",
    //       barWidth: 15,
    //       color: "#00bbff",
    //       data: [],
    //     },
    //     {
    //       label: {
    //         show: true,
    //         position: "right",
    //         valueAnimation: true,
    //       },
    //       realtimeSort: true,
    //       name: "真实金额",
    //       type: "bar",
    //       barWidth: 15,
    //       color: "#00AA11",
    //       data: [],
    //     },
    //     {
    //       label: {
    //         show: true,
    //         position: "right",
    //         valueAnimation: true,
    //       },
    //       realtimeSort: true,
    //       //name: "售后毛利润",
    //       type: "bar",
    //       barWidth: 15,
    //       color: "#00BBFF",
    //       data: [],
    //     },
    //   ];

    //   this.departmentData = [];

    //   // "chartCalculatedActualProfit",

    //   console.log("chartDepartmentItems", this.chartDepartmentItems);

    //   this.departmentData = Object.keys(this.chartDepartmentItems).map(
    //     (i) => this.departmentIdToName[i]
    //   );

    //   console.log("departmentData", this.departmentData);

    //   console.log("1", this.departmentSeries.toString());

    //   // var a = [
    //   //   "chartTotalAmount",
    //   //   "chartCalculatedActualAmount",
    //   //   "chartCalculatedActualProfit",
    //   // ];
    //   // var chartDepartmentItemsKey = Object.keys(this.chartDepartmentItems);
    //   // for (let i = 0; i < a.length; i++) {
    //   //   // console.log(a[i]);
    //   //   for (let j = 0; j < chartDepartmentItemsKey.length; j++) {
    //   //     // console.log(typeof a[i]);
    //   //     // console.log(this.chartDepartmentItems[b[j]]);
    //   //     this.departmentSeries[i].data.push(
    //   //       this.chartDepartmentItems[chartDepartmentItemsKey[j]][a[i]].toFixed(
    //   //         2
    //   //       )
    //   //     );
    //   //   }
    //   // }

    //   this.departmentSeries.find((i) => i.name == "成交额").data =
    //     Object.values(this.chartDepartmentItems).map((i) =>
    //       i.chartTotalAmount.toFixed(2)
    //     );
    //   this.departmentSeries.find((i) => i.name == "真实金额").data =
    //     Object.values(this.chartDepartmentItems).map((i) =>
    //       i.chartCalculatedActualAmount.toFixed(2)
    //     );
    //   this.departmentSeries.find((i) => i.name == "售后毛利润").data =
    //     Object.values(this.chartDepartmentItems).map((i) =>
    //       i.chartCalculatedActualProfit.toFixed(2)
    //     );

    //   console.log("2", this.departmentSeries);

    //   //this.departmentSeries[i]

    //   // this.teamData = [];
    //   // var c = Object.keys(this.chartTeamItems);

    //   // for (let i = 0; i < c.length; i++) {
    //   //   this.teamData[i] =
    //   //     this.teamIdToName[Object.keys(this.chartTeamItems)[i]];
    //   // }
    //   // console.log(this.teamData);

    //   this.teamData = Object.keys(this.chartTeamItems).map(
    //     (i) => this.teamIdToName[i]
    //   );

    //   // for (let i = 0; i < a.length; i++) {
    //   //   for (let j = 0; j < c.length; j++) {
    //   //     this.teamSeries[i].data.push(
    //   //       this.chartTeamItems[c[j]][a[i]].toFixed(2)
    //   //     );
    //   //   }
    //   // }

    //   this.teamSeries.find((i) => i.name == "成交额").data = Object.values(
    //     this.chartTeamItems
    //   ).map((i) => i.chartTotalAmount.toFixed(2));
    //   this.teamSeries.find((i) => i.name == "真实金额").data = Object.values(
    //     this.chartTeamItems
    //   ).map((i) => i.chartCalculatedActualAmount.toFixed(2));
    //   // this.teamSeries.find((i) => i.name == "售后毛利润").data = Object.values(
    //   //   this.chartTeamItems
    //   // ).map((i) => i.chartCalculatedActualProfit.toFixed(2));

    //   // console.log(this.chartTeamItems);
    //   // console.log(this.departmentSeries);
    //   // console.log(this.teamSeries);
    //   // console.log("生成teamSeries");

    //   // for (let i = 0; i < a.length; i++) {
    //   //   for (let j = 0; j < b.length; j++) {
    //   //     this.departmentSeries[i].data[j].map(function (item) {
    //   //       return {
    //   //         value: item,
    //   //         itemStyle: {
    //   //           normal: {
    //   //             label: {
    //   //               show: true,
    //   //               textStyle: {
    //   //                 fontSize: 12,
    //   //               },
    //   //             },
    //   //           },
    //   //         },
    //   //       };
    //   //     });
    //   //   }
    //   // }
    // },

    dataAnalyze(date, profitItems) {
      profitItems.forEach((item) => {
        item.date = date;

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
      });

      this.profitItems[date] = profitItems;
      this.profitItemsCluster[date] = {
        date: date,
        timeStemp: new Date(date).getTime(),
      };
      this.profitHeadersForGroupby.forEach((headerForGroupby) => {
        this.profitItemsCluster[date][headerForGroupby] = {};
      });

      profitItems.forEach((item) => {
        this.profitHeadersForGroupby.forEach((headerForGroupby) => {
          if (!this.profitItemsCluster[date][headerForGroupby][item[headerForGroupby]]) {
            this.profitItemsCluster[date][headerForGroupby][item[headerForGroupby]] = {};
            this.profitItemsCluster[date][headerForGroupby][item[headerForGroupby]][headerForGroupby] = item[headerForGroupby];
            this.profitHeadersForSumup.forEach((headerForSumup) => {
              this.profitItemsCluster[date][headerForGroupby][item[headerForGroupby]][headerForSumup] = 0;
            });
          }
          this.profitHeadersForSumup.forEach((headerForSumup) => {
            this.profitItemsCluster[date][headerForGroupby][item[headerForGroupby]][headerForSumup] += item[headerForSumup];
          });
        });

        if (!this.profitItemsCluster[date].total) {
          this.profitItemsCluster[date].total = {};
          this.profitHeadersForSumup.forEach((headerForSumup) => {
            this.profitItemsCluster[date].total[headerForSumup] = 0;
          });
        }
        this.profitHeadersForSumup.forEach((headerForSumup) => {
          this.profitItemsCluster[date].total[headerForSumup] += item[headerForSumup];
        });
      });

      //console.log("数据：" + date);
      //console.log(this.profitItems);
      //console.log("统计数据", this.profitItemsCluster);
    },
  },

  beforeDestroy() {
    this.observer.unobserve(document.querySelector("#profitChartMainContainer"));
  },
};
</script>

<style scoped>
</style>