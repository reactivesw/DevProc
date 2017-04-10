# 1. Description
The design of the event system.

# 2. Event body
Use Json as event body and the schema of the event body:
```Json
{
  "id": "event id", // NOT NULL
  "createTime": long, //NOT NULL
  "sequenceNumber":long,
  "data":{} // JSON DATA
}
```

# 3. Event Producer
Event producer contains three part: `event creator`, `event db`, `event publisher`

## 3.1 Event creator
Event created by domain services, and save it to event database. The `event create` and `domain service` should be in one transaction.

## 3.2 Event database
The schema:
```Java
  id; //UUID NOT NULL
  createTime; // create time, NOT NULL
  expire; //expire time
  version; //version of the event, NOT NULL
  status; // status of event: pending, created, NOT NULL
  data; //the real data of the event
```

## 3.3 Event producer
The event producer read events from `event db`, and publish them to event borker.
### 3.3.1 How to Read events
Read status whos staus is created, or status is pending but already expired.
### 3.3.2 How to publish
Publish events to broker, publish a batch of events or just one.
### 3.3.3 How to delete event
After publish sucessed, then delete the event from the event db.
### 3.3.4 How to start
The producer will start when the service starts, each micro-service constains an event producer.

### 3.4 Work flow:
- domain service create event, and save the event to event db.
- the producer read event from db, and then publish it to broker.
[Image](./producer.png)
