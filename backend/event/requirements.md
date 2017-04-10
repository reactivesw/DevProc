# 1. Description
This doc show the requirements of the `event system`.

# 2. Event body
## 2.1 All event should in the same schema
All event should have the same schema except the detail data.
## 2.2 Every event should has a unique Id
Each event should has a unique Id, so that the sysem can know which one has been processed
## 2.3 every event should contains some addtional info
Each event should contains info like: create time, sequence number.

# 3. Event producer
Producer publish events.
## 3.1 Each event must be published at least onece
Each event should be published successfully at least onece.
## 3.2 Event producer should be decoupled with the domain business
Producer should runs in it's own thread or process, and be decoupled with the domain business.
## 3.3 Producer must be scaleable
Producer can be scale an any time.
## 3.4 Producer should retry if publish failed
Producer should retry when publish an event failed. The retry rule should be configurable.

# 4. Event consumer
Consumer process the event.
## 4.1 Each Event mush be processed at least onece
Each event must be processed at least onece.
## 4.2 Each event can be processed by multi consumer
An event can has many consumers, and each consumer can process the event independently.
## 4.3 Consumer should be decoupled with the domain business
Consumer should runs in it's own thread or process, and be decoupled with the domain business.
## 4.4 Consumer must be scaleable
Consumer can be scale an any time.
## 4.5 Consumer should retry if publish failed
Consumer should retry when process an event failed. The retry rule should be configurable.

# 5. Event Broker
Event Broker store events.
## 5.1 Broker can store evnets
Broker can store events for a customized time.
## 5.2 Broker should delete expired event
## 5.3 Broker should support multi channel or topic



