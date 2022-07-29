<template>
  <div>
    <template>
      <v-card>
        <v-card-title>
          <p>上传订单信息</p>
        </v-card-title>

        <v-card
          id="dropbox"
          class="d-flex align-center justify-center mx-10 my-5 transition-swing"
          :min-height="180"
          :color="hover ? '#fafafa' : '#fff'"
          @dragenter.prevent="dragenter($event)"
          @dragleave.prevent="dragleave($event)"
          @drop.prevent="drop($event)"
          @dragover.prevent=""
          @dragend.prevent=""
        >
          <h5>{{ status }}</h5>
        </v-card>
        <v-card-text> 请确认文件选择无误 </v-card-text>
      </v-card>
    </template>

<v-subheader></v-subheader>

    <template>
      <v-data-table
        loading-text="加载中... 请稍后"
        no-data-text="空"
        item-key=""
        hide-default-footer
        class="elevation-1"
        height="400px"
        :loading="loading"
        :headers="returnHeader"
        :items="returnItems"
        :options.sync="options"
        :items-per-page="50"
      >
      <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>历史记录</v-toolbar-title>
              <v-divider class="mx-4" inset vertical></v-divider>

              <v-spacer></v-spacer>
            </v-toolbar>
          </template>
      </v-data-table>
    </template>
  </div>
</template>
<script>
import { addOrder } from "@/settings/order";
import * as XLSX from "xlsx";
export default {
  name: "SkuUpload",
  components: {},

  props: {
    product: Object,
  },
  data() {
    return {
      status: "",
      dialog: false,
      dropActive: false,

      hover: false,
      maxWidth: 500,

      loading: false,

      wrong: 0,
    };
  },
  mounted() {
    this.status = "拖拽上传订单信息";
  },
  watch: {
    hover(value) {
      this.status = value ? "松开上传" : "拖拽上传订单信息";
    },
  },
  methods: {
    upload() {
      addOrder({});
    },

    dragenter() {
      this.maxWidth = 550;
      this.hover = true;
    },

    dragleave() {
      this.maxWidth = 500;
      this.hover = false;
    },

    drop(event) {
      this.maxWidth = 500;
      this.hover = false;
      console.log(event);

      //加载
      if (event.dataTransfer.files.length == 0) {
        console.log("拦截");
        return;
      }

      if (event.dataTransfer.files.length > 1) {
        console.log("拦截");
        this.showInfo("泼发EBC：拖拽文件数量过多");
        return;
      }

      this.file = event.dataTransfer.files[0];
      console.log(this.file);

      if (!this.file.name.endsWith(".xlsx")) {
        console.log("拦截");
        this.showInfo("泼发EBC: 只支持xlsx格式");
        return;
      }

      var reader = new FileReader();
      reader.onload = (e) => {
        console.log("加载完毕");

        console.log("数据处理");

        var data = new Uint8Array(e.target.result);
        data = this.stox(XLSX.read(data, { type: "array" }));

        console.log(data);
        console.log("数据处理完毕");
      };
    },
  },
};
</script>
<style scoped lang="scss">
.v-card__title {
  font-size: 1rem !important;
}

#dropbox {
  border-radius: 10px;
  color: #777;
  h5 {
    pointer-events: none;
  }
}

.checkInfo {
  .topBar {
    height: 65px;
  }
}
.v-application .v-card .v-card__title p {
  font-size: 1rem;
}

.loading {
  width: 100%;
  height: 100%;
  background-color: #777;
}
</style>
