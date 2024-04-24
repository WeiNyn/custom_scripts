# Count uniq value of specific field(s)
export def "nk uniq" [
    file: string = '-', # file path
    --index (-i): string = "0", # index of column to count
    --separator (-s): string = "\"\t\"", # separator
] {
    ^gawk -F $separator $'
        !seen[($index | split row "," | each { |index| '$' + ($index | str trim) } | str join ",")]++ {
            count++
        }
        
        END {
            print count
        }
    ' $file
}

# Get top frequency of specific field(s)
export def "nk top" [
    file: string = '-', # file path
    --count (-c): int = 5, # number of top items to show
    --limit (-l): int = 1000000, # number of lines to read
    --separator (-s): string = "\"\t\"", # separator
    --header (-h) # whether the file has header
] { 
    ^gawk -F $separator -v $'l=($limit)' -v $'c=($count)' -v $'h=($header)' '
        NR == 1 {
            num_field = NF
            if (h == "true") {
                for (i = 1; i <= num_field; i++) {
                    header[i] = $i
                }
            }
        }
    
        NR <= l {
            if (NR == 1 && h == "true") {
                next
            }

            for (i = 1; i <= num_field; i++) {
                seen[i][$i]++
            }
        }
        
        END {
            for (s in seen) {
                if (h == "true") {
                    field = header[s]
                } else {
                    field = s
                }
                print field ":"

                n = asorti(seen[s], sorted, "@val_num_desc")
                
                for (i = 1; i <= n && i <= c; i++) {
                    field = sorted[i]
                    print "  " "\"" field "\"" ": " seen[s][sorted[i]]
                }
            }
        }
    ' $file | from yaml
}

export def "nk vuniq" [
    file: string = '-', # file path
    --index (-i): string = "0", # index of column to count
    --separator (-s): string = "\"\t\"", # separator
] {
    ^gawk -F $separator $'
        !seen[($index | split row "," | each { |index| '$' + ($index | str trim) } | str join ",")]++ {
            print ($index | split row "," | each { |index| '$' + ($index | str trim) } | str join "\"\t\"")
        }
    ' $file
}