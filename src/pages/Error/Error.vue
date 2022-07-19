<template>
  <v-app>
    <v-container fluid class="error-page">
      <v-row class="d-flex justify-center">
        <v-col cols="8">
          <div class="card">
            <span class="error-logo">404</span>

            <v-btn
                class="text-capitalize"
                dark
                x-large
                :color="config.light.primary"
                to="/"
            >
              返回登陆页面
            </v-btn>
          </div>
        </v-col>
      </v-row>
  </v-container>
  </v-app>
</template>

<script>
import config from '@/config';

export default {
  name: 'Error',
  data(){
    return{
      config
    }
  }
};
</script>

<style src="./Error.scss" lang="scss"></style>
