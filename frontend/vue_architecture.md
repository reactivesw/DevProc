# Vue Architecture

The architecture is about the relationship among components. 

There are three communication mechanism between two components: props for a parent to sync data with a child, slot for a parent to insert conent to child,  event for a child to notify a parent, and finally a global store is to sync data globally. 

We should use functional stateless components as much as possible. Therefore the primary interaction between a parent and child is via props and events. 

A component uses states when 
* it communicate with backend or 
* it is used by multiple components. 

# Workflow

## Step 1: Create HTTP request
Create all remote requests in a file inside the `infrastructure/api_client/`. 

## Step 2: Create Store State
* create types in `infrastructure/store/`. 
* create the initial states, actions, getters and mutations and put them into `index.ts`.
* add the module to `infrastructure/store/index.ts`.

## Step 3: Fetch and Get data in container component
* use `mapActions` to map an action to a method of a component. 
* call the fetch data in `created` lifecycle callback to fetch data and put it in the store. 
* use `mapGetters` to map a state getter to get state data from store and set it as a `computed` prop.

## Step 4: Pass data to a presentation component
* define the data as a prop in a presentation component.
* in the container component, check if the data is available in presentation component template using `v-if` before pass it to the child presentation component. 

## Step 5: Raise event in a presentation component
* raise an event with a name that starts with an event source name and terminates with a verb ending with -ing or -ed (Closing/Closed). 

## Step 6: Handle event in a container component 
* a paraent uses `@eventName="theEventHandler"` to catch the event.
* an event handler should have a "EventHandler" postfix and is often defined as a component method.
* if it is a remote call, the event handler call the mapped action to start the process. 

# Error Handling


