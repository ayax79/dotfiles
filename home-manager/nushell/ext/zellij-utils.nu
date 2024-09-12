# Sets the window title of tmux to be the current directories name
export def set-window-title [] {
     pwd | path split | last | zellij action rename-tab $in
} 

# # Closes all neovim sessions and then kills the tmux session
# export def safe-close [] {
#    nvim-close-all 
#    tmux kill-session
# }
