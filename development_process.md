# Development Process
This file describes the things we do to complement an iteration of application development. There are some assumptions for our process: 

* The process should be as simple as possible, but not simpler -- Albert Einstein
* Correctness and maitainability are top two goals, everything else follows. 
* Documents are as important as the code in two ways: they are the most important communcation tools and their quality really matters.

## 1. Development Phases
As an open-source cloud-native application, this endeavor will be alive for a long long time. There will be many iterations in the development process. Each iteration involves the following steps:

1. Document requirments: no matter how we collect and justify the requirments, the first step is documenting those requirements. A requirment document has many use cases describing a user story of a function. A user can be a human or another application. Each use case should include three scenarios: normal cases, abnormal cases and operation requirements. Ideally, in each iteration we only describe one use case. 
2. Document design: based on the requirments, we document the design decisions for the to-be implementations. Usually this is an iterative process. Initially we only describe the high level design decisions. As we write more code and learn more about the requirement, we add more design details thus anybody can have a clear understanding of the service by checking the requriement and design document. 
3. Implement functions: it is the simple and fun part. All programs have to follow the suggested coding style, have appropriate unit test and code coverage, have to be checked by PMD and Findbug, and come with system integration tests.
4. DevOps: we care about operation. Logging and system monitoring are two important tools that build into any code.
5. Reflect and Refactor: we consistently do this to improve. 

As a programmer, we know how important are the consistency and DRY. 

## 2. Iteration Plan and Tracking
It is important to know the team productivity because so many things built upon it. Actaully, good planning helps. We use two level planners: team planner and individual planner. We use Trello as our planner. 

### Team Planner 
This is an overal planner for the overall endeavor. It shows tasks to be performed in about 6 months. 

### Individual Planner
Each person has a planner that shows daily task items. Ideally it should be no longer than a month.     
