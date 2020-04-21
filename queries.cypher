MATCH (r1:Resource {name: "SARS-CoV-2"})
MATCH (r2:Resource {name: "severe acute respiratory syndrome coronavirus"})
MATCH path = shortestpath((r1)-[*]-(r2))
RETURN path;

WITH ["SARS-CoV-2", "Middle East respiratory syndrome coronavirus", "severe acute respiratory syndrome coronavirus"] AS virus
UNWIND apoc.coll.combinations(virus, 2, 2) AS pair
MATCH (r1:Resource {name: pair[0]})
MATCH (r2:Resource {name: pair[1]})
MATCH path = shortestpath((r1)-[*]-(r2))
RETURN path;

MATCH path = (h:Host {name: "Homo sapiens"})<-[:HOST]-(virus)-[:HOST]->(otherHost)
RETURN path;
