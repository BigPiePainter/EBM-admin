import Vue from 'vue'
import App from './App.vue'
import router from './Routes'
import store from './store/index'
import vuetify from './plugins/vuetify'
import Toast from "vue-toastification";
import Global from './global'
import "vue-toastification/dist/index.css";
import VueApexCharts from 'vue-apexcharts'



Vue.use(VueApexCharts)
Vue.component('apexchart', VueApexCharts)
Vue.use(Toast, {
  transition: "Vue-Toastification__fade",
  position: "top-right",
  timeout: 2000,
  closeOnClick: true,
  pauseOnFocusLoss: false,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  closeButton: "button",
  icon: true,
});

Vue.config.productionTip = false

Vue.prototype.global = Global

new Vue({
  vuetify,
  router,
  render: h => h(App), store
}).$mount('#app')
