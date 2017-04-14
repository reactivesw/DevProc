# Requirement Guide

In the `docs` folder of each project, there is a `reqirement.md` specifying the
business requirment of the project.

## 1. Title -- usually it is the name of service
Description of this micro-service -- the purpose of this service

## 2. The Services or futures provided
What kinds of services or futures are provided by this micro-service. Taking
`category` project for example, it could provide such features:

+ Create category
+ Delete category
+ Update category
+ Get individual category
+ Get all categories

## 3. Key points
key points of the whole project or each feature.
Taking `category` project for example, the key points of the whole project is:

```
1.   Name, description, meta title, meta description, meta keywords of category
     should be multiple language.
2.   Slug of category should be alphabetic, numeric, underscore(_) and hyphen(-)
     characters.Maximize size of slug is 256, and minimum size is 2.
3.   Name and slug of category are required, others is optional. Category could
	 be multilevel.
4.   A category can only have one parent category. each root category and its
	 descendents form a tree structure. 
```

And the key points for a single, such as create category:

```
1.   Name and slug of category should be unique.
2.   Parent of a category could be added while creating a new category.
3.   OrderHint will be generated automatically by server.
```

## 4. Services dependencies
This is optional, if this micro-service depends on other services, dependencies
should be demonstrated clearly. 



