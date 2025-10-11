// ------------ SUBQUERIES ------------ //

// ------------ CALL ------------ // -> Variables imported into a CALL subquery are visible in the whole subquery
// Return all node labels use in the graph
CALL db.labels() YIELD labels // Calls inside a larger query requires passing variables with YIELD.
RETURN count(labels) AS labelNumber;

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
// NOT EXISTS
MATCH (p:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
	(coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors)
WHERE NOT EXISTS { (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors) } AND p <> cocoActors
RETURN cocoActors.name AS recommended, count(*) AS score ORDER BY score DESC;

// ------------ COLLECT ------------ //
MATCH (p:Person) WHERE p.name = "Peter"
SET p.dogNames = COLLECT { MATCH (p)-[:HAS_DOG]->(d:Dog) RETURN d.name } // creates a list with the rows returned by the subquery.
RETURN p.dogNames as dogNames;

// ------------ WITH ------------ // -> pass along variables to the next query part
// Use WITH to assign variables
WITH 2 AS expMin, 6 AS expMax
MATCH (p:Person) WHERE expMin <= p.yearsExp <= expMax RETURN p // Find people with 2-6 years of experience
