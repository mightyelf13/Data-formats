.countries as $countries
| .studios as $studios
| .movies
| map(.producedBy)
| unique
| map(
    . as $sid |
    ($studios[] | select(.id == $sid) | .location) as $cid
    | {
        countryId: $cid,
        countryName: ($countries[] | select(.id == $cid) | .name.en)
    }
)