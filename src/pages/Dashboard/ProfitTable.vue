<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="利润报表">
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
    </PageHeader>
    <div>
      <v-toolbar flat>
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
              color="primary"
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

        <v-btn text small depressed class="mx-2 ml-5" @click="showDetail">
          <v-icon small class="mr-1">
            {{
              check
                ? "mdi-checkbox-marked-outline"
                : "mdi-checkbox-blank-outline"
            }}
          </v-icon>
          <span> 详细数据 </span>
        </v-btn>
      </v-toolbar>
    </div>
    <div class="d-flex">
      <div>
        <v-data-table
          mobile-breakpoint="0"
          id="tablePartA"
          v-show="!loading && check"
          style="width: fit-content"
          class="profit-table profit-table-a"
          height="calc(100vh - 221px)"
          fixed-header
          hide-default-footer
          loading-text="计算中... 请稍后"
          no-data-text="空"
          :items-per-page="50"
          :footer-props="{
            'items-per-page-options': [50, 100, 500],
            'items-per-page-text': '每页显示条数',
          }"
          :options.sync="options"
          :items="loading ? [] : profitItems"
          :headers="profitHeadersPartA"
          :loading="loading"
        >
          <template v-slot:[`item.department`]="{ item }">
            {{ departmentIdToName[item.department] }}
          </template>
          <template v-slot:[`item.team`]="{ item }">
            {{ teamIdToName[item.team] }}
          </template>

          <template v-slot:[`item.owner`]="{ item }">
            {{ userIdToNick[item.owner] }}
          </template>

          <template v-slot:[`item.shopName`]="{ item }">
            <div style="width: 40px">
              {{ item.shopName }}
            </div>
          </template>
          <template v-slot:[`item.productName`]="{ item }">
            <div style="width: 100px">
              {{ item.productName }}
            </div>
          </template>
        </v-data-table>
        <v-divider style="margin-top: 10px"></v-divider>
      </div>
      <v-divider
        v-show="!loading && check"
        vertical
        style="
          margin: 0px;
          height: calc(100vh - 210px);
          min-height: calc(100vh - 210px);
        "
      ></v-divider>
      <v-data-table
        mobile-breakpoint="0"
        id="tablePartB"
        class="profit-table profit-table-b flex-grow-1"
        height="calc(100vh - 211px)"
        fixed-header
        loading-text="计算中... 请稍后"
        no-data-text="空"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [50, 100, 500],
          'items-per-page-text': '每页显示条数',
        }"
        :options.sync="options"
        :items="loading ? [] : profitItems"
        :headers="
          !profitItems.length || loading
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
              {{
                item.totalFakeAmount > 0 ? item.totalFakeAmount.toFixed(2) : ""
              }}
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
          {{
            item.calculatedActualOrderCount > 0
              ? item.calculatedActualOrderCount
              : ""
          }}
        </template>

        <template v-slot:[`item.calculatedActualAverageAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualAverageAmount" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{
                item.calculatedActualAverageAmount > 0
                  ? item.calculatedActualAverageAmount.toFixed(2)
                  : ""
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedCostRatio`]="{ item }">
          {{
            item.calculatedCostRatio > 0
              ? (item.calculatedCostRatio * 100).toFixed(2) + "%"
              : ""
          }}
        </template>

        <template v-slot:[`item.calculatedProfitRatio`]="{ item }">
          {{
            item.calculatedCostRatio > 0
              ? (item.calculatedProfitRatio * 100).toFixed(2) + "%"
              : ""
          }}
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
            <span>
              {{
                !isNaN(item.calculatedRefundWithNoShipAmount)
                  ? "￥  " + item.calculatedRefundWithNoShipAmount.toFixed(2)
                  : ""
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualCost`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedActualCost" class="mr-1"
              >{{ "￥  " }}
            </span>
            <span>
              {{
                item.calculatedActualCost > 0
                  ? item.calculatedActualCost.toFixed(2)
                  : ""
              }}
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
          <span :style="item.wrongCount > 0 ? `color:red` : ``">
            {{ item.wrongCount }}
          </span>
          <v-btn
            v-if="item.wrongCount > 0"
            x-small
            depressed
            text
            class="pa-0"
            @click="showMismatchedSkus(item)"
          >
            啊？
          </v-btn>
        </template>

        <template v-slot:[`item.calculatedActualProfit`]="{ item }">
          <div class="d-flex" :style="item.wrongCount > 0 ? `color:red` : ``">
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
          <span :style="item.wrongCount > 0 ? `color:red` : ``">
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
          <span :style="item.wrongCount > 0 ? `color:red` : ``">
            {{
              item.calculatedDiscount == Infinity
                ? Infinity
                : item.calculatedDiscount > 0
                ? (item.calculatedDiscount * 100).toFixed(2) + " %"
                : ""
            }}
          </span>
        </template>
      </v-data-table>
    </div>
    <v-dialog v-model="mismatchedSkuDialog" max-width="800px">
      <v-card>
        <v-col style="width: fit-content">
          <v-row class="mx-3 pt-4">
            {{ `${selectedProduct.productName}` }}
            <span class="pl-5">{{ selectedProduct.productId }}</span>
            <span class="pl-2">未匹配SKU</span>
            <span class="text--secondary pl-8">{{ this.startTime }}</span>
          </v-row>
        </v-col>

        <v-card-text
          class="mx-5 pt-4"
          style="overflow-y: visible; width: fit-content"
        >
          {{
            `事业部：${
              departmentIdToName[selectedProduct.department]
            }ㅤㅤㅤ组别：${teamIdToName[selectedProduct.team]}ㅤㅤㅤ持品人：${
              userIdToNick[selectedProduct.owner]
            }`
          }}
        </v-card-text>

        <div class="mx-5">
          <v-data-table
            loading-text="加载中... 请稍后"
            no-data-text="好奇怪！没有未匹配的SKU！注意淘特链接和主链要分开获取SKUID，不然无法准确匹配订单来源，可能会导致此问题。"
            height="422px"
            fixed-header
            :headers="mismatchedSkuheaders"
            :items="mismatchedSkus"
            :loading="mismatchedSkuLoading"
            item-key="skuName"
            :items-per-page="10"
            :footer-props="{
              'items-per-page-options': [10, 20, 50, 100],
              'items-per-page-text': '每页显示条数',
            }"
          />
        </div>

        <!-- <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click.stop="mismatchedSkuDialog = false"
          >
            关闭
          </v-btn>
        </v-card-actions> -->
      </v-card>
    </v-dialog>
  </div>
</template>


<script>
import { amountBeautify } from "@/libs/utils";
import { javaUTCDateToString } from "@/libs/utils";
import { getProfitReport } from "@/settings/profitReport";
import { getMismatchedSkus } from "@/settings/profitReport";

import { mapState } from "vuex";

import PageHeader from "@/components/PageHeader";

export default {
  components: {
    PageHeader,
  },
  data() {
    return {
      scrollFlag: 0,
      options: {},
      search: {},

      startTime: "",
      endTime: "",

      dateEnd: "",

      menu: null,
      menu2: null,

      datePicker: false,
      datePicker2: false,

      check: false,
      loading: false,

      midVarOfProfitItems: [],
      profitHeadersPartA: [
        //{ text: "日期", value: "date" },
        { text: "部门", value: "department" },
        { text: "组别", value: "team" }, //1
        { text: "店铺", value: "shopName" }, //1
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
        { text: "商品ID", value: "productId" },
      ],

      profitItems: [],
      profitHeadersAll: [
        { text: "一级类目", value: "firstCategory" }, //1
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

      mismatchedSkuheaders: [
        { text: "SKU名称", value: "skuName" },
        { text: "销售数量", value: "productCount" },
        { text: "销售金额", value: "totalAmount" },
      ],
      mismatchedSkus: [],
      selectedProduct: {},
      mismatchedSkuLoading: false,
      mismatchedSkuDialog: false,
    };
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.startTime = javaUTCDateToString(date);
    this.loadData();
  },

  mounted() {
    this.tablePartAWrapper = document.querySelector(
      "#tablePartA .v-data-table__wrapper"
    );
    this.tablePartBWrapper = document.querySelector(
      "#tablePartB .v-data-table__wrapper"
    );
    //const box2 = document.querySelector(".box2");

    var left = true;
    this.tablePartBWrapper.addEventListener("scroll", (event) => {
      if (this.scrollFlag < event.timeStamp - 50) {
        this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
        left = true;
      } else {
        if (left) {
          this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
        } else {
          this.tablePartBWrapper.scrollTop = this.tablePartAWrapper.scrollTop;
        }
      }
      this.scrollFlag = event.timeStamp;
    });

    this.tablePartAWrapper.addEventListener("scroll", (event) => {
      if (this.scrollFlag < event.timeStamp - 50) {
        this.tablePartBWrapper.scrollTop = this.tablePartAWrapper.scrollTop;
        left = false;
      } else {
        if (left) {
          this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
        } else {
          this.tablePartBWrapper.scrollTop = this.tablePartAWrapper.scrollTop;
        }
      }
      this.scrollFlag = event.timeStamp;
    });
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

  watch: {
    search: {
      handler() {
        this.filter();
      },
      deep: true,
      immediate: true,
    },
  },

  methods: {
    showDetail() {
      this.check = !this.check;
      setTimeout(() => {
        this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
      }, 0);
    },
    filter() {
      this.midVarOfProfitItems = this.profitItems;
      if (this.search.team?.length > 0) {
        var team = {};
        this.search.team.forEach((i) => (team[i] = true));
        this.midVarOfProfitItems = this.midVarOfProfitItems.filter(
          (profitItem) => team[profitItem.team]
        );
      }

      if (this.search.department?.length > 0) {
        var department = {};
        this.search.department.forEach((i) => (department[i] = true));
        this.midVarOfProfitItems = this.midVarOfProfitItems.filter(
          (profitItem) => department[profitItem.department]
        );
      }

      if (this.search.owner?.length > 0) {
        var owner = {};
        this.search.owner.forEach((i) => (owner[i] = true));
        this.midVarOfProfitItems = this.midVarOfProfitItems.filter(
          (profitItem) => owner[profitItem.owner]
        );
      }
    },
    remove(props, option) {
      console.log(option);
      console.log(this.search);
      console.log(this.profitItems);
      this.search[props.header.value].splice(option.index, 1);
    },
    showMismatchedSkus(item) {
      this.selectedProduct = item;
      this.mismatchedSkuDialog = true;
      this.mismatchedSkuLoading = true;
      var args = {
        date: this.startTime,
        productId: this.selectedProduct.productId,
      };
      args.date = args.date.replaceAll("-", "/");
      getMismatchedSkus(args)
        .then((res) => {
          console.log("getmismatchedSkus返回的结果", res);
          this.mismatchedSkus = res.data.mismatchedSkus;
          this.mismatchedSkuLoading = false;
        })
        .catch(() => {
          this.mismatchedSkuLoading = false;
        });
    },
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
      getProfitReport(args)
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          for (let name in res.data) {
            this.profitItems = res.data[name];
            this.dataAnalyze(name);
            break;
          }
          setTimeout(() => {
            this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
          }, 0);
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
      this.midVarOfProfitItems = [...this.profitItems];
    },
  },
};
</script>

<style lang="scss">
.v-data-table.profit-table {
  tr {
    td {
      height: 23px !important;

      text-overflow: ellipsis;
      overflow: hidden;
      div {
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }
  }
  width: 0%;
}

.v-data-table.profit-table tr:not(.v-data-table__progress) > th {
  padding-right: 0px !important;
  padding-left: 8px !important;
}

.profit-table-a {
  .v-data-table__wrapper::-webkit-scrollbar {
    display: none;
  }
  tr {
    td {
      padding-right: 4px !important;
      padding-left: 4px !important;
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