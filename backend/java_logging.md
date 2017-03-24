# Java Log
We use logback and slf4j for application logging. Because there is no consistent method to track business operation status, the logging is used for both operation monitoring and application debugging. 

An important question is what should be logged at which level. This [stackoverflow discussion](http://stackoverflow.com/questions/7839565/logging-levels-logback-rule-of-thumb-to-assign-log-levels) has some useful information. A key decision is made to log all cross-boundary API calls (REST API, RPC or database access) at the `INFO` level because such data is useful in operation managment and there is no standard way to do it in a cloud application. 

## Log Level
For all exceptions, one needs to log a detail message in the location it happens. Based on the severity of the exception, it may have a log level of `ERROR`, `WARNING`, `INFO`, or `DEBUG`. 

`ERROR` means a fatal error that an application cannot continue, for example, a NULL parameter. It should be fixed ASAP. 

`WARNING` means a serious bug though an application can continue. For example, a customer id is not in the database. It should be investigated and fixed in a short period. 

`INFO` means a significant event. For example, 
* System lifecycle event such as start stop
* Session lefecycle event such as login, logout.
* all cross-boundary API calls including REST API, RPC, databaes access etc. 
* Significant business event such as a new customer registration.
* Typeical business exceptions such as login failure due to bad credentials.  

`DEBUG` is used for debugging. It gives a full execution path and context. The term full execution path means that a detail tracing of non-trivial function calls (stacks) and their parameters are recorded. 

`TRACE` is used for detail message such as a big data object or an array. It is not used often. 


