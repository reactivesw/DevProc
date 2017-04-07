# GitHub Workflow
This document describes the workflow used in our development process. 

## 1. The GitHub Workflow
As a small team, we literally follow the so-called [GitHub Workflow](https://guides.github.com/introduction/flow/). It is also explained in the [GitHub Workflow Blog](http://scottchacon.com/2011/08/31/github-flow.html): 

> It is very simple, very effective and works for fairly large teams - GitHub is 35 employees now, maybe 15-20 of whom work on the same project (github.com) at the same time. I think that most development teams - groups that work on the same logical code at the same time which could produce conflicts - are around this size or smaller. Especially those that are progressive enough to be doing rapid and consistent deployments.

Every team member should fully understand the workflow. Youtube https://youtu.be/oFYyTZwMyAg has a short tutorial for pull, reveiw and merge. 

## 2. Basic Workflow
Each service has a repository that can be built, tested, released and deployed independently. For each repository, we use the following workflow: 

1. The team creates a new repository for a new service/task. 
2. A developer creates a branch (https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) for a new feature or bug fix. Naming your branch with an meaningful name, such as fixCartNotExistBug, not fixbug.
3. A developer creates, edits, renames, moves, or deletes files. 
4. Send a pull request (https://help.github.com/articles/using-pull-requests/). 
5. Ask a peer to do a code review -- optionally there are some discussions and changes.
6. Make changes on the branch as needed. The pull request will update automatically.  
7. Once changes are approved by the reviewer, the developer merges the pull request(https://help.github.com/articles/merging-a-pull-request/), once the branch is ready to go, using the big green button.
8. Delete the branch (https://help.github.com/articles/deleting-unused-branches/) in the pull request or on the branches page. 

## 3. Naming Conventions
Naming is very important therefore we have a section just for it. 

The repository name shoud use the `lowercase-with-hyphens` style. The repository should be named after its primary business role such as "customer-authentication" or "product-category". 

Branch naming convention suggested by GitHub team: 
>When you want to start work on anything, you create a descriptively named branch off of the stable master branch. Some examples in the GitHub codebase right now would be user-content-cache-key, submodules-init-task or redis2-transition. This has several advantages - one is that when you fetch, you can see the topics that everyone else has been working on. Another is that if you abandon a branch for a while and go back to it later, it’s fairly easy to remember what it was.

## 4. Rules
1. The master branch is alway ready to release. 
2. Every pull request must be reviewed before merge to the master. 
3. Open small pull request, review and merge frequently. 

A developer may want to combine multiple trivial local commits into one o commits (and give it a helpful message summurizing major changes) to be reviewed and merged. Please check http://stackoverflow.com/questions/5308816/how-to-use-git-merge-squash for details. The [squash or not squash](http://jamescooke.info/git-to-squash-or-not-to-squash.html) explains the squash tradeoffs.  

## 5. Related Resources
The [Pull request review guide](./review_guide/pull_request_review_guide.md) give detail information about review purpose, what to review and how to review. 

## 6. Create issue
Create an issue to track an question or a bug, and is you are fix an issue, then association your pull request with the issue, by add link in comments of the issue. like:
```
See [pull request](your pull request link)
```