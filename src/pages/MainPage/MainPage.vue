<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="主页"> </PageHeader>
    <v-container fluid id="mainContainer">
      <div class="dashboard-page">
        <div class="ma-5 d-flex flex-column">
          <span>开发中</span>
          <span>...</span>
        </div>

        <!-- <v-row>
        <v-col cols="4">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">今日总销售额/退款额/毛利润</p>
            </v-card-title>
            <v-chart
              style="height: 480px"
              :option="allTurnoverBarOption"
              ref="echartA"
            ></v-chart>
          </v-card>
        </v-col>

        <v-col cols="8">
          <v-row>
            <v-col cols="6">
              <v-card
                class="mx-1 mb-1"
                style="position: relative; height: 250px"
                ><v-card-title class="pb-0" style="height: 0px"
                  ><p>今日数据</p></v-card-title
                >
                <v-chart
                  style="height: 235px"
                  :option="dataCardChart"
                  ref="dataCardChart"
                >
                </v-chart>
              </v-card>
            </v-col>

            <v-col cols="6">
              <v-card class="mx-1 mb-1"
                ><v-chart
                  style="height: 250px"
                  :option="departmentsTurnoverPieOption"
                  ref="pieA"
                ></v-chart>
              </v-card>
            </v-col>
          </v-row>

          <v-row>
            <v-col cols="6">
              <v-card class="mx-1 mb-1"
                ><v-chart
                  style="height: 250px"
                  :option="departmentsProfitPieOption"
                  ref="pieB"
                ></v-chart>
              </v-card>
            </v-col>

            <v-col cols="6">
              <v-card class="mx-1 mb-1"
                ><v-chart
                  style="height: 250px"
                  :option="departmentsRteurnPieOption"
                  ref="pieC"
                ></v-chart>
              </v-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row> 

      <v-row>
        <v-col cols="12">
          <v-card class="mx-1 mb-1">
            <v-card-title>
              <p class="caption">小组毛利润汇总条形图</p>
            </v-card-title>
            <v-chart
              style="height: 500px"
              :option="groupsProfitBarOption"
              ref="echartD"
            ></v-chart>
          </v-card>
        </v-col>
      </v-row>
      --></div>
    </v-container>
  </div>
</template>

<script>
// import axios from "axios";

//import VChart from "vue-echarts";
import {
  TooltipComponent,
  GridComponent,
  LegendComponent,
  MarkLineComponent,
  TitleComponent,
  ToolboxComponent,
} from "echarts/components";
import { BarChart, LineChart, PieChart } from "echarts/charts";
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

import PageHeader from "@/components/PageHeader";

use([
  PieChart,
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
  },
  data() {
    return {
      observer: null,
      allTurnoverBarOption: {
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
            data: ["部门A", "部门B", "部门C"],
          },
        ],
        yAxis: [
          {
            type: "value",
          },
        ],
        series: [
          {
            name: "退款",
            type: "bar",
            data: [20, 32, 31],
          },
          {
            name: "毛利润",
            type: "bar",
            data: [60, 40, 60],
          },
          {
            name: "营业额",
            type: "bar",
            data: [90, 78, 110],
          },
        ],
      },

      dataCardChart: {
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
        toolbox: {},
        xAxis: [
          {
            type: "category",
            data: ["营业额", "毛利", "退款"],
          },
        ],
        yAxis: [
          {
            type: "value",
          },
        ],
        series: [
          {
            type: "bar",
            data: [60, 30, 20],
          },
        ],
      },

      departmentsTurnoverPieOption: {
        legend: {
          top: "bottom",
        },
        toolbox: {
          show: true,
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            restore: { show: true },
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: "营业额饼图",
            type: "pie",
            radius: [30, 100],
            center: ["70%", "50%"],
            roseType: "area",
            itemStyle: {
              borderRadius: 3,
            },
            labelLine: {
              normal: {
                show: false,
                length: 45,
                length2: 45,
              },
            },
            label: { normal: { show: false } },
            data: [
              { value: 40, name: "部门A" },
              { value: 38, name: "部门B" },
              { value: 32, name: "部门C" },
            ],
          },
        ],
      },

      departmentsProfitPieOption: {
        legend: {
          top: "bottom",
        },
        toolbox: {
          show: true,
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            restore: { show: true },
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: "营业额饼图",
            type: "pie",
            radius: [30, 100],
            center: ["70%", "50%"],
            roseType: "area",
            itemStyle: {
              borderRadius: 3,
            },
            labelLine: {
              normal: {
                show: false,
                length: 45,
                length2: 45,
              },
            },
            label: { normal: { show: false } },
            data: [
              { value: 40, name: "部门A" },
              { value: 38, name: "部门B" },
              { value: 32, name: "部门C" },
            ],
          },
        ],
      },

      departmentsRteurnPieOption: {
        legend: {
          top: "bottom",
        },
        toolbox: {
          show: true,
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            restore: { show: true },
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: "营业额饼图",
            type: "pie",
            radius: [30, 100],
            center: ["70%", "50%"],
            roseType: "area",
            itemStyle: {
              borderRadius: 3,
            },
            labelLine: {
              normal: {
                show: false,
                length: 45,
                length2: 45,
              },
            },
            label: { normal: { show: false } },
            data: [
              { value: 40, name: "部门A" },
              { value: 38, name: "部门B" },
              { value: 32, name: "部门C" },
            ],
          },
        ],
      },

      groupsProfitBarOption: {
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
        xAxis: {
          type: "value",
        },
        yAxis: {
          type: "category",
          axisTick: {
            show: false,
          },
          data: [
            "YJX",
            "WQ",
            "JY",
            "PL",
            "AY",
            "QJH1/WXF1",
            "CJY",
            "HWX",
            "XW",
            "ZC",
            "QJH/WXF",
          ],
        },
        series: [
          {
            name: "营业额",
            type: "bar",
            barWidth: 2,
            label: {
              show: true,
            },
            data: [640, 600, 630, 688, 800, 600, 640, 600, 630, 688, 640],
          },

          {
            name: "毛利润",
            type: "bar",
            stack: "Total",
            label: {
              show: true,
            },
            data: [320, 302, 301, 334, 390, 330, 320, 302, 301, 334, 320],
          },
          {
            name: "成本",
            type: "bar",
            stack: "Total",
            label: {
              show: true,
            },
            data: [320, 298, 329, 354, 410, 270, 320, 298, 329, 354, 320],
          },
          {
            name: "退款",
            type: "bar",
            stack: "Total",
            label: {
              show: true,
              position: "left",
            },
            data: [
              -120, -132, -101, -134, -190, -230, -210, -101, -134, -190, -230,
            ],
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
    this.observer = new ResizeObserver(() => {
      this.$refs.echartA.resize();
      this.$refs.echartD.resize();
      this.$refs.dataCardChart.resize();
      this.$refs.pieA.resize();
      this.$refs.pieB.resize();
      this.$refs.pieC.resize();
    });
    this.observer.observe(document.querySelector("#mainContainer"));

    console.log("开始request");
    // axios.get("https://tgc.tmall.com/ds/api/v1/supplier/product/list?page=1&itemsPerPage=10&title=&ids=&planId=&scmBarcode=", {}).then(res =>{
    //   console.log("结果", res)
    // });

    function loadScript(url, func) {
      var head = document.head;
      var script = document.createElement("script");

      script.src = url;

      script.onload = script.onreadystatechange = function () {
        if (
          !this.readyState ||
          this.readyState == "loaded" ||
          this.readyState == "complete"
        ) {
          func();
          script.onload = script.onreadystatechange = null;
        }
      };

      head.appendChild(script, 0);
    }

    loadScript("https://tgc.tmall.com/ds/api/v1/supplier/product/list?page=1&itemsPerPage=10&title=&ids=&planId=&scmBarcode=", function(){console.log("完毕！")})
  },

  beforeDestroy() {
    this.observer.unobserve(document.querySelector("#mainContainer"));
  },

  method: {},
};
</script>

<style scoped>
</style>