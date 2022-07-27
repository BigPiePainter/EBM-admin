<template>
<div> 
      <v-card>
        <v-card-title>
          订单信息
          <v-spacer />
          <order-upload />
        </v-card-title>

        <v-divider />

      <v-data-table>
          <template>  

          </template>
      </v-data-table>

      </v-card>
</div>
</template>


<script>
import OrderUpload from "../../components/OrderUpload/OrderUpload.vue";

import {loadOrder} from "@/settings/order"

export default {
  components: { OrderUpload },
  data() {
    return {};
  },

  created() {
    loadOrder({})
  },

  methods: {

  },
};
</script>