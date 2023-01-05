<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="利润报表">
      <v-btn
        class="ml-2"
        text
        color="primary"
        @click="download"
        :disabled="loading"
      >
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
      <v-btn class="ml-2" text color="primary" @click="showDetailButton">
        <v-icon v-if="isShowDetail" size="20" style="padding-top: 2px"
          >mdi-arrow-collapse-horizontal</v-icon
        >
        <v-icon v-else size="20" style="padding-top: 2px"
          >mdi-arrow-expand-horizontal</v-icon
        >
        <span> {{ isShowDetail ? "收起详细数据" : "展开详细数据" }} </span>
      </v-btn>
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
      <v-col class="px-8 pt-4 pb-6">
        <v-row>
          <v-col md="auto" class="mx-2">
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
                    style="width: 200px"
                    v-model="dateRangeText"
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    outlined
                    dense
                    hide-details
                    :disabled="loading"
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
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选部门 -->
              <span class="group-title"> 事业部 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                color="primary"
                :items="validDepartments"
                dense
                outlined
                no-data-text="空"
                item-text="name"
                item-value="uid"
                v-model="search.department"
                multiple
                hide-details
                class="search-input search-input"
              >
                <template v-slot:selection="option">
                  <v-chip
                    small
                    close
                    close-icon="mdi-close"
                    color="primary"
                    outlined
                    @click:close="remove('department', option)"
                  >
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选组别 -->
              <span class="group-title"> 组别 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="validTeam"
                dense
                outlined
                item-text="name"
                item-value="uid"
                v-model="search.team"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip
                    small
                    close
                    close-icon="mdi-close"
                    color="primary"
                    outlined
                    @click:close="remove('team', option)"
                  >
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选持品人 -->
              <span class="group-title"> 持品人 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="validOwner"
                dense
                outlined
                item-text="nick"
                item-value="uid"
                v-model="search.owner"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip
                    small
                    close
                    close-icon="mdi-close"
                    color="primary"
                    outlined
                    @click:close="remove('owner', option)"
                  >
                    {{ option.item.nick }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.nick }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2">
            <v-row>
              <!-- 筛选一级类目 -->
              <span class="group-title"> 一级类目 </span>
            </v-row>
            <v-row>
              <v-autocomplete
                no-data-text="空"
                color="primary"
                :items="allCategorys"
                dense
                outlined
                item-text="name"
                item-value="uid"
                v-model="search.categorys"
                multiple
                hide-details
                class="search-input"
              >
                <template v-slot:selection="option">
                  <v-chip
                    small
                    close
                    close-icon="mdi-close"
                    color="primary"
                    outlined
                    @click:close="remove('categorys', option)"
                  >
                    {{ option.item.name }}
                  </v-chip>
                </template>
                <template v-slot:item="data">
                  <span style="font-size: 13px">
                    {{ data.item.name }}
                  </span>
                </template>
              </v-autocomplete>
            </v-row>
          </v-col>
          <v-col class="mx-2" md="auto">
            <v-row>
              <!-- 筛选商品ID -->
              <span class="group-title"> 商品ID </span>
            </v-row>
            <v-row>
              <v-text-field
                color="primary"
                style="max-width: 160px"
                v-model="search.productId"
                outlined
                dense
                clearable
                hide-details
                class="search-input"
              >
              </v-text-field>
            </v-row>
          </v-col>
        </v-row>
      </v-col>
    </div>
    <div class="d-flex">
      <div>
        <v-data-table
          mobile-breakpoint="0"
          id="tablePartA"
          v-show="!loading && isShowDetail"
          style="width: fit-content"
          class="profit-table profit-table-a"
          height="calc(100vh - 221px - 12px)"
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
          :items="loading ? [] : midVarOfProfitItems"
          :headers="profitHeadersShownPartA"
          :loading="loading"
        >
          <template v-slot:[`body.append`]>
            <tr v-if="canShowSumup" class="sumup">
              <td colspan="10">
                <v-divider></v-divider>
                <span style="margin-left: 4px">简单统计：</span>
              </td>
            </tr>
          </template>

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
        v-show="!loading && isShowDetail"
        vertical
        style="
          margin: 0px;
          height: calc(100vh - 210px - 12px);
          min-height: calc(100vh - 210px - 12px);
        "
      ></v-divider>
      <v-data-table
        mobile-breakpoint="0"
        id="tablePartB"
        class="profit-table profit-table-b flex-grow-1"
        height="calc(100vh - 211px - 12px)"
        fixed-header
        loading-text="计算中... 请稍后"
        no-data-text="空"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [50, 100, 500],
          'items-per-page-text': '每页显示条数',
        }"
        :options.sync="options"
        :items="loading ? [] : midVarOfProfitItems"
        :headers="profitHeadersShownPartB"
        :loading="loading"
      >
        <template v-slot:[`body.append`]>
          <tr v-if="canShowSumup" class="sumup">
            <td v-for="i in profitHeadersShownPartB" :key="i.value">
              <v-divider></v-divider>
              <div
                v-if="profitHeadersForSumup.indexOf(i.value) >= 0"
                style="margin-left: 12.8px"
              >
                <div
                  v-if="
                    i.value == `orderCount` ||
                    i.value == `productCount` ||
                    i.value == `calculatedActualOrderCount` ||
                    i.value == `totalFakeCount`
                  "
                >
                  {{
                    amountFormat(sumup(midVarOfProfitItems, i.value), null, 0)
                  }}
                </div>
                <div v-else>
                  <span>
                    {{
                      amountFormat(sumup(midVarOfProfitItems, i.value), "￥")
                    }}
                  </span>
                </div>
              </div>
              <span v-else class="ml-1"></span>
            </td>
          </tr>
        </template>

        <template v-slot:[`item.date`]="{ item }">
          <span>
            {{ item.date }}
          </span>
        </template>

        <template v-slot:[`item.insurance`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.insurance, "￥") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.deduction`]="{ item }">
          <div class="d-flex">
            <span>
              {{
                item.deduction
                  ? (item.deduction * 100).toFixed(2) + " %"
                  : "   " + "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.extraRatio`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.extraRatio, "￥") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalAmount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.totalAmount, "￥") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalFakeAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalFakeAmount">{{ "￥  " }} </span>
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
              : item.freight
              ? "￥" + item.freight
              : ""
          }}
        </template>

        <template v-slot:[`item.totalCost`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.totalCost, "￥", 2, "————") }}
            </span>
            <Help
              class="ml-1"
              v-if="item.wrongCount > 0"
              text="存在未匹配SKU，抓取该SKU的售卖价作为成本"
            />
          </div>
        </template>

        <template v-slot:[`item.totalRefundAmount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.totalRefundAmount, "￥") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalRefundWithNoShipAmount`]="{ item }">
          <div class="d-flex">
            <span v-if="item.totalRefundWithNoShipAmount">{{ "￥  " }} </span>
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
            <span v-if="item.totalBrokerage">{{ "￥  " }} </span>
            <span>
              {{
                item.totalBrokerage ? item.totalBrokerage.toFixed(2) : "————"
              }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.totalPrice`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.totalPrice, "￥", 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualAmount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.calculatedActualAmount, "￥", 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.orderCount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.orderCount, null, 0) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.productCount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.productCount, "", 0) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedActualOrderCount`]="{ item }">
          {{ amountFormat(item.calculatedActualOrderCount, null, 0) }}
        </template>

        <template v-slot:[`item.calculatedActualAverageAmount`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.calculatedActualAverageAmount, "￥") }}
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
            <span>
              {{ amountFormat(item.calculatedActualIncome, "￥", 2, "————") }}
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
            <span>
              {{ amountFormat(item.calculatedActualCost, "￥", 2, "————") }}
            </span>
            <Help
              class="ml-1"
              v-if="item.wrongCount > 0"
              text="存在未匹配SKU，抓取该SKU的售卖价作为成本"
            />
          </div>
        </template>

        <template v-slot:[`item.calculatedTmallTokeRatio`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.calculatedTmallTokeRatio, "￥", 2, "————") }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.department`]="{ item }">
          {{ departmentIdToName[item.department] }}
        </template>
        <template v-slot:[`item.team`]="{ item }">
          {{ teamIdToName[item.team] }}
        </template>
        <template v-slot:[`item.owner`]="{ item }">
          {{ userIdToNick[item.owner] }}
        </template>
        <template v-slot:[`item.firstCategory`]="{ item }">
          <div style="width: 135px">
            {{ categoryIdToName[item.firstCategory] }}
          </div>
        </template>

        <template v-slot:[`item.calculatedTotalFreight`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedTotalFreight">{{ "￥  " }} </span>
            <span>
              {{ item.calculatedTotalFreight.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.calculatedTotalInsurance`]="{ item }">
          <div class="d-flex">
            <span v-if="item.calculatedTotalInsurance">{{ "￥  " }} </span>
            <span>
              {{ item.calculatedTotalInsurance.toFixed(2) }}
            </span>
          </div>
        </template>

        <template v-slot:[`item.wrongCount`]="{ item }">
          <div class="d-flex">
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
          </div>
        </template>

        <template v-slot:[`item.calculatedActualProfit`]="{ item }">
          <div class="d-flex">
            <span>
              {{ amountFormat(item.calculatedActualProfit, "￥", 2, "————") }}
            </span>
            <Help
              class="ml-1"
              v-if="item.wrongCount > 0"
              text="存在未匹配SKU，抓取该SKU的售卖价作为成本"
            />
          </div>
        </template>

        <template v-slot:[`item.calculatedActualProfitRatio`]="{ item }">
          <div class="d-flex">
            <span>
              {{
                item.calculatedActualProfit > 0
                  ? (item.calculatedActualProfitRatio * 100).toFixed(2) + " %"
                  : ""
              }}
              <!-- {{
                
                item.wrongCount == 0
                  ? item.calculatedActualProfitRatio >= 0
                    ? (item.calculatedActualProfitRatio * 100).toFixed(2) + " %"
                    : "————"
                  : "0.00 %"
              }} -->
            </span>
          </div>
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
          <v-card-title class="text-subtitle-1"><v-col style="width: fit-content">
          <v-row class="mx-3 pt-4">
            {{ `${selectedProduct.productName}` }}
            <span class="pl-5">{{ selectedProduct.productId }}</span>
            <span class="pl-2">未匹配SKU</span>
            <span class="text--secondary pl-8">{{ this.dates }}</span>
              <v-spacer></v-spacer>
              <v-btn small color="primary" @click="downloadMismatchedSkus">
                导出未匹配SKU
              </v-btn>
          </v-row>
          </v-col></v-card-title>
          

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
import { saveAs } from "file-saver";

import { amountBeautify } from "@/libs/utils";
import Help from "@/components/Help";
import { javaUTCDateToString } from "@/libs/utils";
import { getProfitReport } from "@/settings/profitReport";
import { getMismatchedSkus } from "@/settings/profitReport";

import { mapState } from "vuex";

import PageHeader from "@/components/PageHeader";

export default {
  name: "ProfitTable",
  components: {
    PageHeader,
    Help,
  },
  data() {
    return {
      scrollFlag: 0,
      options: {},
      search: {},

      dates: [],

      menu: null,
      menu2: null,

      datePicker: false,
      datePicker2: false,

      isShowDetail: false,
      loading: false,
      isDateRange: false,

      midVarOfProfitItems: [],
      analyzedData: [],
      profitHeadersPartA: [
        // { text: "日期", value: "date" },
        { text: "部门", value: "department" },
        { text: "组别", value: "team" }, //1
        { text: "店铺", value: "shopName" }, //1
        { text: "持品人", value: "owner" }, //1
        { text: "产品名称", value: "productName" }, //1
      ],

      profitItems: [],
      profitHeadersAll: [
        { text: "商品ID", value: "productId" },
        { text: "一级类目", value: "firstCategory" }, //1
        { text: "扣点", value: "deduction" }, //1
        { text: "运费险", value: "insurance" }, //1
        { text: "运费", value: "freight" }, //1,2 freight or topayment1
        { text: "子/主", value: "extraRatio" }, //1
        { text: "成交额", value: "totalAmount" }, //1
        { text: "订单数", value: "orderCount" }, //1
        { text: "销售数", value: "productCount" }, //1
        { text: "补单额", value: "totalFakeAmount" }, //1
        { text: "团队补单", value: "totalFakeCount" }, //1
        { text: "个人补单", value: "totalPersonalFakeCount" }, //1
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
      profitHeadersForSumup: [
        //进行简单求和的列
        "totalAmount", //1
        "orderCount", //1
        "productCount", //1
        "totalFakeAmount", //1
        "totalFakeCount", //1
        "calculatedActualAmount", //成交额-补单额1
        "calculatedActualOrderCount", //订单数-补单数1
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
    this.dates = javaUTCDateToString(date);
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
    validDepartments() {
      var validTemp = {};
      this.profitItems.forEach((i) => {
        validTemp[i.department] = true;
      });
      return this.allDepartments.filter((d) => validTemp[d.uid]);
    },
    validTeam() {
      var validTemp = {};
      this.profitItems.forEach((i) => {
        validTemp[i.team] = true;
      });
      return this.allTeams.filter((d) => validTemp[d.uid]);
    },
    validOwner() {
      var validTemp = {};
      this.profitItems.forEach((i) => {
        validTemp[i.owner] = true;
      });
      return this.allUsers.filter((d) => validTemp[d.uid]);
    },
    profitHeadersShownPartA() {
      console.log(this.user);
      if (this.user.permission.f?.s) {
        return this.profitHeadersPartA;
      } else {
        return this.profitHeadersPartA.filter(
          (i) => i.value != "shopName" && i.value != "productId"
        );
      }
    },
    profitHeadersShownPartB() {
      return !this.profitItems.length || this.loading
        ? []
        : this.isShowDetail
        ? this.profitHeadersAll
        : this.profitHeadersHide;
    },
    canShowSumup() {
      if (this.loading) return false;
      if (!this.isShowDetail) return false;
      if (this.midVarOfProfitItems.length == 0) return false;
      return true;
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
    async download() {
      const ExcelJS = require("exceljs");

      const workbook = new ExcelJS.Workbook();
      workbook.creator = "泼发EBC";
      workbook.lastModifiedBy = "泼发EBC";
      console.log(this.user);
      workbook.company = "浙江泼发进出口贸易有限公司";
      workbook.manager = this.user.nick + " " + this.user.username;
      workbook.created = new Date();
      workbook.modified = new Date();

      const sheetA = workbook.addWorksheet("有效SKU信息", {
        views: [{ state: "frozen", ySplit: 1, xSplit: 6, zoomScale: 80 }],
      });

      var font = {
        name: "微软雅黑",
        size: 10,
      };
      var headerFont = {
        name: "微软雅黑",
        size: 10,
        bold: true,
      };

      var centerAlignment = {
        vertical: "center",
        horizontal: "center",
      };
      var backgroundOrange = {
        type: "pattern",
        pattern: "solid",
        fgColor: { argb: "FFFFC000" },
      };
      var backgroundNone = {
        type: "pattern",
        pattern: "none",
        fgColor: { argb: "FFFFFFFF" },
      };
      // var backgroundBlue = {
      //   type: "pattern",
      //   pattern: "solid",
      //   fgColor: { argb: "FFDCE6F1" },
      // };

      console.log(sheetA);
      sheetA.columns = [
        {
          header: "日期",
          key: "date",
          width: 15,
          style: { font },
        },
        {
          header: "部门",
          key: "calculatedDepartment",
          width: 10,
          style: { font },
        },
        {
          header: "组别",
          key: "calculatedTeam",
          width: 10,
          style: { font },
        },
        {
          header: "店铺",
          key: "shopName",
          width: 7,
          style: { font },
        },
        {
          header: "持品人",
          key: "calculatedOwner",
          width: 10,
          style: { font },
        },
        {
          header: "产品名称",
          key: "productName",
          width: 15,
          style: { font },
        },
        {
          header: "商品ID",
          key: "productId",
          width: 15,
          style: { font },
        },
        {
          header: "一级类目",
          key: "calculatedFirstCategory",
          width: 14,
          style: { font },
        },
        {
          header: "扣点",
          key: "deduction",
          width: 7,
          style: { font },
        },
        {
          header: "运费险",
          key: "insurance",
          width: 8,
          style: { font },
        },
        {
          header: "运费",
          key: "freight",
          width: 7,
          style: { font },
        },
        {
          header: "子/主",
          key: "extraRatio",
          width: 10,
          style: { font },
        },
        {
          header: "成交额",
          key: "totalAmount",
          width: 10,
          style: { font },
        },
        {
          header: "订单数",
          key: "orderCount",
          width: 10,
          style: { font },
        },
        {
          header: "销售数",
          key: "productCount",
          width: 10,
          style: { font },
        },
        {
          header: "补单额",
          key: "totalFakeAmount",
          width: 10,
          style: { font },
        },
        {
          header: "补单数",
          key: "totalFakeCount",
          width: 10,
          style: { font },
        },
        {
          header: "真实金额",
          key: "calculatedActualAmount",
          width: 10,
          style: { font },
        },
        {
          header: "真实单数",
          key: "calculatedActualOrderCount",
          width: 10,
          style: { font },
        },
        {
          header: "单均价",
          key: "calculatedActualAverageAmount",
          width: 10,
          style: { font },
        },
        {
          header: "拿货成本",
          key: "totalCost",
          width: 10,
          style: { font },
        },
        {
          header: "成本率",
          key: "calculatedCostRatio",
          width: 10,
          style: { font },
        },
        {
          header: "利润率",
          key: "calculatedProfitRatio",
          width: 10,
          style: { font },
        },
        {
          header: "退款金额",
          key: "totalRefundAmount",
          width: 10,
          style: { font },
        },
        {
          header: "净入金额",
          key: "calculatedActualIncome",
          width: 10,
          style: { font },
        },
        {
          header: "未发仅退",
          key: "totalRefundWithNoShipAmount",
          width: 10,
          style: { font },
        },
        {
          header: "未发退本",
          key: "calculatedRefundWithNoShipAmount",
          width: 10,
          style: { font },
        },
        {
          header: "未发数",
          key: "refundWithNoShipCount",
          width: 10,
          style: { font },
        },
        {
          header: "拿货成本（售后）",
          key: "calculatedActualCost",
          width: 10,
          style: { font },
        },
        {
          header: "平台扣点",
          key: "calculatedTmallTokeRatio",
          width: 10,
          style: { font },
        },
        {
          header: "快递费",
          key: "calculatedTotalFreight",
          width: 10,
          style: { font },
        },
        {
          header: "运费险",
          key: "calculatedTotalInsurance",
          width: 10,
          style: { font },
        },
        {
          header: "刷单佣金",
          key: "totalBrokerage",
          width: 10,
          style: { font },
        },
        {
          header: "售后毛利润",
          key: "calculatedActualProfit",
          width: 10,
          style: { font },
        },
        {
          header: "售后利润率",
          key: "calculatedActualProfitRatio",
          width: 10,
          style: { font },
        },
        {
          header: "SKU未匹配",
          key: "wrongCount",
          width: 10,
          style: { font },
        },
        {
          header: "折扣",
          key: "calculatedDiscount",
          width: 10,
          style: { font },
        },
        {
          header: "错数",
          key: "operatorGivenWrongPriceCount",
          width: 10,
          style: { font },
        },
        {
          header: "原售价",
          key: "totalPrice",
          width: 10,
          style: { font },
        },
      ];
      //sheetA.autoFilter = 'B1:AM1';

      sheetA.addRows(this.midVarOfProfitItems);

      sheetA.getRow(1).alignment = centerAlignment;
      sheetA.getRow(1).font = headerFont;
      // sheetA.getCell("A1").fill = backgroundYellow;
      // sheetA.getCell("B1").fill = backgroundYellow;
      // sheetA.getCell("C1").fill = backgroundYellow;
      // sheetA.getCell("D1").fill = backgroundYellow;
      // sheetA.getCell("E1").fill = backgroundYellow;
      // sheetA.getCell("F1").fill = backgroundYellow;

      sheetA.getColumn(6).border = {
        right: { style: "medium", color: { argb: "FF000000" } },
      };

      for (let index = 1; index <= 39; index++) {
        sheetA.getColumn(index).alignment = centerAlignment;
        sheetA.getRow(1).getCell(index).border = {
          bottom: { style: "medium", color: { argb: "FF000000" } },
        };

        if ([13, 18, 21, 25, 29, 34].indexOf(index) > -1) {
          sheetA.getColumn(index).fill = backgroundOrange;
        } else {
          sheetA.getColumn(index).fill = backgroundNone;
        }
      }

      // sheetA.getCell("G1").fill = backgroundBlue;

      // var amountFormat = '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';

      //sheetA.getColumn(6).numFmt = "yyyy年m月d日";
      //sheetA.getColumn(7).numFmt = "yyyy-m-d hh:mm:ss";

      // var convert = (i, lite) => {
      //   return {
      //     productId: lite ? "" : i.productId.toString(),
      //     skuId: lite ? "" : i.skuId.toString(),
      //     skuName: i.skuName,
      //     skuPrice: i.skuPrice,
      //     skuCost: i.skuCost,
      //     startTime: new Date(this.parseDate(i.startTime)),
      //     createTime: new Date(this.parseDateTime(i.createTime)),
      //   };
      // };

      console.log("生成完毕");

      const buffer = await workbook.xlsx.writeBuffer();
      const fileType =
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

      const blob = new Blob([buffer], { type: fileType });

      saveAs(blob, `利润报表.xlsx`);
    },
    sumup(object, key) {
      var result = 0;
      object.forEach((i) => (result += i[key]));
      return result;
    },
    showDetailButton() {
      this.isShowDetail = !this.isShowDetail;
      setTimeout(() => {
        this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
      }, 0);
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
    filter() {
      // function filterId(id) {
      //   return id.indexOf(this.search.productId >= 0);
      // }
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

      if (this.search.categorys?.length > 0) {
        var category = {};
        this.search.categorys.forEach((i) => (category[i] = true));
        this.midVarOfProfitItems = this.midVarOfProfitItems.filter(
          (profitItem) => category[profitItem.firstCategory]
        );
      }

      if (this.search.productId?.length > 0) {
        this.midVarOfProfitItems = this.midVarOfProfitItems.filter(
          (profitItem) =>
            profitItem.productId.toString().indexOf(this.search.productId) >= 0
        );

        // var a = [];
        // for (let i = 0; i < this.midVarOfProfitItems.length; i++) {
        //   if (
        //     this.midVarOfProfitItems[i].productId
        //       .toString()
        //       .indexOf(this.search.productId) >= 0
        //   ) {
        //     a.push(this.midVarOfProfitItems[i]);
        //   }
        // }
        // this.midVarOfProfitItems = a;
      }

      console.log(this.midVarOfProfitItems);
    },

    remove(key, option) {
      console.log(this.midVarOfProfitItems);
      console.log(this.search);
      console.log(this.profitItems);
      this.search[key].splice(option.index, 1);
    },
    showMismatchedSkus(item) {
      if (this.isDateRange) {
        this.global.infoAlert("泼发EBC：时间段模式暂时不支持查看未匹配SKU");
        return;
      }
      this.selectedProduct = item;
      this.mismatchedSkuDialog = true;
      this.mismatchedSkuLoading = true;
      var args = {
        date: this.dates,
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

    async downloadMismatchedSkus() {
      const ExcelJS = require("exceljs");

      const workbook = new ExcelJS.Workbook();
      workbook.creator = "泼发EBC";
      workbook.lastModifiedBy = "泼发EBC";
      console.log(this.user);
      workbook.company = "浙江泼发进出口贸易有限公司";
      workbook.manager = this.user.nick + " " + this.user.username;
      workbook.created = new Date();
      workbook.modified = new Date();

      const sheetA = workbook.addWorksheet("未匹配SKU信息");

      var font = {
        name: "微软雅黑",
        size: 10,
      };
      var font2 = {
        name: "微软雅黑",
        size: 10,
        color: { argb: "FFAAAAAA" },
      };

      var centerAlignment = {
        vertical: "center",
        horizontal: "center",
      };
      var rtAlignment= {
        vertical: "top",
        horizontal: "right",
      };
      var backgroundYellow = {
        type: "pattern",
        pattern: "solid",
        fgColor: { argb: "FFFFFF00" },
      };

      console.log(sheetA);
      sheetA.columns = [
      {
          header: "商品ID",
          key: "productId",
          width: 15,
          style: { font },
        },
        {
          header: "SKUID",
          key: "skuId",
          width: 16,
          style: { font },
        },
        {
          header: "SKU名称",
          key: "skuName",
          width: 70,
          style: { font },
        },
        {
          header: "售卖价",
          key: "skuPrice",
          width: 13,
          style: { font },
        },
        {
          header: "成本",
          key: "skuCost",
          width: 13,
          style: { font },
        },
        {
          header: "价格开始时间",
          key: "startTime",
          width: 15,
          style: { font },
        },
        {
          header: "销售数量",
          key: "productCount",
          width: 10,
          style: { font: font2 },
        },
        {
          header: "销售金额",
          key: "totalAmount",
          width: 10,
          style: { font: font2 },
        },
      ];
      //sheetA.autoFilter = 'B1:AM1';
      var analyzedData = this.mismatchedSkus;
      for (let i = 0; i < analyzedData.length; i ++){
        analyzedData[i].productId = this.selectedProduct.productId.toString();
      }
      console.log(analyzedData);
      sheetA.addRows(analyzedData);

      sheetA.getColumn(6).alignment = rtAlignment;
      sheetA.getColumn(7).alignment = rtAlignment;
      sheetA.getRow(1).alignment = centerAlignment;
      sheetA.getCell("A1").fill = backgroundYellow;
      sheetA.getCell("B1").fill = backgroundYellow;
      sheetA.getCell("C1").fill = backgroundYellow;
      sheetA.getCell("D1").fill = backgroundYellow;
      sheetA.getCell("E1").fill = backgroundYellow;
      sheetA.getCell("F1").fill = backgroundYellow;


      console.log("生成完毕");

      const buffer = await workbook.xlsx.writeBuffer();
      const fileType =
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

      const blob = new Blob([buffer], { type: fileType });

      saveAs(blob, this.selectedProduct.productName + this.dates + `未匹配SKU`+ this.selectedProduct.productId + `.xlsx`);
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
      var args;
      if (this.isDateRange) {
        args = { startDate: this.dates[0], endDate: this.dates[1] };
      } else {
        args = { startDate: this.dates, endDate: this.dates };
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
            this.midVarOfProfitItems = this.profitItems;
            return;
          }

          this.profitItems = res.data.profitReport;
          this.dataAnalyze();
          this.midVarOfProfitItems = this.profitItems;
          this.filter();

          setTimeout(() => {
            this.tablePartAWrapper.scrollTop = this.tablePartBWrapper.scrollTop;
          }, 0);
        })
        .catch(() => {
          this.loading = false;
        });
    },
    dataAnalyze() {
      var dateString;
      if (this.isDateRange) {
        var diff =
          new Date(this.dates[1]).getTime() - new Date(this.dates[0]).getTime();
        console.log("差距", diff);
        dateString = `${this.dates[diff < 0 ? 1 : 0]}  + ${
          Math.abs(diff) / 86400000
        }`;
      } else {
        dateString = this.dates;
      }

      this.profitItems.forEach((item) => {
        item.date = dateString;

        item.calculatedDepartment = this.departmentIdToName[item.department];
        item.calculatedTeam = this.teamIdToName[item.team];
        item.calculatedOwner = this.userIdToNick[item.owner];
        item.calculatedFirstCategory =
          this.categoryIdToName[item.firstCategory];

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

        item.calculatedActualAmount = item.totalAmount - item.totalFakeAmount;
        item.calculatedActualOrderCount = item.orderCount - item.totalFakeCount;

        if (item.calculatedActualOrderCount == 0) {
          item.calculatedActualAverageAmount = 0;
        } else {
          item.calculatedActualAverageAmount =
            item.calculatedActualAmount / item.calculatedActualOrderCount;
        }

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

        if (
          item.calculatedActualProfit < 0 &&
          item.calculatedActualProfitRatio > 0
        ) {
          item.calculatedActualProfitRatio *= -1;
        }

        item.calculatedDiscount = item.totalAmount / item.totalPrice;
      });
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

  tr.sumup {
    td {
      padding-right: 0px !important;
      padding-left: 0px !important;
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

.v-input.search-input:not(v-input--is-focused) {
  input {
    min-width: 0px;
  }
}

.v-input.search-input {
  .v-input__slot {
    min-height: 0% !important;
    // padding-left: 6px !important;
    padding-right: 6px !important;
    .v-text-field__slot {
      input {
        height: 30px;
        font-size: 14px;
      }
    }
    .v-input__append-inner {
      margin: auto !important;
      .v-input__icon--clear {
        button {
          font-size: 17px;
        }
      }
    }
    > .v-select__slot {
      > .v-select__selections {
        padding-top: 0px !important;
        padding-bottom: 0px !important;
        min-height: 0% !important;
        flex-wrap: nowrap;
        input {
          height: 30px;
          font-size: 14px;
        }

        > span {
          height: 20px;
          margin-top: 2px;
          margin-bottom: 2px;
        }
      }
      .v-input__append-inner {
        margin-top: 3px !important;
        margin-bottom: auto !important;
      }
    }
  }
}
// .date-picker-textfield {
//   max-width: 125px;
//   .v-input__slot {
//     min-height: 0px !important;

//     .v-text-field__slot > input {
//       padding-top: 4px !important;
//       padding-bottom: 4px !important;
//       font-size: 15px;
//     }
//   }
// }

.group-title {
  font-size: 13px;
  color: rgb(102, 102, 102);
  white-space: nowrap;
  padding-top: 10px;
}
</style>