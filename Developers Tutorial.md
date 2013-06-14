## Prerequisites

Get hold of JSON, [JSON-LD](http://json-ld.org/) and [OAuth 1.0a](http://oauth.net/core/1.0a/) libraries for your platform.

## Getting OAuth credentials

Follow these steps:

1. Register new account at https://dev.grids.by/
1. Log in at https://dev.grids.by/
1. Go to https://dev.grids.by/data/ and click "Add Graph…" button
 1. Set IRI-name (something alphanumeric would be just fine), Title and Description
 1. Chose "Import Data" tab and upload your dataset (there is a link to dummy example, if you don't have anything to upload right now)
1. Go to https://dev.grids.by/apps/ and click "Add Application…" button
 1. Set Title, Description and in "Access Rights" section set checkbox on the crossing of "Read" column and row which corresponds to the graph which you created (you might need to scroll down a bit)
 1. Click "Save" and **WRITE DOWN OAuth Consumer credentials, which will be given to you**
 1. Click "Proceed", you will be transferred to the new screen
 1. Click "Create new Access-Token" button
 1. Write something in Comment field, "Create" and, again, **WRITE DOWN OAuth Access credentials, which will be given to you**

Now, you have 5 pieces of information, which you'll need to hardcode into your app:

1. graph IRI
2. OAuth Consumer Token
3. OAuth Consumer Secret
4. OAuth Access Token
5. OAuth Access Secret

## API

### Introspection

#### predicates

API endpoint: `https://api.grids.by/v1/predicates.json`

Parameters:

* `graph` [required]

Example query: `https://api.grids.by/v1/predicates.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis`

OAuth signature is required.

Returns list of RDF-predicates, which are present in graph.

Valid responses are:

* 200 OK, `Content-type: application/json`, body is an array of URIs
* 4xx — various errors

#### values

API endpoint: `https://api.grids.by/v1/values.json`

Parameters:

* `graph` [required]
* `predicate` [required]

Example query: `https://api.grids.by/v1/value.json?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fweb-apis&predicate=http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23label`

OAuth signature is required.

Returns list of values, which correspond to the predicate given, in this graph.

Valid responses are:

* 200 OK, `Content-type: application/json`, body is an array of strings
* 4xx — various errors

### Read data

#### list

API endpoint: `https://api.grids.by/v1/list.json`

Parameters:

* `graph` [required]
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

#### get

API endpoint: `https://api.grids.by/v1/get.json`

Parameters:

* `graph` [required]
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

### Write data

#### append

API endpoint: `https://api.grids.by/v1/append`

Parameters:

* `graph` [required]

Example query: `http://api.gridsby.by/v1/append?graph=http%3A%2F%2Fgrids.by%2Fgraphs%2Fmovies`

This should be a POST request, POST body should contain the triples to import in Turtle or JSON-LD format with the appropriate headers `text/turtle` or `application/ld+json` respectively. 

OAuth signature is required

Triples would be imported into requested graph (if application has enough permissions).

Check HTTP status code. Valid responses are:

* 200 OK, Content-type: plain/text, body has number of triples which were imported
* 202 Accepted (we got the data, put it in queue, but it is not imported yet)
* 400 Bad Request (required parameters are not set, or data is not valid syntactically)
* 422 Unprocessable Entity (we can't import data you provided, for some reason. syntax is ok, but there is some semantic problem)
* 4xx — various other errors
