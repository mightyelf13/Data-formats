// Cinemas that show movies from 2+ distinct studios
MATCH (ci:Cinema)<-[:TAKES_PLACE_AT]-(scr:Screening)-[:SHOWS]->(m:Movie)<-[:PRODUCED_BY]-(st:Studio)
WITH ci, collect(DISTINCT st.name) AS studios
WHERE size(studios) >= 2
RETURN ci.name AS cinema, ci.city AS city, studios, size(studios) AS studioCount
ORDER BY studioCount DESC, cinema ASC;