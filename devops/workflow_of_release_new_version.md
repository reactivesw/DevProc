# Workflow of release new version of services
This doc describes the flow of release mircro-services and e-commerce.

# Tips: How to create branch
we usually got three kind of reasons to create branch
- Create branch for new version
- Create branch for a new change
- Create branch for a hot fix

1. Create branch for new version

Each time, we want to upgrade one service, we need to create a new version for this. 
- Naming: 

  Name the branch `dev`, and change the version of this branch to the version you need, such as `0.0.4`
- Work on this branch: 

  Each version may contains many small changes, such as `add a function`, `update a function`, for each change, create a branch from this `dev` branch, and after the branch finished, then merge it to the `dev`
- Merge: 

  After the version tested, then you can merge it to master

2. Create branch for new change

Usually we use this kind of changes on `dev` branch.

3. Create branch for hot fix

When the master got a error, and we need to fix it as soon as possible. We create a branch from `master`, and when we fixed, then merge it to master, and change the small version of master.


# 1. Add new branch
Before start to work on a new release, we should figure out the version of this release, and create a branch from master, and change the new brench's version.

# 2. Work on the release
Each release may got several changes, we need to create new branch from this for each change.
- Create sub branch based on this branch
- Work on this branch
- Merge the sub branch: use suqsh to merge, so each sub change only got one commit

# 3. Test the on dev
Before we merge the release to master, we must test it on `dev`.

# 4. Merge to master
After tested, we merge this to master, and deploy it to `staging`.

# 5. Test on staging
Test the on staging.

# 6. Create tag and release branch from master
After test the versin on staging, then release it.
