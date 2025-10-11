// ------------ list ------------ //
// Doc : https://neo4j.com/docs/cypher-manual/current/expressions/list-expressions/

// range()
RETURN range(0, 10)[3] AS element; // -> 3
// List slicing
RETURN range(0, 10)[1..4] AS elements; // -> [1, 2, 3]
// Negative index
RETURN range(0, 10)[-2] AS element; // -> 8
RETURN range(0, 10)[1..-5] AS elements; // -> [1, 2, 3, 4]
// List length : size()
WITH [1, 5, 2, 8, 7] AS list RETURN size(list); // -> 5
// Nested list access
WITH [[1, 2], [3, 4], [5, 6]] AS nestedList RETURN nestedList[1][0]; // -> 3
// WHERE IN
MATCH (:Human {name: "Michael"})-[:HAS_FRIEND]->(f:Human)
WHERE f.name IN ["John", "George", "Paul", "Ringo"]
RETURN f;
// List concatenation
RETURN [1, 2] || [3, 4] AS list1, [1, 2] + [3, 4] AS list2; // Return the same [1, 2, 3, 4]
WITH [[1, 2], [3, 4]] AS nestedList
// List append / insert
RETURN 0 + nestedList,  // [0, [1, 2], [3, 4]]
	   nestedList + 5, // [[1, 2], [3, 4], 5]
	   nestedList + [5, 6] AS nonNestedAddition, // [[1, 2], [3, 4], 5, 6]
       nestedList + [[5, 6]] AS nestedAddition; // [[1, 2], [3, 4], [5, 6]]
// List comprehension : [item IN list [WHERE predicate] | [expression]]
RETURN [x IN range(0,10) WHERE x % 2 = 0] AS result; // -> [0, 2, 4, 6, 8, 10]
RETURN [x IN range(0,5) | x * 10] AS result; // -> [0, 10, 20, 30, 40, 50]
RETURN [x IN range(1,6) WHERE x > 2 | x + 10] AS filteredList; // -> [13, 14, 15]
WITH [1,2,3,4] AS list
RETURN [i IN range(0, size(list)-1) | toString(i) || ': ' || toString(list[i])] AS mapped; // ["0: 1", "1: 2", "2: 3", "3: 4"]
// With collect()
MATCH (person:Person)
RETURN [p IN collect(person) WHERE 'Python' IN p.skills | p.name] AS pythonExperts;
// Get all distinct relationship type of a node
MATCH p=(n:User {user_id:605})--()
RETURN collect(distinct [r IN relationships(p) | type(r)]);
// Pattern comprehension
MATCH (alice:Person {name: 'Alice'})
RETURN [(p:Person)-[:WORKS_FOR]->(alice) WHERE p.age > 30 | p.name || ', ' || toString(p.age)] AS employeesAbove30; // -> ["Cecilia, 31"]
// List functions
WITH [-1, 1, 2, 3, 4] AS l
RETURN head(l), tail(l), last(l), size(l);


// ------------ FOREACH ------------ //
// Mark relationships along the path
MATCH p=(start)-[*]->(finish)
WHERE start.name = 'A' AND finish.name = 'D'
FOREACH ( r IN relationships(p) | SET r.marked = true );
// Mark nodes along the path
MATCH p=(start)-[*]->(finish)
WHERE start.name = 'A' AND finish.name = 'D'
FOREACH (n IN nodes(p) | SET n.marked = true);
// Looping on list elements with FOREACH to create nodes
WITH ['E', 'F', 'G'] AS names
FOREACH ( value IN names | CREATE (:Person {name: value}) )