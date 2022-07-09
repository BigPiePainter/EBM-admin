<template>
  <v-container fluid class="productsput-page">
    <h1 class="page-title mt-10 mb-9">SKU录入</h1>

    <v-card>
      <v-card-title class="pa-6 pb-3">
        <p>商品：某某某某床垫</p>
        
      </v-card-title>

      <div class="dropbox pa-16 mb-5">
        <h2 v-if="!progress" class="text-center">{{ status }}</h2>
        <div v-else>
          <v-progress-linear
            indeterminate
            color="yellow darken-2"
          ></v-progress-linear>
          <br />
          <v-progress-linear indeterminate color="green"></v-progress-linear>
          <br />
          <v-progress-linear indeterminate color="teal"></v-progress-linear>
          <br />
          <v-progress-linear indeterminate color="cyan"></v-progress-linear>
        </div>

      </div>

      <v-card-actions>
        <v-btn color="blue lighten-2" text @click="none">
          下载SKU导入模板
        </v-btn>
      </v-card-actions>
      <!-- 
      <v-card-text class="pa-6 pt-0">
        <v-row no-gutters class="productsput-widget pb-6">
          <v-col cols="12" class="card-dark-grey">
            <h6>将.xslx文件拖入此处</h6>
          </v-col>
        </v-row>
      </v-card-text>
    -->
    </v-card>
  </v-container>
</template>

<script>
export default {
  name: "ProductsPut",
  data() {
    return {
      status: "松开上传",
      progress: false,
    };
  },
};
</script>

<style lang="scss">
@import "src/styles/variables";

.productsput-page {
  .productsput-widget {
    border: 1px dashed $primary;
    padding: 32px 8px 8px 16px;
  }
}

.dropbox {
  border: 0.23rem dashed #aaa;
  min-height: 5rem;
  margin: 30px;
  text-align: center;
}
</style>