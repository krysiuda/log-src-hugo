---
layout: post
title:  "colorful tmux"
date:   2017-01-31
tags:
- linux
- tmux
---

# colorful tmux #

An eye-candy, which makes tmux more usable, and matches my colorful bash prompt.

## .bash.rc ##

I prefer tmux to try to reattach to a session before creating a new one, this bash alias changes the default behaviour:

```bash
# always try to reattach
alias tmux="tmux attach"
```

## .tmux.conf ##

Here are the modifications to tmux, with comments:

The features I use the most have new keybindings allowing me to access them instantly.

```bash
# rebind default C-b to M-a (not conflicting with bash C-a)
unbind -n C-b
set -g prefix M-a
bind M-a send-key M-a

# use colors 256
set -g default-terminal "screen-256color"

# select pane
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# split
bind C-Up split-window -bv
bind C-Down split-window -v
bind C-Left split-window -bh
bind C-Right split-window -h

# zoom-in pane (toggle)
bind Enter resize-pane -Z

# display panes
bind a display-panes
set -g display-panes-time 5000

# use mouse
set -g mouse on

# allow tmux attach to create new session if no existing
new-session

# refresh status every sec
set status-interval 1

# prevent apps from changing window names
set allow-rename off

# window rename
bind s command-prompt 'rename-window %%'

# eye-candy
set -g pane-border-bg colour0
set -g pane-border-fg colour238
set -g pane-active-border-bg colour0
set -g pane-active-border-fg colour226

set -g status-position top
set -g status-bg colour237
set -g status-fg colour247
set -g status-attr dim
set -g status-left ''
set -g status-right '#[bg=colour236] #[bg=colour235] #[bg=colour234] #[bg=colour233] %d/%m #[bg=colour232] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

set -g display-panes-active-colour colour226
set -g display-panes-colour colour238
```

After appling the above you will have yor tmux \"escape\" key mapped to `Alt+A`, which does not conflict with anything else I use and is still really easy to reach with one hand.

To split a window (into panes) you can hit `Alt+A` followed by `Ctrl+ArrowKey` (if you want the new pane to be on right from the current, hit `Right ArrowKey`).

Switching between panes is shorter, just `Alt+ArrowKey`. To resize pane: press down `Alt`, hit `A`, adjust the size with `ArrowKey`, release `Alt`.

Hit `Alt+A` followed by `A` to get some more info about the panes.

Hit `Alt+A` followed by `S` to rename the current window.

Hit `Alt+A` followed by `Z` to toggle zoom of the current pane (make it temporary fit the whole window).

It's probably the best to have your own key bindings, but I hope this may be an inspiration.
