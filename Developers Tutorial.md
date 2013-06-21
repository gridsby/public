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

API-description was moved into [separate document](API.md).
