# Design Guide

In the `documents` folder of each project, there is a `design.md` specifying desgin of this project. 

Each design document should have these parts:

## 1. a short describe
## 2. table we used
## 3. domain
### 3.1 service
For each service, we should have `description, input, output, exception, workflow`
### 3.2 event
For each event, we should have `description, trigger, content`
## 4. proto link
## 5. grpc
### 5.1 grpc service
For each service, we should have `description, input, output, exception`
### 5.2 grpc exception & domain exception
Give a table about the corresponding relation
### 5.3 grpc client
If this project used other grpc services, you need to describe the grpc client.

