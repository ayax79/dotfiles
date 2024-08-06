export def "unzip list" [file: path] {
    (unzip -l $file |
        detect columns -s 1 --combine-columns 1..2 |
        where not ($it.Length =~ '----') |
        drop 1 |
        update Length {into filesize} |
        update Date {into datetime})
}

export def cds [] {
    cd (fd -t d . ~/src/ | fzf)
}
