from neo4j import GraphDatabase

# Dump RDF graph in Neo4j DB
server_url = ""
server_auth = ("username", "password")
with GraphDatabase.driver(server_url, auth=server_auth) as server:
	# Check server connection
	server.verify_connectivity()
	# Making a cypher query
	query = "MATCH (h:Human) WHERE h.age > 18 RETURN h LIMIT 10"
	# Execute cypher query
	records, summary, keys = server.execute_query(query)
	# Print results
	for record in records:
		print(record)
	# Close connection
	server.close()