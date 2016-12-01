# Micro-service develop base rules
This document shows the rules when we start a new micro-service.

## Micro-service Scope && collection.
Before we start, we should figure out the detail scope of this micro-service, so that we can know what should this micro-service do or not do clearly.
  Also, we should know the collections between this service and other services, and try our best to make their relation less and simple. 
  At last, each micro-service can only access other micro-services by their interface(Restful APi) that they exposed.
   
## Use Package-info
 each package should contains its own `package-info.java`

## Use plural to name our package, 
like`io.reactivesw.carts` not`io.reactivesw.cart`

## Database
### Naming table  
Table name should has micro-service's name as prefix, like:
```
@table(name = "myservice_mytable")
```
### Use Column Type
We can use all the kind of type that our db support, but we still have some basic rule for it:
1. `JSON`, if your column need to support dynamic fields, the you can use JSON, If your column need very frequently search or query, you should not use JSON and save is in an independent table.

## Domain
Should only contains domain model and domain service.

### Domain model
Domain model should under `entities` package. And we have two kind of domain model: business model, value model.a

1. Naming
Usually, our domain model has strong relation with the database entity, so we name our business model with `entity` as suffix. Like:
```
ProductEntity
```
and we name our value model with `Value` as suffix, and keep it in the subfolder`values`. like:
```
ProductNameValue
```

If the entity's column name is the same with the property name, we do not need to add `name` in `@Column`, else we need to add the name, like:
```
@Column
parent

@Column(name = "external_id")
externalId
```
sometimes, domain model may contains some word that is the saved keywords of the db, at this time ,you need to rename the column, like:
```
@Column(name = "product_type_key")
key
```
2. Identifier
Normally, we use the `uuid` as identifier of the domain model. But for value model, if not necessary, we use the business model's id for identifier. 

3. Version and time
For all business model(like `product`), we should contains an version, createAt, lastModifiedAt

4. Property type
We only use wrap class not primitive type, because the primitive type may have default value that may makes some confusion

5. Domain model 


## Domain service
Domain service only handle business logic.

1. Entry & output
the entry and output of the domain service should the domain model, not the DTO.

# Restful API
For now, all of our micro-service expose their service as RESTful service

1. Use Restful API standard
Use the standard to define our restful api. like use the verb, plural


# Controller
Actually, the controller is the place we expose our service. And we finish these works here:

1. check the parameters, can organize the api model
2. call domain service or other micro-service to finish the work
3. handle the exception if needed
4. return the result data


# How to submit
Each step should have someone review.
1. before start coding, you should have the documents for design, especially the work flow
2. design the RESTful API and the model used, and gives the swagger-ui.
3. design the domain model
4. coding: domain service
5. coding: controller and other code
6. test

#How to review
this is fellow `How to submit`
1. review the document: work flow, if it's work flow is correct.
2. review the api for: the api pattern, the model(fellow our review guide) 
3. review the domain model and service: fellow the `Domain` and our `review guide`
4. review the controller: review the work it dose
5. review test: if it covers all the work flow and all kind of situation




