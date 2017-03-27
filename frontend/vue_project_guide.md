# Vue Project Guide

## 1. Scaffold a Project 

### 1.1. Initialize a Vuejs Project
Run `yarn global add vue-cli@latest` to install the latest vue-client.  

Run `vue init webpack my-project` to create a new project named `my-project`. When asked, use recommended settings and answer "Y" to vue-router, ESLint, unit test and e2e test.  

### 2.2. Customize Configuration and Install Packages
To make the root folder less crowded, move the `index.html` to the `src/` folder.
Change the line `template: 'index.html'` to `template: 'src/index.html'` in both `build/webpack.dev.conf.js` and `build/webpack.prod.conf.js`.

Edit `package.json` file to update vue and vue-router to the latest verion. 
Run `yarn install` to  install all packages used in the project. 
Run `yarn run dev` to check that the site is up and running correctly. 

Finally, copy [resources/gitignore](./resources/gitignore) to the `.gitignore` file in the project folder. 

## 2. Architecture Overview
The architecture is about the relationship among components. 

There are three communication mechanism between two components: props for a parent to sync data with a child, slot for a parent to insert conent to child,  event for a child to notify a parent, and finally a global store is to sync data globally. 

We should use functional stateless components as much as possible. Therefore the primary interaction between a parent and child is via props and events. 

A component uses states when 
* it communicates with backend or 
* it is used/controlled by multiple components. 

## 3. Workflow
The workflow describes the steps needed to create new component in the frontedn. 

### Step 1: Create HTTP request
Create all remote requests in a file inside the `infrastructure/api_client/`. 

### Step 2: Create Store State
* create types in `infrastructure/store/`. All store putter/getter using as naming convention of "setMyState" and "getMyState". For async actions, using "fetchStateData" for data fetching, "putStateData" for data update, "postStateData" for data creation, and "deleteStateData" for delete.  
* create the initial states, actions, getters and mutations and put them into `index.ts`.
* add the module to `infrastructure/store/index.ts`.

!! The store mutation method only takes one payload argument. 

### Step 3: Fetch and get data in a container component
* use `mapActions` to map an action to a method of a component. 
* call the fetch data in `created` lifecycle callback to fetch data and put it in the store. 
* use `mapGetters` to map a state getter to get state data from store and set it as a `computed` prop.

### Step 4: Pass data to a presentation component
* define the data as a prop in a presentation component.
* in the container component, check if the data is available in presentation component template using `v-if` before pass it to the child presentation component. 

### Step 5: Raise event in a presentation component
* raise an event with a name that starts with an event source name and terminates with a verb ending with -ing or -ed (Closing/Closed). 

### Step 6: Handle event in a container component 
* a paraent uses `@eventName="theEventHandler"` to catch the event.
* an event handler should have a "EventHandler" postfix and is often defined as a component method.
* if it is a remote call, the event handler call the mapped action to call remote server.

### Step 7: Process result 
* get the result or handle error
* update local state based on the call result. 

## 4. Error Handling
TBD. 
