// ------------ Value types ------------ //

// Types : BOOLEAN, DATE, DURATION, FLOAT, INTEGER, LIST, STRING
// LOCAL DATETIME, LOCAL TIME, POINT, ZONED DATETIME, ZONED TIME
// ! All types include null value

// Using valueType()
WITH [
	1,			// "INTEGER NOT NULL"
	true,		// "BOOLEAN NOT NULL"
	"three",	// "STRING NOT NULL"
	4.0,		// "FLOAT NOT NULL"
	null,		// "NULL"
	['a']		// "LIST<STRING NOT NULL> NOT NULL"
] AS x
RETURN [item IN x | valueType(item) ] AS res;

// Using apoc.meta.cypher.type()
WITH [
	1,			// "INTEGER"
	true,		// "BOOLEAN"
	"three",	// "STRING"
	4.0,		// "FLOAT"
	null,		// "NULL"
	['a']		// "LIST OF STRING"
] AS x
RETURN [item IN x | apoc.meta.cypher.type(item) ] AS res;

// Filter type using IS ::
WITH [1, true, "three", 4.0, null, ['a']] AS x
RETURN [item IN x WHERE item IS :: INTEGER] AS res; // -> [1, null]

// Filter out null values using IS ::
WITH [1, true, "three", 4.0, null, ['a']] AS x
RETURN [item IN x WHERE item IS :: INTEGER NOT NULL ] AS res; // -> [1]

// Filter out null values using NULL type and NOT
WITH [1, true, "three", 4.0, null, ['a']] AS x
RETURN [item IN x WHERE NOT item IS :: NULL | item] AS res; // -> [1, true, "three", 4.0, ["a"]]

// ------------ POINT ------------ //
// point data type is not suported by import manager
// it needs to bet set after
MATCH (l:Location)
SET l.position = point({latitude: l.latitude, longitude: l.longitude});
// Distance between two points
MATCH (l:Location {address: '1 Coronation Street'})
WITH l.position AS corrie
MATCH (x:Location)<-[:OCCURRED_AT]-(c:Crime)
RETURN x.address as crime_location, point.distance(x.position, corrie) AS distanceFromCoronationSt