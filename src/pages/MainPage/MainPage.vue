<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="主页"> </PageHeader>
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
              style="max-width: 120px"
              v-model="dates"
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
    <v-container fluid id="mainContainer">
      <div class="dashboard-page">
        <v-row>
          <v-col cols="4">
            <v-card class="ml-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">所有订单管理的总成交额</p>
              </v-card-title>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表总成交额</p>
              </v-card-title>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">差额</p>
              </v-card-title>
            </v-card>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <v-card class="ml-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表中的总订单数</p>
              </v-card-title>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表的真实单数</p>
              </v-card-title>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="caption">利润报表的真实毛利</p>
              </v-card-title>
            </v-card>
          </v-col>
        </v-row>
      </div>
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
import { getProfitReport } from "@/settings/profitReport";
import { javaUTCDateToString } from "@/libs/utils";

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

      dateText: "",
      datePicker: false,
      dates: [],
      loading: false,
    };
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.dates = javaUTCDateToString(date);
    this.loadData();
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
      // this.$refs.echartA.resize();
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
      console.log("接口调用", args);
      getProfitReport(args)
        .then((res) => {
          console.log(res.data);

          if (!res.data.profitReport) {
            this.global.infoAlert("泼发EBC：" + res.data);
            //this.profitItems = [];
            return;
          }

          // for (let name in res.data) {
          //   this.profitItems = res.data[name];
          //   break;
          // }

          setTimeout(() => {}, 0);
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>

<style scoped>
</style>