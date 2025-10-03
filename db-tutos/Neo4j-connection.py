from neo4j import GraphDatabase

# Dump RDF graph in Neo4j DB
server_url = ""
server_auth = ""
with GraphDatabase.driver(server_url, auth=server_auth) as server:
	server.verify_connectivity()
	serialized_rdf = "" # g.serialize()
	query = "CALL n10s.rdf.import.inline('{}', \"Turtle\");".format(serialized_rdf)
	response = server.execute_query(query, database_='neo4j')
	print(response)
