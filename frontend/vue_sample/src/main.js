import Vue from 'vue'
import App from './App'

import VueResource from 'vue-resource'
Vue.use(VueResource)
// set the API root so we can use relative url's in our actions.
var config = require('../config')
var port = process.env.PORT || config.dev.port
Vue.http.options.root = `http://localhost:${port}/api`

// import some global styles
import './styles/style.scss'

import store from './store'

/* eslint-disable no-new */
new Vue({
  el: '#app',
  store,
  render: h => h(App)
})
