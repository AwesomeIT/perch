Perch
===========
The management system for the BirdFeed API, using Rails + Sidekiq. 

# Getting Started
Currently, Perch runs on a [Heroku](https://heroku.com) instance. Use the Heroku panel to deploy the latest master branch to your application instance. 

## Building the docs
You may be interested in building the [swagger-ui](https://github.com/birdfeed/swagger-ui) docs to make development easier. A Rake task currently clones the schema, swagger-ui, and dumps it into the Rails `public/docs` directory.

```bash
rake swagger_ui:build
```

### Directory already exists 

Try:
  - `rake swagger_ui:cleanup`
  - Deleting `swagger_ui` and `api_schema`

### During deployment
Short of customizing the Heroku buildpack, there is no way to do this as part of the deployment process. We are working on a better way of doing this, but in the meantime, just do this...

```bash
heroku run rake swagger_ui:build
```