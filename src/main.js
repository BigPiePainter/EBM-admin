import Vue from 'vue'
import App from './App.vue'
import router from './Routes'
import store from './store/index'
import vuetify from './plugins/vuetify'
import Toast from "vue-toastification";
import Global from './global'
import "vue-toastification/dist/index.css";

Vue.use(Toast);

Vue.config.productionTip = false

Vue.prototype.global = Global

new Vue({
  vuetify,
  router,
  render: h => h(App), store
}).$mount('#app')
