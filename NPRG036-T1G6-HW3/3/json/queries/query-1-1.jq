.["@graph"]
| map(select(.type == "Movie"))
| map(
    select((.releaseDate[0:4] | tonumber) > 2010)
    | {
        id, title: .title.en,
        releaseYear: (.releaseDate[0:4] | tonumber)
    }
)