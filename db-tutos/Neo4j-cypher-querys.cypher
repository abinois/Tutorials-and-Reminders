// create unique
CREATE CONSTRAINT n10s_unique_uri FOR (r:Resource)
REQUIRE r.uri IS UNIQUE;

// show config
call n10s.graphconfig.show()

// init config
call n10s.graphconfig.init()

// modify config param
call n10s.graphconfig.init({handleMultival: "ARRAY"})

// import ttl file from string (g.serialize())
call n10s.rdf.import.inline(rdf_str, "Turtle")

// load ttl file from path or http
call n10s.rdf.import.fetch("<file_path or file_url>", "Turtle", {headerParams: {Accept: "application/turtle"}});

// clear all nodes
MATCH (n) DETACH DELETE n;
// clear all nodes attached to 1 specific node of type Human with an attribute human_id with a specific value
MATCH (:Human {human_id: "xxxxxx"})-[*]-(n) DETACH DELETE n;

// show all nodes
MATCH (n) RETURN (n);
// show all nodes with limit
MATCH (n) RETURN (n) LIMIT 200;
// show all nodes attach to 1 specific node, with edges of any type and any direction
MATCH (h:Human {human_id: "xxxxxx"})-[*]-(n) RETURN h, n;
// show all human nodes targeting 1 specific human
MATCH (h1:Human {human_id: "xxxxxx"})<--(h2:Human) RETURN h1, h2;
// show all human nodes targeting 1 specific human, with an edge of type hasFriend
MATCH (h1:Human {human_id: "xxxxxx"})<-[:hasFriend]-(h2:Human) RETURN h1, h2;
// show all nodes of type Animal targeted by 2 specific nodes of type Human with edges of type eat
MATCH (h1:Human {human_id: "xxxxxx"})-[:eat]->(a:Animal)<-[:eat]-(h2:Human {human_id: "yyyyyy"}) RETURN a;
// Show all Human friends of a specific node that have The Beatles names
MATCH (h:Human {human_id: "xxxxxx"})-[:hasFriend]->(f:Human) WHERE f.name IN ["John", "George", "Paul", "Ringo"] RETURN f;
// Show the id of a node
MATCH (p:Product) WHERE p.productName = "Queso Manchego La Pastora" RETURN elementId(p);
// Specific value
MATCH (h:Human) WHERE h.name = "John" RETURN h;
// With regex
MATCH (h:Human) WHERE h.name =~ "J.*" RETURN h;
// Comparison with numerical value
MATCH (h:Human) WHERE h.age > 18 RETURN h;
// Comparison with date
MATCH (h:Human) WHERE h.birthday > date("2025-01-02") RETURN h;
// Comparison with graph itself
MATCH (h1:Human)--(h2:Human) WHERE NOT (h1)-[:hasFriend]->(h2) RETURN h1, h2;

