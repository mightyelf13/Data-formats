// Screening counts by cinema country
MATCH (scr:Screening)-[:TAKES_PLACE_AT]->(ci:Cinema)-[:LOCATED_IN]->(co:Country)
RETURN co.label AS country, count(scr) AS screenings
ORDER BY screenings DESC, country ASC;