// ------------ DETACH ------------ // -> Remove nodes or relationships
// Clear all nodes
MATCH (n) DETACH DELETE n;
// Clear all nodes attached to 1 specific node of type Human with an attribute human_id with a specific value
MATCH (:Human {human_id: "xxx"})-[*]-(n) DETACH DELETE n;
// Clear nodes with specific labels
MATCH (n:Person|Movie) // Person OR Movie nodes
DETACH DELETE n;
// ------------ REMOVE ------------ // -> Remove properties
MATCH (p:Person) REMOVE p.age RETURN p;
MATCH (p:Person) SET p.age = null RETURN p // Or setting it to null
