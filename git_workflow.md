# GitHub Workflow

## 1. Setup

### 1.1. Username and Email
Ensure that Git is setup to use your email address in the ~/.gitconfig file. You can do this from the command line:

```sh
git config --global user.name "Your Name"
git config --global user.email "your_email@mail.com”
```

Likewise, in your GitHub account email settings, add your email. This step ensures that Git commits you make directly on GitHub.com (such as quick documentation fixes) and merges made via the ‘big green button’ have proper authorship metadata.

### 1.2. Bash Prompt and Auto-completion
Run the following to create `~/.git-completion.bash` and `~/.git-prompt.sh`:

```sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
```

Then add the following to your `~/.bashrc` or `~/.bash_profile` after `PATH`:

```sh
# Set the base PS1
export PS1="\t: \W$ "

# Source the git bash completion file
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
    source ~/.git-prompt.sh
    PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

export PS1
```
This will display the branch name next to the folder name in the bash prompt.

## 2. Basic Workflow

Each service has a repository that can be built, tested, released and deployed independently. For each repository, we use the following workflow: 

1. An organisation manager creates a new repository for a new service/task. 
3. A developer creates a branch (https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) for a new feature or bug fix. 
4. A developer creates, edits, renames, moves, or deletes files. 
5. Send a pull request (https://help.github.com/articles/using-pull-requests/). 
5. Ask a peer to do a code review -- optionally there are some discussions and changes.
6. Make changes on the branch as needed. The pull request will update automatically.  
6. Once changes are approved by the reviewer, the developer merges the pull request(https://help.github.com/articles/merging-a-pull-request/), once the branch is ready to go, using the big green button.
7. Delete the branch (https://help.github.com/articles/deleting-unused-branches/) in the pull request or on the branches page. 

Youtube https://youtu.be/oFYyTZwMyAg has a short tutorial for pull, reveiw and merge. 

## 3. Code Review
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

## 4. Submodules
### 1. To clone a project with sub modules
Use the command `git submodule update --init --recursive`

### 2. To initially add a submodule to a project  
Use the command `git submodule add url_of_the_repository`

### 3. To Remove the submodule from a project
Use the following three commands: 
```sh
// Remove the submodule entry from .git/config
git submodule deinit -f path/to/submodule

// Remove the submodule directory from the superproject's .git/modules directory
rm -rf .git/modules/path/to/submodule

// Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
git rm -f path/to/submodule
```
