<template>
  <v-container fluid id="mainContainer">
    <div class="dashboard-page">
      <v-row no-gutters class="d-flex justify-space-between mt-2">
        <h1 class="page-title">利润报表</h1>
      </v-row>

      <v-row>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">今日总销售额/退款额/毛利润</p>
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="option"
              ref="echartA"
            ></v-chart>
          </v-card>
        </v-col>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">今日总销售额/退款额/毛利润</p>
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="option"
              ref="echartB"
            ></v-chart>
          </v-card>
        </v-col>
        <v-col lg="4" md="6" sm="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">今日总销售额/退款额/毛利润</p>
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="option"
              ref="echartC"
            ></v-chart>
          </v-card>
        </v-col>
      </v-row>
    </div>
  </v-container>
  <!-- <v-card style="margin-right: 10px">
        <div>
       position:absolute;   <v-chart class="chart"
        style="width:100px;height:1000px" :option="option"></v-chart>
        </div>
      </v-card> -->
</template>

<script>
import VChart from "vue-echarts";

import {
  TooltipComponent,
  GridComponent,
  LegendComponent,
  MarkLineComponent,
} from "echarts/components";

import { BarChart } from "echarts/charts";

import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

use([
  TooltipComponent,
  GridComponent,
  LegendComponent,
  MarkLineComponent,
  BarChart,
  CanvasRenderer,
]);

export default {
  name: "HelloWorld",
  components: {
    VChart,
  },
  data() {
    return {
      option: {
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
    });
    observer.observe(document.querySelector("#mainContainer"));
  },

  method: {

  },
};
</script>

<style scoped>
</style>