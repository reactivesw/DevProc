# 1. Description
The guidelines we fellowed when we design our REST API.

# 2. Design flow
The flow we design our REST API.
## 2.1 Determine what types of resources an API provides
First, determine the type of the resource. For most services, there is only two kind of type: `resource` or `list of resource`.
## 2.2 Determine the relationships between resources
Second, figure out the relationships between resources. Such as the relationships between `product` and `variant`
## 2.3 Decide the resource name and url based on types and relationships
Third, decide the name of the resource. Such as: use `customers` or `users`
## 2.4 Decide the resource schemas
Fourth, decide the resource schema. Schema is the content structure of the resource.
## 2.5 Attach minimum set of methods to resources
Last, determin the method we need to use on this resource.

# 3. How to determine resource name
- Use plural
- Use domain based name. like: `customer` not `player` in customer-info

# 4. How to determine the method and the response  body
Method	| HTTP Mapping            | HTTP Request Body                                 | 	HTTP Response Body
---|---|---|---
List    |	GET <collection URL>    | Empty	                                            | Resource list
Get     |	GET <resource URL>	    | Empty	                                            | Resource
Create	| POST <resource URL>	    | Resource                                          | Resource
Update	| PUT <resource URL>	    | Resource	                                        | Resource
Delete	| DELETE <resource URL>	  | Empty	or with a body with version                 | Empty

# 5. How to define the URL
- For resource type: 
Use `domain/resources/resource-id` or `domain/resources/resource-id/sub-resources/sub-resource-id`,
Example: `http://www.reactivesw.io/products/product1` and `http://www.reactivesw.io/products/product1/variants/variant2`

- For collection type: 
Use: `domain/resources` or `domain/resources/resource-id/sub-resources`
Example: `http://www.reactivesw.io/products` and `http://www.reactivesw.io/products/product1/variants`

# 6. Http Code and Errors
- For correct request, the service return `200`(`HttpStatus.OK`)
- For error or fault, the service return `4**` or `5**`, and `no response body` or a `simple response body with custom code and message` like:
```json
{
  "code":10001,
  "message":"you got something wrong."
}
```
Example:
Get a product by product id, return `200` and the product data as response body. Or return `404` for not found this product and empty response body.

# 7. How to add version to API
API version name should at the front of the url, like: `http://api.reactivesw.io/v1/products`.

# 8. Others
## 8.1 Seach
Seach is an special API, and should return a collection of resource.
## 8.2 Paging
Paging should return a `Paging Resource` with page id, page size and etc.
## 8.3 Filters
For `Collection` APIs, the client can add some condition for filter the resource, like: products cheaper than $20
## 8.4 Parameter & request body
Use Parameter for filter resources, and use request body to change existing resources.
Example: 
- GET `http://www.reactivesw.io/products?price=100` 
- Post `http://www.reactivesw.io/products` with product body
- Delete `http://www.reactivesw.io/products/product1` with request body contains version
All request body and reponse should use type: `application/json`


