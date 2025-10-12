// ------------ WHERE ------------ // -> Filter results
// Node with a specific label
MATCH (h) WHERE h:Human RETURN h;
// Node with a specific property value
MATCH (h) WHERE h.name = "John" RETURN h;
// WHERE inside pattern mathcing
MATCH (a:Person WHERE a.name = 'Andy')-[:KNOWS]->(b:Person WHERE b.age > 35) RETURN b.name AS name;
// WHERE inside relationship pattern matching
MATCH ()-[r WHERE 10 < r.distance < 100]->() RETURN r;
// With regex
MATCH (h) WHERE h.name =~ "J.*" RETURN h;
// String matching : STARTS WITH, ENDS WITH CONTAINS
MATCH (h:Human)
WHERE h.name ENDS WITH "Jr."
AND h.name STARTS WITH "Mr."
AND h.name CONTAINS "John"
RETURN h;
// Unicodes can be escaped as \uxxx
MATCH (r:Recipe)
WHERE r.description CONTAINS "\u00B0"
RETURN r;
// Comparison with numerical value : <, >, <=, >=
MATCH (h) WHERE h.age > 18 RETURN h;
MATCH (h) WHERE 20 <= h.age < 30 RETURN h; // Double comparison
// Not equal : <>
MATCH (h) WHERE h.name <> "John" RETURN h;
// Comparison with date
MATCH (h) WHERE h.birthday > date("2025-01-02") RETURN h;
// OR / AND / XOR / NOT
MATCH (h)
WHERE (h.name = "John" OR h.name = "Jane")
AND h.age = 42
AND NOT h.lastname CONTAINS "Smith"
RETURN h;
// Comparison with graph itself
MATCH (h1:Human)--(h2:Human)
WHERE NOT (h1)-[:HAS_FRIEND]->(h2)
RETURN h1, h2;

// ------------ NULL / AS / ORDER BY / SKIP / LIMIT ------------ //
MATCH (m:Movie)
WHERE m.released IS NOT NULL // Filter empty property values
RETURN m.title AS title, m.released AS released // Rename with AS
ORDER BY released DESC // Sort with ORDER BY
SKIP 1 // Skip first row with SKIP
LIMIT 5; // Limit result to 5

// Filter out null values
WITH [1, true, "three", 4.0, null, ['a']] AS x
RETURN [item IN x WHERE NOT item IS NULL] AS res
