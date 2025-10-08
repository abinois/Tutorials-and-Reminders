from SPARQLWrapper import SPARQLWrapper, JSON

# Init Wikidata SPARQL wrapper
url = 'https://query.wikidata.org/sparql'
wrapper = SPARQLWrapper(url)
wrapper.setReturnFormat(JSON)

# Make query with batch value
language = 'en'
names = [
    'panda',
    'Donald Trump',
    'lemon'
]
query_batch = '''SELECT DISTINCT *
WHERE
{
    VALUES ?value
    {
        ''' + '\n       '.join([f'"{name}"@{language}' for name in names]) + '''
    }
    ?s rdfs:label ?value.
    FILTER EXISTS { ?s ?p ?o. }
    SERVICE wikibase:label { bd:serviceParam wikibase:language "'''+language+'''". }
}'''

# Set and process query
wrapper.setQuery(query_batch)
response = wrapper.queryAndConvert()

# Print response
print("Names:", names)
print("Urls:")
for result in response["results"]["bindings"]:
	if result["s"]["type"] == "uri":
		print(f' - {result["s"]["value"]}')