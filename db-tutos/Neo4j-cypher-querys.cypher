// ====== Documentations ======
// Cypher	: https://neo4j.com/docs/cypher-cheat-sheet/5/all/
// Neo4j	: https://neo4j.com/docs/
// Install	: https://neo4j.com/docs/operations-manual/current/installation/
// Download	: https://neo4j.com/download/
// Courses	: https://graphacademy.neo4j.com/


// ------------ CONFIG ------------ //
// Show config
call n10s.graphconfig.show()
// Init config
call n10s.graphconfig.init()
// Modify config param
call n10s.graphconfig.init({handleMultival: "ARRAY"})

// ------------ Import data ------------ //
// Import ttl file from string (g.serialize())
call n10s.rdf.import.inline(rdf_str, "Turtle")
// Load ttl file from path or http
call n10s.rdf.import.fetch("<file_path or file_url>", "Turtle", {headerParams: {Accept: "application/turtle"}});

// ------------ DETACH ------------ // -> Remnove nodes or relationships
// Clear all nodes
MATCH (n) DETACH DELETE n;
// Clear all nodes attached to 1 specific node of type Human with an attribute human_id with a specific value
MATCH (:Human {human_id: "xxx"})-[*]-(n) DETACH DELETE n;

// ------------ MATCH ------------ // -> Search pattern in graph
// Show all nodes with limit
MATCH (n) RETURN (n) LIMIT 200;
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
// Return the path itself
MATCH p = ()-[:ACTED_IN]->(:Movie) RETURN p;
// Unspecified relationship
MATCH (h1:Human {human_id: "xxx"})<--(h2:Human) RETURN h1, h2;
// HAS_FRIEND relationship
MATCH (h1:Human {human_id: "xxx"})<-[r:HAS_FRIEND]-(h2:Human) RETURN h1, h2, r;
// Multiple nodes pattern
MATCH (:Human)-[:EAT]->(a:Animal)<-[:EAT]-(:Human) RETURN a;
// Relationship with a specific property value
MATCH (h:Human)-[:HAS_FRIEND {best: TRUE}]->() RETURN h;

// ------------ WHERE ------------ // -> Filter results
// Node with a specific label
MATCH (h) WHERE h:Human RETURN h;
// Node with a specific property value
MATCH (h) WHERE h.name = "John" RETURN h;
// With regex
MATCH (h) WHERE h.name =~ "J.*" RETURN h;
// Comparison with numerical value : <, >, <=, >=
MATCH (h) WHERE h.age > 18 RETURN h;
// Not equal : <>
MATCH (h) WHERE h.name <> "John" RETURN h;
// Comparison with date
MATCH (h) WHERE h.birthday > date("2025-01-02") RETURN h;
// OR / AND / XOR / NOT
MATCH (h)
WHERE (h.name = "John" OR h.name = "Jane") AND h.age = 42
RETURN h;
// Comparison with graph itself
MATCH (h1:Human)--(h2:Human)
WHERE NOT (h1)-[:HAS_FRIEND]->(h2)
RETURN h1, h2;
// WHERE IN
MATCH (h:Human {name: "John"})-[:HAS_FRIEND]->(f:Human)
WHERE f.name IN ["John", "George", "Paul", "Ringo"]
RETURN f;

// ------------ NULL / AS / ORDER BY ------------ //
// Show the 5 most recent Movie nodes
MATCH (m:Movie)
WHERE m.released IS NOT NULL // Filter empty property values
RETURN m.title AS title, m.url AS url, m.released AS released // Rename with AS
ORDER BY released DESC LIMIT 5; // Sort with ORDER BY

// ------------ Functions ------------ //
// Show the id of a node and the type of the relationship
MATCH (p:Product)-[r]-(c:Customer) WHERE p.productName = "Queso"
RETURN elementId(c), type(r);
// Count
MATCH (p:Product)<-[:buy]-(c:Customer)
RETURN c.customerId, count(*) AS numberOfProduct;
// sum(), avg(), min(), max()
MATCH (p:Person) RETURN avg(p.age);

// ------------ CREATE ------------ // -> Create nodes and relationships
// Create a new node
CREATE (h42:Human {human_id: "zzz"}) RETURN h42;
// ------------ MERGE ------------ // -> Check if exist before creation
// Create a new node and a new relationship if they dont exist yet
MERGE (h42:Human {human_id: "zzz"})
MERGE (h42)-[r:HAS_FRIEND {date: "2020-01-04"}]->(h1)
RETURN h42, r, h1;
// ------------ SET ------------ // -> Set properties
// Add new properties
MATCH (h:Human) WHERE h.name = "John"
SET h.age = 42, h.last_name = "Doe"
RETURN h;
// Add new properties with +=
MATCH (h:Human) WHERE h.name = "John"
SET h += {age: 42, last_name: "Doe"}
RETURN h;
// Will SET a property if the MERGE creates a new node
MERGE (h42:Human {human_id: "zzz"})
ON CREATE SET h42.name = "Sam"
RETURN h42;


// ------------ CONSTRAINT ------------ // -> Associate a node property to its unique identifier
// Force uniqueness of a property value for all Person nodes
CREATE CONSTRAINT person_name IF NOT EXISTS FOR (p:Person)
REQUIRE p.name IS UNIQUE;


// ------------ CALL ------------ //
// Return all node labels use in the graph
CALL db.labels() YIELD label;