export def "unzip list" [file: path] {
    (unzip -l $file |
        detect columns -s 1 --combine-columns 1..2 |
        where not ($it.Length =~ '----') |
        drop 1 |
        update Length {into filesize} |
        update Date {into datetime})
}

export def generate-proj-list [] {
    mkdir ~/.cache/file-utils
    ls -a ~/src/**/.git | get name | par-each {|it| $it | path dirname } | save --force ~/.cache/file-utils/proj-list.txt
}

export alias cds = cd ((open ~/.cache/file-utils/proj-list.txt | fzf) | str trim)
export alias es = enter ((open ~/.cache/file-utils/proj-list.txt | fzf) | str trim)
