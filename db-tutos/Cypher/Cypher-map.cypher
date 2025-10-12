// ------------ map ------------ //
// Doc : https://neo4j.com/docs/cypher-manual/current/expressions/map-expressions/#map-operators

WITH {a:"jjj", b:3, c:true} AS x, "c" AS keyVar
RETURN  valueType(x), 	// "MAP NOT NULL"
		keys(x), 		// ["a", "b", "c"]
		x.a, 			// "jjj" 	-> Static access
		x["b"], 		// 3 		-> Dynamic access
		x[keyVar]; 		// true

// Access multiple keys with list comprehension
WITH {a: 10, b: 20, c: 30} AS map, ['a', 'c'] AS dynamicKeys
RETURN [key IN dynamicKeys | map[key]] AS dynamicValue;
// Access node properties as a map using list comprehension
MATCH (n:User {user_id:605})
RETURN [k IN keys(n) | [k, n[k]]] AS properties; // -> [[key, value], ...]

// --- Map projection : return a new map from a original map
// key selector
WITH {a: 10, b: 20, c: 30} AS map
RETURN map{.a, .c} AS projectedMap; // -> {a: 10, c: 30}
// custom key/value pairs
WITH {a: 10, b: 20, c: 30} AS map
RETURN map {
	newKey: map.a, // same value
	otherNewKey: map.a + map.b + map.c, // new value
    final: "countdown" // litteral value
} AS projectedMap;
// custom, key/value pairs using variables : key = variable_name / value = variable_value
MATCH (p:Person {name: 'Keanu Reeves'})
WITH p, date('1964-09-02') AS dob, 'Beirut, Lebanon' AS birthPlace
RETURN p{.name, dob, birthPlace} AS projectedKeanu; // ->  {name: "Keanu Reeves", birthPlace: "Beirut, Lebanon", dob: 1964-09-02}
// works on nodes and relationship properties
MATCH (p:Person {name: 'Keanu Reeves'})-[:ACTED_IN]->(m:Movie)
WITH p, collect(m) AS movies
RETURN p {.name, totalMovies: size(movies)} AS keanuDetails;
// Get all node properties with all-map projection
MATCH (n:User {user_id:605})
RETURN n{.*} AS properties;
// Generate list of map using collect()
MATCH (c:Case {primaryid: 111791005})
MATCH (c)-[consumed]->(d:Drug)-[:PRESCRIBED]-(therapy)
MATCH (r)<-[:HAS_REACTION]-(c)-[:RESULTED_IN]->(outcome)
WITH distinct c.age + ' ' + c.ageUnit as age, c.gender as gender,
collect(distinct r.description) as sideEffects,
collect(
    distinct {
        drug: d.name,
        dose: consumed.doseAmount + ' '  + consumed.doseUnit,
        indication: consumed.indication,
        route: consumed.route
    }) as treatment,
collect(distinct outcome.outcome) as outcomes
RETURN age, gender, treatment, sideEffects, outcomes