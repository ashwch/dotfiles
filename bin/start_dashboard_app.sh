#!/bin/bash

# Name of the session to be created
SESSION_NAME="dashboard_app_session"

# Create a new tmux session and window
tmux new-session -d -s $SESSION_NAME -n main

# Split the window into two panes vertically
tmux split-window -h -t $SESSION_NAME:main

# Select the first pane (pane indices start at 0)
tmux select-pane -t $SESSION_NAME:main.0
# Run a command in the first pane
tmux send-keys -t $SESSION_NAME:main.0 'cd /Users/monty/work/diversio/DiversioTeam/Django4Lyfe' C-m
tmux send-keys -t $SESSION_NAME:main.0 'pyrun python manage.py runserver' C-m

# Select the second pane
tmux select-pane -t $SESSION_NAME:main.1
tmux send-keys -t $SESSION_NAME:main.1 'cd /Users/monty/work/diversio/DiversioTeam/Diversio-Frontend' C-m
tmux send-keys -t $SESSION_NAME:main.1 'nvm use 20.6.1' C-m
tmux send-keys -t $SESSION_NAME:main.1 'npm start' C-m

# Split the second pane into two more panes vertically
tmux split-window -v -t $SESSION_NAME:main.1

# Select the new third pane
tmux select-pane -t $SESSION_NAME:main.2
tmux send-keys -t $SESSION_NAME:main.2 'cd /Users/monty/work/diversio/DiversioTeam/Diversio-Frontend' C-m
tmux send-keys -t $SESSION_NAME:main.2 'nvm use 20.6.1' C-m

# Split the third pane into two more panes vertically
tmux split-window -v -t $SESSION_NAME:main.2

# Select the new fourth pane
tmux select-pane -t $SESSION_NAME:main.3
tmux send-keys -t $SESSION_NAME:main.3 'cd /Users/monty/work/diversio/DiversioTeam/Django4Lyfe' C-m
tmux send-keys -t $SESSION_NAME:main.3 'pyrun python manage.py shell' C-m

# Attach to the tmux session
tmux attach-session -t $SESSION_NAME

