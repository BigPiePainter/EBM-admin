<template>
  <v-container fluid id="mainContainer">
    <div class="dashboard-page">
      <v-row no-gutters class="d-flex justify-space-between mt-2">
        <h1 class="page-title">利润报表--还在做呢</h1>
      </v-row>

      <v-row>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">今日总销售额/退款额/毛利润</p>
              <v-spacer />
              <v-btn small color="primary" @click.stop="totalChartButton"
                ><span>完整图表</span></v-btn
              >
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="totalChartOption"
              ref="echartA"
            ></v-chart>
          </v-card>
        </v-col>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">部门毛利润比较折线图</p>
              <v-spacer />
              <v-btn small color="primary" @click="departmentProfitChartButton"
                ><span>完整图表</span></v-btn
              >
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="departmentsProfitLineOption"
              ref="echartB"
            ></v-chart>
          </v-card>
        </v-col>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">部门销售额比较折线图</p>
              <v-spacer />
              <v-btn
                small
                color="primary"
                @click="departmentTurnoverChartButton"
                ><span>完整图表</span></v-btn
              >
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="departmentsTurnoverLineOption"
              ref="echartC"
            ></v-chart>
          </v-card>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">小组毛利润汇总条形图</p>
              <v-spacer />
              <v-btn small color="primary" @click="groupProfitChartButton"
                ><span>完整图表</span></v-btn
              >
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="groupsProfitBarOption"
              ref="echartD"
            ></v-chart>
          </v-card>
        </v-col>
      </v-row>
      <template>
        <v-dialog v-model="showTotalChartDialog"
          ><v-card
            >
            <v-card-title><p class="caption">总销售额/退款额/毛利润</p></v-card-title><v-chart
              style="height: 500px"
              :option="totalChartOption"
              ref="echartA"
            ></v-chart></v-card
        ></v-dialog>
        <v-dialog v-model="showGroupProfitChartDialog"
          ><v-card></v-card
        ></v-dialog>
        <v-dialog v-model="showDepartmentProfitChartDialog"
          ><v-card></v-card
        ></v-dialog>
        <v-dialog v-model="showDepartmentTurnoverChartDialog"
          ><v-card></v-card
        ></v-dialog>
      </template>
    </div>
  </v-container>
</template>

<script>
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
    VChart,
  },
  data() {
    return {
      showTotalChartDialog: false,
      showGroupProfitChartDialog: false,
      showDepartmentProfitChartDialog: false,
      showDepartmentTurnoverChartDialog: false,
      departmentsTurnoverLineOption: {
        tooltip: {
          trigger: "axis",
        },
        legend: {
          data: ["Email", "Union Ads", "Video Ads", "Direct", "Search Engine"],
        },
        grid: {
          left: "3%",
          right: "4%",
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
          boundaryGap: false,
          data: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        },
        yAxis: {
          type: "value",
        },
        series: [
          {
            name: "Email",
            type: "line",

            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: "Union Ads",
            type: "line",

            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: "Video Ads",
            type: "line",

            data: [150, 232, 201, 154, 190, 330, 410],
          },
          {
            name: "Direct",
            type: "line",

            data: [320, 332, 301, 334, 390, 330, 320],
          },
          {
            name: "Search Engine",
            type: "line",

            data: [820, 932, 901, 934, 1290, 1330, 1320],
          },
        ],
      },
      departmentsProfitLineOption: {
        tooltip: {
          trigger: "axis",
        },
        legend: {
          data: ["Email", "Union Ads", "Video Ads", "Direct"],
        },
        grid: {
          left: "3%",
          right: "4%",
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
          boundaryGap: false,
          data: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        },
        yAxis: {
          type: "value",
        },
        series: [
          {
            name: "Email",
            type: "line",

            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: "Union Ads",
            type: "line",

            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: "Video Ads",
            type: "line",

            data: [150, 232, 201, 154, 190, 330, 410],
          },
          {
            name: "Direct",
            type: "line",

            data: [320, 332, 301, 334, 390, 330, 320],
          },
        ],
      },
      totalChartOption: {
        tooltip: {
          trigger: "axis",
          axisPointer: {
            type: "shadow",
          },
        },
        legend: {},
        grid: {
          left: "3%",
          right: "4%",
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
            data: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
          },
        ],
        yAxis: [
          {
            type: "value",
          },
        ],
        series: [
          {
            name: "Direct",
            type: "bar",
            emphasis: {
              focus: "series",
            },
            data: [320, 332, 301, 334, 390, 330, 320],
          },
          {
            name: "Email",
            type: "bar",
            stack: "Ad",
            emphasis: {
              focus: "series",
            },
            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: "Union Ads",
            type: "bar",
            stack: "Ad",
            emphasis: {
              focus: "series",
            },
            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: "Video Ads",
            type: "bar",
            stack: "Ad",
            emphasis: {
              focus: "series",
            },
            data: [150, 232, 201, 154, 190, 330, 410],
          },
          {
            name: "Search Engine",
            type: "bar",
            data: [862, 1018, 964, 1026, 1679, 1600, 1570],
            emphasis: {
              focus: "series",
            },
            markLine: {
              lineStyle: {
                type: "dashed",
              },
              data: [[{ type: "min" }, { type: "max" }]],
            },
          },
          {
            name: "Baidu",
            type: "bar",
            barWidth: 5,
            stack: "Search Engine",
            emphasis: {
              focus: "series",
            },
            data: [620, 732, 701, 734, 1090, 1130, 1120],
          },
          {
            name: "Google",
            type: "bar",
            stack: "Search Engine",
            emphasis: {
              focus: "series",
            },
            data: [120, 132, 101, 134, 290, 230, 220],
          },
          {
            name: "Bing",
            type: "bar",
            stack: "Search Engine",
            emphasis: {
              focus: "series",
            },
            data: [60, 72, 71, 74, 190, 130, 110],
          },
          {
            name: "Others",
            type: "bar",
            stack: "Search Engine",
            emphasis: {
              focus: "series",
            },
            data: [62, 82, 91, 84, 109, 110, 120],
          },
        ],
      },
      groupsProfitBarOption: {
        tooltip: {
          trigger: "axis",
          axisPointer: {
            // Use axis to trigger tooltip
            type: "shadow", // 'shadow' as default; can also be 'line' or 'shadow'
          },
        },
        legend: {},
        grid: {
          left: "3%",
          right: "4%",
          bottom: "3%",
          containLabel: true,
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
        },
        xAxis: {
          type: "value",
        },
        yAxis: {
          type: "category",
          data: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        },
        series: [
          {
            name: "Direct",
            type: "bar",
            stack: "total",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: [320, 302, 301, 334, 390, 330, 320],
          },
          {
            name: "Mail Ad",
            type: "bar",
            stack: "total",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: "Affiliate Ad",
            type: "bar",
            stack: "total",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: "Video Ad",
            type: "bar",
            stack: "total",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: [150, 212, 201, 154, 190, 330, 410],
          },
          {
            name: "Search Engine",
            type: "bar",
            stack: "total",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: [820, 832, 901, 934, 1290, 1330, 1320],
          },
        ],
      },
    };
  },
  computed: {
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

  methods: {
    totalChartButton() {
      this.showTotalChartDialog = true;
    },
    departmentProfitChartButton() {
      this.showTotalChartDialog = true;
    },
    departmentTurnoverChartButton() {
      this.showTotalChartDialog = true;
    },
    groupProfitChartButton() {
      this.showTotalChartDialog = true;
    },
  },
};
</script>

<style scoped>
</style>