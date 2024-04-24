export def gl [
    limit: int = 10
] {
    git log --pretty="%h | %aN | %cr | %s |||||" | 
    split row "|||||" | 
    str trim | 
    first ($limit + 1) | 
    parse "{Hash} | {Author} | {Date} | {Commit}"
}