import { http } from 'vue'
import { FETCH_PRODUCTS, SET_PRODUCTS } from '../../products-types'

export const actions = {
  [FETCH_PRODUCTS] ({ commit }) {
    return http.get('products/')
      .then((response) => commit(SET_PRODUCTS, response.body.data))
  }
}
