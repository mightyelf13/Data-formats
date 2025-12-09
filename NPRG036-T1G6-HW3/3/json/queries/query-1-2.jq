.["@graph"] as $g
| ($g | map(select(.type == "Studio"))) as $studios
| $g
| map(select(.type == "Movie"))
| sort_by(.producedBy)
| group_by(.producedBy)
| map(
  .[0].producedBy as $sid
  | {
    studioId: $sid,
    studioName: (
      $studios[]
      | select(.id == $sid) 
      | .name.en
  ),
  movies: map(.title.en)
  }
)