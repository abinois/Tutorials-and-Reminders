// ====== Documentations ======
// Cypher	: https://neo4j.com/docs/cypher-cheat-sheet/5/all/
// Neo4j	: https://neo4j.com/docs/
// Install	: https://neo4j.com/docs/operations-manual/current/installation/
// Download	: https://neo4j.com/download/
// Courses	: https://graphacademy.neo4j.com/

// ====== Syntax Convention ======
// Syntax	: https://neo4j.com/docs/cypher-manual/current/syntax/
// Keywords : https://neo4j.com/docs/cypher-manual/current/syntax/keywords/
//  - PascalCase is used for node labels
//  - capitalized SNAKE_CASE for relationship types
//  - camelCase for property names
//  - snake_case for constraints
//  - No special characters allowed except underscore, otherwise use backticks
//  - Keywords in uppercase and variables in camelCase
//  - Unicode characters can be escapded like so : \uxxx


// ------------ SCHEMA ------------ //
CALL db.schema.visualization();

// ------------ PROFILE / EXPLAIN ------------ //
// Show query execution plan
PROFILE MATCH (h:Human {human_id: "xxx"})-[*]-(n) RETURN h, n;


// ------------ MATCH ------------ // -> Search pattern in graph
// Show all nodes with limit
MATCH (n) RETURN (n) LIMIT 200;
// Count nodes
MATCH () RETURN count(*);
// Show all nodes attach to 1 specific node, with edges of any type and any direction
MATCH (h:Human {human_id: "xxx"})-[*]-(n) RETURN h, n;
// Node with multiple labels
MATCH (n:Human:Superhero)-->(a:Animal) RETURN n, a;
// Multiple lines query
MATCH (h:Human)-[:HAS_PET]->(:Animal {color: "Brown"})
MATCH (s:Store)<-[r1]-(h)-[r2]->(c:Location {category: "cinema"})
WHERE h.human_id = "xxx"
AND h.age < 23
RETURN h, r1, r2, s, c;
// Return a table of property instead of nodes
MATCH (h:Human)-[:EAT]->(a:Animal)
WHERE a.label = "dog"
RETURN h.name, h.locality, h.extinctionDate;
// Unspecified relationship
MATCH (h1:Human {human_id: "xxx"})<--(h2:Human) RETURN h1, h2;
// HAS_FRIEND relationship
MATCH (h1:Human {human_id: "xxx"})<-[r:HAS_FRIEND]-(h2:Human) RETURN h1, h2, r;
// Multiple relationship pattern
MATCH (p:Person)-[r:ACTED_IN|DIRECTED]->(m:Movie)
RETURN p.name AS name, type(r) AS type, m.title AS title;
// Multiple nodes pattern
MATCH (:Human)-[:EAT]->(a:Animal)<-[:EAT]-(:Human) RETURN a;
// Relationship with a specific property value
MATCH (h:Human)-[:HAS_FRIEND {best: TRUE}]->() RETURN h;

// ------------ NULL / AS / ORDER BY ------------ //
// Show the 5 most recent Movie nodes
MATCH (m:Movie)
WHERE m.released IS NOT NULL // Filter empty property values
RETURN m.title AS title, m.url AS url, m.released AS released // Rename with AS
ORDER BY released DESC LIMIT 5; // Sort with ORDER BY

// ------------ WITH ------------ // -> pass along variables to the next query
// Use WITH to assign variables
WITH 2 AS expMin, 6 AS expMax
MATCH (p:Person) WHERE expMin <= p.yearsExp <= expMax RETURN p; // Find people with 2-6 years of experience

// ------------ Path ------------ //
// Return the path itself
MATCH p = ()-[:ACTED_IN]->(:Movie) RETURN p;
// Restrict number of hops
MATCH (:Person {name:"Kevin Bacon"})-[*1..6]-(n) // Show all nodes up to six hops away from a node
RETURN DISTINCT n;
// Find shortest path
MATCH p=shortestPath((:Person {name:"Kevin Bacon"})-[*]-(:Person {name:"Meg Ryan"}))
RETURN p;
// Find all shortest paths
MATCH p = allShortestPaths((u1:User {name:"A. L"})-[*]-(u2:User {name:"cybersam"}))
RETURN p;

// ------------ Complex query ------------ //
// pattern from customer purchasing products to another customer purchasing the same products
MATCH (c:Customer)-[:PURCHASED]->(:Order)-[:ORDERS]->(p:Product)<-[:ORDERS]-(:Order)<-[:PURCHASED]-(c2:Customer)
// don't want the same customer pair twice
WHERE c < c2
// sort by the top-occuring products
WITH c, c2, p, count(*) as productOccurrence
ORDER BY productOccurrence DESC
// return customer pairs ranked by similarity and the top 5 products
RETURN c.companyName, c2.companyName, sum(productOccurrence) as similarity, collect(distinct p.productName)[0..5] as topProducts
ORDER BY similarity DESC LIMIT 10