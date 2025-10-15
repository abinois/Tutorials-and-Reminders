import os
from dotenv import load_dotenv
from langchain_community.document_loaders import DirectoryLoader, PyPDFLoader
from langchain_community.document_loaders.csv_loader import CSVLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_neo4j import Neo4jGraph, GraphCypherQAChain, Neo4jVector
from langchain_experimental.graph_transformers import LLMGraphTransformer
from langchain_community.graphs.graph_document import Node, Relationship
from langchain.prompts import PromptTemplate
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.prompts import ChatPromptTemplate

# In Terminal :
# > git clone https://github.com/neo4j-graphacademy/llm-knowledge-graph-construction
# > cd llm-knowledge-graph
# > pip install -r requirements.txt

# In .env file :
# OPENAI_API_KEY=sk-...
# NEO4J_URI=bolt://
# NEO4J_USERNAME=neo4j
# NEO4J_PASSWORD=

# Test setup:
# > llm-knowledge_graph/test_environment.py


load_dotenv()


# ================================= GENERATE GRAPH WITH LLM =================================
DOCS_PATH = "llm-knowledge-graph/data/course/pdfs"

llm = ChatOpenAI(
	openai_api_key=os.getenv('OPENAI_API_KEY'),
	model_name="gpt-3.5-turbo"
)
embedding_provider = OpenAIEmbeddings(
	openai_api_key=os.getenv('OPENAI_API_KEY'),
	model="text-embedding-ada-002"
	)
graph = Neo4jGraph(
	url=os.getenv('NEO4J_URI'),
	username=os.getenv('NEO4J_USERNAME'),
	password=os.getenv('NEO4J_PASSWORD')
)
doc_transformer = LLMGraphTransformer(
    llm=llm
    # allowed_nodes=["Technology", "Concept", "Skill", "Event", "Person", "Object"], # Node label schema
    # allowed_relationships=["USES", "HAS", "IS", "AT", "KNOWS"], # Relationship type schema
    # node_properties=["name", "description"], # properties to be added for nodes, if found in the data
)
loader = DirectoryLoader(
    DOCS_PATH,
    glob="**/*.pdf",
    loader_cls=PyPDFLoader
)
# loader = CSVLoader(file_path="path/to/csv_file.csv") # Loader for csv files
text_splitter = CharacterTextSplitter(
	separator="\n\n",
	chunk_size=1500,
	chunk_overlap=200,
)

# Load data
docs = loader.load()
# Chunking
chunks = text_splitter.split_documents(docs)
for chunk in chunks:
	# Extract the filename
	filename = os.path.basename(chunk.metadata["source"])
	# Create a unique identifier for the chunk
	chunk_id = f"{filename}.{chunk.metadata["page"]}"
	print("Processing -", chunk_id)
	# Embed the chunk
	chunk_embedding = embedding_provider.embed_query(chunk.page_content)
	# Add the Document and Chunk nodes to the graph
	properties = {
		"filename": filename,
		"chunk_id": chunk_id,
		"text": chunk.page_content,
		"textEmbedding": chunk_embedding
	}
	graph.query("""
		MERGE (d:Document {id: $filename})
		MERGE (c:Chunk {id: $chunk_id})
		SET c.text = $text
		MERGE (d)<-[:PART_OF]-(c)
		WITH c
		CALL db.create.setNodeVectorProperty(c, 'textEmbedding', $embedding)
		""",
		properties
	)
	# Generate the entities and relationships from the chunk
	graph_docs = doc_transformer.convert_to_graph_documents([chunk])
	# Map the entities in the graph documents to the chunk node
	for graph_doc in graph_docs:
		chunk_node = Node(
			id=chunk_id,
			type="Chunk"
		)
		for node in graph_doc.nodes:
			graph_doc.relationships.append(
				Relationship(
					source=chunk_node,
					target=node, 
					type="HAS_ENTITY"
					)
				)
	# add the graph documents to the graph
	graph.add_graph_documents(graph_docs)

# Create the vector index
graph.query("""
	CREATE VECTOR INDEX `vector`
	FOR (c: Chunk) ON (c.embedding)
	OPTIONS {indexConfig: {
	`vector.dimensions`: 1536,
	`vector.similarity_function`: 'cosine'
	}};""")



# ================================= GENERATING CYPHER QUERIES =================================
CYPHER_GENERATION_TEMPLATE = """Task:Generate Cypher statement to query a graph database.
Instructions:
Use only the provided relationship types and properties in the schema.
Do not use any other relationship types or properties that are not provided.
Only include the generated Cypher statement in your response.

Always use case insensitive search when matching strings.

Schema:
{schema}

Examples:
# Use case insensitive matching for entity ids
MATCH (c:Chunk)-[:HAS_ENTITY]->(e)
WHERE e.id =~ '(?i)entityName'

# Find documents that reference entities
MATCH (d:Document)<-[:PART_OF]-(:Chunk)-[:HAS_ENTITY]->(e)
WHERE e.id =~ '(?i)entityName'
RETURN d

The question is:
{question}"""


llm2 = ChatOpenAI(
    openai_api_key=os.getenv('OPENAI_API_KEY'), 
    temperature=0 # Recommended for Cypher generation
)
cypher_generation_prompt = PromptTemplate(
    template=CYPHER_GENERATION_TEMPLATE,
    input_variables=["schema", "question"],
)
cypher_chain = GraphCypherQAChain.from_llm(
	# qa_llm=qa_llm,			# LLM for Question/Answer only
    # cypher_llm=cypher_llm,	# LLM for Cypher generation only
    llm2,						# Same LLM for both
    graph=graph,
    cypher_prompt=cypher_generation_prompt,
    verbose=True,
    # exclude_types=["Session", "Message", "LAST_MESSAGE", "NEXT"],
    # enhanced_schema=True,
    allow_dangerous_requests=True
)

def run_cypher(q):
    return cypher_chain.invoke({"query": q})

while (q := input("> ")) != "exit":
    print(run_cypher(q))



# ================================= RAG =================================
chunk_vector = Neo4jVector.from_existing_index(
    embedding_provider,
    graph=graph,
    index_name="chunkVector",
    embedding_node_property="textEmbedding",
    text_node_property="text",
    retrieval_query="""
// get the document
MATCH (node)-[:PART_OF]->(d:Document)
WITH node, score, d

// get the entities and relationships for the document
MATCH (node)-[:HAS_ENTITY]->(e)
MATCH p = (e)-[r]-(e2)
WHERE (node)-[:HAS_ENTITY]->(e2)

// unwind the path, create a string of the entities and relationships
UNWIND relationships(p) as rels
WITH
    node,
    score,
    d,
    collect(apoc.text.join(
        [labels(startNode(rels))[0], startNode(rels).id, type(rels), labels(endNode(rels))[0], endNode(rels).id]
        ," ")) as kg
RETURN
    node.text as text, score,
    {
        document: d.id,
        entities: kg
    } AS metadata
"""
)
instructions = (
    "Use the given context to answer the question."
    "Reply with an answer that includes the id of the document and other relevant information from the text."
    "If you don't know the answer, say you don't know."
    "Context: {context}"
)
prompt = ChatPromptTemplate.from_messages(
    [
        ("system", instructions),
        ("human", "{input}"),
    ]
)
chunk_retriever = chunk_vector.as_retriever()
chunk_chain = create_stuff_documents_chain(llm2, prompt)
chunk_retriever = create_retrieval_chain(chunk_retriever, chunk_chain)

def find_chunk(q):
    return chunk_retriever.invoke({"input": q})

while (q := input("> ")) != "exit":
    print(find_chunk(q))

# Output example:
# {
#     'input': 'What is a vector index?',
#     'context': [
#         Document(
#             metadata={
#                 'document': 'llm-fundamentals_2-vectors-semantic-search_4-improving-semantic-search.pdf',
#                 'entities': [
#                     'Technology Langchain UTILIZES Technology Language Models',
#                     'Concept Vector-Based Semantic Search UTILIZES Technology Vector Index',
#                     'Technology Vector Index HAS_PROPERTY Concept Vector Properties',
#                     'Technology Vector Index HAS_PROPERTY Concept Vector Properties',
#                     'Concept Vector-Based Semantic Search UTILIZES Technology Vector Index',
#                     'Technology Langchain UTILIZES Technology Language Models'
#                     ]
#                 },
#             page_content='You have learned how to create a vector index using `CREATE VECTOR INDEX`,\nset vector properties using the `db.create.setVectorProperty()` procedure,\nand query the vector index using the `db.index.vector.queryNodes()`\nprocedure.\nYou also explored the benefits and potential drawbacks of Vector-based\nSemantic Search.\nIn the next module, you will get hands-on with Langchain, a framework\ndesigned to simplify the creation of applications using large language\nmodels.'
#         )
#     ...
#     ]
# }