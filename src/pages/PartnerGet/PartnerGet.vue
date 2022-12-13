<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="商品清单">
      <v-btn class="ml-2" text color="primary" @click="addButton">
        <v-icon size="20" style="padding-top: 2px">mdi-bookmark-plus</v-icon>
        新增商品信息
      </v-btn>
      <v-btn class="ml-2" text color="primary" disabled>
        <v-icon size="20" style="padding-top: 2px">mdi-export</v-icon>
        导出
      </v-btn>
    </PageHeader>
    <div class="flex-grow-1">
      <v-data-table
        single-select
        show-expand
        fixed-header
        disable-sort
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key="id"
        class=""
        height="calc(100vh - 197px)"
        mobile-breakpoint="0"
        v-model="selectedProductItem"
        :show-select="ifAction"
        :loading="loading"
        :headers="headers"
        :items="products"
        :expanded.sync="expanded"
        :server-items-length="totalProducts"
        :options.sync="options"
        :items-per-page="50"
        :footer-props="{
          'items-per-page-options': [10, 20, 50, 100, 500, 1000, 5000],
          'items-per-page-text': '每页显示条数',
        }"
        @click:row="clickRow"
      >
        <!-- 商品清单表头搜索功能 -->
        <!-- 查找商品id -->
        <template v-slot:[`header.id`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找商品名称 -->
        <template v-slot:[`header.productName`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找备注 -->
        <template v-slot:[`header.note`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找聚水潭仓库 -->
        <template v-slot:[`header.storehouse`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找发货方式 -->
        <template v-slot:[`header.transportWay`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找店铺 -->
        <template v-slot:[`header.shopName`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-text-field
                  color="primary"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                >
                </v-text-field>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找部门 -->
        <template v-slot:[`header.department`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-autocomplete
                  color="primary"
                  :items="allDepartments"
                  item-text="name"
                  item-value="uid"
                  v-model="search.search[props.header.value]"
                  single-line
                  multiple
                  label="选择"
                  class="ml-3"
                >
                <template v-slot:selection="option">
                    <v-chip close @click:close="remove(props, option)">
                      {{ option.item.name }}
                    </v-chip>
                  </template>
                </v-autocomplete>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找组别 -->
        <template v-slot:[`header.team`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-autocomplete
                  color="primary"
                  :items="allTeams"
                  item-text="name"
                  item-value="uid"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                  multiple
                  label="选择"
                >
                <template v-slot:selection="option">
                    <v-chip close @click:close="remove(props, option)">
                      {{ option.item.name }}
                    </v-chip>
                  </template>
                </v-autocomplete>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找持品人 -->
        <template v-slot:[`header.owner`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-autocomplete
                  color="primary"
                  :items="allUsers"
                  item-text="nick"
                  item-value="uid"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                  multiple
                  label="选择"
                >
                  <template v-slot:selection="option">
                    <v-chip close @click:close="remove(props, option)">
                      {{ option.item.nick }}
                    </v-chip>
                  </template>
                </v-autocomplete>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <!-- 查找一级类目 -->
        <template v-slot:[`header.firstCategory`]="props">
          <v-edit-dialog @close="loadData">
            {{ props.header.text }}
            <template v-slot:input>
              <div class="d-flex align-center">
                <span> {{ props.header.text }} </span>
                <v-autocomplete
                  color="primary"
                  :items="allCategorys"
                  item-text="name"
                  item-value="uid"
                  v-model="search.search[props.header.value]"
                  single-line
                  class="ml-3"
                  multiple
                  label="选择"
                >
                <template v-slot:selection="option">
                    <v-chip close @click:close="remove(props, option)">
                      {{ option.item.name }}
                    </v-chip>
                  </template>
                </v-autocomplete>
              </div>
            </template>
          </v-edit-dialog>
        </template>

        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="pa-0">
            <SkuTable :productInfo="item" />
          </td>
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
          {{ categoryIdToName[item.firstCategory] }}
        </template>

        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>商品信息</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-btn
              small
              depressed
              class="ml-2"
              @click="
                ifAction = !ifAction;
                selectedProductItem = [];
              "
            >
              <v-icon small class="mr-1">
                {{
                  ifAction
                    ? "mdi-checkbox-marked-outline"
                    : "mdi-checkbox-blank-outline"
                }}
              </v-icon>
              <span> 操作 </span>
            </v-btn>
            <v-spacer></v-spacer>
            <span class="grey--text body-2 overflow-y-auto mr-3">{{
              searchPreview
            }}</span>

            <v-btn
              v-if="ifAction"
              :disabled="selectedProductItem.length != 1"
              small
              depressed
              outlined
              color="green"
              class="ml-1"
              @click.stop="editProductButton"
            >
              修改
            </v-btn>
            <v-btn
              v-if="ifAction"
              :disabled="selectedProductItem.length != 1"
              outlined
              color="red lighten-2"
              small
              depressed
              class="ml-2"
              @click.stop="deleteProductItem"
            >
              <span> 下架 </span>
            </v-btn>
          </v-toolbar>
        </template>

        <template v-slot:[`header.actions`]="{ header }">
          <div class="d-flex mr-11">
            <v-spacer />
            {{ header.text }}
          </div>
        </template>
        <!-- <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex">
            <v-spacer />
            <v-btn
              small
              depressed
              outlined
              color="green"
              @click.stop="editProductButton(item)"
              class="ml-1"
            >
              修改
            </v-btn>

            <v-btn
              small
              depressed
              outlined
              color="red lighten-2"
              @click.stop="deleteProductItem(item)"
              class="ml-1"
            >
              删除
            </v-btn>
          </div>
        </template> -->
      </v-data-table>
    </div>

    <!-- 商品信息Dialog -->
    <v-dialog v-model="productInfoDialog" max-width="550px" persistent>
      <v-card>
        <v-container class="px-10 py-10 product-dialog">
          <v-row>
            <span class="text-subtitle-1">商品信息</span>
          </v-row>
          <v-row>
            <v-col cols="5">
              <span class="text-body-2 text--secondary">商品ID*</span>
              <v-text-field
                color="primary"
                :readonly="mode == 2"
                outlined
                dense
                hide-details
                v-model="editedItem.id"
              >
              </v-text-field>
            </v-col>

            <v-col cols="7">
              <span class="text-body-2 text--secondary">商品名(简称)*</span>
              <Help text="请填写简称，只做内部记录使用，简单易懂即可" />
              <v-text-field
                color="primary"
                outlined
                dense
                hide-details
                v-model="editedItem.productName"
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="7">
              <span class="text-body-2 text--secondary">一级类目*</span>
              <v-autocomplete
                color="primary"
                outlined
                dense
                hide-details
                :items="allCategorys"
                item-text="name"
                item-value="uid"
                no-data-text="无"
                v-model="editedItem.firstCategory"
              >
                <template v-slot:item="data">
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ data.item.name }}
                    </v-list-item-title>
                    <v-list-item-subtitle class="mt-1 caption">
                      <span>👉</span>
                      <span>
                        扣点:
                        {{
                          typeof categoryIdToInfo[data.item.uid].deduction ==
                          "string"
                            ? categoryIdToInfo[data.item.uid].deduction
                            : categoryIdToInfo[data.item.uid].deduction + "%"
                        }}
                      </span>
                      <span>👉</span>
                      <span>
                        运费险:
                        {{
                          typeof categoryIdToInfo[data.item.uid].insurance ==
                          "string"
                            ? categoryIdToInfo[data.item.uid].insurance
                            : categoryIdToInfo[data.item.uid].insurance + "￥"
                        }}</span
                      >
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </template>
              </v-autocomplete>
            </v-col>
            <v-col cols="5">
              <span class="text-body-2 text--secondary">店铺名*</span>
              <v-autocomplete
                color="primary"
                outlined
                dense
                hide-details
                :items="allShops"
                v-model="editedItem.shopName"
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-divider class="my-8" />
          <v-row>
            <span class="text-subtitle-1">内部归属</span>
          </v-row>
          <v-row>
            <v-col cols="5">
              <span class="text-body-2 text--secondary">部门*</span>
              <v-autocomplete
                color="primary"
                outlined
                dense
                :items="
                  allDepartments.filter((d) =>
                    user.permission.a.d.find((i) => i == d.uid)
                  )
                "
                no-data-text="无"
                v-model="editedItem.department"
                menu-props="auto"
                hide-details
                single-line
                item-text="name"
                item-value="uid"
              ></v-autocomplete>
            </v-col>

            <v-col cols="4">
              <span class="text-body-2 text--secondary">组别*</span>
              <v-autocomplete
                color="primary"
                outlined
                dense
                v-model="editedItem.team"
                :items="
                  allTeams.filter((g) =>
                    user.permission.a.g.find((i) => i == g.uid)
                  )
                "
                no-data-text="无"
                menu-props="auto"
                hide-details
                item-text="name"
                item-value="uid"
                single-line
              ></v-autocomplete>
            </v-col>

            <v-col cols="3">
              <span class="text-body-2 text--secondary">持品人*</span>
              <v-autocomplete
                outlined
                dense
                color="primary"
                v-model="editedItem.owner"
                :items="
                  allUsers.filter(
                    (i) =>
                      JSON.parse(i.permission).a &&
                      JSON.parse(i.permission).a.g &&
                      JSON.parse(i.permission).a.g.find(
                        (id) => id == editedItem.team
                      )
                  )
                "
                no-data-text="无"
                menu-props="auto"
                hide-details
                single-line
                item-text="nick"
                item-value="uid"
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-divider class="my-8" />
          <v-row>
            <v-col cols="4">
              <span class="text-body-2 text--secondary">发货方式</span>
              <v-combobox
                color="primary"
                outlined
                dense
                hide-details
                :items="['手动', '聚水潭', '旺店通', '店管家']"
                v-model="editedItem.transportWay"
              ></v-combobox>
            </v-col>

            <v-col cols="8" v-if="editedItem.transportWay == '聚水潭'">
              <span class="text-body-2 text--secondary text-no-wrap">
                <!-- {{ editedItem.transportWay == "聚水潭" ? "聚水潭仓库*" : "聚水潭仓库" }} -->
                聚水潭仓库*
              </span>
              <v-text-field
                color="primary"
                outlined
                dense
                hide-details
                single-line
                v-model="editedItem.storehouse"
              >
                <template v-slot:prepend-inner>
                  <span style="margin-top: 5px"> 聚水潭： </span>
                </template>
              </v-text-field>
            </v-col>

            <v-col cols="8" v-if="editedItem.transportWay != '聚水潭'">
              <span class="text-body-2 text--secondary">备注</span>
              <v-text-field
                color="primary"
                outlined
                dense
                hide-details
                v-model="editedItem.note"
              >
              </v-text-field>
            </v-col>

            <v-expand-transition>
              <!-- 用一个container消除动画卡顿 -->
              <v-container v-if="editedItem.transportWay == '聚水潭'">
                <v-col cols="12">
                  <span class="text-body-2 text--secondary">备注</span>
                  <v-text-field
                    color="primary"
                    outlined
                    dense
                    hide-details
                    v-model="editedItem.note"
                  >
                  </v-text-field>
                </v-col>
              </v-container>
            </v-expand-transition>
          </v-row>
        </v-container>

        <v-card-actions>
          <p class="caption font-italic font-weight-thin">带*为必填项目</p>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="productInfoDialog = false">
            取消
          </v-btn>
          <v-btn color="blue darken-1" text @click="save" :disabled="isEmp">
            保存
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 归属变化Dialog -->
    <v-dialog v-model="ascriptionChangeDialog" max-width="370px">
      <v-card>
        <v-card-title>
          <span class="text-subtitle-1">商品归属发生变化, 请指定变化时间</span>
        </v-card-title>

        <div class="my-1">
          <v-data-table
            :headers="[
              { align: 'start', value: 'a' },
              { align: 'start', value: 'b', text: '旧数据' },
              { align: 'start', value: 'c' },
              { align: 'start', value: 'd', text: '新数据' },
            ]"
            :items="[
              {
                b: departmentIdToName[oldItem.department],
                c: '👉👉👉',
                d: departmentIdToName[editedItem.department],
              },
              {
                b: teamIdToName[oldItem.team],
                c: '👉👉👉',
                d: teamIdToName[editedItem.team],
              },
              {
                b: userIdToNick[oldItem.owner],
                c: '👉👉👉',
                d: userIdToNick[editedItem.owner],
              },
            ]"
            hide-default-footer
            disable-sort
          >
          </v-data-table>
        </div>
        <v-col class="px-8 pt-3 pb-2 product-dialog">
          <v-row>
            <v-col>
              <span class="text-body-2 text--secondary"> 选择变化日期* </span>
              <v-menu
                ref="menuA"
                v-model="datePicker"
                :close-on-content-click="false"
                :return-value.sync="editedItem.startTime"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="editedItem.startTime"
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    outlined
                    dense
                    hide-details
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="editedItem.startTime"
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
                    @click="$refs.menuA.save(editedItem.startTime)"
                  >
                    确定
                  </v-btn>
                </v-date-picker>
              </v-menu>
            </v-col>
          </v-row>
        </v-col>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="ascriptionChangeDialog = false"
          >
            取消
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="ascriptionSave"
            :disabled="!editedItem.startTime"
          >
            保存
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 删除Dialog -->
    <v-dialog v-model="deleteDialog" max-width="450px">
      <v-card class="delete-dialog">
        <v-card-title class="text-subtitle-1"
          >{{ deleteItem.productName }}
        </v-card-title>

        <div class="delete-table-container mt-2 mb-1">
          <v-data-table
            :headers="[
              { align: 'start', value: 'key' },
              { align: 'start', value: 'value' },
            ]"
            :items="deleteItemParse"
            hide-default-footer
            hide-default-header
            disable-sort
          >
            <template v-slot:[`item.key`]="{ item }">
              <div class="ml-3">
                {{ item.key }}
              </div>
            </template>
          </v-data-table>
          <div class="px-7 mt-3">
            <v-row>
              <v-col cols="4">
                <span class="text-body-2 text--secondary"> 选择下架日期* </span>
                <v-menu
                  ref="menuB"
                  v-model="datePicker"
                  :close-on-content-click="false"
                  :return-value.sync="editedItem.underTime"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="editedItem.underTime"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                      outlined
                      dense
                      hide-details
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="editedItem.underTime"
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
                      @click="$refs.menuB.save(editedItem.underTime)"
                    >
                      确定
                    </v-btn>
                  </v-date-picker>
                </v-menu>
              </v-col>
              <v-col cols="8">
                <span class="text-body-2 text--secondary">下架原因*</span>
                <v-text-field
                  color="primary"
                  outlined
                  dense
                  hide-details
                  v-model="editedItem.note"
                >
                </v-text-field>
              </v-col>
            </v-row>
          </div>
        </div>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="deleteDialog = false"
            >取消</v-btn
          >
          <v-btn
            color="red darken-1"
            text
            @click="sureDelete"
            :disabled="isConfirm"
          >
            <v-icon small class="mr-1"> mdi-delete </v-icon>下架
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>


<script>
import { mapState } from "vuex";

import { addProducts } from "@/settings/product";
import { editProduct } from "@/settings/product";
import { deleteProduct } from "@/settings/product";
import { loadProducts } from "@/settings/product";
//import { getClass } from "@/settings/product";

import { javaUTCDateToString } from "@/libs/utils";

import SkuTable from "@/components/SkuTable/SkuTable";
import PageHeader from "@/components/PageHeader";
import Help from "@/components/Help";
//import SelectDialog from "@/components/SelectDialog";

export default {
  components: {
    SkuTable,
    PageHeader,
    Help,
    //SelectDialog,
  },
  data: () => ({
    categoryInfo: {},
    selectedProductItem: [],
    ifAction: false,
    mode: 0,

    //筛选菜单
    menu: {}, //类别可选项

    search: {
      //选中项
      select: {
        //类别筛选
        department: [],
        owner: [],
        team: [],
        transportWay: [],
        firstCategory: [],
        shopName: [],
      },
      search: {
        //模糊查找
      },
    },

    searchPreview: "",

    //分页懒加载
    totalProducts: 50,
    options: {},

    productInfoDialog: false,

    deleteDialog: false, //删除弹框
    deleteItem: {},
    deleteItemParse: [],

    //二级展开
    expanded: [],

    //主表加载
    loading: false,

    //主表头, 内容
    headers: [],
    products: [],

    headersContent: [
      { text: "商品ID", value: "id" },
      { text: "商品名", value: "productName" },
      { text: "部门", value: "department" },
      { text: "组别", value: "team" },
      { text: "持品人", value: "owner" },
      { text: "店铺名", value: "shopName" },
      { text: "一级类目", value: "firstCategory" },
      { text: "发货方式", value: "transportWay" },
      { text: "聚水潭仓库", value: "storehouse" },
      { text: "备注", value: "note" },
    ],

    oldItem: {},
    editedItem: {},

    idToNick: {},

    ascriptionChangeDialog: false,
    datePicker: false,
  }),

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

    isEmp: function () {
      var check = [
        "id",
        "department",
        "team",
        "owner",
        "shopName",
        "productName",
        "firstCategory",
      ];

      var pass = true;
      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false;
      });
      return !pass;
    },

    isConfirm: function () {
      var check = ["note", "underTime"];
      var pass = true;
      check.forEach((item) => {
        if (!this.editedItem[item]) pass = false;
      });
      return !pass;
    },
  },

  watch: {
    options: {
      handler() {
        this.loadData();
      },
      deep: true,
    },

    "search.search": {
      handler() {
        this.searchPreview = "";

        for (let name in this.search.search) {
          if (!this.search.search[name]) continue;
          if (typeof this.search.search[name] == "string") {
            this.search.search[name] = this.search.search[name].trim();
          }
          if (this.search.search[name]) {
            this.searchPreview += `${
              this.headersContent.find((i) => i.value == name).text
            }：${this.search.search[name]} ，`;
          }
        }
        this.searchPreview = this.searchPreview
          ? this.searchPreview.slice(0, -1)
          : "点击列名可以进行模糊搜索";
      },
      deep: true,
      immediate: true,
    },
  },

  created() {
    this.init();
  },

  mounted() {
    if (localStorage.ProductIdAutoComplete) {
      this.addButtonAutoCompleteId(localStorage.ProductIdAutoComplete);
      localStorage.removeItem("ProductIdAutoComplete");
    }
  },

  methods: {
    remove(props, option) {
      console.log(option);
      console.log(this.search.search);
      this.search.search[props.header.value].splice(option.index, 1);
    },
    parseDate(time) {
      return javaUTCDateToString(time);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },
    init() {
      // getClass({})
      //   .then((res) => {
      //     this.menu = res.data;
      //     console.log(this.menu);
      //     console.log(res.data);
      //   })
      //   .catch(() => {});
      //有watch search.search, init时不需要loadData
    },

    showHeaders() {
      this.headers = this.headersContent;
      console.log(this.search);
    },

    refreshData(a) {
      if (a.select) {
        this.search.select[a.select.key] = a.select.value;
      } else {
        console.log("未知");
      }
      this.loadData();
    },

    clickRow(item, event) {
      // console.log(this.departmentList);
      if (event.isExpanded) {
        const index = this.expanded.findIndex((i) => i === item);
        this.expanded.splice(index, 1);
      } else {
        this.expanded.push(item);
      }
    },

    loadData() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      // console.log({ page, itemsPerPage, match: JSON.stringify(this.search) });
      loadProducts({ page, itemsPerPage, match: JSON.stringify(this.search) })
        .then((res) => {
          this.loading = false;
          console.log(res.data);
          this.showHeaders();
          this.products = res.data.products;
          this.totalProducts = res.data.total;
          //this.global.infoAlert("泼发EBC：" + res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    addButton() {
      this.editedItem = {};
      this.mode = 1; //新增
      this.productInfoDialog = true;
    },

    addButtonAutoCompleteId(id) {
      this.editedItem = { id };
      this.mode = 1; //新增
      this.productInfoDialog = true;
    },

    editProductButton() {
      this.mode = 2; //修改
      this.oldItem = { ...this.selectedProductItem[0] };
      this.editedItem = { ...this.selectedProductItem[0] };
      this.productInfoDialog = true;
    },

    deleteProductItem() {
      // console.log(this.selectedProductItem);
      this.deleteItem = this.selectedProductItem[0];
      this.deleteItemParse = [
        {
          key: "商品ID",
          value: this.selectedProductItem[0].id,
        },
        {
          key: "商品名",
          value: this.selectedProductItem[0].productName,
        },
        {
          key: "店铺名",
          value: this.selectedProductItem[0].shopName,
        },
        {
          key: "一级类目",
          value: this.selectedProductItem[0].firstCategory,
        },
      ];

      this.deleteDialog = true;
    },

    sureDelete() {
      deleteProduct({ id: this.selectedProductItem[0].id })
        .then((res) => {
          this.global.infoAlert("泼发EBC：" + res.data);
          this.deleteDialog = false;
          this.ifAction = false;
          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：error");
          }, 100);
        });
      this.selectedProductItem = [];
    },

    save() {
      this.productInfoDialog = false;
      if (this.mode == 1) {
        this.add();
      } else {
        if (
          this.oldItem.department != this.editedItem.department ||
          this.oldItem.team != this.editedItem.team ||
          this.oldItem.owner != this.editedItem.owner
        ) {
          this.ascriptionChangeDialog = true;
        } else {
          this.edit();
        }
      }
    },

    ascriptionSave() {
      this.ascriptionChangeDialog = false;
      this.edit();
    },

    add() {
      if (/[^\d]/.test(this.editedItem.id)) {
        this.global.infoAlert("泼发EBC：商品ID格式错误");
        return;
      }
      this.loading = true;
      // console.log(this.editedItem);
      addProducts(this.editedItem)
        .then((res) => {
          this.loading = false;
          this.global.infoAlert("泼发EBC：" + res.data);
          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：上传失败");
          }, 100);
        });
    },

    edit() {
      // var args = { ...this.editedItem };
      // console.log(this.editedItem);
      // console.log(args);
      // if (args.freightToPayment == null) { delete args.freightToPayment; }
      // console.log(args);

      var args = { ...this.editedItem };

      //预处理
      if (args.storehouse == null) delete args.storehouse;
      if (args.startTime) args.startTime = args.startTime.replaceAll("-", "/");

      // console.log(args);
      this.loading = true;
      editProduct(args)
        .then((res) => {
          this.loading = false;
          this.global.infoAlert("泼发EBC：" + res.data);
          //刷新页面数据
          this.loadData();
        })
        .catch(() => {
          this.loading = false;
          setTimeout(() => {
            this.global.infoAlert("泼发EBC：修改失败");
          }, 100);
        });
      this.selectedProductItem = [];
    },
  },
};
</script>

<style src="./PartnerGet.scss" lang="scss">
//we grow, we sow, we feed our people;
//we learn, we build, we protect our people.
//keep forward, we are the proletariet.
</style>

