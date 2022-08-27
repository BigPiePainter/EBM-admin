<template>
  <div>
    <v-card class="mb-1">
      <v-data-table
        class="profit-table"
        height="calc(100vh - 200px)"
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        :items-per-page="100"
        :footer-props="{
          'items-per-page-options': [50, 100, 500, 1000, 2000],
          'items-per-page-text': '每页显示条数',
        }"
        :items="profitItems"
        :headers="
          !profitItems.length
            ? []
            : check
            ? profitHeadersAll
            : profitHeadersHide
        "
        :loading="loading"
      >
        <template v-slot:[`item.insurance`]="{ item }">
          <div class="d-flex">
            <span v-if="item.insurance" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ item.insurance ? item.insurance.toFixed(2) : "————" }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.deduction`]="{ item }">
          <div class="d-flex">
            <span>
              {{
                item.deduction
                  ? (item.deduction * 100).toFixed(1) + " %"
                  : "   " + "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.extraRatio`]="{ item }">
          <div class="d-flex">
            <span v-if="item.extraRatio" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ item.extraRatio ? item.extraRatio.toFixed(2) + "%" : "————" }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalAmount" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ amountFormat(item.totalAmount, 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalFakeAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalFakeAmount" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ item.totalFakeAmount && item.totalFakeAmount.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.freight`]="{ item }">
          {{
            item.freightToPayment
              ? (item.freightToPayment * 100).toFixed(2) + "%"
              : "￥" + item.freight
          }}
        </template>

        <template v-slot:[`item.totalCost`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalCost" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ amountFormat(item.totalCost, 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalRefundAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalRefundAmount" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{
                item.totalRefundAmount
                  ? item.totalRefundAmount.toFixed(2)
                  : "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalRefundWithNoShipAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalRefundWithNoShipAmount" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{
                item.totalRefundWithNoShipAmount
                  ? item.totalRefundWithNoShipAmount.toFixed(2)
                  : "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalBrokerage`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalBrokerage" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{
                item.totalBrokerage ? item.totalBrokerage.toFixed(2) : "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalPrice`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalPrice" class="mr-1">{{ "￥  " }} </span>
            <span>
              {{ item.totalPrice ? item.totalPrice.toFixed(2) : "————" }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualAmount" class="mr-1">￥</span>
            <span>
              {{ amountFormat(item.calculatedActualAmount, 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualOrderCount`]="{ item }">
          {{ item.calculatedActualOrderCount }}
        </template>

        <template v-slot:[`item.calculatedActualAverageAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualAverageAmount" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ item.calculatedActualAverageAmount.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedCostRatio`]="{ item }">
          {{ (item.calculatedCostRatio * 100).toFixed(2) + "%" }}
        </template>

        <template v-slot:[`item.calculatedProfitRatio`]="{ item }">
          {{ (item.calculatedProfitRatio * 100).toFixed(2) + "%" }}
        </template>

        <template v-slot:[`item.calculatedActualIncome`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualIncome" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ amountFormat(item.calculatedActualIncome, 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedRefundWithNoShipAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedRefundWithNoShipAmount" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ item.calculatedRefundWithNoShipAmount.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualCost`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualCost" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ item.calculatedActualCost.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedTmallTokeRatio`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedTmallTokeRatio" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ amountFormat(item.calculatedTmallTokeRatio, 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.department`]="{ item }">
          {{ global.log(departmentIdToName) }}
          {{ departmentIdToName[item.department] }}
        </template>
        <template v-slot:[`item.team`]="{ item }">
          {{ teamIdToName[item.team] }}
        </template>
        <template v-slot:[`item.owner`]="{ item }">
          {{ userIdToNick[item.owner] }}
        </template>
        <template v-slot:[`item.firstCategory`]="{ item }">
          {{ categoryIdToName[item.firstCategory] }}
        </template>

        <template v-slot:[`item.calculatedTotalFreight`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedTotalFreight" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ item.calculatedTotalFreight.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedTotalInsurance`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedTotalInsurance" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{ item.calculatedTotalInsurance.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.wrongCount`]="{ item }">
          <span :style="item.wrongCount == 0 ? `` : `color:red`">
            {{ item.wrongCount }}
          </span>
        </template>

        <template v-slot:[`item.calculatedActualProfit`]="{ item }">
          <div class="d-flex" :style="item.wrongCount == 0 ? `` : `color:red`">
            <span v-if="item.calculatedActualProfit">{{ "￥ " }} </span>
            <span>
              <span>
                {{
                  item.wrongCount != 0
                    ? "0.00"
                    : amountFormat(item.calculatedActualProfit, 2, "————")
                }}
              </span>
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualProfitRatio`]="{ item }">
          <span :style="item.wrongCount == 0 ? `` : `color:red`">
            {{
              item.wrongCount == 0
                ? item.calculatedActualProfitRatio >= 0
                  ? (item.calculatedActualProfitRatio * 100).toFixed(2) + " %"
                  : "————"
                : "0.00 %"
            }}
          </span>
        </template>

        <template v-slot:[`item.calculatedDiscount`]="{ item }">
          <span :style="item.wrongCount == 0 ? `` : `color:red`">
            {{
              item.calculatedDiscount == Infinity
                ? Infinity
                : (item.calculatedDiscount * 100).toFixed(2) + " %"
            }}
          </span>
        </template>

        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>利润报表（单日）</v-toolbar-title>
            <v-divider class="mx-1" inset vertical></v-divider>

            <span
              class="text-subtitle-2 ml-3 mr-1 text--secondary"
              style="margin-top: 2px"
            >
              日期选择
            </span>
            <v-menu
              ref="menu"
              v-model="datePicker"
              :close-on-content-click="false"
              :return-value.sync="startTime"
              offset-y
            >
              <template v-slot:activator="{ on, attrs }">
                <v-text-field
                  class="shrink ml-1 date-picker-textfield"
                  v-model="startTime"
                  readonly
                  v-bind="attrs"
                  v-on="on"
                  outlined
                  dense
                  hide-details
                  color="blue-grey lighten-1"
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
            <span
              class="text-subtitle-2 ml-3 mr-2 text--secondary"
              style="margin-top: 2px"
            >
              ~
            </span>
            <v-menu
              ref="menu2"
              v-model="datePicker2"
              :close-on-content-click="false"
              :return-value.sync="endTime"
              offset-y
            >
              <template v-slot:activator="{ on, attrs }">
                <v-text-field
                  class="shrink ml-1 date-picker-textfield"
                  v-model="endTime"
                  readonly
                  v-bind="attrs"
                  v-on="on"
                  outlined
                  dense
                  hide-details
                  color="blue-grey lighten-1"
                  disabled
                ></v-text-field>
              </template>
              <v-date-picker
                v-model="endTime"
                no-title
                scrollable
                locale="zh-cn"
                first-day-of-week="1"
                :day-format="dayFormat"
                min="2021-01-01"
                :max="parseDate(new Date())"
              >
                <v-spacer></v-spacer>
                <v-btn text color="primary" @click="datePicker2 = false">
                  取消
                </v-btn>
                <v-btn
                  text
                  color="primary"
                  @click="
                    $refs.menu.save(endTime);
                    loadData();
                  "
                >
                  确定
                </v-btn>
              </v-date-picker>
            </v-menu>

            <v-btn
              text
              small
              depressed
              class="mx-2 ml-5"
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
          </v-toolbar>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>


<script>
import { amountBeautify } from "@/libs/utils";
import { javaUTCDateToString } from "@/libs/utils";
import { getDailyReport } from "@/settings/order";
import { mapState } from "vuex";

export default {
  data() {
    return {
      startTime: "",
      endTime: "",

      dateEnd: "",

      menu: null,
      menu2: null,

      datePicker: false,
      datePicker2: false,

      check: false,
      loading: false,
      profitItems: [],
      profitHeadersAll: [
        { text: "日期", value: "date" },
        { text: "部门", value: "department" },
        { text: "组别", value: "team" }, //1
        { text: "店铺", value: "shopName" }, //1
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "一级类目", value: "firstCategory" }, //1
        //_____________________________________________________________筛选
        { text: "商品ID", value: "productId" }, //1
        { text: "扣点", value: "deduction" }, //1
        { text: "运费险", value: "insurance" }, //1
        { text: "运费", value: "freight" }, //1,2 freight or topayment1
        { text: "子/主", value: "extraRatio" }, //1
        { text: "成交额", value: "totalAmount" }, //1
        { text: "订单数", value: "orderCount" }, //1
        { text: "销售数", value: "productCount" }, //1
        { text: "补单额", value: "totalFakeAmount" }, //1
        { text: "补单数", value: "fakeOrderCount" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //成交额-补单额1
        { text: "真实单数", value: "calculatedActualOrderCount" }, //订单数-补单数1
        { text: "单均价", value: "calculatedActualAverageAmount" }, //真实金额/真实单数1
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
        { text: "刷单佣金", value: "totalBrokerage" }, //1
        { text: "售后毛利润", value: "calculatedActualProfit" }, //净收入额-拿货成本（售后）-平台扣点-运费险-快递费-刷单佣金1
        { text: "售后利润率", value: "calculatedActualProfitRatio" }, //售后毛利润/净收入额(为负时显示"-")
        { text: "SKU未匹配", value: "wrongCount" }, //1
        { text: "折扣", value: "calculatedDiscount" }, //成交额/原售价
        { text: "错数", value: "operatorGivenWrongPriceCount" }, //(定价<实际成交价 的订单条数)
        { text: "原售价", value: "totalPrice" }, //1
        //{ text: "厂家返款", value: "" },
        //----------------------------------------------------------------------
      ],
      profitHeadersHide: [
        { text: "日期", value: "date" },
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "真实金额", value: "calculatedActualAmount" }, //2
        { text: "真实单数", value: "calculatedActualOrderCount" }, //2
        { text: "拿货成本", value: "totalCost" }, //1
        { text: "成本率", value: "calculatedCostRatio" },
        { text: "利润率", value: "calculatedProfitRatio" },
        { text: "退款金额", value: "totalRefundAmount" }, //1
        { text: "未发仅退", value: "totalRefundWithNoShipAmount" }, //1
        { text: "未发退本", value: "calculatedRefundWithNoShipAmount" },
        { text: "净收入额", value: "calculatedActualIncome" },
        { text: "拿货成本（售后）", value: "calculatedActualCost" }, //2
        { text: "售后毛利润", value: "calculatedActualProfit" },
        { text: "售后利润率", value: "calculatedActualProfitRatio" },
        { text: "SKU未匹配", value: "wrongCount" },
        { text: "折扣", value: "calculatedDiscount" },
        { text: "错数", value: "operatorGivenWrongPriceCount" },
        //----------------------------------------------------------------------
      ],
    };
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 1);
    this.startTime = javaUTCDateToString(date);
    this.loadData();
  },

  computed: {
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

  methods: {
    amountFormat() {
      return amountBeautify(...arguments);
    },

    parseDate(date) {
      return javaUTCDateToString(date);
    },

    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    loadData() {
      var args = { date: this.startTime };
      args.date = args.date.replaceAll("-", "/");

      this.loading = true;

      console.log("接口调用", args);
      getDailyReport(args)
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          for (let name in res.data) {
            this.profitItems = res.data[name];
            this.dataAnalyze(name);
            break;
          }
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
    },
  },
};
</script>

<style lang="scss">
.profit-table {
  tr {
    td {
      height: 23px !important;
    }
  }
}

.date-picker-textfield {
  max-width: 125px;
  .v-input__slot {
    min-height: 0px !important;

    .v-text-field__slot > input {
      padding-top: 4px !important;
      padding-bottom: 4px !important;
      font-size: 15px;
    }
  }
}
</style>