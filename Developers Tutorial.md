## Prerequisites

Get hold of JSON, [JSON-LD](http://json-ld.org/) and [OAuth 1.0a](http://oauth.net/core/1.0a/) libraries for your platform.

## Create your first Graph

Follow these steps:

1. Register new account at https://dev.grids.by/
1. Log in at https://dev.grids.by/
1. Go to https://dev.grids.by/data/ and click "Create new graph" button
1. Set IRI-name (something alphanumeric would be just fine), Title and Description and confirm your choice by clicking button.
1. Chose "Upload Data" tab and upload your dataset (there is a link to dummy example, if you don't have anything to upload right now)

## Getting OAuth credentials

Follow these steps:

1. Go to https://dev.grids.by/apps/ and click "Add Application…" button
1. Set Title, Description and in "Access Rights" section set checkbox on the crossing of "Read" column and row which corresponds to the graph which you created (you might need to scroll down a bit)
1. Click "Save" and **WRITE DOWN OAuth Consumer credentials, which will be given to you**
1. Click "Proceed", you will be transferred to the new screen

You can stop at this point, if you're interested in 3-legged OAuth flow (application will need to request additional privileges from user).

But, if you're interested in 0-legged OAuth flow (without access to users private data) proceed with 2 more steps:

1. Click "Create new Access-Token" button
1. Write something in Comment field, "Create" and, again, **WRITE DOWN OAuth Access credentials, which will be given to you**

Now, you have 5 pieces of information, which you'll need to hardcode into your app:

1. graph IRI
2. OAuth Consumer Token
3. OAuth Consumer Secret
4. OAuth Access Token (0-legged flow only)
5. OAuth Access Secret (0-legged flow only)

## 3-legged OAuth endpoints

* Request-token endpoint:           `https://api.grids.by/oauth/request_token`
* Token-authorization endpoint:     `https://dev.grids.by/oauth/authorize`
* Access-token (exchange) endpoint: `https://api.grids.by/oauth/access_token`

## API

API-description was moved into [separate document](API.md).
