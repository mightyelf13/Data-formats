// Movies released since 2010 with studio and studio's country
MATCH (s:Studio)-[:BASED_IN]->(co:Country)
MATCH (s)-[:PRODUCED_BY]->(m:Movie)
WHERE m.releaseYear >= 2010
RETURN m.title AS movie, m.releaseYear AS year, s.name AS studio, co.label AS studioCountry
ORDER BY year, movie;