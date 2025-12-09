.movies
| sort_by(.directedBy)
| group_by(.directedBy)
| map({
    directorId: .[0].directedBy,
    movies: map(.title.en),
    count: length
})