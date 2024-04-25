# Display a list of all Java processes
export def jps [] {
    ^jps | detect columns -n | rename pid name
}
