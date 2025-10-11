// ------------ Path ------------ //

// Return the path itself
MATCH p = ()-[:ACTED_IN]->(:Movie) RETURN p;

// Restrict number of hops
MATCH (:Person {name:"Kevin Bacon"})-[*1..6]-(n) // Show all nodes up to six hops away
RETURN DISTINCT n;
// Repetitive relationship : up to 2 times repetition of a KNOWS relationship
MATCH (p:Person)-[:KNOWS*1..2]-(friend)-[:PARTY_TO]->(:Crime)
WHERE NOT (p:Person)-[:PARTY_TO]->(:Crime)
RETURN p.name, count(distinct friend) AS dangerousFriends;

// Quantified relationship matching
MATCH p = (a:Person {name: "Andy"})-[r:KNOWS WHERE r.since < 2011]->{1,4}(:Person) // the relationship can appear from 1 to 4 times
RETURN [n IN nodes(p) | n.name] AS paths;
// Quantified path pattern matching
MATCH	(:Station { name: 'Denmark Hill' })<-[:CALLS_AT]-(d:Stop)
		((:Stop)-[:NEXT]->(:Stop)){1,3} // from 1 to 3 times
		(a:Stop)-[:CALLS_AT]->(:Station { name: 'Clapham Junction' })
RETURN d.departs AS departureTime, a.arrives AS arrivalTime;

// Mark nodes along the path
MATCH p=(start)-[*]->(finish)
WHERE start.name = 'A' AND finish.name = 'D'
FOREACH (n IN nodes(p) | SET n.marked = true);
// Mark relationships along the path
MATCH p=(start)-[*]->(finish)
WHERE start.name = 'A' AND finish.name = 'D'
FOREACH ( r IN relationships(p) | SET r.marked = true );

// Get all distinct relationship type of a node
MATCH p=(n:User {user_id:605})--()
RETURN collect(distinct [r IN relationships(p) | type(r)]);

// Find shortest path
MATCH p=shortestPath((:Person {name:"Kevin"})-[*]-(:Person {name:"Meg"})) RETURN p;
// Find all shortest paths
MATCH p=allShortestPaths((u1:User {name:"AL"})-[*]-(u2:User {name:"Sam"})) RETURN p;
// Find all shortest paths within 3 hops max
MATCH path = allshortestpaths((p1:Person {name:'Jack', surname:'Powell'})-[:KNOWS|KNOWS_LW|KNOWS_SN|FAMILY_REL|KNOWS_PHONE*..3]-(p2:Person{name:'Raymond', surname:'Walker'}))
RETURN path