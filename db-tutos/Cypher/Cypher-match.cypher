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
// AND on node labels
MATCH (n:Human:Superhero)-->(a:Animal) RETURN n, a;
// AND on node label dinamically : $() or $all()
WITH ["Person", "Director"] AS labels
MATCH (directors:$(labels)) // -> equivalent as an AND : MATCH (n:Person:Director)
RETURN directors;
// OR on node labels
MATCH (n:Movie|Person) // Movie OR Person nodes
RETURN n.name AS name, n.title AS title;
// TrainStation AND BusStation OR StationGroup
MATCH (n:(TrainStation&BusStation)|StationGroup) RETURN n;
// OR on node labels dinamically : $any()
MATCH (n:$any(["Movie", "Actor"])) // -> equivalent as an OR : MATCH (n:Movie|Actor)
RETURN n;
// Node with not this label
MATCH (n:!Movie)
RETURN labels(n) AS label, count(n) AS labelCount;
// Multiple MATCH clause
MATCH (h:Human)-[:HAS_PET]->(:Animal {color: "Brown"})
MATCH (s:Store)<-[r1]-(h)-[r2]->(c:Location {category: "cinema"})
WHERE h.human_id = "xxx" AND h.age < 23
RETURN *;
// Multiple pattlerns for 1 MATCH clause (more efficient) -> graph pattern
MATCH (h:Human)-[:HAS_PET]->(:Animal {color: "Brown"}),
	(s:Store)<-[r1]-(h)-[r2]->(c:Location {category: "cinema"})
WHERE h.human_id = "xxx" AND h.age < 23
RETURN *;

// Unspecified relationship
MATCH (h1:Human {human_id: "xxx"})<--(h2:Human) RETURN h1, h2;
// HAS_FRIEND relationship
MATCH (h1:Human {human_id: "xxx"})<-[r:HAS_FRIEND]-(h2:Human) RETURN h1, h2, r;
// Relationship with a specific property value
MATCH (h:Human)-[:HAS_FRIEND {best: TRUE}]->() RETURN h;
// OR on relationship type
MATCH (p:Person)-[r:ACTED_IN|DIRECTED]->(m:Movie)
RETURN p.name AS name, type(r) AS type, m.title AS title;
// Dynamically filtering relationship type
WITH "ACTED_IN" AS relationshipType
MATCH (p)-[r:$(relationshipType)]->(m)
RETURN p, m;


// ------------ OPTIONAL MATCH ------------ //
MATCH (p:Person {name: 'Martin Sheen'})
OPTIONAL MATCH (p)-[r:DIRECTED]->()
RETURN p.name, r // 'r' will be null for nodes who don't match the pattern
