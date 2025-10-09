// ------------ DELETE ------------ // -> Remove isolated node or relationship
// Delete node
MATCH (n:Node {id:123}) DELETE n; // Works only if the node doesn't have any relationship
// Delete relationship
MATCH (:Node {id:123})-[r:RELATED_TO]->(:Node {id:456}) DELETE r;
// ------------ DETACH DELETE ------------ // -> Remove relationships then nodes
// Clear all nodes
MATCH (n) DETACH DELETE n;
// Clear all nodes attached to 1 specific node of type Human with an attribute human_id with a specific value
MATCH (:Human {human_id: "xxx"})-[*]-(n) DETACH DELETE n;
// Clear nodes with specific labels
MATCH (n:Person|Movie) DETACH DELETE n; // Person OR Movie nodes
// ------------ REMOVE ------------ // -> Remove properties
MATCH (p:Person) REMOVE p.age RETURN p;
MATCH (p:Person) SET p.age = null RETURN p // Or setting it to null
