<template>
  <v-container fluid class="productsput-page">
    <h1 class="page-title mt-10 mb-6">录入SKU信息</h1>

    <v-card class="mx-1 mb-1">
      <v-card-title class="pa-6 pb-3"> </v-card-title>
      <v-card-text class="pa-6 pt-0">
        <v-row no-gutters class="productsput-widget pb-6">
          <v-col cols="12" class="card-dark-grey">
            <h6>将.xslx文件拖入此处</h6>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
export default {
  name: "ProductsPut",
};
</script>

<style src="./ProductsPut.scss" scoped lang="scss"></style>