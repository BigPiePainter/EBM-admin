<template>
  <div>
    <v-card
      id="dropbox"
      tile
      class="d-flex align-center justify-center transition-swing mb-5"
      :elevation="elevation"
      :min-height="180"
      :color="hover ? '#fafafa' : '#fff'"
      @dragenter.prevent="dragenter($event)"
      @dragleave.prevent="dragleave($event)"
      @drop.prevent="drop($event)"
      @dragover.prevent=""
      @dragend.prevent=""
    >
      <span class="text-subtitle-1">{{ state }}</span>
    </v-card>
    <v-row v-if="uploadStates.length > 0">
      <v-col class="d-flex">
        <span class="text-body-2"
          >解析状态 共有{{ uploadStates.length }} 上传中
          {{ uploadStates.filter((i) => i.uploaded != i.size).length }} 解析中
          {{ uploadStates.filter((i) => i.code == 1 || i.code == 0).length }}
          成功 {{ uploadStates.filter((i) => i.code == 2).length }} 出错
          {{ uploadStates.filter((i) => !(i.code >= 0)).length }}</span
        >
        <v-spacer />
        <v-btn text small @click="deleteSucceedFileProcessStates">
          清除成功
        </v-btn>
        <v-btn text small @click="deleteFailedFileProcessStates">
          清除错误
        </v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col
        v-for="(file, i) in uploadStates.slice(
          10 * (page - 1),
          10 * (page - 1) + 10
        )"
        :key="i"
        cols="12"
        class="pt-0"
      >
        <v-card tile class="pt-2">
          <v-toolbar-items>
            <v-icon
              v-if="file.code < 0"
              class="ml-3 mr-2 mb-1 mt-1"
              color="red lighten-2"
              small
            >
              mdi-alert-circle-outline
            </v-icon>

            <v-icon v-else class="ml-3 mr-2 mb-1 mt-1" color="primary" small>
              mdi-file-excel
            </v-icon>

            <span class="text-body-2 pt-1">{{ file.name }}</span>

            <span class="ml-5 pt-1 text--secondary text-body-2">
              {{ file.state }}
            </span>

            <v-spacer></v-spacer>
            <span class="text--secondary text-body-2 pt-1"
              >{{ Math.floor(file.uploaded / 1024) }} k</span
            >
            <span class="mx-1 text-body-2 pt-1"> / </span>
            <span class="text--secondary text-body-2 pt-1"
              >{{ Math.floor(file.size / 1024) }} k</span
            >
            <span class="text--secondary ml-3 mr-3 text-body-2 pt-1"
              >{{ Math.floor((file.uploaded * 100) / file.size) }} %</span
            >
            <v-icon v-if="file.code == 2" class="mr-4 mb-1" color="green">
              mdi-check-circle-outline
            </v-icon>

            <v-btn
              v-if="file.code == 2 || file.code < 0"
              icon
              @click="deleteFileState(file, i)"
            >
              <v-icon color="grey" small> mdi-close </v-icon>
            </v-btn>
          </v-toolbar-items>
          <v-progress-linear
            :height="file.code < 0 ? 2 : 3"
            :indeterminate="file.code == 1"
            :value="(file.uploaded * 100) / file.size"
            class="mt-2"
            :color="
              file.code < 0 ? 'red' : file.code == 2 ? 'green' : 'primary'
            "
          >
          </v-progress-linear>
        </v-card>
      </v-col>
    </v-row>
    <v-row v-if="uploadStates.length > 0">
      <v-col>
        <v-pagination
          v-model="page"
          :length="Math.ceil(uploadStates.length / 10)"
        ></v-pagination>
      </v-col>
    </v-row>

    <v-data-table
      loading-text="加载中... 请稍后"
      no-data-text="空"
      item-key=""
      hide-default-footer
      class="card-shadow mt-5"
      height="calc(100vh - 340px)"
      :loading="loading"
      :headers="historyHeaders"
      :items="historyItems"
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
  </div>
</template>
<script>
import { fileUpload } from "@/settings/order";
import { getFileProcessStates } from "@/settings/order";
import { deleteFileProcessState } from "@/settings/order";

export default {
  name: "SkuUpload",
  components: {},

  props: {
    product: Object,
  },
  data() {
    return {
      page: 1,
      state: "",
      dialog: false,
      dropActive: false,
      historyHeaders: [
        { text: "用户", value: "name" },
        { text: "文件名", value: "file" },
        { text: "上传条数", value: "number" },
        { text: "上传时间", value: "time" },
      ],
      historyItems: [],

      hover: false,
      elevation: 1,

      loading: false,

      uploadStates: [],

      fileStates: [],

      interval: 0,
    };
  },
  mounted() {
    this.state = "拖拽上传订单信息";
    this.refreshFileStates();
  },
  watch: {
    hover(value) {
      this.state = value ? "松开上传" : "拖拽上传订单信息";
    },
  },
  beforeDestroy() {
    clearTimeout(this.timeout);
  },
  methods: {
    deleteFileState(file, i) {
      console.log(file, i);
      this.uploadStates.splice(i, 1);
      deleteFileProcessState({ fileName: file.name })
        .then((res) => {
          console.log("完毕", res);
        })
        .catch(() => {});
    },
    deleteFailedFileProcessStates() {
      console.log(1, this.uploadStates);
      if (this.uploadStates.filter((i) => i.code < 0).length == 0) return;
      var args = {
        fileName: this.uploadStates
          .filter((i) => i.code < 0)
          .map((i) => i.name)
          .join("!@#!#@!@#"),
      };
      this.uploadStates = this.uploadStates.filter((i) => i.code >= 0);
      deleteFileProcessState(args)
        .then((res) => {
          console.log("完毕", res);
        })
        .catch(() => {});
    },
    deleteSucceedFileProcessStates() {
      console.log(2, this.uploadStates);
      if (this.uploadStates.filter((i) => i.code == 2).length == 0) return;
      var args = {
        fileName: this.uploadStates
          .filter((i) => i.code == 2)
          .map((i) => i.name)
          .join("!@#!#@!@#"),
      };
      this.uploadStates = this.uploadStates.filter((i) => i.code != 2);
      deleteFileProcessState(args)
        .then((res) => {
          console.log("完毕", res);
        })
        .catch(() => {});
    },
    refreshFileStates() {
      console.log("refreshFileStates");
      getFileProcessStates({})
        .then((res) => {
          console.log("完毕");
          console.log(res.data.fileStates);
          this.fileStates = res.data.fileStates;
          this.fileStatesAnalyze();

          this.timeout = setTimeout(() => {
            this.refreshFileStates();
          }, 2000);
        })
        .catch(() => {
          this.timeout = setTimeout(() => {
            this.refreshFileStates();
          }, 2000);
        });
    },
    fileStatesAnalyze() {
      for (let name in this.fileStates) {
        var file = this.uploadStates.find((i) => i.name == name);

        if (file) {
          file.code = this.fileStates[name].code;
          file.state = this.fileStates[name].state;
        } else {
          this.uploadStates.push({
            name,
            size: this.fileStates[name].size,
            uploaded: this.fileStates[name].size,
            state: this.fileStates[name].state,
            code: this.fileStates[name].code,
          });
        }
      }
    },
    dragenter() {
      this.elevation = 15;
      this.hover = true;
    },

    dragleave() {
      this.elevation = 3;
      this.hover = false;
    },

    drop(event) {
      this.elevation = 3;
      this.hover = false;
      console.log(event.dataTransfer.files);

      //加载
      if (event.dataTransfer.files.length == 0) {
        console.log("拦截");
        return;
      }

      for (let file of event.dataTransfer.files) {
        if (this.uploadStates.find((i) => i.name == file.name)) {
          console.log("拦截");
          this.global.infoAlert(
            "解析状态中存在相同的文件，取消上传，文件名：" + file.name
          );
          continue;
        }

        let fileState = {};

        console.log(file.name);

        fileState.name = file.name;
        fileState.size = file.size;
        fileState.uploaded = 0;
        fileState.code = 0;
        fileState.state = "";

        this.uploadStates.push(fileState);

        if (!file.name.endsWith(".xlsx")) {
          console.log("拦截");
          fileState.code = -2;
          fileState.state = "文件后缀错误, 跳过上传";
          fileState.size = 0;
          continue;
        }

        var form = new FormData();
        form.append("file", file);

        // form.append("id", 888);
        // form.append("type", "123");
        console.log(form);
        fileUpload(form, (progressEvent) => {
          console.log("进度");
          console.log(progressEvent);
          console.log("赋值");
          console.log(progressEvent.loaded);
          fileState.size = progressEvent.total;
          fileState.uploaded = progressEvent.loaded;
          console.log(fileState);
        })
          .then((res) => {
            console.log("完毕");
            console.log(res);
          })
          .catch((error) => {
            console.log("错误！！", error);
            fileState.code = -3;
            fileState.state = "网络错误，上传失败";
          });
      }

      // var reader = new FileReader();
      // reader.onload = (e) => {
      //   console.log("加载完毕");

      //   console.log("数据处理");

      //   var data = new Uint8Array(e.target.result);
      //   data = this.stox(XLSX.read(data, { type: "array" }));

      //   console.log(data);
      //   console.log("数据处理完毕");
      // };
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
  span {
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
