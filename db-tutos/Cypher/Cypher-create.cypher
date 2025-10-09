// ------------ CONSTRAINT ------------ // -> Associate a node property to its unique identifier
// Force uniqueness of a property value for all Person nodes
CREATE CONSTRAINT person_name IF NOT EXISTS FOR (p:Person)
REQUIRE p.name IS UNIQUE;

// ------------ CREATE ------------ // -> Create nodes and relationships
// Create a new node. Will create a duplicate if that exact node already exists
CREATE (h42:Human {human_id: "zzz"}); // human_id property will be the unique primary key for the node
// ------------ MERGE ------------ // -> Check if exist before creation
// Create a new node and a new relationship if they dont exist yet
MERGE (h42:Human {human_id: "zzz"})
MERGE (h42)-[r:HAS_FRIEND {date: "2020-01-04"}]->(h1)
RETURN h42, r, h1;
// ------------ ON CREATE / ON MATCH ------------ //
MERGE (h42:Human {human_id: "zzz"})
ON CREATE SET h42.createAt = datetime() // If node doesn't exist, MERGE will create it and this will happen
ON MATCH SET h42.updateAt = datetime() // If node already exists, MERGE won't create it and this will happen
RETURN h42;

// ------------ SET ------------ // -> Set properties, node labels
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
// Add new label
MATCH (h:Human)
WHERE EXISTS { (h)-[:EAT]->(:Animal) }
SET h:Carnivore
