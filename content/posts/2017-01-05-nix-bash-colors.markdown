---
layout: post
title:  "colorful bash"
date:   2017-01-05
tags:
- git
- linux
- bash
---

# colorful bash #

An eye-candy, which actually makes bash more usable.

## .bash.rc ##

I have used background color to mark the prompt, and differentiate between command and it's output.

The prompt requires a 256-color terminal (rather common today) to show properly.

The script below also defines a function returning current git branch name. The function is later used to construct part of the bash prompt, so you can see the branch name in the current directory.

I display a timestamp for each command so I can track when I have executed the last command.

The ``username@host:/path/`` format in the prompt is taken from ``scp``, you can easily copy it (e.g. between windows) and use it to transfer remote files.

```bash

find_git_branch() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ \"$branch\" == \"HEAD\" ]]; then
      branch='detached*'
    fi
    git_branch=\"($branch)\"
  else
    git_branch=\"\"
  fi
}

PROMPT_COMMAND=\"find_git_branch; $PROMPT_COMMAND\"
PS1=\"\\n\\[\\e[38;5;247m\\e[48;5;237m\\]\\u@\\H:\\[\\e[38;5;15m\\]\\w\\[\\e[48;5;236m\\] \\[\\e[48;5;235m\\] \\[\\e[48;5;234m\\] \\[\\e[48;5;233m\\] \\[\\e[48;5;232m\\] \\[\\e[m\\e[38;5;237m\\]   \t   \\$?   \\$git_branch   \\[\\e[m\\]\n\\[\\e[38;5;237m\\e[48;5;237m\\] \\[\\e[m\\e[38;5;226m\\] $ \\[\\e[m\\]\"

```

Note: when you define your own prompt, remember to wrap all escape codes (colors) in square brackets.
Otherwise bash will not count shown characters correctly and the prompt may break while you edit a long command, or use search history (``Ctrl+R``).
