# Start A New Vue Project
Base on [Jayway's Vue.js 2.0 workshop](https://jayway.github.io/vue-js-workshop/), this document descripts the steps to scaffold a project and add more components to make it a good fit for non-trivial project. The sample project is in the [vue_sample](./vue_sample).

## 1. Scaffold a Project 

Run `npm install -g vue-cli` to install vue-client. If you already have it, run `npm update -g vue-cli` to update it to the latest version. You may need to use `sudo` to install it as a global package. 

Run `vue init webpack my-project` to create a new project named `my-project`. When asked, use recommended default settings and answer "Y" to unit test and e2e test.  

For "vue-clie@2.5.0" (the version when writing this doc), edit the package.json and change the following two lines:
* change vue version to the latest (find it in https://github.com/vuejs/vue/releases): `"vue": "^2.0.5",`
* change eslint plugin promise to supress the warning: `"eslint-plugin-promise": "^3.3.0",`

Then run `npm install` to  install all packages used in the project. 

Run `npm run dev` to check that the site is up and running correctly. 

Finally, copy [resources/gitignore](./resources/gitignore) to the `.gitignore` file in the project folder. 

## 2. Render the Root Vue Instance
In the initial project scaffold, the root Vue instance has three options: `el`, `template` and `components`. To make the rendering explict (in future, we may want to set server-side context), we use the `render` option to render the root component and delete the `template` and `components` options. The final `src/main.js` is as the following: 

```js
import Vue from 'vue'
import App from './App'

/* eslint-disable no-new */
new Vue({
  el: '#app',
  render: h => h(App)
})
```

It is a convention in Vue ecosystem to aliase the first parameter `createElement` of the `render` function to `h`. Please see https://vuejs.org/v2/guide/render-function for details.  

## 3. Use BootStrap 4 Styles
### 3.1. Install BootStrap 4
Run `npm install --save bootstrap@4.0.0-alpha.5` to install BootStrap 4. 

### 3.2. Install `node-saas` and `sass-loader`
Run the following two commands to install `node-sass` and  `sass-loader`. 
```sh
npm install --save-dev node-sass
npm install --save-dev sass-loader
```

### 3.3. Create a Style File with Standard Style
create a `src/styles` folder and create a `style.scss` file with the following content: 
```
@import "../../node_modules/bootstrap/scss/bootstrap-flex.scss";
```

### 3.4. Use the Created Style 
Import the standard bootstrap style by adding the following contents to `main.js`. 

```js
// import some global styles
import './styles/style.scss'
```

### 4. Create a Product List Page
First, delete the `src/components/Hello.vue` file. 

Second, create the `src/components/ProductList.vue` file with the following content: 
```
<template>
  <table class="table table-hover">
     <thead>
      <tr>
        <th>Product Id</th>
        <th>Name</th>
        <th>Description</th>
        <th>Price</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="product in products" track-by="id">
        <td>{{product.id}}</td>
        <td>{{product.name}}</td>
        <td>{{product.description}}</td>
        <td>{{product.price}}</td>
      </tr>
    </tbody>
  </table>
</template>
```

Then change `App.vue` as the following to use the new product list component. 
```js
<template>
  <product-list></product-list>
</template>

<script>
import ProductList from './components/ProductList'

export default {
  name: 'app',
  components: {
    ProductList
  }
}
</script>
```

Optionally, run `npm run dev` to check that the site is up and running correctly. 

## 5. Create The Store
We use modules to manage the store for different parts of an application. Run `npm install --save vuex` to install the state store plugin. 

## 5.1. Create Type Constants
Create `src/store/products-types.js` file as the following:

```js
export const FETCH_PRODUCTS = 'products/FETCH_PRODUCTS'
export const SET_PRODUCTS = 'products/SET_PRODUCTS'
export const GET_PRODUCTS = 'products/GET_PRODUCTS'
```

### 5.2. Create the `getProducts` Getter
Create `src/store/modules/products/getters.js` as the following:

```js
import { GET_PRODUCTS } from '../../products-types'

export const getters = {
  [GET_PRODUCTS] (state) {
    return state.products
  }
}
```

### 5.3. Create the Products Store Module
Create `src/store/modules/products/index.js` with the following content: 

```js
import { getters } from './getters'

const initialState = {
  products: []
}

export default {
  state: {...initialState},
  getters
}
```

### 5.4. Create the Store with the Products Store Module
Create `src/store/index.js` as following: 
```js
import Vue from 'vue'
import Vuex from 'vuex'

import products from './modules/products'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    products
  },
  strict: debug
})
```
 
### 5.5. Add the Store to the Root Instance
In `src/main.js`, import the newly created store and add it to the root instance option. After this, all child components can access the store. 

```js
// Step 1: import it
import store from './store'

new Vue({
  el: '#app',

  // Step 2: set the option
  store,
  render: h => h(App)
})
```

### 5.6. Use the Store in ProductList Component
Add the following content to `src/components/ProductList.vue` to get products data from the store using a computed property. 

```js
<script>
import { mapGetters } from 'vuex'
import * as types from '../store/products-types'

export default {
  computed: mapGetters({
    products: types.GET_PRODUCTS
  })
}
</script>
```

In the above code, we map the `types.GET_PRODUCTS` getter meethod to a local computed property with a name `products`. 

## 6. Create HTTP Server API and Set HTTP Client 

### 6.1 Create HTTP Server API
First, create `/server/src/product-data.js` with the following code:
```js
module.exports = [
    {
        id: '001',
        name: 'COBOL 101 vintage',
        description: 'Learn COBOL with this vintage programming book',
        price: 399,
    },
    {
        id: '007',
        name: 'Sharp C2719 curved TV',
        description: 'Watch TV like with new screen technology',
        price: 1995,
    },
    {
        id: '719',
        name: 'Remmington X mechanical keyboard',
        description: 'Excellent for gaming and typing',
        price: 595,
    }
]
```

Then, create `/server/src/get-products.js` with the following code:
```js
const products = require('./products-data')

exports.getProducts = (req, res) => {
  res.status(200); // 200 OK
  res.json({data: products})
}
```

Finally, add the server API by inserting the following two lines to `build/dev-server.js`, right after creating `var app = express()`:
```js
var productsApi = require('../server/src/get-products')
app.get('/api/products', productsApi.getProducts)
```

### 6.2. Install `vue-resource`
First, run `npm install --save vue-resource` to install `vue-resource` that is used to make REST API requests. 

Then, in `src/main.js`, add the following lines: 

```js
mport VueResource from 'vue-resource'
Vue.use(VueResource)
// set the API root so we can use relative url's in our actions.
var config = require('../config')
var port = process.env.PORT || config.dev.port
Vue.http.options.root = `http://localhost:${port}/api`
```

## 7. Use Mutations and Actions

### 7.1. Add Type Constants
Edit the `src/store/products-types.js` file as the following:

```js
export const FETCH_PRODUCTS = 'products/FETCH_PRODUCTS'
export const SET_PRODUCTS = 'products/SET_PRODUCTS'
export const GET_PRODUCTS = 'products/GET_PRODUCTS'
```

### 7.2. Create the `FETCH_PRODUCTS` Mutation
Create `src/store/modules/products/mutations.js` as the following:
```js
import { SET_PRODUCTS } from '../../products-types'

// special syntax due to the computed property name
export const mutations = {
  [SET_PRODUCTS] (state, products) {
    state.products = products
  }
}
```

### 7.3. Create the `FETCH_PRODUCTS` Action
Create the `src/store/modules/products/actions.js` as the following: 

```js
import { http } from 'vue'
import { FETCH_PRODUCTS, SET_PRODUCTS } from '../../products-types'

export const actions = {
  [FETCH_PRODUCTS] ({ commit }) {
    return http.get('products/')
      .then((response) => commit(SET_PRODUCTS, response.body.data))
  }
}
```

### 7.4. Update the Products Store Module
Edit `src/store/modules/products/index.js` to have the following content: 

```js
import { getters } from './getters'
import { mutations } from './mutations'
import { actions } from './actions'

const initialState = {
  products: []
}

export default {
  state: {...initialState},
  getters,
  mutations,
  actions
}
```

### 7.5. Fetch Data When ProductList is Created
Edit the `<script>` in `src/components/ProductList.vue` to have the following content: 

```js
import { mapGetters, mapActions } from 'vuex'
import * as types from '../store/products-types'

export default {
  computed: mapGetters({
    products: types.GET_PRODUCTS
  }),
  methods: {
    ...mapActions({
      fetchProducts: types.FETCH_PRODUCTS
    })
  },
  created () {
    this.fetchProducts()
  }
}
```

In the above code, we map the `types.FETCH_PRODUCTS` as a local method `fetchProducts` and call it when the component is created. 

