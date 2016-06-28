# GitHub Workflow

## Setup
Ensure that Git is setup to use your gmail email address in the ~/.gitconfig file. You can do this from the command line:
git config --global user.name "Your Name"
git config --global user.email "your_email@gmail.com”

Likewise, in your GitHub account email settings, add your institution-hosted email. We recommend that you set this institutional email as your Primary GitHub email address. This step ensures that Git commits you make directly on GitHub.com (such as quick documentation fixes) and merges made via the ‘big green button’ have proper authorship metadata.

## Basic Workflow

Each service has a repository that can be built, tested, released and deployed independently. For each repository, we use the following workflow: 

1. An organisation manager creates a new repository for a new service/task. 
2. A developer creates an issue for a new task for a new feature or a bug fix. 
3. A developer creates a branch (https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) for a new feature or bug fix. 
4. A developer creates, edits, renames, moves, or deletes files. 
5. Send a pull request (https://help.github.com/articles/using-pull-requests/). Make changes on the brach as needed. The pull request will update automatically.  Developers review and discuss the changes.
6. Merge the pull request(https://help.github.com/articles/merging-a-pull-request/), , once the branch is ready to go, using the big green button.
7. Delete the branch (https://help.github.com/articles/deleting-unused-branches/) in the pull request or on the branches page. 

## Code Review
We review work before it is merged to ensure that code is maintainable and usable by someone other than the author.
* Is the code well commented, structured for clarity, and consistent with DM’s code style?
* Is there adequate unit test coverage for the code?
* Is the documentation augmented or updated to be consistent with the code changes?
* Are the Git commits well organized and well annotated to help future developers understand the code development?

Code reviews should also address whether the code fulfills design and performance requirements.
Ideally the code review should not be a design review. Before serious coding effort is committed to a ticket, the developer should either undertake an informal design review while creating the design. 

Code review discussion should happen on the GitHub pull request, with the reviewer giving a discussion summary. 

Pull request conversations should only happen in ‘Conversation’ and ‘Files changed’ tabs; your comments might get lost otherwise.

Code reviews are a collaborative check-and-improve process. Reviewers do not hold absolute authority, nor can developers ignore the reviewer’s suggestions. The aim is to discuss, iterate, and improve the pull request until the work is ready to be deployed on master.

If the review becomes stuck on a design decision, that aspect of the review can be elevated to seek team-wide consensus.

