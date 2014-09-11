## Release Notes

### 0.6.8, 2014-07-09

**[Grids.by/you](https://grids.by/)** is a hosting platform for [Semantic Web](https://en.wikipedia.org/wiki/Semantic_web). We provide free [RDF](http://www.w3.org/RDF/ "RDF - Semantic Web Standards") hosting, [OAuth-secured](http://oauth.net/core/1.0a/ "OAuth Core 1.0a") noun-based [Web API](API.md) (including [SPARQL](http://www.w3.org/TR/2013/REC-sparql11-protocol-20130321/ "SPARQL 1.1 Protocol") endpoint) for getting necessary pieces of data and **Grids.IO** web-application hosting.

Under the hood, we use a lot of great opensource components glued together. We're powered by [Virtuoso/7](http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/ "Virtuoso Open-Source Wiki : Virtuoso Open-Source Edition") triplestore, [Redis](http://redis.io/ "Redis") for caching and [Celery](http://www.celeryproject.org/ "Homepage | Celery: Distributed Task Queue")/[RabbitMQ](http://www.rabbitmq.com/ "RabbitMQ - Messaging that just works") for task processing.

We value both privacy of our users and responsiveness, so all communications are secured by [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) by default and are [SPDY](http://www.chromium.org/spdy "SPDY - The Chromium Projects") enabled.

Known limitations:

* At the moment, dataset-uploads are limited to 100Mb per file
* Dataset should be either in [Turtle](http://www.w3.org/TeamSubmission/turtle/ "Turtle - Terse RDF Triple Language") or [JSON-LD](http://json-ld.org/ "JSON-LD - JSON for Linking Data") format

Both of these will be waived soon
