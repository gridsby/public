# This is free and unencumbered software released into the public domain.
# For more information, please refer to <http://unlicense.org/>
#
# This script uses "requests-oauthlib" library
# For more information, please refer to <https://github.com/requests/requests-oauthlib#installation>
#
# This script uses "sparql-client" library
# For more information, please refer to <http://www.eionet.europa.eu/software/sparql-client/install.html>
import json
import urllib

import requests
from requests_oauthlib import OAuth1
from sparql import Service


# CHANGE THESE variables
consumer_token  = 'consumer_token'
consumer_secret = 'consumer_secret'
access_token    = 'access_token'
access_secret   = 'access_secret'
graph_iri       = 'http://example.com/graph'


class OAuthSparqlTest(object):
    """Wraps OAuth1 with SPARQL-client to provide nice API"""
    def __init__(self, sparql_endpoint, consumer_token, consumer_secret, access_token, access_secret):
        self.endpoint = sparql_endpoint

        self.sparql_service = Service(self.endpoint)
        self.oauth = OAuth1(consumer_token, consumer_secret, access_token, access_secret, signature_type='auth_header')

    def query(self, sparql_query, graph):
        query_obj = self.sparql_service.createQuery()
        query_obj.addDefaultGraph(graph)

        qs = query_obj._queryString(sparql_query)

        return requests.get('%s?%s' % (self.endpoint, qs), headers={"Accept": "application/sparql-results+json"}, auth=self.oauth)


if __name__ == '__main__':
    sparqler = OAuthSparqlTest('https://api.grids.by/v1/sparql', consumer_token, consumer_secret, access_token, access_secret)
    result = sparqler.query('SELECT COUNT(*) as ?count WHERE {?s ?p ?o}', graph_iri)

    data = json.loads(result.content)

    print(json.dumps(data, indent=4, separators=(',', ': ')))
