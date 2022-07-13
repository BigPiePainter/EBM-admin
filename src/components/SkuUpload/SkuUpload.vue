<template>
  <div>
    <v-dialog v-model="dialog" :max-width="maxWidth">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="red lighten-2" dark v-bind="attrs" v-on="on">
          导入SKU信息
        </v-btn>
      </template>

      <v-card>
        <v-card-title>
          <p>
            {{ `${product.product_name}（${product.first_category}）上传SKU` }}
          </p>
        </v-card-title>

        <v-card
          id="dropbox"
          class="d-flex align-center justify-center ma-10 transition-swing"
          :min-height="200"
          :color="hover ? '#fafafa' : '#fff'"
          @dragenter.prevent="dragenter($event)"
          @dragleave.prevent="dragleave($event)"
          @drop.prevent="drop($event)"
          @dragover.prevent=""
          @dragend.prevent=""
        >
          <h3>把要上传的Excel文件拖到这里</h3>
        </v-card>

        <v-card-actions>
          <v-btn color="blue lighten-2" text> 下载SKU导入模板 </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="checkInfoDialog" fullscreen>
      <div class="background">
        <v-toolbar dark color="info" height="65px">
          <v-btn icon dark @click="checkInfoDialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
          <v-toolbar-title>{{
            `${product.product_name}（${product.first_category}）SKU上传预览`
          }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-toolbar-items>
            <v-btn dark text @click="dialog = false"> 0 错误</v-btn>
            <v-btn dark text @click="dialog = false"> 确认上传 </v-btn>
          </v-toolbar-items>
        </v-toolbar>
      </div>
      <Excel :height="document.documentElement.clientHeight - 65" />
    </v-dialog>
  </div>
</template>
<script>
import Excel from "@/components/Excel/Excel";

export default {
  name: "SkuUpload",
  components: {
    Excel,
  },

  props: {
    product: Object,
  },
  data() {
    return {
      dialog: false,
      checkInfoDialog: false,

      dropActive: false,

      hover: false,
      maxWidth: 600,
    };
  },
  methods: {
    dragenter() {
      this.maxWidth = 650;
      this.hover = true;
    },
    dragleave() {
      this.maxWidth = 600;
      this.hover = false;
    },
    drop(event) {
      this.maxWidth = 600;
      this.hover = false;
      console.log(event);
      this.dialog = false;

      //加载

      this.checkInfoDialog = true;
    },
  },
};
</script>
<style scoped lang="scss">
#dropbox {
  border-radius: 10px;
  color: #555;
  h3 {
    pointer-events: none;
  }
}

.background {
  height: 65px;
  background-color: #000000bb;
}
</style>