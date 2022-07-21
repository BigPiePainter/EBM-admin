<script>
import Vue from 'vue'

export default {
  name: "Global",
  token: "",
  log() {
    console.log(...arguments);
  },
  infoAlert(message) {
    Vue.prototype.$toast.error(message, {
      position: "top-right",
      timeout: 6000,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
      draggablePercent: 0.6,
      showCloseButtonOnHover: false,
      hideProgressBar: true,
      closeButton: "button",
      icon: true,
    });
  },
  errorAlert(message) {
    Vue.prototype.$toast.error(message, {
      position: "top-right",
      timeout: 6000,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
      draggablePercent: 0.6,
      showCloseButtonOnHover: false,
      hideProgressBar: true,
      closeButton: "button",
      icon: true,
    });
  },
};
</script>