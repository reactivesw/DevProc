# Development Process
This file describes the things we do to complement an iteration of application development. There are some assumptions for our process: 

* The process should be as simple as possible, but not simpler -- Albert Einstein
* Correctness and maitainability are top two goals, everything else follows. 
* Documents are as important as the code in two ways: they are the most important communcation tools and their quality really matters.
* Human is not reliable, we need human reviews and automation tools to maintain the desired level of quality.  

## 1. Development Phases
As an open-source cloud-native application, this endeavor will be alive for a long long time. There will be many iterations in the development process. Each iteration involves the following steps:

1. Document requirments: no matter how we collect and justify the requirments, the first step is documenting those requirements. A requirment document has many use cases describing a user story of a function. A user can be a human or another application. Each use case should include three scenarios: normal cases, abnormal cases and operation requirements. Ideally, in each iteration we only describe one use case. 
2. Document design: based on the requirments, we document the design decisions for the to-be implementations. Usually this is an iterative process. Initially we only describe the high level design decisions. As we write more code and learn more about the requirement, we add more design details thus anybody can have a clear understanding of the service by checking the requriement and design document. 
3. Implement functions: it is the simple and fun part. All programs have to follow the suggested coding style, have appropriate unit test and code coverage, have to be checked by PMD and Findbug, and come with system integration tests.
4. DevOps: we care about operation. Logging and system monitoring are two important tools that build into any code.
5. Reflect and Refactor: we consistently do this to improve. 

As a programmer, we know how important are the consistency and DRY. All changes should be reviewed before applied to the production system. 

## 2. Iteration Plan and Tracking
It is important to know the team productivity because so many things built upon it. Actaully, good planning helps. We use two level Kanban boards: a team board and an individual board. The team board updates weekly and individual board updates daily. 

### 2.1 Kanban Board
We use Trello as Kanban system. All Kanban boards have the following columns: 
* New: a new item is created.
* Planned: an item is scheduled into working pipeline with an estimate of required time. This esitmate is not changed once it is in WIP status. The estimate is appened to the item name with a pattern of 8h or 7d -- representing 8 hours or 7 days. The position of the item is its priority. Higher position item has a higher priority to enter WIP.  
* WIP: work in progress. Once in this column, it has two extra suffix in its name: one for actual working time and one for estimated time to fully complete it. For example: 8h-4-6 means that original estimate is 8 hours, 4 hours has spent in this item and 6 more hours are required to complete it. 
* Review: items to be reviewed. 
* Done: the item is done. The time suffix now only has two fields: estimate time and actual working time. For example, 8h-10 means an estimate of 8 hours and the actual working time is 10 hours.   

### 2.2 Team Planner 
This is an overal planner for the overall endeavor. It shows tasks to be performed in about 6 months. Everyone updates the corresponding item in a weekly base. 

### 2.3 Individual Planner
Each person has a planner that shows daily task items. Ideally it should be no longer than a month. This should be updated daily.  

### 2.4 Stand-up Meeting
We have a team stand-up meeting everyday to review working status, schedule working items and raise issues. It should be short and to the point. Any issues is discussed after the stand-up meeting by its stakeholders.  
