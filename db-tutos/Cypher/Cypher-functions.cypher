// ============ Functions ============ //
// Functions : https://neo4j.com/docs/cypher-cheat-sheet/5/all/#_functions
// 			   https://neo4j.com/docs/cypher-manual/5/functions/


// Return function informations
SHOW FUNCTIONS;
SHOW BUILT IN FUNCTIONS YIELD *;
SHOW FUNCTIONS EXECUTABLE BY CURRENT USER YIELD *;
SHOW FUNCTIONS EXECUTABLE BY user_name;

// Show the id of a node, the labels of another node and the type of the relationship
MATCH (p:Product)-[r]-(c:Customer) WHERE p.productName = "Queso"
RETURN elementId(c), labels(p), type(r);
// count()
MATCH (p:Product)<-[:buy]-(c:Customer)
RETURN c.customerId, count(*) AS numberOfProduct;
// collect()
MATCH (p:Product)<-[:buy]-(c:Customer)
RETURN c.customerId, collect(distinct p) AS allProducts;
// sum()
MATCH (p:Person) RETURN avg(p.age);
// String modification: toLower() toUpper()
MATCH (p:Person) WHERE toLower(p.name) = "john" RETURN p;
// Check existing pattern
MATCH (p:Person)-[:EAT]->(:Animal {specie: "Fish"})
WHERE NOT exists( (p)-[:EAT]->(:Animal {specie: "Chicken"}) )
RETURN p;


// --- Convert ---
// toString() toInteger() toFloat() toBoolean()
// toStringOrNull()

// --- Float / Integer ---
// round() floor() ceil()
// sum() avg() min() max()

// --- Strings ---
// replace() split() reverse() normalize()
// Trim : btrim() ltrim() rtrim() trim()
// toLower() lower() toUpper() upper()
// Slicing : left() right() substring()

// randomUUID()


// ============ Procedures ============ //
// Procedure: https://neo4j.com/docs/operations-manual/current/procedures/

SHOW PROCEDURES YIELD *;

// ------------ DATABASE ------------ //
CALL db.schema.visualization(); // Show Graph model
CALL db.info() // Return database informations
CALL db.relationshipTypes() // Return a list all relationship types
CALL db.labels() // Return a list of all node labels
CALL dbms.showCurrentUser() // Return user informations