// ------------ Path ------------ //

// Return the path itself
MATCH p = ()-[:ACTED_IN]->(:Movie) RETURN p;
// Path length
MATCH p=(start {name: 'A'})-[*]->(finish {name: 'D'})
RETURN length(p) AS pathLength;
// Get all distinct relationship type of a node
MATCH p=(n:User {user_id:605})--()
RETURN collect(distinct [r IN relationships(p) | type(r)]);
// Mark nodes along the path
MATCH p=(start {name: 'A'})-[*]->(finish {name: 'D'})
FOREACH (n IN nodes(p) | SET n.marked = true);
// Mark relationships along the path
MATCH p=(start {name: 'A'})-[*]->(finish {name: 'D'})
FOREACH ( r IN relationships(p) | SET r.marked = true );


// === Variable length path ===
// ----------------------------------------------------------------------------------\
// 	  Syntax 2				Description				Syntax 1		Path syntax		 |
// ----------------------------------------------------------------------------------|
// -[*]->		|	1 or more iterations.		|	-[]->+		|	(()-[]->())+	 |
// ----------------------------------------------------------------------------------|
// -[*n]->		|	Exactly n iterations.		|	-[]->{n}	|	(()-[]->()){n}	 |
// ----------------------------------------------------------------------------------|
// -[*m..n]->	|	Between m and n iterations.	|	-[]->{m,n}	|	(()-[]->()){m,n} |
// ----------------------------------------------------------------------------------|
// -[*m..]->	|	m or more iterations.		|	-[]->{m,}	|	(()-[]->()){m,}	 |
// ----------------------------------------------------------------------------------|
// -[*0..]->	|	0 or more iterations.		|	-[]->*		|	(()-[]->())*	 |
// ----------------------------------------------------------------------------------|
// -[*..n]->	|	Between 1 and n iterations.	|	-[]->{1,n}	|	(()-[]->()){1,n} |
// ----------------------------------------------------------------------------------|
// -[*0..n]->	|	Between 0 and n iterations.	|	-[]->{,n}	|	(()-[]->()){,n}	 |
// ----------------------------------------------------------------------------------/
// Note: syntax 1 is more explicit and less confusing

// === Repetitive relationship pattern
// 1 or more LINK relationship, regardless of the nodes traversed
MATCH	(:Station {name: 'Peckham Rye'})
		-[link:LINK]-+ // using the '+' sign
		(:Station {name: 'Clapham Junction'})
RETURN link; // link is a list of relationships
// Quantified relationship matching
MATCH p = (a:Person {name: "Andy"})-[r:KNOWS WHERE r.since < 2011]->{1,4}(:Person) // the relationship can appear from 1 to 4 times
RETURN [n IN nodes(p) | n.name] AS paths;
// Specify maximum number of hops, without specifying relationship type
MATCH (:Person {name:"Kevin Bacon"})-[*1..6]-(n) // Show all nodes up to six hops away, regardless of the relationships and nodes traversed
RETURN DISTINCT n;
// Specify maximum number of hops, with a specific relationship type
MATCH	(p:Person)
		-[:KNOWS*2..4] // From 2 to 4 times repetition of a KNOWS relationship
		-(friend)-[:PARTY_TO]->(:Crime)
WHERE NOT (p:Person)-[:PARTY_TO]->(:Crime)
RETURN p.name, count(distinct friend) AS dangerousFriends;
// Exact number of hops
MATCH	(p1:Person {name:"Kevin"})
		-[:KNOWS*2]- // Exactly 2 hops away
		(p2:Person)
RETURN p2.name AS others;

// === Repetitive path pattern
// 1 or more path pattern, using the '+'
MATCH	(:Station {name: 'Peckham Rye'})
		(()-[link:LINK]-(s) WHERE link.distance <= 2)+ // With a inline WHERE clause
		(:Station {name: 'London Victoria'})
UNWIND s AS station
RETURN station.name AS callingPoint;
// Quantified path pattern matching
MATCH	(:Station {name: 'Peckham Rye'})
		(()-[link:LINK]-(s)){1,3} // From 1 to 3 time
		(:Station {name: 'London Victoria'})
UNWIND s AS station
RETURN station.name AS callingPoint;
// Getting closer to the destination using spacial properties and point.distance()
MATCH (start:Station {name: "London Blackfriars"})
MATCH (end:Station {name: "North Dulwich"})
MATCH p = (start)
        ((a)-[:LINK]-(b:Station) WHERE point.distance(a.location, end.location) > point.distance(b.location, end.location))+ // WHERE inside quantified pattern
		(end)
RETURN reduce(acc = 0, r in relationships(p) | round(acc + r.distance, 2)) AS distance;

// === Shortest path ===
// Find shortest path
MATCH p=shortestPath((:Person {name:"Kevin"})-[*]-(:Person {name:"Meg"})) RETURN p;
// Find all shortest paths
MATCH p=allShortestPaths((u1:User {name:"AL"})-[*]-(u2:User {name:"Sam"})) RETURN p;
// Find all shortest paths within 3 hops max, with specific relationship types
MATCH p = allshortestpaths((p1:Person {name:'Jack', surname:'Powell'})-[:KNOWS|KNOWS_LW|KNOWS_SN|FAMILY_REL|KNOWS_PHONE*..3]-(p2:Person{name:'Raymond', surname:'Walker'}))
RETURN p;
// Shortest path with quantified path pattern using SHORTEST / ALL SHORTEST
MATCH p = SHORTEST 1 // to specify the number of shortest path returned
	(:Station {name: "Brixton"})
	(()-[:LINK]-(:Station))+ // not possible with shortestpath()
	(:Station {name: "Clapham Junction"})
RETURN [station IN nodes(p) | station.name] AS route
