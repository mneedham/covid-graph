CREATE CONSTRAINT n10s_unique_uri ON (r:Resource)
ASSERT r.uri IS UNIQUE;

call n10s.graphconfig.init({handleVocabUris: "MAP"});
call n10s.nsprefixes.add("wd","http://www.wikidata.org/entity/");
call n10s.nsprefixes.add("wdt","http://www.wikidata.org/prop/direct/");

CALL n10s.mapping.addSchema("http://www.wikidata.org/prop/direct/", "wdt");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","CHILD_OF","P171");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","HAS_CAUSE","P828");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","startTime","P580");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","endTime","P582");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","LOCATION","P276");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","INSTANCE_OF","P31");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","HOST","P2975");
CALL n10s.mapping.addMappingToSchema("http://www.wikidata.org/prop/direct/","SIGNIFICANT_EVENT","P793");

CALL n10s.mapping.addSchema("http://www.w3.org/2000/01/rdf-schema#", "rdfs");
CALL n10s.mapping.addMappingToSchema("http://www.w3.org/2000/01/rdf-schema#","name","label");


// Import coronavirus taxonomy
WITH 'CONSTRUCT {
  ?cat rdfs:label ?catName .
  ?subCat rdfs:label ?subCatName ;
          wdt:P171 ?cat .
  ?subSubCat rdfs:label ?subSubCatName ;
          wdt:P171 ?subCat .
  ?subSubSubCat rdfs:label ?subSubSubCatName ;
          wdt:P171 ?subSubCat   .
  ?subSubSubSubCat rdfs:label ?subSubSubSubCatName ;
          wdt:P171 ?subSubSubCat  .
  ?subSubSubSubSubCat rdfs:label ?subSubSubSubSubCatName ;
          wdt:P171 ?subSubSubSubCat
  } WHERE {
  ?cat rdfs:label "Nidovirales"@en .
  ?cat rdfs:label ?catName .
  ?subCat wdt:P171 ?cat ;
          rdfs:label ?subCatName
          filter(lang(?subCatName) = "en") .
  ?subSubCat wdt:P171 ?subCat ;
             rdfs:label ?subSubCatName
             filter(lang(?subSubCatName) = "en") .
  ?subSubSubCat wdt:P171 ?subSubCat ;
             rdfs:label ?subSubSubCatName
             filter(lang(?subSubSubCatName) = "en") .
  ?subSubSubSubCat wdt:P171 ?subSubSubCat ;
             rdfs:label ?subSubSubSubCatName
             filter(lang(?subSubSubSubCatName) = "en") .
  ?subSubSubSubSubCat wdt:P171 ?subSubSubSubCat ;
             rdfs:label ?subSubSubSubSubCatName
             filter(lang(?subSubSubSubSubCatName) = "en") .
}' AS query

CALL n10s.rdf.import.fetch("https://query.wikidata.org/sparql?query=" + apoc.text.urlencode(query),
        "JSON-LD",
        { headerParams: { Accept: "application/ld+json"}})

YIELD triplesLoaded
RETURN triplesLoaded;

// Import the flu taxonomy
WITH 'CONSTRUCT {
  ?cat rdfs:label ?catName .
  ?subCat rdfs:label ?subCatName ;
          wdt:P171 ?cat .
  ?subSubCat rdfs:label ?subSubCatName ;
          wdt:P171 ?subCat .
  ?subSubSubCat rdfs:label ?subSubSubCatName ;
          wdt:P171 ?subSubCat   .
  ?subSubSubSubCat rdfs:label ?subSubSubSubCatName ;
          wdt:P171 ?subSubSubCat  .
  ?subSubSubSubSubCat rdfs:label ?subSubSubSubSubCatName ;
          wdt:P171 ?subSubSubSubCat .
  ?subSubSubSubSubSubCat rdfs:label ?subSubSubSubSubSubCatName ;
          wdt:P171 ?subSubSubSubSubCat .
  ?subSubSubSubSubSubSubCat rdfs:label ?subSubSubSubSubSubSubCatName ;
          wdt:P171 ?subSubSubSubSubSubCat .
  ?subSubSubSubSubSubSubSubCat rdfs:label ?subSubSubSubSubSubSubSubCatName ;
          wdt:P171 ?subSubSubSubSubSubSubCat .

  } WHERE {
  ?cat rdfs:label "Riboviria"@en .
  ?cat rdfs:label ?catName .
  optional { ?subCat wdt:P171 ?cat ;
          rdfs:label ?subCatName
          filter(lang(?subCatName) = "en") .
  ?subSubCat wdt:P171 ?subCat ;
             rdfs:label ?subSubCatName
             filter(lang(?subSubCatName) = "en") .
  ?subSubSubCat wdt:P171 ?subSubCat ;
             rdfs:label ?subSubSubCatName
             filter(lang(?subSubSubCatName) = "en") .
  ?subSubSubSubCat wdt:P171 ?subSubSubCat ;
             rdfs:label ?subSubSubSubCatName
             filter(lang(?subSubSubSubCatName) = "en") .
  ?subSubSubSubSubCat wdt:P171 ?subSubSubSubCat ;
             rdfs:label ?subSubSubSubSubCatName
             filter(lang(?subSubSubSubSubCatName) = "en") .
  ?subSubSubSubSubSubCat wdt:P171 ?subSubSubSubSubCat ;
             rdfs:label ?subSubSubSubSubSubCatName
             filter(lang(?subSubSubSubSubSubCatName) = "en") .
  ?subSubSubSubSubSubSubCat wdt:P171 ?subSubSubSubSubSubCat ;
             rdfs:label ?subSubSubSubSubSubSubCatName
             filter(lang(?subSubSubSubSubSubSubCatName) = "en") .
  ?subSubSubSubSubSubSubSubCat wdt:P171 ?subSubSubSubSubSubSubCat ;
             rdfs:label ?subSubSubSubSubSubSubSubCatName
             filter(lang(?subSubSubSubSubSubSubSubCatName) = "en") .
           }
}' AS query

CALL n10s.rdf.import.fetch("https://query.wikidata.org/sparql?query=" + apoc.text.urlencode(query),
        "JSON-LD",
        { headerParams: { Accept: "application/ld+json"}})

YIELD triplesLoaded
RETURN triplesLoaded;

// Add Virus label
MATCH (n:Resource)
SET n:Virus;

// Add hosts
MATCH (r:Virus)
WITH split(r.uri, "/")[-1] AS virus, r
WITH 'prefix schema: <http://schema.org/>

CONSTRUCT {
  wd:' + virus + ' wdt:P2975 ?host.
  ?host rdfs:label ?hostName ;
        rdf:type schema:Host

}
WHERE {
  OPTIONAL {
    wd:' + virus + ' wdt:P2975 ?host.
    ?host rdfs:label ?hostName.
    filter(lang(?hostName) = "en")
  }
}' AS query, r
CALL n10s.rdf.import.fetch("https://query.wikidata.org/sparql?query=" + apoc.text.urlencode(query),
        "JSON-LD",
        { headerParams: { Accept: "application/ld+json"}})

YIELD triplesLoaded
RETURN r.name, triplesLoaded;

// Add diseases
MATCH (r:Virus)
WITH split(r.uri, "/")[-1] AS virus, r
WITH 'prefix schema: <http://schema.org/>

CONSTRUCT {
  ?event wdt:P828 wd:' + virus + ';
         wdt:P31 ?eventType;
         rdfs:label ?diseaseName;
         wdt:P276 ?origin ;
         wdt:P793 ?significantEvent.
  ?origin rdfs:label ?originName;
          rdf:type schema:Place .
  ?eventType rdfs:label ?eventTypeName.
  ?significantEvent rdfs:label ?significantEventName ;
                    rdf:type schema:Event.
}
WHERE {
  { ?event wdt:P828 wd:'+ virus + '; }
  UNION
  { ?event wdt:P1478 wd:' + virus + '; } .
  ?event rdfs:label ?diseaseName .
  filter(lang(?diseaseName) = "en")

  OPTIONAL { ?event wdt:P31 ?eventType.
           ?eventType rdfs:label ?eventTypeName
               filter(lang(?eventTypeName) = "en")}

  OPTIONAL {
    ?event wdt:P276 ?origin .
    ?origin rdfs:label ?originName .
    filter(lang(?originName) = "en")
  }

  OPTIONAL {
    ?event wdt:P793 ?significantEvent .
           ?significantEvent rdfs:label ?significantEventName .
    filter(lang(?significantEventName) = "en")
    }
}' AS query, r
CALL n10s.rdf.import.fetch("https://query.wikidata.org/sparql?query=" + apoc.text.urlencode(query),
        "JSON-LD",
        { headerParams: { Accept: "application/ld+json"}})

YIELD triplesLoaded
RETURN r.name, triplesLoaded
ORDER BY triplesLoaded DESC;

MATCH (r:Resource)-[:INSTANCE_OF]->(item:Resource)
WHERE item.name CONTAINS "infectious disease"
WITH r, collect(item.name) AS items
SET r:Disease;
