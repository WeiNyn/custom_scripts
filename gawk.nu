export def "nk wc" [
    file: string = '-', # file path
    --line (-l), # line count
    --separator (-s): string = "\"\t\"", # separator
] {
    ^gawk -F $separator -v $"l=(if ($line) {1} else {0})" '
        {
            if (l == 0) {
                count += NF
            }
        }
        
        END {
            print(l)
            if (l == 1) {
                print NR
            } else {
                print count
            }
        }
    ' $file
}

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

export def "nk top" [
    file: string = '-', # file path
    --count (-c): int = 5, # number of top items to show
    --limit (-l): int = 1000000, # number of lines to read
    --separator (-s): string = "\"\t\"", # separator
] {
    ^gawk -F $separator -v $'l=($limit)' -v $'c=($count)' '
        NR == 1 {
            num_field = NF
        }
    
        NR <= l {
            for (i = 1; i <= num_field; i++) {
                seen[i][$i]++
            }
        }
        
        END {
            print "{"
            for (s in seen) {
                print "\"" s "\" : {"

                n = asorti(seen[s], sorted, "@val_num_desc")
                
                for (i = 1; i <= n && i <= c; i++) {
                    print "\t" "\""sorted[i]"\" : " seen[s][sorted[i]]
                }
                print "\t}"
            }
            print "}"
        }
    ' $file | from json
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