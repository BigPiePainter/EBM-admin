<template>
  <v-container fluid class="typography-page">
    <h1 class="page-title mt-10 mb-6">录入产品信息</h1>
    <v-row>
      <v-col lg=6 cols=12>
        <v-card class="mx-1 mb-1">
          <v-card-title class="pa-6 pb-3">
          </v-card-title>
          <v-card-text class="pa-6 pt-0">
            <v-row no-gutters class="typography-widget pb-6">
              <v-col cols="12" class="card-dark-grey">
                <h6>将.xslx文件拖入此处</h6>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
      
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'Typography',
};
</script>

<style src="./Typography.scss" scoped lang="scss"></style>
