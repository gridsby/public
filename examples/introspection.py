# This is free and unencumbered software released into the public domain.
# For more information, please refer to <http://unlicense.org/>
#
# This script uses "requests-oauthlib" library
# For more information, please refer to <https://github.com/requests/requests-oauthlib#installation>
import json
import urllib

import requests
from requests_oauthlib import OAuth1


# CHANGE THESE variables
consumer_token  = 'consumer_token'
consumer_secret = 'consumer_secret'
access_token    = 'access_token'
access_secret   = 'access_secret'
graph_iri       = 'http://example.com/graph'


oauth = OAuth1(consumer_token, consumer_secret, access_token, access_secret, signature_type='auth_header')

_predicates = requests.get('https://api.grids.by/v1/predicates.json?%s' % (urllib.urlencode({'graph': graph_iri})), auth=oauth)
predicates = json.loads(_predicates.content)

for predicate in predicates:
    print(predicate)

    _values = requests.get('https://api.grids.by/v1/values.json?%s' % (urllib.urlencode({'graph': graph_iri, 'predicate': predicate})), auth=oauth)
    values = json.loads(_values.content)

    for value in values:
        print("--> %s" % (value))
