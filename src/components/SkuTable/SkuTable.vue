
<template>
  <div>
    <div v-if="show" class="sub-table elevation-20 ml-2 mb-3">
      <v-tabs v-model="tabs" align-with-title>
        <!-- align-with-title -->
        <!-- <v-tabs-slider color="yellow"></v-tabs-slider> -->
        <v-tab>
          <span class="text-body-1">SKU信息</span>
        </v-tab>
        <v-tab>
          <span class="text-body-1">厂家信息</span>
        </v-tab>
        <v-tab>
          <span class="text-body-1">内部归属</span>
        </v-tab>
        <v-toolbar flat v-if="tabs == 0" :key="1">
          <SkuUpload :product="productInfo" @refresh="init" />

          <v-btn small depressed class="ml-2" @click="download">
            <v-icon small class="mr-1"> mdi-export </v-icon>
            <span class="" color=""> 导出 </span>
          </v-btn>

          <v-btn
            small
            depressed
            class="ml-2"
            @click="
              skuAction = !skuAction;
              skuSelected = [];
            "
          >
            <v-icon small class="mr-1">
              {{
                skuAction
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 批量操作 </span>
          </v-btn>

          <v-btn small depressed class="ml-2" @click="check = !check">
            <v-icon small class="mr-1">
              {{
                check
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 有效SKU </span>
          </v-btn>

          <v-spacer />
          <template>
            <v-btn
              small
              v-if="skuAction"
              :disabled="skuSelected.length == 0"
              depressed
              outlined
              color="red lighten-2"
              @click="deleteSku"
              class="ml-1"
            >
              {{
                skuSelected.length == 0 ? "删除" : `删除${skuSelected.length}条`
              }}
            </v-btn>
          </template>
        </v-toolbar>
        <v-toolbar flat v-else-if="tabs == 1" :key="2">
          <v-btn small depressed color="primary" @click="addManufacturerButton">
            新增厂家信息
          </v-btn>

          <v-btn small depressed class="ml-2">
            <v-icon small class="mr-1"> mdi-export </v-icon>
            <span class="" color=""> 导出 </span>
          </v-btn>
          <v-btn
            small
            depressed
            class="ml-2"
            @click="
              manufactureAction = !manufactureAction;
              manufactureSelected = [];
            "
          >
            <v-icon small class="mr-1">
              {{
                manufactureAction
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 操作 </span>
          </v-btn>
          <v-btn
            small
            depressed
            class="ml-2"
            @click="showRecipientInfo = !showRecipientInfo"
          >
            <v-icon small class="mr-1">
              {{
                showRecipientInfo
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 显示收款信息 </span>
          </v-btn>
          <v-btn
            small
            depressed
            class="ml-2"
            @click="showDeliveryInfo = !showDeliveryInfo"
          >
            <v-icon small class="mr-1">
              {{
                showDeliveryInfo
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 显示退货信息 </span>
          </v-btn>
          <v-spacer />
          <template>
            <v-btn
              small
              v-if="manufactureAction"
              :disabled="manufactureSelected.length != 1"
              depressed
              outlined
              color="green"
              @click="editManufacturerButton"
              class="ml-1"
            >
              修改
            </v-btn>
            <v-btn
              small
              v-if="manufactureAction"
              :disabled="manufactureSelected.length != 1"
              depressed
              outlined
              color="red lighten-2"
              @click="deleteManufacturerButton"
              class="ml-1"
            >
              删除
            </v-btn>
          </template>
        </v-toolbar>
        <v-toolbar flat v-else-if="tabs == 2" :key="3">
          <v-btn
            small
            depressed
            class="ml-2"
            @click="
              ascriptionAction = !ascriptionAction;
              ascriptionSelected = [];
            "
          >
            <v-icon small class="mr-1">
              {{
                ascriptionAction
                  ? "mdi-checkbox-marked-outline"
                  : "mdi-checkbox-blank-outline"
              }}
            </v-icon>
            <span> 操作 </span>
          </v-btn>
          <v-spacer />
          <template>
            <v-btn
              small
              v-if="ascriptionAction"
              :disabled="
                ascriptionSelected.length != 1 ||
                ascriptionSelected[0].startTime <= 0
              "
              depressed
              outlined
              color="red lighten-2"
              @click="deleteAscriptionButton"
              class="ml-1"
            >
              删除
            </v-btn>
          </template>
        </v-toolbar>
      </v-tabs>
      <v-expand-transition>
        <v-tabs-items v-model="tabs" v-if="itemShow">
          <v-tab-item>
            <v-data-table
              v-model="skuSelected"
              loading-text="加载中... 请稍后"
              no-data-text="空"
              :headers="headers"
              :show-select="skuAction"
              @click:row="showselect"
              :items="check ? validSkuInfos : skuInfos"
              :loading="loading"
              item-key="uid"
              :hide-default-footer="
                (check ? validSkuInfos : skuInfos).length <= 10
              "
              :items-per-page="10"
              :footer-props="{
                'items-per-page-options': [10, 20, 50, 100],
                'items-per-page-text': '每页显示条数',
              }"
            >
              <template v-slot:[`header.skuPrice`]="{ header }">
                <span class="mr-1">
                  {{ header.text }}
                </span>
              </template>
              <template v-slot:[`header.skuCost`]="{ header }">
                <span class="mr-2">
                  {{ header.text }}
                </span>
              </template>
              <template v-slot:[`item.skuPrice`]="{ item }">
                ￥{{ item.skuPrice }}
              </template>
              <template v-slot:[`item.skuCost`]="{ item }">
                ￥{{ item.skuCost }}
              </template>

              <template v-slot:[`item.startTime`]="{ item }">
                {{ parseDate(item.startTime) }}
              </template>
              <template v-slot:[`item.createTime`]="{ item }">
                {{ parseDateTime(item.createTime) }}
              </template>
            </v-data-table>
          </v-tab-item>
          <v-tab-item>
            <v-data-table
              item-key="uid"
              v-model="manufactureSelected"
              :show-select="manufactureAction"
              single-select
              calculate-widths
              loading-text="加载中... 请稍后"
              no-data-text="空"
              :headers="calculatedManufacturerHeaders"
              :items="manufacturerInfos"
              :loading="loading"
              :hide-default-footer="manufacturerInfos.length <= 10"
              :items-per-page="10"
              :footer-props="{
                'items-per-page-options': [10, 20, 50, 100],
                'items-per-page-text': '每页显示条数',
              }"
            >
              <template v-slot:[`item.freight`]="{ item }">
                {{ !item.freightToPayment ? "￥ " + item.freight : "" }}
              </template>
              <!-- <template v-slot:[`item.extraRatio`]="{ item }">
                {{ !item.freightToPayment ? item.extraRatio + " %" : "" }}
              </template> -->
              <template v-slot:[`item.freightToPayment`]="{ item }">
                {{
                  item.freightToPayment > 0 ? item.freightToPayment + " %" : ""
                }}
              </template>

              <!-- <template v-slot:[`item.actions`]="{ item }">
                <v-btn
                  small
                  depressed
                  outlined
                  color="green"
                  @click="editManufacturerButton(item)"
                  class="ml-1"
                >
                  修改
                </v-btn>
                <v-btn
                  small
                  depressed
                  outlined
                  color="red lighten-2"
                  @click="deleteManufacturerButton(item)"
                  class="ml-1"
                >
                  删除
                </v-btn>
              </template> -->

              <template v-slot:[`item.startTime`]="{ item }">
                {{ parseDate(item.startTime) }}
              </template>
            </v-data-table>
          </v-tab-item>
          <v-tab-item>
            <v-data-table
              item-key="uid"
              v-model="ascriptionSelected"
              :show-select="ascriptionAction"
              calculate-widths
              loading-text="加载中... 请稍后"
              no-data-text="空"
              :headers="ascriptionHeaders"
              :items="ascriptionInfos"
              :loading="loading"
              :sort-by="['startTime']"
              :sort-desc="[true]"
              :hide-default-footer="ascriptionInfos.length <= 3"
              :items-per-page="3"
              :footer-props="{
                'items-per-page-options': [3, 10, 20, 50],
                'items-per-page-text': '每页显示条数',
              }"
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
              <template v-slot:[`item.startTime`]="{ item }">
                {{ parseDate(item.startTime) }}
              </template>
            </v-data-table>
          </v-tab-item>
        </v-tabs-items>
      </v-expand-transition>
    </div>
    <div v-else>
      <v-progress-circular
        class="ml-10 mb-2 mt-2"
        size="25"
        width="3"
        indeterminate
        color="grey"
      >
      </v-progress-circular>
    </div>

    <!-- 删除SKU Dialog -->
    <v-dialog v-model="deleteSkuDialog" max-width="450px">
      <v-card>
        <div class="mx-5 pt-4">
          <span>
            {{ this.skuSelected[0] && this.skuSelected[0].skuName }}
          </span>
        </div>

        <div class="mt-2">
          <TableKV :items="deleteSkuItemParse" />
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="deleteSkuDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDeleteSkuButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="mutipleDeleteDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1">是否删除选中sku信息</v-card-title>
        <v-card-text> 删除后无法恢复，并且不会参与数据运算 </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="mutipleDeleteDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDeleteSkuButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除商品归属信息 Dialog -->
    <v-dialog v-model="deleteAscriptionDialog" max-width="360px">
      <v-card>
        <v-card-title class="text-subtitle-1">
          删除这条归属记录？
        </v-card-title>

        <div class="mt-2">
          <TableKV :items="deleteAscriptionItemParse" />
        </div>

        <v-card-actions>
          <span class="text--secondary caption font-italic font-weight-thin"
            >无法恢复</span
          >
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="deleteAscriptionDialog = false"
          >
            取消
          </v-btn>
          <v-btn color="red darken-1" text @click="sureDeleteAscriptionButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 厂家信息Dialog -->
    <v-dialog v-model="manufacturerInfoDialog" max-width="600px" persistent>
      <v-card>
        <v-form>
          <v-col class="px-10 py-10 manufacturer-dialog">
            <v-row>
              <span class="text-subtitle-1">基本信息</span>
            </v-row>
            <v-row>
              <v-col>
                <span class="text-body-2 text--secondary">厂家名* </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  required
                  v-model="manufacturerEdit.manufacturerName"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary">厂家群名 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerGroup"
                ></v-text-field
              ></v-col>
            </v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">收款信息</span>
            </v-row>
            <v-row>
              <v-col cols="5">
                <span class="text-body-2 text--secondary"> 收款人 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPaymentName"
                ></v-text-field
              ></v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 收款方式 </span>

                <v-combobox
                  outlined
                  dense
                  hide-details
                  :items="[
                    '支付宝',
                    '中国银行',
                    '中国农业银行',
                    '中国工商银行',
                  ]"
                  v-model="manufacturerEdit.manufacturerPaymentMethod"
                ></v-combobox>
              </v-col>
            </v-row>
            <v-row
              ><v-col>
                <span class="text-body-2 text--secondary"> 收款账户 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPaymentId"
                ></v-text-field></v-col
            ></v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">退货信息</span>
            </v-row>
            <v-row>
              <v-col cols="5">
                <span class="text-body-2 text--secondary"> 收件人 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerRecipient"
                ></v-text-field>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 收件手机号 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerPhone"
                ></v-text-field
              ></v-col>
            </v-row>
            <v-row
              ><v-col>
                <span class="text-body-2 text--secondary"> 收件地址 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.manufacturerAddress"
                ></v-text-field></v-col
            ></v-row>

            <v-divider class="my-7" />

            <v-row>
              <span class="text-subtitle-1">运费信息</span>
            </v-row>
            <v-row>
              <v-col cols="6">
                <span
                  class="text-body-2 text--secondary"
                  :class="
                    manufacturerEdit.freightToPayment > 0 &&
                    'text-decoration-line-through'
                  "
                >
                  每单运费</span
                >
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.freight"
                  :disabled="manufacturerEdit.freightToPayment > 0"
                  type="number"
                  suffix="￥"
                ></v-text-field>
              </v-col>
              <!-- <v-col cols="4">
                <span
                  class="text-body-2 text--secondary"
                  :class="
                    manufacturerEdit.freightToPayment > 0 &&
                    'text-decoration-line-through'
                  "
                >
                  子/主订单附带比
                </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  :disabled="manufacturerEdit.freightToPayment > 0"
                  suffix="%"
                  type="number"
                  v-model="manufacturerEdit.extraRatio"
                ></v-text-field
              ></v-col> -->
              <v-col cols="6">
                <span class="text-body-2 text--secondary"> 运费/货品成本 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  suffix="%"
                  type="number"
                  v-model="manufacturerEdit.freightToPayment"
                ></v-text-field
              ></v-col>
            </v-row>

            <v-divider class="my-7" />

            <v-row>
              <v-col cols="3">
                <span class="text-body-2 text--secondary"> 选择起始日期* </span>
                <v-menu
                  ref="menu"
                  v-model="datePicker"
                  :close-on-content-click="false"
                  :return-value.sync="manufacturerEdit.startTime"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="manufacturerEdit.startTime"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                      outlined
                      dense
                      hide-details
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="manufacturerEdit.startTime"
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
                      @click="$refs.menu.save(manufacturerEdit.startTime)"
                    >
                      确定
                    </v-btn>
                  </v-date-picker>
                </v-menu>
              </v-col>
              <v-col>
                <span class="text-body-2 text--secondary"> 备注 </span>
                <v-text-field
                  outlined
                  dense
                  hide-details
                  v-model="manufacturerEdit.note"
                ></v-text-field
              ></v-col>
            </v-row>
          </v-col>
        </v-form>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">带*为必填项目</p>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="manufacturerInfoDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="blue darken-1"
            text
            @click="sureManufactureAddOrEditButton"
            type="submit"
            :disabled="isEmpty"
          >
            {{ manufacturerMode == 1 ? "添加" : "修改" }}</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除厂家 Dialog -->
    <v-dialog v-model="deleteManufacturerDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1">{{
          deleteManufacturerItem.manufacturerName
        }}</v-card-title>

        <div class="mt-2">
          <TableKV :items="deleteManufacturerItemParse" />
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="deleteManufacturerDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="red darken-1"
            text
            @click="sureDeleteManufacturerButton"
          >
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import { saveAs } from "file-saver";

import { mapState } from "vuex";

import SkuUpload from "@/components/SkuUpload/SkuUpload";
import TableKV from "@/components/TableKV/TableKV";
import { loadSkus } from "@/settings/sku";
import { deleteSku } from "@/settings/sku";

import { loadAscriptions } from "@/settings/ascription";
import { deleteAscription } from "@/settings/ascription";

import { loadManufacturers } from "@/settings/manufacturer";
import { addManufacturer } from "@/settings/manufacturer";
import { deleteManufacturer } from "@/settings/manufacturer";
import { editManufacturer } from "@/settings/manufacturer";

editManufacturer;
//import { deleteSkus } from "@/settings/sku";
//import * as XLSX from 'xlsx/xlsx.mjs';

import { javaUTCDateToString } from "@/libs/utils";
import { javaDateTimeToString } from "@/libs/utils";

export default {
  components: {
    SkuUpload,
    TableKV,
  },

  props: {
    //skuInfos: Array,
    productInfo: Object,
  },

  created() {
    this.init();
  },

  mounted() {
    //this.show = true
  },

  data() {
    return {
      ascriptionSelected: [],
      ascriptionAction: false,
      manufactureAction: false,
      manufactureSelected: [],
      skuAction: false,
      skuSelected: [],
      show: false,
      itemShow: false,

      tabs: 0,

      deleteSkuDialog: false, //删除SKU弹框
      mutipleDeleteDialog: false,
      deleteSkuUid: [], //删除信息
      deleteSkuItemParse: {}, //删

      deleteAscriptionDialog: false, //删除商品归属弹框
      deleteAscriptionItem: {},
      deleteAscriptionItemParse: {},

      deleteManufacturerDialog: false, //删除厂家弹框
      deleteManufacturerItem: {},
      deleteManufacturerItemParse: {},

      manufacturerInfoDialog: false,
      manufacturerEdit: {},
      manufacturerMode: 0, // 1--添加模式,  2--修改模式

      headers: [
        { text: "SKUID", align: "start", value: "skuId" },
        { text: "SKU名称", align: "start", value: "skuName" },
        { text: "售卖价", align: "end", value: "skuPrice" },
        { text: "成本", align: "end", value: "skuCost" },
        { text: "价格开始时间", align: "start", value: "startTime" },
        //{ text: "价格截止时间", align: "start", value: "endTime" },
        { text: "销售子订单条数", align: "start", value: "orderNum" },
        { text: "销售数", align: "start", value: "seleNum" },
        { text: "创建时间", align: "start", value: "createTime" },
      ],
      skuInfos: [],
      validSkuInfos: [],

      manufacturerHeaders: [
        { text: "厂家名", align: "start", value: "manufacturerName" },
        { text: "厂家群名", align: "start", value: "manufacturerGroup" },
        {
          text: "厂家收款方式",
          align: "start",
          value: "manufacturerPaymentMethod",
        },
        {
          text: "厂家收款人",
          align: "start",
          value: "manufacturerPaymentName",
        },
        {
          text: "厂家收款号码",
          align: "start",
          value: "manufacturerPaymentId",
        },
        {
          text: "厂家退货-收件人",
          align: "start",
          value: "manufacturerRecipient",
        },
        {
          text: "厂家退货-收件手机号",
          align: "start",
          value: "manufacturerPhone",
        },
        {
          text: "厂家退货-收件地址",
          align: "start",
          value: "manufacturerAddress",
        },
        {
          text: "每单运费",
          align: "end",
          value: "freight",
        },
        // {
        //   text: "子/主订单附带比",
        //   align: "end",
        //   value: "extraRatio",
        // },
        {
          text: "运费/货品成本",
          align: "end",
          value: "freightToPayment",
        },
        { text: "厂家生效时间", align: "start", value: "startTime" },
        // { text: "创建时间", align: "start", value: "createTime" },
        // { text: "修改时间", align: "start", value: "modifyTime" },
        { text: "备注", align: "start", value: "note" },
      ],
      manufacturerInfos: [],

      ascriptionHeaders: [
        { text: "部门", align: "start", value: "department" },
        { text: "组别", align: "start", value: "team" },
        {
          text: "持品人",
          align: "start",
          value: "owner",
        },
        {
          text: "生效时间",
          align: "start",
          value: "startTime",
        },
        { text: "备注", align: "start", value: "note" },
        { text: "操作", align: "start", value: "actions" },
      ],
      ascriptionInfos: [],

      datePicker: false,

      loading: false,

      check: true,
      showRecipientInfo: false,
      showDeliveryInfo: false,

      done: [false, false, false],
    };
  },

  watch: {},

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
    isEmpty: function () {
      var check = ["manufacturerName", "startTime"];
      var pass = true;
      check.forEach((item) => {
        if (!this.manufacturerEdit[item]) pass = false;
      });

      console.log(pass);

      return !pass;
    },
    calculatedManufacturerHeaders: function () {
      var headers = this.manufacturerHeaders;
      if (!this.showRecipientInfo) {
        headers = headers.filter(
          (i) =>
            i.value != "manufacturerPaymentMethod" &&
            i.value != "manufacturerPaymentName" &&
            i.value != "manufacturerPaymentId"
        );
      }
      if (!this.showDeliveryInfo) {
        headers = headers.filter(
          (i) =>
            i.value != "manufacturerRecipient" &&
            i.value != "manufacturerAddress" &&
            i.value != "manufacturerPhone"
        );
      }
      return headers;
    },
  },

  methods: {
    showselect() {
      console.log(this.skuSelected);
    },
    parseDate(date) {
      return javaUTCDateToString(date);
    },
    parseDateTime(date) {
      return javaDateTimeToString(date);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    init() {
      this.loading = true;
      //加载数据
      Promise.all([
        loadSkus({ productId: this.productInfo.id }),
        loadManufacturers({ productId: this.productInfo.id }),
        loadAscriptions({ productId: this.productInfo.id }),
      ]).then((res) => {
        // console.log("请求结束");
        // console.log(res);
        this.skuInfos = res[0].data.skus;
        this.manufacturerInfos = res[1].data.manufacturers;
        this.ascriptionInfos = res[2].data.ascriptions;
        this.dataAnalyze();
        // console.log("显示");
        this.loading = false;
        this.show = true;
        //this.itemShow = true;
        // setTimeout(() => {
        //   this.itemShow = true;
        // }, 0);
        this.$nextTick(() => {
          this.itemShow = true;
        });
      });
    },

    dataAnalyze() {
      var skuId = {};
      this.skuInfos.forEach((sku) => {
        if (skuId[sku.skuId]) {
          skuId[sku.skuId].count++;
          if (skuId[sku.skuId].sku.startTime < sku.startTime) {
            skuId[sku.skuId].sku = sku;
          } else if (skuId[sku.skuId].sku.startTime == sku.startTime) {
            if (skuId[sku.skuId].sku.createTime < sku.createTime) {
              skuId[sku.skuId].sku = sku;
            }
          }
        } else {
          skuId[sku.skuId] = { count: 1, sku: sku };
        }
      });
      console.log(this.skuInfos);

      this.validSkuInfos = [];
      for (let id in skuId) this.validSkuInfos.push(skuId[id].sku);
    },

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

      const sheet = workbook.addWorksheet("SKU信息", {
        views: [{ state: "frozen", ySplit: 1 }],
      });

      var font = {
        name: "微软雅黑",
        size: 10,
      };
      var centerAlignment = {
        vertical: "center",
        horizontal: "center",
      };
      var background = {
        type: "pattern",
        pattern: "solid",
        fgColor: { argb: "FFFFFF00" },
      };

      console.log(sheet);
      sheet.columns = [
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
          width: 16,
          style: { font },
        },
      ];

      sheet.getCell("A1").alignment = centerAlignment;
      sheet.getCell("B1").alignment = centerAlignment;
      sheet.getCell("C1").alignment = centerAlignment;
      sheet.getCell("D1").alignment = centerAlignment;
      sheet.getCell("E1").alignment = centerAlignment;
      sheet.getCell("F1").alignment = centerAlignment;

      sheet.getCell("A1").fill = background;
      sheet.getCell("B1").fill = background;
      sheet.getCell("C1").fill = background;
      sheet.getCell("D1").fill = background;
      sheet.getCell("E1").fill = background;
      sheet.getCell("F1").fill = background;

      sheet.getColumn(4).numFmt =
        '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
      sheet.getColumn(5).numFmt =
        '_ ¥* #,##0.00_ ;_ ¥* -#,##0.00_ ;_ ¥* "-"??_ ;_ @_ ';
      sheet.getColumn(6).numFmt = "[$-x-sysdate]dddd, mmmm dd, yyyy";

      // const data = [
      //   [
      //     "1234567890123",
      //     "1234567890123",
      //     "XXXXX-XXXXX-XXXXXX-XXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXX",
      //     10,
      //     5,
      //     new Date("2022-11-11"),
      //   ],
      //   [
      //     "1234567890123",
      //     "1234567890123",
      //     "XXXXX-XXXXX-XXXXXX-XXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXX",
      //     10,
      //     5,
      //     new Date("2022-11-11"),
      //   ],
      // ];
      // sheet.addRows(data);

      var skuDatas = this.skuInfos.map((i) => {
        return {
          productId: i.productId.toString(),
          skuId: i.skuId.toString(),
          skuName: i.skuName,
          skuPrice: i.skuPrice,
          skuCost: i.skuCost,
          startTime: new Date(i.startTime),
        };
      });
      sheet.addRows(skuDatas);
      console.log("生成完毕");

      const buffer = await workbook.xlsx.writeBuffer();
      const fileType =
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

      const blob = new Blob([buffer], { type: fileType });

      saveAs(
        blob,
        `${this.productInfo.owner}-${this.productInfo.productName}-${this.productInfo.id}.xlsx`
      );

      // var skuInfoCopy = [];

      // for (let sku of this.check ? this.validSkuInfos : this.skuInfos) {
      //   console.log(sku);
      //   skuInfoCopy.push({
      //     productId: sku.productId + "",
      //     skuId: sku.skuId + "",
      //     skuName: sku.skuName,
      //     skuPrice: sku.skuPrice,
      //     skuCost: sku.skuCost,
      //     startTime: javaUTCDateToString(sku.startTime),
      //   });
      // }

      // const XLSX = require("xlsx");

      // console.log(skuInfoCopy);
      // const raw_data = skuInfoCopy;
      // //this.check ? this.validSkuInfos : this.skuInfos;
      // /*
      // const prez = raw_data.filter((row) =>
      //   row.terms.some((term) => term.type === "prez")
      // );*/
      // const rows = raw_data.map((row) => row);
      // /* generate worksheet and workbook */
      // const worksheet = XLSX.utils.json_to_sheet(rows);
      // const workbook = XLSX.utils.book_new();
      // XLSX.utils.book_append_sheet(workbook, worksheet, "SKU数据");
      // /* fix headers */
      // XLSX.utils.sheet_add_aoa(
      //   worksheet,
      //   [["商品ID", "SKUID", "SKU名称", "售卖价", "成本", "价格开始时间"]],
      //   {
      //     origin: "A1",
      //   }
      // );

      // worksheet["!cols"] = [
      //   { wch: 14 },
      //   { wch: 14 },
      //   { wch: 70 },
      //   { wch: 8 },
      //   { wch: 8 },
      //   { wch: 13 },
      // ];

      // /* create an XLSX file and try to save to Presidents.xlsx */
      // XLSX.writeFile(
      //   workbook,
      //   `${this.productInfo.owner}-${this.productInfo.productName}-${this.productInfo.id}.xlsx`
      // );
    },

    deleteSku() {
      this.deleteSkuItemParse = [];
      console.log(this.skuSelected);
      this.deleteSkuUid = this.skuSelected.map((i) => i.uid);
      if (this.deleteSkuUid.length == 1) {
        this.deleteSkuItemParse = [
          {
            key: "SKUID",
            value: this.skuSelected[0].skuId,
          },
          {
            key: "售卖价",
            value: this.skuSelected[0].skuPrice,
          },
          {
            key: "单个成本",
            value: this.skuSelected[0].skuCost,
          },
          {
            key: "价格开始时间",
            value: this.parseDate(this.skuSelected[0].startTime),
          },
          {
            key: "创建时间",
            value: this.parseDateTime(this.skuSelected[0].createTime),
          },
        ];
        console.log(this.deleteSkuItemParse);
        this.deleteSkuDialog = true;
      } else {
        this.mutipleDeleteDialog = true;
      }
    },

    sureDeleteSkuButton() {
      this.deleteSkuDialog = false;
      deleteSku({ uids: this.deleteSkuUid.join() })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
      this.skuSelected = [];
    },

    deleteAscriptionButton() {
      console.log(this.ascriptionSelected);
      if (!this.user.permission.a.da) {
        this.global.infoAlert("泼发EBC：权限不足");
        return;
      }

      this.deleteAscriptionItem = { ...this.ascriptionSelected[0] };
      this.deleteAscriptionItemParse = [
        {
          key: "部门",
          value: this.departmentIdToName[this.ascriptionSelected[0].department],
        },
        {
          key: "组别",
          value: this.teamIdToName[this.ascriptionSelected[0].team],
        },
        {
          key: "持品人",
          value: this.userIdToNick[this.ascriptionSelected[0].owner],
        },
        {
          key: "生效时间",
          value: javaUTCDateToString(this.ascriptionSelected[0].startTime),
        },
      ];

      this.deleteAscriptionDialog = true;
    },

    sureDeleteAscriptionButton() {
      console.log(this.deleteAscriptionItem.uid);
      deleteAscription({ uid: this.deleteAscriptionItem.uid })
        .then((res) => {
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
      this.deleteAscriptionDialog = false;
    },

    deleteManufacturerButton() {
      console.log(this.manufactureSelected[0]);

      this.deleteManufacturerItem = { ...this.manufactureSelected[0] };
      this.deleteManufacturerItemParse = [
        {
          key: "厂家名",
          value: this.manufactureSelected[0].manufacturerName,
        },
        {
          key: "厂家群名",
          value: this.manufactureSelected[0].manufacturerGroup,
        },
        {
          key: "厂家收款方式",
          value: this.manufactureSelected[0].manufacturerPaymentMethod,
        },
        {
          key: "厂家收款人",
          value: this.manufactureSelected[0].manufacturerPaymentName,
        },
        {
          key: "厂家收款号码",
          value: this.manufactureSelected[0].manufacturerPaymentId,
        },
        {
          key: "厂家生效时间",
          value: this.parseDate(this.manufactureSelected[0].startTime),
        },
      ];

      this.deleteManufacturerDialog = true;
    },

    //deleteManufacturer

    sureDeleteManufacturerButton() {
      this.deleteManufacturerDialog = false;
      deleteManufacturer({ uid: this.deleteManufacturerItem.uid })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.manufactureSelected = [];
          this.init();
        })
        .catch(() => {});
    },

    editManufacturerButton() {
      this.manufacturerMode = 2; //"修改"模式
      this.manufacturerEdit = { ...this.manufactureSelected[0] };
      //注意
      this.manufacturerEdit.startTime = this.parseDate(
        this.manufacturerEdit.startTime
      );
      this.manufacturerInfoDialog = true;
    },

    addManufacturerButton() {
      this.manufacturerMode = 1; //"添加"模式
      this.manufacturerEdit = {};
      this.manufacturerInfoDialog = true;
    },

    sureManufactureAddOrEditButton() {
      this.manufacturerMode == 1
        ? this.newManufacturer()
        : this.modifyManufacturer();
    },

    newManufacturer() {
      this.manufacturerInfoDialog = false;
      console.log(this.manufacturerEdit);
      var pars = { productId: this.productInfo.id, ...this.manufacturerEdit };
      pars.startTime = pars.startTime.replaceAll("-", "/");
      console.log(pars);
      addManufacturer(pars)
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});
    },

    modifyManufacturer() {
      this.manufacturerInfoDialog = false;
      var args = { ...this.manufacturerEdit };

      //参数预处理
      args.startTime = args.startTime.replaceAll("-", "/");
      args.freight || (args.freight = 0);
      // args.extraRatio || (args.extraRatio = 0);
      args.freightToPayment || (args.freightToPayment = 0);
      for (let name in args) args[name] == null && delete args[name];
      args.manufacturerPaymentMethod || (args.manufacturerPaymentMethod = "");

      console.log(args);
      editManufacturer(args)
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.init();
        })
        .catch(() => {});

      this.manufactureSelected = [];
    },
  },
};
</script>



<style scoped lang="scss">
// .delete-table-container {
//   width: fit-content;
// }
.sub-table {
  width: fit-content;
  // background-color: red;
  transform: translateY(-5px);
  border-radius: 20px;
}

.v-card__title {
  overflow: hidden;
  text-overflow: ellipsis;
}

.manufacturer-dialog {
  .col {
    padding-top: 5px;
    padding-bottom: 5px;
  }

  .v-input {
    font-size: 15px;
  }
}

.v-menu__content {
  .v-list {
    .v-list-item__title {
      font-size: 15px;
    }
  }
}
//关山难越，谁悲失路之人
//萍水相逢，尽是他乡之客
</style>