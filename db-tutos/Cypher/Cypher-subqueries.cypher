// ------------ SUBQUERIES ------------ //

// ------------ CALL ------------ // -> Variables imported into a CALL subquery are visible in the whole subquery
// Return all node labels use in the graph
CALL db.labels() YIELD labels // Calls inside a larger query requires passing variables with YIELD.
RETURN count(labels) AS labelNumber;
// Passing variable into a subquery
MATCH (m:Movie)
CALL (m) { // passing 'm' to the subquery
	// WITH m // old way to pass variable to the subquery
	MATCH (m)<-[r:RATED]-(u:User) WHERE r.rating = 5
	RETURN count(u) AS numReviews
}
RETURN m.title AS title, numReviews
ORDER BY numReviews DESC;

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
// Inside a node pattern
MATCH	(:Station {name: 'Denmark Hill'})<-[:CALLS_AT]-(start:Stop)-[:NEXT]->+
		(end:Stop WHERE NOT EXISTS { (end)-[:NEXT]->(:Stop) })
		-[:CALLS_AT]->(dest:Station)
RETURN start.departs AS departure, end.arrives AS arrival, dest.name AS finalDestination;


// ------------ COLLECT ------------ //
MATCH (p:Person) WHERE p.name = "Peter"
SET p.dogNames = COLLECT { MATCH (p)-[:HAS_DOG]->(d:Dog) RETURN d.name } // creates a list with the rows returned by the subquery.
RETURN p.dogNames as dogNames;

// ------------ WITH ------------ // -> pass along variables to the next query part
// Use WITH to assign variables
WITH 2 AS expMin, 6 AS expMax
MATCH (p:Person) WHERE expMin <= p.yearsExp <= expMax RETURN p; // Find people with 2-6 years of experience

// ------------ UNION ------------ // -> Combines results of 2 queries
// UNION within a CALL subquery
MATCH (p:Person)
WITH p LIMIT 100 // LIMIT in a WITH clause
CALL (p) {
	OPTIONAL MATCH (p)-[:ACTED_IN]->(m:Movie)
	RETURN m.title + " : Actor" AS work // both queries return a row named 'work'
UNION // UNION clause
	OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)
	RETURN m.title + " : Director" AS work // both queries return a row named 'work'
}
RETURN p.name, collect(work)