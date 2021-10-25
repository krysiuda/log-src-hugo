---
layout: post
title:  "git cheatsheet vol 1"
date:   2016-11-10
tags:
- git
- cheatsheet
---

# git cheatsheet vol 1 #

Here are a few one-liners to start working with GIT.

(for people who know what they want to do, but don't know how - SVN users?)

## working with remote repository ##

Clone (copy) a GIT repository from a remote:

```bash
git clone http://...
```

Update repository from a remote:

```bash
git pull
```

Push local branch to remote:

```bash
git push -u origin [branchname]
```

To list remote branches:

```bash
git branch -r # remote
git branch -a # all
```

## working with local repository and general ##

Instead of cloning a remote repository we can create a new one in the current directory:

```bash
git init .
git add [files]+
git add .gitignore # optionalally add file holding a list of ignored (unversioned) files
git commit .
```

The whole repository is stored in the ``.git`` directory.

To check status (current branch, changes)

```bash
git status
```

To add files to staging (changes ready to be committed):

```bash
git add [files]+
```

To commit changes:

```bash
git commit
git commit -m [commit message] # to avoid getting a editor prompt for the message
```

To change message (or add files) of the last commit:

```bash
git commit --amend
```

To see the list of (local) branches:

```bash
git branch
```

To create a new branch based on current (checked-out) branch:

```bash
git branch [branchname]
```

To checkout an existing branch (this will get the data from ``.git`` directory and put them in the repository root directory):

```bash
git checkout branchname
```

To remove a branch:

```bash
git branch -d branchname # checks if branch has been merged
git branch -D branchname # this forces the removal
```

To get a diff (list of changes):

```bash
git diff HEAD
git diff origin/HEAD # against the remote repository
```

Diff against staged (commited, but not pushed) items:

```bash
git diff --cached
```
