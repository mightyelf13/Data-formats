// Next screenings for a given movie title ('Arrival' in this case)
WITH 'Arrival' AS titleParam
MATCH (m:Movie {title:titleParam})
MATCH (scr:Screening)-[:SHOWS]->(m)
MATCH (scr)-[:TAKES_PLACE_AT]->(ci:Cinema)
RETURN m.title AS movie, ci.name AS cinema, ci.city AS city, scr.date AS date, scr.time AS time
ORDER BY date, time;