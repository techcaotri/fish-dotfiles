function clipy_history
  set clipy_output $(clipy history --tmux)  
  commandline -a "$clipy_output"
  commandline -C 9999 # Move cursor to the end of the line
end
