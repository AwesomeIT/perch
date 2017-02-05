Perch (DEPRECATED, SEE NOTES)
===========

This project has been deprecated by the new API and its components. REST services are now provided by [turaco](https://github.com/birdfeed/turaco), intensive compute tasks are facilitated by [myna](https://github.com/birdfeed/myna), and all database models can be found in [kagu](https://github.com/birdfeed/kagu).

------------------


The BirdFeed API and management panel, powered by Rails 4+, authentication by Devise, and OAuth by Doorkeeper. 

# Deploying
Perch is designed to make it easy to deploy the BirdFeed API onto your infrastructure. Please treat this as a primer to an easy deployment and use best practices while setting up your own infrastructure. 

## Requirements 
- Ruby 2+
- Node.JS runtime (for docs)

## Setting up Perch
It's actually ridiculously simple, just...

```bash
git clone https://github.com/birdfeed/perch
cd perch
vim config/database.yml # do your thing
bundle install && rails s
```

## Building the docs
You may be interested in building the [swagger-ui](https://github.com/birdfeed/swagger-ui) docs to make development easier. A Rake task currently clones the schema, swagger-ui, and dumps it into the Rails `public/docs` directory. Documentation will then be served at `/docs`, publicly.  

```bash
rake swagger_ui:build
```

### Issues

#### I use Windows
Please install either `bash` or `zsh` to continue. [Git for Windows](https://git-scm.com/downloads) ships with MinGW and `bash`.

#### Directory already exists

Try:
  - `rake swagger_ui:cleanup`
  - Deleting `swagger_ui` and `api_schema`

# Using the API

It is highly recommended to build the documentation for this project as it helps you easily make requests while writing your application. 

## Authorization

[OAuth](https://en.wikipedia.org/wiki/OAuth) is used to securely connect both the application and the user to the API. 

### Scopes
| Scope       | Description                                                                                                 |
|-------------|-------------------------------------------------------------------------------------------------------------|
| client      | Only applications can obtain this grant to perform read-only operations on Experiment and Sample resources. |
| participant | Only participants can obtain this grant to create Score resources.                                          |

### Obtaining a token for your application

Ideally, only a certain amount of client "TalkBirdy" applications will be cleared for use with the API. To use the API, they must obtain a `client_credentials` grant token with the **client** scope. 

**NOTE**: Application tokens live for only 6 hours; you are responsible for refreshing authorization once it expires.

##### Request
```http
POST /oauth/token
Content-Type application/json

{
  "client_id": "hello",
  "client_secret": "shhhhh",
  "grant_type": "client_credentials",
  "scope": "client"
}
```
##### Response
```json
{"access_token":"snip","token_type":"bearer","expires_in":21600,"scope":"client","created_at":1450241513}
```

### Obtaining a token for your participant

In order to ensure that the application does not create any `Score` resources on behalf of the user, only `Participant` resources are authorized to make requests to `/score/record`. As such, you must obtain a `password` grant token with the **participant** scope.

**NOTE**: Participant tokens live for only 6 hours; you are responsible for refreshing authorization once it expires.

##### Request
```http
POST /oauth/token
Content-Type application/json

{
  "username": "supercoolguy1337",
  "password": "hush",
  "grant_type": "password",
  "scope": "participant"
}
```
##### Response
```json
{"access_token":"snip","token_type":"bearer","expires_in":21600,"scope":"client","created_at":1450241513}
```

## Example request

Let's grab a `Sample` resource with `id = 1` as an authorized `client`.

```http
GET /v1/sample/1
Content-Type application/json

{"id":1,"name":"A sample","total_scores":2,"avg_score":"3.8599999999999998756550212419824674725","expected_score":"3.0","created_at":"2015-12-15T02:22:23.604Z","updated_at":"2015-12-15T05:18:55.813Z","audio_file_name":"fix_me.mp3","audio_content_type":"audio/mp3","audio_file_size":179849,"audio_updated_at":"2015-12-15T02:22:23.486Z","s3_url":"http://s3.amazonaws.com/birdfeedtemp/samples/audios/000/000/001/original/fix_me.mp3?1450146143","tag_list":["fix me"]}
```

# Testing
Currently, due to a hectic semester, we did not have time to write up-to-date unit tests as the specification kept changing frequently as user feedback came in. To aid in testing functionality, we have provided a seedfile:

```bash
RAILS_ENV=development rake db:seed
```

This will populate your database with a few hundred scores and some very basic data to test CSV export functionality, as well as data visualization. Feel free to add more. No S3 files are created as all models are by-hand
