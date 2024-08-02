export def set-window-title [] {
     pwd | path split | last | tmux rename-window $in
} 
