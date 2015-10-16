Perch
===========
A Rails-based management frontend for the Sinatra powered BirdFeed API.

# Getting Started
Perch is designed to make it easy to deploy the BirdFeed API onto your infrastructure. Please treat this as a primer to an easy deployment and use best practices while setting up your own infrastructure. 

## Requirements 
- Ruby 2.2+
- Bundler
- Rails 4+
- Sinatra
- sidekiq
- nodejs 
- npm

## Setting up Perch
It's actually ridiculously simple, just...

```bash
git clone https://github.com/birdfeed/perch
cd perch
bundle install && rails s
```

## Building the docs
You may be interested in building the [swagger-ui](https://github.com/birdfeed/swagger-ui) docs to make development easier. A Rake task currently clones the schema, swagger-ui, and dumps it into the Rails `public/docs` directory. 

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