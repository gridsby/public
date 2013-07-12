## Release Notes

### 0.05, 2013-07-12

**[Grids.by/you](http://grids.by/you)** is a hosting platform for [Semantic Web](https://en.wikipedia.org/wiki/Semantic_web). We provide free [RDF](http://www.w3.org/RDF/ "RDF - Semantic Web Standards") hosting and [OAuth-secured](http://oauth.net/core/1.0a/ "OAuth Core 1.0a") [HTTP-API](API.md) (including [SPARQL](http://www.w3.org/TR/2013/REC-sparql11-protocol-20130321/ "SPARQL 1.1 Protocol") endpoint) for getting necessary pieces of data.

Under the hood, we use a lot of great opensource components glued together. We're powered by [Virtuoso/7](http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/ "Virtuoso Open-Source Wiki : Virtuoso Open-Source Edition") triplestore, [Redis](http://redis.io/ "Redis") for caching and [Celery](http://www.celeryproject.org/ "Homepage | Celery: Distributed Task Queue")/[RabbitMQ](http://www.rabbitmq.com/ "RabbitMQ - Messaging that just works") for task processing.

We value both privacy of our users and responsiveness, so all communications are secured by [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) by default and are [SPDY](http://www.chromium.org/spdy "SPDY - The Chromium Projects") (aka [HTTP/2.0](https://en.wikipedia.org/wiki/HTTP_2.0)) enabled.

Known limitations:

* At the moment, dataset-uploads are limited to 100Mb per file
* Dataset should be either in [Turtle](http://www.w3.org/TeamSubmission/turtle/ "Turtle - Terse RDF Triple Language") or [JSON-LD](http://json-ld.org/ "JSON-LD - JSON for Linking Data") format

Both of these will be waived soon

While users can bring their own data, we also provide some liberally licensed datasets out of the box, including: 

* [OpenCyc](http://www.cyc.com/platform/opencyc) ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/ "Creative Commons – Attribution 3.0 Unported – CC BY 3.0"))
* [SUMO](http://www.ontologyportal.org/ "The Suggested Upper Merged Ontology (SUMO)") ("free to use", [© IEEE](http://suo.ieee.org/ "Standard Upper Ontology Working Group (SUO WG) - Home Page")) — you can find example application [here](examples/sumo)
* [WordNet](http://wordnet.princeton.edu/) (MIT-like [WordNet 3.0 License](http://casta-net.jp/~kuribayashi/multi/wns/eng/LICENSE)) — you can find example application [here](examples/word_net)
* [HEML](http://heml.mta.ca/) ([LGPL](https://www.gnu.org/licenses/lgpl.html)) — you can find example application [here](examples/heml)
