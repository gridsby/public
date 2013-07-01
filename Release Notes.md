## Release Notes

### 0.03, 2013-07-01

**[Grids.by/you](http://grids.by/you)** is a hosting platform for [Semantic Web](https://en.wikipedia.org/wiki/Semantic_web). We provide free [RDF](http://www.w3.org/RDF/ "RDF - Semantic Web Standards") hosting and [OAuth-secured](http://oauth.net/core/1.0a/ "OAuth Core 1.0a") [HTTP-API](API.md) (including [SPARQL](http://www.w3.org/TR/2013/REC-sparql11-protocol-20130321/ "SPARQL 1.1 Protocol") endpoint) for getting necessary pieces of data.

Under the hood, we use a lot of great opensource components glued together. We're powered by [Virtuoso/7](http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/ "Virtuoso Open-Source Wiki : Virtuoso Open-Source Edition") triplestore, [Redis](http://redis.io/ "Redis") for caching and [Celery](http://www.celeryproject.org/ "Homepage | Celery: Distributed Task Queue")/[RabbitMQ](http://www.rabbitmq.com/ "RabbitMQ - Messaging that just works") for task processing.

We value both privacy of our users and responsiveness, so all communications are secured by [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) by default and are [SPDY](http://www.chromium.org/spdy "SPDY - The Chromium Projects") (aka [HTTP/2.0](https://en.wikipedia.org/wiki/HTTP_2.0)) enabled.

Known limitations:

* At the moment, dataset-uploads are limited to 100Mb per file
* Dataset should be either in [Turtle](http://www.w3.org/TeamSubmission/turtle/ "Turtle - Terse RDF Triple Language") or [JSON-LD](http://json-ld.org/ "JSON-LD - JSON for Linking Data") format

Both of these will be waived soon

If you're curious, and just need some data to "test" our platform, you can use [education.data.gov.uk](http://education.data.gov.uk/ "education.data.gov.uk") as a source (go to one of the sample-links there and click on "ttl" to download)
