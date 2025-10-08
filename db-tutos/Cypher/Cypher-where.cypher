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