<template>
  <v-container fluid class="productsput-page">
    <h1 class="page-title mt-10 mb-9">SKU录入</h1>

    <v-card>
      <v-card-title class="pa-6 pb-3">
        <p>选择商品</p>
      </v-card-title>

      <v-container fluid>
        <v-select
          v-model="select"
          :hint="`创建日期：${select.abbr}，现有SKU：100`"
          :items="items"
          item-text="state"
          item-value="abbr"
          persistent-hint
          return-object
          single-line
        ></v-select>
      </v-container>

      <div class="dropbox">
        <h2 class="text-center">把要上传的文件拖动到这里</h2>
      </div>

      <div>
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
      select: { state: "Flo345rida", abbr: "FL" },
      items: [
        { state: "Florida888", abbr: "FL" },
        { state: "Georgia", abbr: "GA" },
        { state: "Nebraska", abbr: "NE" },
        { state: "California", abbr: "CA" },
        { state: "New York", abbr: "NY" },
        { state: "F99999", abbr: "FL" },
        { state: "Georgia2", abbr: "GA" },
        { state: "234", abbr: "NE" },
        { state: "234", abbr: "CA" },
        { state: "N3ew York", abbr: "NY" },
        { state: "Flor7ida", abbr: "FL" },
        { state: "Ge5orgia", abbr: "GA" },
        { state: "Neb6raska", abbr: "NE" },
        { state: "California", abbr: "CA" },
        { state: "New4 York", abbr: "NY" },
        { state: "Flo345rida", abbr: "FL" },
        { state: "Georgi3a", abbr: "GA" },
        { state: "Nebras2ka", abbr: "NE" },
        { state: "Cali23fornia", abbr: "CA" },
        { state: "New York", abbr: "NY" },
        { state: "Flori2da", abbr: "FL" },
        { state: "Geor2gia", abbr: "GA" },
        { state: "Nebraska", abbr: "NE" },
        { state: "Cali2fornia", abbr: "CA" },
        { state: "New2 York", abbr: "NY" },
        { state: "Flo2rida", abbr: "FL" },
        { state: "Geor2gia", abbr: "GA" },
        { state: "Neb2raska", abbr: "NE" },
        { state: "Cal2ifornia", abbr: "CA" },
        { state: "New2 York", abbr: "NY" },
        { state: "Flo2rida", abbr: "FL" },
        { state: "Geor2gia", abbr: "GA" },
        { state: "Nebraska", abbr: "NE" },
        { state: "Ca2lifornia", abbr: "CA" },
        { state: "New York", abbr: "NY" },
        { state: "Fl22orida", abbr: "FL" },
        { state: "Geo2rgia", abbr: "GA" },
        { state: "Neb2raska", abbr: "NE" },
        { state: "Cali2fornia", abbr: "CA" },
        { state: "New 2York", abbr: "NY" },
        { state: "Flor2ida", abbr: "FL" },
        { state: "Geor2gia", abbr: "GA" },
        { state: "Neb22raska", abbr: "NE" },
        { state: "Cali2fornia", abbr: "CA" },
        { state: "New 2York", abbr: "NY" },
        { state: "Florida", abbr: "FL" },
        { state: "Ge2orgia", abbr: "GA" },
        { state: "Ne2braska", abbr: "NE" },
        { state: "Cal2ifornia", abbr: "CA" },
        { state: "New 2York", abbr: "NY" },
        { state: "Flor22ida", abbr: "FL" },
        { state: "Georgia", abbr: "GA" },
        { state: "Nebr2aska", abbr: "NE" },
        { state: "Cal2ifornia", abbr: "CA" },
        { state: "New2 York", abbr: "NY" },
        { state: "Flo2rida", abbr: "FL" },
        { state: "Geor2gia", abbr: "GA" },
        { state: "Nebraska", abbr: "NE" },
        { state: "Cali1fornia", abbr: "CA" },
        { state: "New 21York", abbr: "NY" },
        { state: "Flor1ida", abbr: "FL" },
        { state: "Georg21ia", abbr: "GA" },
        { state: "Nebras242ka", abbr: "NE" },
        { state: "Califo5rnia", abbr: "CA" },
        { state: "New York", abbr: "NY" },
      ],
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