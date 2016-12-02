import { SET_PRODUCTS } from '../../products-types'

// special syntax due to the computed property name
export const mutations = {
  [SET_PRODUCTS] (state, products) {
    state.products = products
  }
}
