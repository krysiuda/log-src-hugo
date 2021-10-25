---
layout: post
title:  "git cheatsheet vol 2"
date:   2017-03-29
tags:
- git
- cheatsheet
---

# git cheatsheet vol 2 #

Here are some more advanced one-liners for GIT. This time more about working with the history (and rewrites).

## working with the history ##

To squash 4 last commits:

```bash
git rebase -i HEAD~4
```

To cherry-pick a commit (integrate any given commit into your branch):

```bash
git cherry-pick [commit]
```

## rebasing ##

This changes the commit (think of SVN \"revision\") your current branch was based on.

```bash
git rebase [branch]
```

## navigating branches ##

Find all branches containing a given commit.

```bash
git branch -r --contains [commit]
```

## reseting (reverting) changes ##

If you want to get rid off all changes (staged commits), e.g. in situations when you have accidently finished a merge, you may discard all staged changes:

```bash
git reset --hard HEAD
```
