// ====== Documentations ======
// Cypher	: https://neo4j.com/docs/cypher-cheat-sheet/5/all/
// Neo4j	: https://neo4j.com/docs/
// Install	: https://neo4j.com/docs/operations-manual/current/installation/
// Download	: https://neo4j.com/download/
// Courses	: https://graphacademy.neo4j.com/

// Conventionally, CamelCase is used for node labels
// and capitalized SNAKE_CASE for relationship types.



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
// Clear nodes with specific labels
MATCH (n:Person|Movie) // Person OR Movie nodes
DETACH DELETE n;


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


// ------------ WHERE ------------ // -> Filter results
// Node with a specific label
MATCH (h) WHERE h:Human RETURN h;
// Node with a specific property value
MATCH (h) WHERE h.name = "John" RETURN h;
// With regex
MATCH (h) WHERE h.name =~ "J.*" RETURN h;
// String matching : STARTS WITH, ENDS WITH CONTAINS
MATCH (h:Human)
WHERE h.name ENDS WITH "Jr."
AND h.name STARTS WITH "Mr."
AND h.name CONTAINS "John"
RETURN h;
// Comparison with numerical value : <, >, <=, >=
MATCH (h) WHERE h.age > 18 RETURN h;
MATCH (h) WHERE 20 <= h.age < 30 RETURN h; // Double comparison
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
// ------------ NULL / AS / ORDER BY ------------ //
// Show the 5 most recent Movie nodes
MATCH (m:Movie)
WHERE m.released IS NOT NULL // Filter empty property values
RETURN m.title AS title, m.url AS url, m.released AS released // Rename with AS
ORDER BY released DESC LIMIT 5; // Sort with ORDER BY


// ------------ WITH ------------ // -> pass along variables
// Find people with 2-6 years of experience
WITH 2 AS expMin, 6 AS expMax
MATCH (p:Person) WHERE expMin <= p.yearsExp <= expMax RETURN p;


// ------------ Path ------------ //
// Return the path itself
MATCH p = ()-[:ACTED_IN]->(:Movie) RETURN p;
// Restrict number of hops
MATCH (:Person {name:"Kevin Bacon"})-[*1..6]-(n) // Show all nodes up to six hops away from a node
RETURN DISTINCT n;
// Find shortest path
MATCH p=shortestPath((:Person {name:"Kevin Bacon"})-[*]-(:Person {name:"Meg Ryan"}))
RETURN p;


// ------------ Functions ------------ //
// Show the id of a node, the labels of another node and the type of the relationship
MATCH (p:Product)-[r]-(c:Customer) WHERE p.productName = "Queso"
RETURN elementId(c), labels(p), type(r);
// Count
MATCH (p:Product)<-[:buy]-(c:Customer)
RETURN c.customerId, count(*) AS numberOfProduct;
// sum(), avg(), min(), max()
MATCH (p:Person) RETURN avg(p.age);
// String modification: toLower() toUpper() toInteger() toFloat()
MATCH (p:Person) WHERE toLower(p.name) = "john" RETURN p;
// Check existing pattern
MATCH (p:Person)-[:EAT]->(:Animal {specie: "Fish"})
WHERE NOT exists( (p)-[:EAT]->(:Animal {specie: "Chicken"}) )
RETURN p;


// ------------ list ------------ //
// range()
RETURN range(0, 10)[3] AS element; // -> 3
// List slicing
RETURN range(0, 10)[1..4] AS elements; // -> [1, 2, 3]
// Negative index
RETURN range(0, 10)[-2] AS element; // -> 8
RETURN range(0, 10)[1..-5] AS elements; // -> [1, 2, 3, 4]
// List length : size()
WITH [1, 5, 2, 8, 7] AS list RETURN size(list); // -> 5
// Nested list access
WITH [[1, 2], [3, 4], [5, 6]] AS nestedList RETURN nestedList[1][0]; // -> 3
// WHERE IN
MATCH (:Human {name: "Michael"})-[:HAS_FRIEND]->(f:Human)
WHERE f.name IN ["John", "George", "Paul", "Ringo"]
RETURN f;
// List concatenation
RETURN [1, 2] || [3, 4] AS list1, [1, 2] + [3, 4] AS list2; // Return the same [1, 2, 3, 4]
WITH [[1, 2], [3, 4]] AS nestedList
// List append / insert
RETURN 0 + nestedList,  // [0, [1, 2], [3, 4]]
	   nestedList + 5, // [[1, 2], [3, 4], 5]
	   nestedList + [5, 6] AS nonNestedAddition, // [[1, 2], [3, 4], 5, 6]
       nestedList + [[5, 6]] AS nestedAddition; // [[1, 2], [3, 4], [5, 6]]
// List comprehension : [item IN list [WHERE predicate] | [expression]]
RETURN [x IN range(0,10) WHERE x % 2 = 0] AS result; // -> [0, 2, 4, 6, 8, 10]
RETURN [x IN range(0,5) | x * 10] AS result; // -> [0, 10, 20, 30, 40, 50]
RETURN [x IN range(1,6) WHERE x > 2 | x + 10] AS filteredList; // -> [13, 14, 15]
WITH [1,2,3,4] AS list
RETURN [i IN range(0, size(list)-1) | toString(i) || ': ' || toString(list[i])] AS mapped; // ["0: 1", "1: 2", "2: 3", "3: 4"]
// With collect()
MATCH (person:Person)
RETURN [p IN collect(person) WHERE 'Python' IN p.skills | p.name] AS pythonExperts;
// Pattern comprehension
MATCH (alice:Person {name: 'Alice'})
RETURN [(p:Person)-[:WORKS_FOR]->(alice) WHERE p.age > 30 | p.name || ', ' || toString(p.age)] AS employeesAbove30; // -> ["Cecilia, 31"]


// ------------ CREATE ------------ // -> Create nodes and relationships
// Create a new node. Will create a duplicate if that exact node already exists
CREATE (h42:Human {human_id: "zzz"}); // human_id property will be the unique primary key for the node
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


// ------------ SUBQUERIES ------------ //
// ------------ CALL ------------ //
// Return all node labels use in the graph
CALL db.labels() YIELD label;
// ------------ COUNT ------------ //
MATCH (p:Person)
WHERE COUNT { (p)-[:HAS_DOG]->(:Dog) } > 1 // counts the number of rows returned by the subquery
RETURN p.name AS name;
// ------------ EXISTS ------------ //
MATCH (p:Person)
WHERE EXISTS {
	MATCH (p)-[:HAS_DOG]->(d:Dog) // determines if a specified pattern exists at least once in the graph
	WHERE p.name = d.name
}
RETURN p.name AS name;
// Another exist pattern
MATCH (p:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
	(coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors)
WHERE NOT EXISTS { (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors) } AND p <> cocoActors
RETURN cocoActors.name AS recommended, count(*) AS score ORDER BY score DESC;
// ------------ COLLECT ------------ //
MATCH (p:Person) WHERE p.name = "Peter"
SET p.dogNames = COLLECT { MATCH (p)-[:HAS_DOG]->(d:Dog) RETURN d.name } // creates a list with the rows returned by the subquery.
RETURN p.dogNames as dogNames