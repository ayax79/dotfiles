def remote_path [
  prefix: string,
  index: int,
] {
  $"/tmp/nvim-($prefix)-($index)"
}


def build_remote_file [
  prefix: string,
  index: int,
] {
  let p = (remote_path $prefix $index)
  if ($p | path exists) {
    build_remote_file $prefix ($index + 1)
  } else {
    $p
  }
}

def current_session [] {
  #(zellij current)
  tmux display-message -p '#W'
}

export def build_remote_location [
  index: int
] {
  let session = (current_session)
  if ($session | is-empty) {
    let prefix = (random chars)
    build_remote_file $prefix $index
  } else {
    build_remote_file $session $index
  }
}

#export alias nvim = nvim --listen (build_listen_location)

# Run vim while controlling which neovim server by multiplexer session
export def vir [
  --listen(-l),                       # Port to listen on for initial session
  --index(-i): int = 0,               # The version per multiplexer session
  --remote(-r): string,               # The remote string.. optional instead of --index
  --previous-pane(-p)                 # Return to the previous pane in multiplexer (probably the editor pane)
  ...rest: string,                    # The rest of the command args
] {
  
  if $listen {
    let location = (build_remote_location $index)
    $"Listening on ($location)\n"
    nvim --listen $location ...$rest
  } else {

    if not ($remote | is-empty) {
      $"Attempting to connect to ($remote)\n"
      nvim --remote $remote $rest
    } else {
      let current_session = (current_session)
      let path = (remote_path $current_session $index)
      $"Attempting to connect to ($path)\n"
      nvim --server $path --remote ...$rest
    }

  #   if $previous_pane {
  #     zellij action focus-previous-pane
  #   }
  }

}

# Run nvim and create a server pipe with the current working directory as the name.
# Example: /tmp/my_project-nvim.pipe 
export def --env "nvim server" [
    ...rest: string
] {
    let current_cir = (pwd | path basename)
    let pipe_name = $"/tmp/($current_cir)-nvim.pipe"
    $env.CURRENT_SERVER = $pipe_name
    nvim --listen $pipe_name $rest
}

# Connect to the nvim server with a pipe in the env variable CURRENT_SERVER
export def --env "nvim current" [
    --set (-s),    # Set the CURRENT_SERVER env variable based off of cwd
    file: string
] {
    # remote doesn't work with relative paths, so make expand the file path
    let file = ($"($file)" | path expand)
    if $set {
        let basename = (pwd | path basename)
        $env.CURRENT_SERVER = $"/tmp/($basename)-nvim.pipe"
    }
    let current_server = ($env.CURRENT_SERVER)
    nvim --server $current_server --remote $file
}
