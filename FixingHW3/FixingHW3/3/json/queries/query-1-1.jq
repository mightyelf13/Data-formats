.movies
| map(. as $m | select(($m.releaseDate[0:4] | tonumber) > 2010)
| {
    id, 
    title: $m.title.en, 
    releaseYear: ($m.releaseDate[0:4] | tonumber)})