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

r = requests.get('https://api.grids.by/v1/list.json?%s' % (urllib.urlencode({'graph': graph_iri})), auth=oauth)
data = json.loads(r.content)

print(json.dumps(data, indent=4, separators=(',', ': ')))
