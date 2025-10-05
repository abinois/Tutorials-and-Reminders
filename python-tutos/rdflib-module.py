from rdflib import Namespace, Graph, Literal, URIRef, namespace
from neo4j import GraphDatabase

# Init RDF graph
g = Graph()

# Create a namespace
class_url = "https://example.com/ontology/class/"
link_url = "https://example.com/ontology/link/"
data_url = "https://example.com/ontology/data/"

human_url = class_url + "Human"
human = URIRef(Namespace(human_url))
hasFriend_attribute_url = link_url + "hasFriend"
hasFriend = URIRef(Namespace(hasFriend_attribute_url))
hasFriendNumber_attribute_url = data_url + "hasFriendNumber"
hasFriendNumber = URIRef(Namespace(hasFriendNumber_attribute_url))

# Add prefixe to a namespace
g.bind('h', Namespace(human_url))
g.bind('l', Namespace(link_url))
g.bind('d', Namespace(data_url))

# Create nodes
human1 = URIRef(Namespace(human_url) + '/1')
human2 = URIRef(Namespace(human_url) + '/2')
human3 = URIRef(Namespace(human_url) + '/3')

# Add triples
g.add((human1, namespace.RDF.type, human))
g.add((human1, namespace.RDFS.label, Literal("John")))
g.add((human1, namespace.SKOS.altLabel, Literal("Johnny")))
g.add((human1, hasFriend, human2))
g.add((human1, hasFriend, human3))
g.add((human1, hasFriendNumber, Literal(42)))
g.add((human2, namespace.RDF.type, human))
g.add((human2, namespace.RDFS.label, Literal("Jack")))
g.add((human2, namespace.SKOS.altLabel, Literal("Jacky")))
g.add((human2, hasFriend, human3))
g.add((human3, namespace.RDF.type, human))
g.add((human3, namespace.RDFS.label, Literal("Jason")))
g.add((human3, namespace.SKOS.altLabel, Literal("Jay")))

# Properties domain and range
g.add((hasFriend, namespace.RDF.type, namespace.OWL.ObjectProperty))
g.add((hasFriend, namespace.RDFS.domain, namespace.OWL.Thing))
g.add((hasFriend, namespace.RDFS.range, namespace.OWL.Thing))
g.add((hasFriendNumber, namespace.RDF.type, namespace.OWL.DatatypeProperty))
g.add((hasFriendNumber, namespace.RDFS.domain, namespace.OWL.Thing))
g.add((hasFriendNumber, namespace.RDFS.range, namespace.XSD.string))

# Stringify RDF graph
serialized_rdf = g.serialize(format="ttl")

# Export RDF graph in a ttl file
filepath = "my_file.ttl"
g.serialize(filepath, format='ttl')

# Export in Neo4j
server_url = ""
server_auth = ""
with GraphDatabase.driver(server_url, auth=server_auth) as server:
	server.verify_connectivity()
	query = "CALL n10s.rdf.import.inline('{}', \"Turtle\");".format(serialized_rdf)
	rq = server.execute_query(query, database_='neo4j')
	print(rq)


# This will create this rdf file :

# @prefix d: <https://example.com/ontology/data/> .
# @prefix h: <https://example.com/ontology/class/Human> .
# @prefix l: <https://example.com/ontology/link/> .
# @prefix owl: <http://www.w3.org/2002/07/owl#> .
# @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
# @prefix skos: <http://www.w3.org/2004/02/skos/core#> .
# @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

# <https://example.com/ontology/class/Human/1> a h: ;
#     rdfs:label "John" ;
#     skos:altLabel "Johnny" ;
#     d:hasFriendNumber 42 ;
#     l:hasFriend <https://example.com/ontology/class/Human/2>,
#         <https://example.com/ontology/class/Human/3> .

# d:hasFriendNumber a owl:DatatypeProperty ;
#     rdfs:domain owl:Thing ;
#     rdfs:range xsd:string .

# l:hasFriend a owl:ObjectProperty ;
#     rdfs:domain owl:Thing ;
#     rdfs:range owl:Thing .

# <https://example.com/ontology/class/Human/2> a h: ;
#     rdfs:label "Jack" ;
#     skos:altLabel "Jacky" ;
#     l:hasFriend <https://example.com/ontology/class/Human/3> .

# <https://example.com/ontology/class/Human/3> a h: ;
#     rdfs:label "Jason" ;
#     skos:altLabel "Jay" .
