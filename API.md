## Introspection

### predicates

API endpoint: `https://api.grids.by/v1/predicates.json`

Parameters:

* `graph` [required, Read-access required]

Example query: `https://api.grids.by/v1/predicates.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis`

OAuth signature is required.

Returns list of RDF-predicates, which are present in graph.

Valid responses are:

* 200 OK, `Content-type: application/json`, body is an array of URIs
* 4xx — various errors

### values

API endpoint: `https://api.grids.by/v1/values.json`

Parameters:

* `graph` [required, Read-access required]
* `predicate` [required]

Example query: `https://api.grids.by/v1/value.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis&predicate=http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23label`

OAuth signature is required.

Returns list of values, which correspond to the predicate given, in this graph.

Valid responses are:

* 200 OK, `Content-type: application/json`, body is an array of strings
* 4xx — various errors

## Read data

### list

API endpoint: `https://api.grids.by/v1/list.json`

Parameters:

* `graph` [required, Read-access required]
* you can use any number of `filters[n][predicate]=value` parameters to filter dataset (don't forget to "urlencode" them)

Example query: `https://api.grids.by/v1/list.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis&filters%5B0%5D%5Bschema%3Aname%5D=BitBucket&filters%5B1%5D%5Bschema%3Aname%5D=GitHub`

If you're planning on passing a lot of parameters it's recommended to use POST and provide the parameters in the request body as a JSON (make sure to provide proper `Content-type` header):

```json
{
    "graph":"http://grids.by/graphs/web-apis",
    "filters":[
        {"schema:name":"BitBucket"},
        {"schema:name":"123ContactForm"},
    ]
}
```

OAuth signature is required.

Returns list of RDF-subjects, which have matching predicate/value pairs.

Valid responses are:

* 200 OK, `Content-type: application/json`, body is an array of URIs, which are "subjects" of the items
* 4xx — various errors

### get

API endpoint: `https://api.grids.by/v1/get.json`

Parameters:

* `graph` [required, Read-access required]
* `subject` [required]
* `deeper` [optional, default=0; can be "0" or "1"]

Example query: `https://api.grids.by/v1/get.json?graph=http://grids.by/graphs/web-apis&subject=http://apis.io/Bing`

If you're planning on passing a lot of parameters it's recommended to use POST and provide the parameters in the request body as a JSON:
```json
{
    "graph":"http://grids.by/graphs/web-apis",
    "subject":"http://apis.io/Bing",
    "deeper":0
}
```

OAuth signature is required

Returns JSON-LD structure, which corresponds to requested graph/subject pair. Will give 1 additional level of depth, if `deeper=1` parameter is given.

Valid responses are:

* 200 OK, `Content-type: application/ld+json`
* 4xx — various errors

## Write data

### append

API endpoint: `https://api.grids.by/v1/append`

Parameters:

* `graph` [required, Append- or Write-access is required]

Example query: `http://api.grids.by/v1/append?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fmovies`

This should be a POST request, POST body should contain the triples to import in Turtle or JSON-LD format with the appropriate headers `text/turtle` or `application/ld+json` respectively. 

OAuth signature is required

Triples would be imported into requested graph (if application has enough permissions).

Check HTTP status code. Valid responses are:

* 200 OK, Content-type: plain/text, body has number of triples which were imported
* 202 Accepted (we got the data, put it in queue, but it is not imported yet)
* 400 Bad Request (required parameters are not set, or data is not valid syntactically)
* 422 Unprocessable Entity (we can't import data you provided, for some reason. syntax is ok, but there is some semantic problem)
* 4xx — various other errors

## Other

### SPARQL

API endpoint: `https://api.grids.by/v1/sparql`

Parameters:

* `default-graph-uri` [at least one required, **both** Read- and Write-access is required]
* see [SPARQL 1.1 Protocol](http://www.w3.org/TR/2013/REC-sparql11-protocol-20130321/) for further details

OAuth signature is required
