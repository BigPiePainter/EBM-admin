<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="未匹配个人补单">
    </PageHeader>
    <div class="flex-grow-1">
      <v-data-table
        v-model="selectedBrushItems"
        fixed-header
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="id"
        disable-sort
        :show-select="ifAction"
        height="calc(100vh - 197px)"
        mobile-breakpoint="0"
        :loading="loading"
        :headers="brushHeader"
        :items="brushItems"
        :options.sync="options"
        :server-items-length="totalBrushItems"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100],
          'items-per-page-text': '每页显示条数',
        }"
      >
        <template v-slot:[`item.requestTime`]="{ item }">
          <span>
            {{ parseDate(item.requestTime) }}
          </span>
        </template>
        <template v-slot:[`item.orderPaymentTime`]="{ item }">
          <span>
            {{ parseDate(item.orderPaymentTime) }}
          </span>
        </template>
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title @click="show">补单订单</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-btn
              small
              depressed
              class="ml-2"
              @click="
                ifAction = !ifAction;
                selectedBrushItems = [];
              "
            >
              <v-icon small class="mr-1">
                {{
                  ifAction
                    ? "mdi-checkbox-marked-outline"
                    : "mdi-checkbox-blank-outline"
                }}
              </v-icon>
              <span> 批量操作 </span>
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn
              v-if="ifAction"
              :disabled="selectedBrushItems.length < 1"
              outlined
              small
              color="red lighten-2"
              depressed
              class="ml-1"
              @click.stop="delectBrushItems"
            >
              {{
                selectedBrushItems.length > 0
                  ? `删除${selectedBrushItems.length}条`
                  : "删除"
              }}
            </v-btn>
          </v-toolbar>
        </template>
      </v-data-table>
    </div>

    <v-dialog v-model="deleteBrushItemsDialog" max-width="450px">
      <v-card>
        <div class="mx-5 pt-4">
          <span>
            {{
              `是否确认删除 ` + selectedBrushItems.length + ` 条未匹配个人补单 ?`
            }}
          </span>
        </div>

        <v-card-actions>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="deleteBrushItemsDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDeleteBrushItemsButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="mutipleDeleteDialog" max-width="450px">
      <v-card>
        <v-card-title class="text-subtitle-1"
          >是否删除选中补单信息</v-card-title
        >
        <v-card-text> 删除后无法恢复，并且不会参与数据运算 </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="mutipleDeleteDialog = false"
            >取消</v-btn
          >
          <v-btn color="red darken-1" text @click="sureDeleteBrushItemsButton">
            <v-icon small class="mr-1"> mdi-delete </v-icon>删除</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
  
  
<script>
import { getMismatchPersonalFakeOrders } from "@/settings/order";
import { deletePersonalFakeOrders } from "@/settings/order";
import { javaUTCDateToString } from "@/libs/utils";
import PageHeader from "@/components/PageHeader";

export default {
  components: {
    PageHeader,
  },
  data() {
    return {
      ifAction: false,
      selectedBrushItems: [],
      deleteBrushItemsId: [],
      deleteBrushItemsDialog: false,
      mutipleDeleteDialog: false,

      totalBrushItems: 0,
      options: {},
      loading: false,
      moreInfo: false,
      brushItems: [],
      brushHeader: [
        { text: "主订单编号", value: "id" },
        { text: "支付时间", value: "orderPaymentTime" },
      ],
    };
  },

  created() {
    console.log = function (){}
  },

  watch: {
    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },
  },

  methods: {
    parseDate(time) {
      return javaUTCDateToString(time);
    },
    show() {
      const { page, itemsPerPage } = this.options;
      getMismatchPersonalFakeOrders({ page, itemsPerPage })
        .then((res) => {
          console.log(res.data);
        })
        .catch(() => {});
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      console.log({ page, itemsPerPage });
      getMismatchPersonalFakeOrders({ page, itemsPerPage })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.brushItems = res.data.mismatchPersonalFakeOrders.fakeorders;
          this.totalBrushItems = res.data.mismatchPersonalFakeOrders.total;
        })
        .catch(() => {
          this.loading = false;
        });
    },

    delectBrushItems() {
      console.log(this.selectedBrushItems);
      this.deleteBrushItemsId = this.selectedBrushItems.map((i) => i.id);
      this.deleteBrushItemsDialog = true;
    },

    sureDeleteBrushItemsButton() {
      this.deleteBrushItemsDialog = false;
      deletePersonalFakeOrders({ ids: this.deleteBrushItemsId.join() })
        .then((res) => {
          console.log(res);
          this.global.infoAlert(res.data);
          this.loadData();
        })
        .catch(() => {});
      this.selectedBrushItems = [];
      this.ifAction = false;
    },
  },
};
</script>