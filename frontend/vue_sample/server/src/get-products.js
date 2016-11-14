const products = require('./products-data')

exports.getProducts = (req, res) => {
  res.status(200); // 200 OK
  res.json({data: products})
}