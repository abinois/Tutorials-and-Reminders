// ============ Functions ============ //
// Functions : https://neo4j.com/docs/cypher-cheat-sheet/5/all/#_functions

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


// ============ Procedures ============ //
// Procedure: https://neo4j.com/docs/operations-manual/current/procedures/

// ------------ DATABASE ------------ //
CALL db.schema.visualization(); // Show Graph model
CALL db.info() // Return database informations
