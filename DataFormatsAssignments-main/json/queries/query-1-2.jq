.studios as $studios
| .movies
| sort_by(.producedBy)
| group_by(.producedBy)
| map(
  . as $g | {
    studioId: $g[0].producedBy,
    studioName: (
      $studios[]
      | select(.id == $g[0].producedBy) | .name.en
    ),
    movies: map(.title.en)
  }
)