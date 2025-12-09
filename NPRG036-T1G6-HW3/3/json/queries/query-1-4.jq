.["@graph"] as $g
| ($g | map(select(.type == "Country"))) as $countries
| ($g | map(select(.type == "Studio"))) as $studios
| $g
| map(select(.type == "Movie") | .producedBy)
| unique
| map(
    . as $sid
    | ($studios[] | select(.id == $sid) | .basedIn)
)
| unique
| map(
    . as $cid
    | {
        countryId: $cid,
        countryName: ($countries[] | select(.id == $cid) | .label.en)
    }
)