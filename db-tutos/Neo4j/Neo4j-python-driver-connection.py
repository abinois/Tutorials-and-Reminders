# ============= Documentation =============
# Python driver : https://neo4j.com/docs/python-manual/current/


from neo4j import GraphDatabase, basic_auth

server_url = ""
server_auth = ("username", "password")

# Query graph in Neo4j
with GraphDatabase.driver(server_url, auth=server_auth) as driver:
	# Check server connection
	driver.verify_connectivity()
	# Making a cypher query
	query = "MATCH (h:Human) WHERE h.age > 18 RETURN h LIMIT 10"
	# Execute cypher query
	records, summary, keys = driver.execute_query(query, database_="neo4j")
	# Print results
	for record in records:
		print(record)
	# Close connection
driver.close()

# Cypher query with parameters
query = '''
MATCH (movie:Movie {title:$favorite})<-[:ACTED_IN]-(actor)-[:ACTED_IN]->(rec:Movie)
RETURN DISTINCT rec.title AS title LIMIT 20
'''
driver = GraphDatabase.driver(server_url, auth=basic_auth(server_auth[0], server_auth[1]))
with driver.session(database="neo4j") as session:
	results = session.read_transaction(lambda tx: tx.run(query, favorite="The Matrix").data())
	for record in results:
		print(record['title'])
driver.close()

# Other example of running a cypher query with parameters
def get_actors(tx, movieTitle): # (1)
	result = tx.run("""
		MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
		WHERE m.title = $title
		RETURN p
	""", title=movieTitle)

	# Access the `p` value from each record
	return [ record["p"] for record in result ]

with driver.session() as session:
    result = session.read_transaction(get_actors, movieTitle="Toy Story")