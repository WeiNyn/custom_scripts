export def fcmd [
    command: string, # command to filter
] {
    ps --long | select pid command mem | where command =~ $command
}

export def pkill [  
] {
    each { |pid| kill $pid }
}