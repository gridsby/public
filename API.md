## Rationale

While using grids.by API, your application would have access to data **graphs**. Those graphs are made of triples, looking like `subject - predicate - object`. Subject of each triple is the identifier of **resource**, and there can be several **predicates** of each resource, linking some **values** to them. Typically (but not always), each resource have one ore more **types** (which is just a `rdf:type` predicate, having special role); resources' type typically describes this resource role in data; resources with same type typically have similar sets of predicates linked to them.

So, to have full and handy access to data, you can receive lists of, filter those lists, and receive individual entities of the kinds:

* graph
* resource
* resource type
* predicate
* value

So, let's rock!

## Request formats

Our API lets you specify parameters using 3 different methods.

### 1. GET + Query

While using GET requests, you can send parameters right in URL. If you need to specify several values for one of parameters just repeat the parameter several times.

`https://{endpoint}?param1=value1&param1=value2&param2=value3&filter%5Bhttp%3A%2F%2Fexample.com%2Fpredicate%5D=value`

Please note, that you can use only simple literal (strings, numbers) `values` this way. Also, make sure to [urlencode](https://en.wikipedia.org/wiki/Percent-encoding) query-parameter names and values.

### 2. POST + JSON

While using POST requests, you can send parameters in a body of request specifying `Content-type: application/json` header.

```json
{
    "param1": ["value1", "value2"],
    "filter": {"http://example.com/predicate": "value"},
    "param2": "value3"
}
```

Please note, that you can use only simple literal (strings, numbers) `values` this way.

### 3. POST + JSON-LD

While using POST requests, you can send parameters in a body of request specifying `Content-type: application/ld+json` header.

```json
{
    "@context": {
        "name": "http://example.com/param1",
        "related": "http://example.com/param2"
    },
    "@id": "http://example.com/graph",
    "param1": ["value1", "value2"],
    "param2": "value3",
    "@graph": [
        {
            "@type": "filter",
            "name": {"@value": "value", "@language": "en"},
            "related": {"@id": "http://example.com/otherResource"}
        },
        {
            "@type": "filter",
            "name": {"@value": "value2", "@language": "fr"}
        }
    ]
}
```

This approach is the most verbose, but it gives you the maximum flexibility.

## Introspection

### Graphs

|               |                                                                                           |
|---------------|-------------------------------------------------------------------------------------------|
|Endpoint:      |`https://api.grids.by/v1/graphs.jsonld`
|Authorization: | **required**
|Parameters:    | `id` [optional],<br>`access` [optional]
|Returns:       | JSON-LD
|Response codes:| 200 OK,<br>403 Forbidden — specified graph is not accessible

Returns JSON-LD encoded graph, which contains either one (if `id` is specified) or all resources which describe graphs accessible to this application.

If `access` parameter is specified and has comma-separated list of the following words: `Read`, `Append` then app will get only graphs, to which it has specified access-rights. If more than one access-right is specified it means that app has at least one of access-rights specified (`OR` relation).


### Predicates

|               |                                                                                           |
|---------------|-------------------------------------------------------------------------------------------|
|Endpoint:      |`https://api.grids.by/v1/predicates.json` or `https://api.grids.by/v1/predicates.jsonld`
|Authorization: | **required**
|Parameters:    | `graph` [required, Read-access required],<br>`resource_type` [optional]<br>`id` [optional]
|Returns:       | JSON: array of predicates or JSON-LD
|Response codes:| 200 OK,<br>4xx

Returns list of RDF-predicates, which are present in graph. Either `id` or `resource_type` parameters might be specified (`id` has priority).

If `resource_type` is specified, then only predicates attached to objects of specified `rdf:type` are listed (several parameters mean `OR`).

If content is returned as JSON then array of IDs is returned.

If content is returned as JSON-LD than information from schema-definition is added (if we have it).

### Types

|               |                                                                                           |
|---------------|-------------------------------------------------------------------------------------------|
|Endpoint:      |`https://api.grids.by/v1/types.json` or `https://api.grids.by/v1/types.jsonld`
|Authorization: | **required**
|Parameters:    | `graph` [required, Read-access required],<br>`has_predicate` [optional]
|Returns:       | JSON: array of types or JSON-LD
|Response codes:| 200 OK,<br>4xx

Returns list of RDF-types, resources of which are present in `graph`. If `has_predicate` parameter is specified, list is additionally filtered to include only types, resources of which have specified predicate.

If content is returned as JSON then array of IDs is returned.

If content is returned as JSON-LD than information from schema-definition is added (if we have it).


### Values

|               |                                                                                           |
|---------------|-------------------------------------------------------------------------------------------|
|Endpoint:      |`https://api.grids.by/v1/values.json`
|Authorization: | **required**
|Parameters:    | `graph` [required, Read-access required],<br>`predicate` [required],<br>`resource_type` [optional]
|Returns:       | JSON-encoded array of values which, in their turn, are encoded according to JSON-LD rules. see: [6.4 Typed Values](http://json-ld.org/spec/latest/json-ld/#typed-values "JSON-LD 1.0") and [6.9 String Internationalization](http://json-ld.org/spec/latest/json-ld/#string-internationalization "JSON-LD 1.0").
|Response codes:| 200 OK,<br>4xx

Returns list of values, which correspond to the `predicate` given, in this graph. If `resource_type` parameter is specified, then additional filtering by rdf-type of resources, which have predicate is applied.

#### Example

Request: `https://api.grids.by/v1/values.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis&predicate=http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23label`

Response:

```json
[
    "foo",
    {"@id": "http://example.com/resource"},
    {"@value": "bar", "@language": "en"},
    {"@value": "2010-05-29T14:17:39+02:00", "@type": "http://www.w3.org/2001/XMLSchema#dateTime"}
]
```


## Read data

### Resources

|               |                                                 |
|---------------|-------------------------------------------------|
|Endpoint:      |`https://api.grids.by/v1/resources.json` or `https://api.grids.by/v1/resources.jsonld`
|Authorization: | **required**
|Parameters:    | `graph` [required],<br>`id` [optional],<br>`predicate` [optional],<br>`filter` [optional],<br>`deeper` [optional],<br>`page` [optional],<br>`pagesize` [optional]
|Returns:       | JSON or JSON-LD
|Response codes:| 200 OK,<br>4xx

Returns either:

* JSON encoded list of subjects (if`json` is chosen as format) from graph specified, which correspond to the given conditions. `deeper` has no meaning in this case
* JSON-LD encoded graph of resources (if `jsonld` is chosen as format), which correspond to the given conditions.

Params description:

* `graph`
* `id` - string or list of strings, setting concrete id(s) of resource(s) to fetch;
* `predicate` - list of strings, if specified, returns only resources, having those predicates linked with them;
* `filter` - list of predicate-value pairs for resource filtering ( **TBD** in more details);
* `deeper` - integer, if specified, unfolds nested resources (in other words, turns `"predicate": {"@id": "some:resource:id"}` into `"predicate": {full resource representation}` ). Nested-to-nested resources are unfolded to the level, specified by `deeper` value. Maximum 5, default 0.
* `page`, `pagesize` - list paging. `page` is 1-based, default (and maximum) `pagesize` is 10'000.

If you use GET request format, then `filter` should be used in `filter[http://example.com/predicate]=value` form.

If you use JSON-LD request format, things get more powerful:

* Implementation detail is, that (in JSON-LD mode) implicit `@context` is specified by API-server which includes unaliasing of params into full uris: `id` is converted into `urn:gridsby:id`, etc. So, it's ok to use full-uris if you want explicitness, but for using those words as literal values you will need to use: `{"@value": "id"}`
* Instead of `graph` parameter you just use top-level `@graph` declaration with corresponding `@id`
* `id` param is converted into objects without contents `{"@id": "http://example.com/id"}` inside of forementioned `@graph` section.
* `predicate` and `filter` params are converted into anonymous objects of `filter` type inside of `@graph` section. Each such object is a pattern, which real objects in graph are matched against. So, if you specify several key-value pairs inside the object-pattern then `AND` relation between them is implied, but if you use several object-patterns those are treated as `OR` pattern. To state, that **predicate** is present in resource you should use a special value 'exists' (unaliased into `urn:gridsby:exists`) and to state that it doesn't exist a special value `not-exists`.
* Other parameters stay on top-level (so, as far as JSON-LD is concerned, they are aditional predicate-value pairs of the graph).

### list

*(deprecated)*

### get

*(deprecated)*

### download

API endpoint `https://api.grids.by/v1/download.[jsonld|ttl]`

Parameters:

* `graph` [required, Read-access required]

Example query: `https://api.grids.by/v1/download.jsonld?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis`

OAuth signature is required

Returns Graph encoded as JSON-LD or Turtle document.

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
