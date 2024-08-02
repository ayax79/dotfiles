# Sets the window title of tmux to be the current directories name
export def set-window-title [] {
     pwd | path split | last | tmux rename-window $in
} 
