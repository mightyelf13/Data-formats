// === CLEAN START (optional) ===
MATCH (n) DETACH DELETE n;

// === CONSTRAINTS ===
CREATE CONSTRAINT country_id IF NOT EXISTS FOR (c:Country)   REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT studio_id  IF NOT EXISTS FOR (s:Studio)    REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT movie_id   IF NOT EXISTS FOR (m:Movie)     REQUIRE m.id IS UNIQUE;
CREATE CONSTRAINT cinema_id  IF NOT EXISTS FOR (c:Cinema)    REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT screen_id  IF NOT EXISTS FOR (s:Screening) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT person_id  IF NOT EXISTS FOR (p:Person)    REQUIRE p.id IS UNIQUE;

// === DATA ARRAYS ===
// COUNTRIES
WITH [
  {id:'country/us', label:'United States',  isoCode:'US'},
  {id:'country/uk', label:'United Kingdom', isoCode:'GB'},
  {id:'country/fr', label:'France',         isoCode:'FR'}
] AS rows
UNWIND rows AS r
MERGE (c:Country {id:r.id})
  SET c.label = r.label,
      c.isoCode = r.isoCode;

// STUDIOS
WITH [
  {id:'studio/warner-bros', name:'Warner Bros. Pictures',  foundedYear:1923, moviesProduced:12500, basedIn:'country/us'},
  {id:'studio/universal',   name:'Universal Pictures',     foundedYear:1912, moviesProduced:400,   basedIn:'country/us'},
  {id:'studio/legendary',   name:'Legendary Pictures',     foundedYear:2000, moviesProduced:70,    basedIn:'country/us'}
] AS rows
UNWIND rows AS r
MERGE (s:Studio {id:r.id})
  SET s.name = r.name,
      s.foundedYear = r.foundedYear,
      s.moviesProduced = r.moviesProduced
WITH rows
UNWIND rows AS r
MATCH (s:Studio {id:r.id})
MATCH (c:Country {id:r.basedIn})
MERGE (s)-[:BASED_IN]->(c);

// CINEMAS
WITH [
  {id:'cinema/imax-london',    name:'IMAX London',     city:'London',      countryCode:'GB', isLuxury:true,  capacity:500, phones:['+441234567890', '+442345678901']},
  {id:'cinema/amc-la',         name:'AMC Los Angeles', city:'Los Angeles', countryCode:'US', isLuxury:false, capacity:350, phones:[]},
  {id:'cinema/le-grand-paris', name:'Le Grand Paris',  city:'Paris',       countryCode:'FR', isLuxury:true,  capacity:220, phones:['+330987654321']}
] AS rows
UNWIND rows AS r
MERGE (c:Cinema {id:r.id})
  SET c.name        = r.name,
      c.city        = r.city,
      c.countryCode = r.countryCode,
      c.isLuxury    = r.isLuxury,
      c.capacity    = r.capacity,
      c.phones      = r.phones;
MATCH (ci:Cinema)
MATCH (co:Country {isoCode: ci.countryCode})
MERGE (ci)-[:LOCATED_IN]->(co);

// PEOPLE 
WITH [
  // DIRECTORS 
  {id:'person/christopher-nolan', name:'Christopher Nolan',  kind:'Director', birthDate:'1970-07-30', activeSince:1998, awardsCount:220, bornIn:'country/uk'},
  {id:'person/denis-villeneuve',  name:'Denis Villeneuve',   kind:'Director', birthDate:'1967-10-03', activeSince:1994, awardsCount:160, bornIn:'country/fr'},
  {id:'person/patty-jenkins',     name:'Patty Jenkins',      kind:'Director', birthDate:'1971-07-24', activeSince:2003, awardsCount:40,  bornIn:'country/us'},

  // ACTORS
  {id:'person/leonardo-dicaprio', name:'Leonardo DiCaprio',  kind:'Actor',    birthDate:'1974-11-11', stageName:'Leonardo DiCaprio', debutYear:1991, bornIn:'country/us'},
  {id:'person/amy-adams',         name:'Amy Adams',          kind:'Actor',    birthDate:'1974-08-20', stageName:'Amy Adams',         debutYear:1995, bornIn:'country/us'},
  {id:'person/gal-gadot',         name:'Gal Gadot',          kind:'Actor',    birthDate:'1985-04-30', stageName:'Gal Gadot',         debutYear:2007, bornIn:'country/us'}
] AS rows
UNWIND rows AS r
MERGE (p:Person {id:r.id})
  SET p.name = r.name, p.birthDate = date(r.birthDate)
WITH rows
UNWIND rows AS r
MATCH (p:Person {id:r.id})
FOREACH (_ IN CASE WHEN r.kind='Director' THEN [1] ELSE [] END |
  SET p:Director
  SET p.activeSince = r.activeSince, p.awardsCount = r.awardsCount
)
FOREACH (_ IN CASE WHEN r.kind='Actor' THEN [1] ELSE [] END |
  SET p:Actor
  SET p.stageName = r.stageName, p.debutYear = r.debutYear
)
WITH rows
UNWIND rows AS r
MATCH (p:Person {id:r.id})
MATCH (c:Country {id:r.bornIn})
MERGE (p)-[:BORN_IN]->(c);

// MOVIES
WITH [
  {id:'movie/inception',    title:'Inception',    releaseYear:2010,   durationMinutes:148, language:'en', directedBy:'person/christopher-nolan', producedBy:'studio/warner-bros'},
  {id:'movie/arrival',      title:'Arrival',      releaseYear:2016,   durationMinutes:116, language:'en', directedBy:'person/denis-villeneuve',  producedBy:'studio/legendary'},
  {id:'movie/wonder-woman', title:'Wonder Woman', releaseYear:2017,   durationMinutes:141, language:'en', directedBy:'person/patty-jenkins',     producedBy:'studio/warner-bros'}
] AS rows
UNWIND rows AS r
MERGE (m:Movie {id:r.id})
  SET m.title = r.title,
      m.releaseYear = r.releaseYear,
      m.durationMinutes = r.durationMinutes,
      m.language = r.language
WITH rows
UNWIND rows AS r
MATCH (m:Movie    {id:r.id})
MATCH (d:Director {id:r.directedBy})
MATCH (s:Studio   {id:r.producedBy})
MERGE (m)-[:DIRECTED_BY]->(d)
MERGE (s)-[:PRODUCED_BY]->(m);

// ACTED IN
WITH [
  {actor:'person/leonardo-dicaprio', movie:'movie/inception',    role:'Cobb'},
  {actor:'person/amy-adams',         movie:'movie/arrival',      role:'Louise Banks'},
  {actor:'person/gal-gadot',         movie:'movie/wonder-woman', role:'Diana Prince'},
  {actor:'person/amy-adams',         movie:'movie/inception',    role:'Cameo'},
  {actor:'person/gal-gadot',         movie:'movie/arrival',      role:'Cameo'}
] AS rows
UNWIND rows AS r
MATCH (a:Actor {id:r.actor})
MATCH (m:Movie {id:r.movie})
MERGE (a)-[rel:ACTED_IN]->(m)
  SET rel.role = r.role;

// SCREENINGS
WITH [
  {id:'screening/arr-lon-2024-06-05-2100', movie:'movie/arrival',      cinema:'cinema/imax-london',    date:'2024-06-05', time:'21:00:00', language:'en', price:14.0},
  {id:'screening/inc-lon-2024-06-01-2000', movie:'movie/inception',    cinema:'cinema/imax-london',    date:'2024-06-01', time:'20:00:00', language:'en', price:13.0},
  {id:'screening/arr-la-2024-06-02-1800',  movie:'movie/arrival',      cinema:'cinema/amc-la',         date:'2024-06-02', time:'18:00:00', language:'en', price:12.0},
  {id:'screening/ww-par-2024-06-03-1900',  movie:'movie/wonder-woman', cinema:'cinema/le-grand-paris', date:'2024-06-03', time:'19:00:00', language:'fr', price:11.0}
] AS rows
UNWIND rows AS r
MERGE (s:Screening {id:r.id})
  SET s.date = date(r.date),
      s.time = time(r.time),
      s.language = r.language
WITH rows
UNWIND rows AS r
MATCH (s:Screening {id:r.id})
MATCH (m:Movie     {id:r.movie})
MATCH (c:Cinema    {id:r.cinema})
MERGE (s)-[sh:SHOWS]->(m)
  SET sh.price = r.price
MERGE (s)-[:TAKES_PLACE_AT]->(c);

RETURN 'LPG import finished' AS status;
