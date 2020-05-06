import Vue from 'vue'
import App from './App.vue'
import VueResource from 'vue-resource'

Vue.use(VueResource);
Vue.config.productionTip = false

Vue.filter('toDecimal', (hex) => {
  if (!hex) return ''
  return parseInt(hex, 16);
});

Vue.filter('toDate', (timestamp) => {
  if (!timestamp) return ''
  return new Date(timestamp * 1000);
});

new Vue({
  render: h => h(App),
}).$mount('#app')
